use Mix.Config

config :scrummer, trello_boards: [
    "PO41CaUH", #houston alerts
    "ul09FhDm", #dev pay ops
]

config :scrummer, trello_secrets: %{
    :key => "",
    :token => "",
}

config :scrummer, slack: %{
    :channel => "",
    :token => "",
}
