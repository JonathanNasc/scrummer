defmodule Scrummer.Members do

    @member_by_trello_id %{
      "59cd1c3b4b3c2963a5bd4f87" => "<@U752LEGCC>", # @jonathan
      "5b6d9d98a786cf4b27962514" => "<@UFXGP0D6Y>", # @Ana Magnoni
      "5945358673370cbe1178ca93" => "<@U9TSFUBN3>", # @Giulia
      "58776f5aff7f82f647ae53d0" => "<@U27BT5ZDH>", # @jpfaria
    }
  
    def get_member_by_id(id, fallback) do
      Map.get(@member_by_trello_id, id, fallback)
    end
  
  end
  