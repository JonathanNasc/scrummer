defmodule Mix.Tasks.Toil do
  use Mix.Task

  @months %{
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December",
  }

  @shortdoc "mix toil [-d yyyy-mm]"
  def run(args) do
    date = get_date(args)

    date
    |> Scrummer.Trello.get_on_call_cards()
    |> print_toil()
  end

  defp print_toil(cards) do
    cards
    |> Enum.map(fn card ->
      month = Map.get(@months, card.date.month)
      date = "#{card.date.year}-#{card.date.month}-#{card.date.day}"
      "#{card.name}, #{date}, #{card.member}, #{card.shortUrl}, code, #{month}"
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp get_date(args), do: Enum.find_index(args, fn x -> x == "-d" end) |> get_date(args)
  defp get_date(_flag_index = nil, _), do: Date.utc_today() |> Date.to_iso8601()
  defp get_date(flag_index, args), do: args |> Enum.at(flag_index + 1) |> add_day()

  defp add_day(year_and_month), do: "#{year_and_month}-01"

end
