defmodule Util.TicketingAuthTest do
  use ExUnit.Case, async: true

  alias Util.TicketingAuth

  @shared_secret Application.get_env(:what_where_when, :ticketing_key)

  describe "outbound/0" do
    setup do
      [output: TicketingAuth.outbound()]
    end

    test "outputs a string", %{output: result} do
      assert is_binary(result)
      assert to_string(result) == result
    end

    test "output is a parsable URL", %{output: o} do
      assert {:ok, _uri} = URI.new(o)
    end

    test "output URI has expected components outside query", %{output: o} do
      uri = URI.parse(o)

      assert uri.scheme == "https"
      assert uri.host == "volunteer.fireflyartscollective.org"
      assert uri.port == 443
      assert uri.path == "/site/eventauth"
    end

    test "output URI's query has expected components", %{output: o} do
      uri = URI.parse(o)
      query = URI.decode_query(uri.query)

      assert map_size(query) == 2
      assert Map.has_key?(query, "timestamp")
      assert Map.has_key?(query, "sig")

      ts = Map.get(query, "timestamp")

      assert is_binary(ts)
      assert to_string(ts) == ts
      assert {_int, ""} = Integer.parse(ts)
    end

    test "output URI's query's timestamp is valid and current", %{output: o} do
      {ts, ""} =
        o
        |> URI.parse()
        |> Map.get(:query)
        |> URI.decode_query()
        |> Map.get("timestamp")
        |> Integer.parse()

      assert ts = DateTime.from_unix!(ts, :second)
      assert DateTime.diff(DateTime.utc_now(), ts) < 1
    end

    test "output URI's query's signature is valid", %{output: o} do
      %{"sig" => sig, "timestamp" => ts} =
        o
        |> URI.parse()
        |> Map.get(:query)
        |> URI.decode_query()

      assert sig = Base.decode64!(sig)

      assert sig == :crypto.mac(:hmac, :sha256, @shared_secret, ts)
    end
  end

  describe "inbound_uri/1" do
    import Jason.Sigil

    setup do
      ts = DateTime.utc_now() |> DateTime.to_unix()

      auth = ~j"""
      {
        "burnName": "Burny",
        "chosenName": "Bernard Sanders",
        "email": "bsanders@senate.gov",
        "username": "feelth3bern",
        "timestamp": #{ts},
        "whereCamped": "The Nintey-Fine Percent"
      }
      """

      auth_json = Jason.encode!(auth)
      sig = :crypto.mac(:hmac, :sha256, @shared_secret, auth_json) |> Base.encode64()

      uri = %URI{query: URI.encode_query(auth: auth_json, sig: sig)}

      %{input_uri: uri, input_auth_object: auth, output: TicketingAuth.inbound_uri(uri)}
    end

    test "output has expected shape", %{output: output} do
      assert map_size(output) == 3

      assert Map.has_key?(output, :payload)
      assert is_struct(output[:payload], TicketingAuth)

      assert Map.has_key?(output, :signature_valid)
      assert is_boolean(output[:signature_valid])

      assert Map.has_key?(output, :delta_seconds)
      assert is_integer(output[:delta_seconds])
    end

    test "payload contains expected data", %{output: out, input_auth_object: in_auth} do
      assert out_auth = out.payload

      assert out_auth.burn_name == in_auth["burnName"]
      assert out_auth.id_name == in_auth["chosenName"]
      assert out_auth.email == in_auth["email"]
      assert out_auth.username == in_auth["username"]
      assert out_auth.where_camped == in_auth["whereCamped"]
      assert out_auth.timestamp == in_auth["timestamp"]
    end

    test "signature is marked valid", %{output: out} do
      assert out.signature_valid
    end

    test "delta is small", %{output: out} do
      assert out.delta_seconds < 5
    end

    test "bad signature is noticed", %{input_uri: uri} do
      output =
        TicketingAuth.inbound_uri(
          Map.put(
            uri,
            :query,
            URI.decode_query(uri.query) |> Map.put("sig", "garbage") |> URI.encode_query()
          )
          |> URI.to_string()
        )

      assert !output.signature_valid
    end
  end
end
