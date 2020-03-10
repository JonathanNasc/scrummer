# Scrummer

Useful scripts to manage teams activities through Trello features

## Installation

- Install Elixir
- Copy the config file and provide the credentials and the other configs `cp config/config.sample.exs config/config.exs`
- Run `mix deps.get`

## Usage

### Scrum

List the team members comments from the last working-day, writed in the pattern `Scrum: bla bla bla` and post it on a Slack channel.

- Run `mix scrum` to get the scrum messages and post it on Slack
- Optionally add a `-t` param to print the result instead of posting it in the channel
- The dafault date is the last working day. But you can also provide it as `-d 2019-11-01` 

### Toil

List the info of cards created from a specific date.

- Run `mix toil` to get the list in CSV format
- Add `-d 2019-11` to specify a month
