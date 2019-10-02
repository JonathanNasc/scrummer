# Scrummer

## Installation

- Install Elixir
- Copy the config file and provide the credentials `cp config/config.sample.exs config/config.exs`
- Run `mix deps.get`

## Usage

- Run `mix post` to get the scrum messages and post it on Slack
- Optionally add a `-t` param to print the result instead of posting it
- The dafault date is the last working day. But you can also provide it as `-d 2019-11-01` 
