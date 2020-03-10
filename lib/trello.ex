defmodule Scrummer.Trello do
  alias Poison, as: JSON

  @trello_api "https://api.trello.com/1"

  def get_scrums(date) do
    Application.get_env(:scrummer, :trello_boards)
    |> Enum.map(&actions_endpoint/1)
    |> Enum.map(&get_comments/1)
    |> List.flatten()
    |> filter_comments(date)
    |> Enum.map(&parse_scrum_messages/1)
  end

  @spec get_on_call_cards(any) :: any
  def get_on_call_cards(date) do
    Application.get_env(:toiler, :trello_lists)
    |> Enum.map(&cards_endpoint/1)
    |> Enum.map(&request_api/1)
    |> List.flatten()
    |> Enum.map(&parse_cards/1)
    |> filter_cards(date)
  end

  defp request_api(endpoint) do
    HTTPoison.start()

    endpoint
    |> HTTPoison.get([], [timeout: 60_000, ssl: [{:versions, [:'tlsv1.2']}]])
    |> parse_response
  end

  defp get_comments(endpoint) do
    response = request_api(endpoint)
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

  defp filter_cards(cards, date) do
    date_limit = Date.from_iso8601!(date)

    cards
    |> Enum.filter(fn card ->
      card_date = DateTime.to_date(card.date)
      :gt == Date.compare(card_date, date_limit)
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

  defp get_creation_date_from_trello_object_id(object_id) do
    {timestamp, _} = String.slice(object_id, 0..7) |> Integer.parse(16)
    {:ok, creation_date} = timestamp * 1000 |> DateTime.from_unix(:millisecond)
    creation_date
  end

  defp parse_cards(%{"id" => card_id, "members" => members, "name" => card_name, "shortUrl" => shortUrl}) do
    date = get_creation_date_from_trello_object_id(card_id)
    member = fist_member(members)
    %Scrummer.Card{author: "test", name: card_name, member: member, id: card_id, shortUrl: shortUrl, date: date}
  end

  defp fist_member(members) do
    members
    |> Enum.map(fn %{"fullName" => name} -> name end)
    |> Enum.join(",")
  end

  defp cards_endpoint(list), do: "#{@trello_api}/lists/#{list}/cards/?limit=100&fields=name,shortUrl&members=true&member_fields=fullName#{signature()}"
  defp actions_endpoint(board), do: "#{@trello_api}/boards/#{board}/?actions=commentCard#{signature()}"
  defp signature(), do: "&key=#{get_config(:key)}&token=#{get_config(:token)}"
  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: body |> JSON.decode!
  defp get_config(key), do: Application.get_env(:scrummer, :trello_secrets) |> Map.get(key)

end
