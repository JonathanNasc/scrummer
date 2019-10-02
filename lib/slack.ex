defmodule Scrummer.Slack do

  @endpoint "https://slack.com/api/chat.postMessage"

  def post_in_the_team_channel(message, _test = true), do: IO.puts message
  def post_in_the_team_channel(message, _) do
    HTTPoison.post(@endpoint, body(message), headers(), options()) |> IO.inspect
  end

  defp options(), do: [timeout: 60_000, ssl: [{:versions, [:'tlsv1.2']}]]
  defp config(key), do: Application.get_env(:scrummer, :slack) |> Map.get(key)
  defp headers(), do: [{"Content-type", "application/x-www-form-urlencoded;charset=UTF-8"}]
  defp body(message) do
    URI.encode_query(%{
      "link_names" => 1,
      "token" => config(:token),
      "channel" => config(:channel),
      "text" => message,
    })
  end

end
  