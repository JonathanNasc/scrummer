defmodule Scrummer.Trello do
  alias Poison, as: JSON

  @trello_api "https://api.trello.com/1/boards"

  def get_scrums(date) do
    Application.get_env(:scrummer, :trello_boards)
    |> Enum.map(&actions_endpoint/1)
    |> Enum.map(&get_comments/1)
    |> List.flatten()
    |> filter_comments(date)
    |> Enum.map(&parse_scrum_messages/1)
  end

  defp get_comments(endpoint) do
    HTTPoison.start()

    response = endpoint
    |> HTTPoison.get([], [timeout: 60_000, ssl: [{:versions, [:'tlsv1.2']}]])
    |> parse_response

    response["actions"]
  end

  defp filter_comments(scrums, date) do
    scrums |> Enum.filter(fn action ->
      is_comment = action["type"] == "commentCard"
      {:ok, comment_date, _} = DateTime.from_iso8601(action["date"])
      is_target_date = comment_date |> DateTime.to_date() |> Date.to_iso8601() == date
      is_comment && is_target_date && is_this_day_scrum?(action["data"]["text"])
    end)
  end

  defp is_this_day_scrum?(message) do
    msg = message |> String.upcase
    is_scrum = msg |> String.contains?("SCRUM")
    is_other_day_scrum = String.contains?(msg, "SCRUM(") || String.contains?(msg, "SCRUM (")

    is_scrum && !is_other_day_scrum
  end

  defp parse_scrum_messages(action) do
    slack_user_id = action["idMemberCreator"]
    trello_username = action["memberCreator"]["fullName"]
    author = Scrummer.Members.get_member_by_id(slack_user_id, trello_username)
    %Scrummer.Scrum{author: author, message: action["data"]["text"]}
  end

  defp actions_endpoint(board), do: "#{@trello_api}/#{board}/?actions=commentCard#{signature()}"
  defp signature(), do: "&key=#{get_config(:key)}&token=#{get_config(:token)}"
  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: body |> JSON.decode!
  defp get_config(key), do: Application.get_env(:scrummer, :trello_secrets) |> Map.get(key)

end
