defmodule Scrummer.Members do

    @member_by_trello_id %{
      # Trello user id              # Slack user id
      "59cd1c3b4b3c2963a5bd4f87" => "<@U752LEGCC>", # @jonathan
      "5b6d9d98a786cf4b27962514" => "<@UFXGP0D6Y>", # @Ana Magnoni
      "5945358673370cbe1178ca93" => "<@U9TSFUBN3>", # @Giulia
      "58776f5aff7f82f647ae53d0" => "<@U27BT5ZDH>", # @jpfaria
      "5a9f2b01f2f615ac798f0f53" => "<@UTV5HEL7Q>", # @jordão
      "5e3981be8b30f21c3fc34ecd" => "<@UTHPY9TFA>", # @rui
    }

    def get_member_by_id(id, fallback) do
      Map.get(@member_by_trello_id, id, fallback)
    end

  end
