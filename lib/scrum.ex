defmodule Scrummer.Scrum do
  defstruct author: nil, message: nil

  def parse([], date), do: "No scrums on #{date} :'("
  def parse(scrums, date) do
    messages = scrums
    |> Enum.map(fn(scrum) -> scrum.author end)
    |> Enum.uniq()
    |> Enum.map(fn author -> scrum_messages_by_author(author, scrums) end)
    |> Enum.join("\n")

    "*Scrums on #{date}*\n\n#{messages}"
  end

  defp scrum_messages_by_author(author, scrums) do
    messages = scrums
    |> Enum.filter(fn (scrum) -> scrum.author == author end)
    |> Enum.map(fn (scrum) -> "-#{format(scrum.message)}" end) 
    |> Enum.join("\n")

    "\n#{author} \n#{messages} \n"
  end

  defp format(message) do
    message
    |> String.replace(~r|\[.*?\]|, "")
    |> String.replace("Scrum:", "")
    |> String.replace("Scrum :", "")
    |> String.replace("Scrum", "")
  end
end
