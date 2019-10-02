defmodule Scrummer.Date do

  def get_last_day() do
    today()
    |> Date.day_of_week()
    |> get_last_working_day()
    |> Date.to_iso8601()
  end

  defp get_last_working_day(_day_of_week = 1), do: today() |> Date.add(-3)
  defp get_last_working_day(_day_of_week), do: today() |> Date.add(-1)

  defp today(), do:  DateTime.utc_now() |> DateTime.to_date()

end
  