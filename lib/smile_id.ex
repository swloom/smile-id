defmodule SmileId do
  @moduledoc """
  A module for interacting with the Smile ID API.
  """

  defstruct [:partner_id, :api_key, :sid_server]

  def new() do
    partner_id = Application.get_env(:smile_id, :partner_id)
    api_key = Application.get_env(:smile_id, :api_key)
    sid_server = Application.get_env(:smile_id, :sid_server)

    %SmileId{partner_id: partner_id, api_key: api_key, sid_server: sid_server}
  end
end
