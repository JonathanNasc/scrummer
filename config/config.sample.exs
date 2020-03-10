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

config :toiler, trello_lists: [
    "5c8e35966ae25a5e7c836f37", #EBANX Plantão list done
]
