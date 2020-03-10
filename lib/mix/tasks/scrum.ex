defmodule Mix.Tasks.Scrum do
  use Mix.Task

  @shortdoc "mix post [-t] [-d yyyy-mm-dd]"
  def run(args) do
    date = get_date(args)
    test = args |> Enum.any?(fn x -> x == "-t" end)

    date
    |> Scrummer.Trello.get_scrums()
    |> Scrummer.Scrum.parse(date)
    |> Scrummer.Slack.post_in_the_team_channel(test)
  end

  defp get_date(args), do: Enum.find_index(args, fn x -> x == "-d" end) |> get_date(args)
  defp get_date(_flag_index = nil, _), do: Scrummer.Date.get_last_day()
  defp get_date(flag_index, args), do: args |> Enum.at(flag_index + 1)

end
