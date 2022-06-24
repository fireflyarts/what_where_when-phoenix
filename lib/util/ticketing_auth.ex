defmodule Util.TicketingAuth do
  defstruct ~w[burn_name id_name email username where_camped timestamp]a

  @baseuri URI.new!("https://volunteer.fireflyartscollective.org/site/eventauth")

  defp shared_secret, do: Application.get_env(:what_where_when, :ticketing_key)

  def outbound() do
    @baseuri
    |> Map.put(
      :query,
      Timex.now()
      |> Timex.to_unix()
      |> to_string
      |> then(
        &%{
          "timestamp" => &1,
          "sig" => calculate_sig(&1)
        }
      )
      |> URI.encode_query(:rfc3986)
    )
    |> URI.to_string()
  end

  def inbound_uri(uri) do
    uri
    |> URI.parse()
    |> Map.get(:query)
    |> URI.decode_query()
    |> inbound_params()
  end

  def inbound_params(params), do: validate(params)

  defp calculate_sig(payload) do
    :crypto.mac(:hmac, :sha256, shared_secret(), payload)
    |> Base.encode64()
  end

  defp validate(%{"auth" => payload, "sig" => sig}) do
    %{
      payload: Jason.decode!(payload) |> structify,
      signature_valid: calculate_sig(payload) == sig
    }
    |> then(
      &Map.put(
        &1,
        :delta,
        Timex.diff(Timex.from_unix(&1[:payload].timestamp), Timex.now(), :seconds)
      )
    )
  end

  defp structify(%{
         "burnName" => burn_name,
         "chosenName" => id_name,
         "email" => email,
         "timestamp" => ts,
         "username" => username,
         "whereCamped" => where_camped
       }) do
    %__MODULE__{
      id_name: id_name,
      burn_name: burn_name,
      email: email,
      username: username,
      where_camped: where_camped,
      timestamp: ts
    }
  end
end
