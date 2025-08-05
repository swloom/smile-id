defmodule SmileId.Signature do
  @moduledoc """
  Generates signature for a given partner ID and API key.

  A generated `%Signature{}` is a struct containing a `signature` and a
  `timestamp`. Signatures are uniquely generated using Elixir's `:crypto` module.
  """

  alias SmileId.Signature

  defstruct [:timestamp, :signature]

  @doc """
  Generate a unique signature.

  ## Parameters
  - `smile_id`: The `%SmileId{}` struct to use for the signature.
  - `timestamp`: The `%DateTime{}` timestamp to use for the signature. Defaults to the current UTC time.

  ## Returns
  A `%Signature{}` struct containing the signature and timestamp.
  """
  def generate_signature(%SmileId{} = smile_id, %DateTime{} = timestamp \\ DateTime.utc_now()) do
    signature =
      :crypto.mac_init(:hmac, :sha256, smile_id.api_key)
      |> :crypto.mac_update(timestamp |> DateTime.to_iso8601())
      |> :crypto.mac_update(smile_id.partner_id)
      |> :crypto.mac_update("sid_request")
      |> :crypto.mac_final()
      |> Base.encode64()

    {:ok, %Signature{timestamp: timestamp, signature: signature}}
  end

  @doc """
  Validate a signature.

  ## Parameters
  - `smile_id`: The `%SmileId{}` struct to use for the signature.
  - `timestamp`: The `%DateTime{}` timestamp of the signature.
  - `signature`: The signature to validate.

  ## Returns
  A boolean indicating if the signature is valid.
  """
  def valid_signature?(%SmileId{} = smile_id, %DateTime{} = timestamp, signature) do
    case generate_signature(smile_id, timestamp) do
      {:ok, %Signature{signature: ^signature}} -> true
      {:ok, %Signature{}} -> false
    end
  end
end
