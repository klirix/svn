defmodule Twitch do

  @hub_link "https://api.twitch.tv/helix/webhooks/hub"
  def streamer_info(name) do
    HTTPoison.get "https://api.twitch.tv/helix/users?login=#{name}", headers()
  end

  def sub_to_streamer(id, unsub \\ false) do
    IO.inspect(HTTPoison.post @hub_link, sub_payload(id, "follows", unsub), headers())
    IO.inspect(HTTPoison.post @hub_link, sub_payload(id, "status", unsub), headers())
  end

  defp headers do
    [
      "Client-ID": "8q5p1n7lvfv6vdiworpac5geon43sq",
      "Content-Type": "application/json"
    ]
  end

  defp sub_payload id, topic, unsub do
    url = case topic do
      "follows" ->
        "https://api.twitch.tv/helix/users/follows?to_id=#{id}"
      "status" ->
        "https://api.twitch.tv/helix/streams?user_id=#{id}"
    end
    secret = Application.get_env(:streamlabs_intro, StreamlabsIntroWeb.Endpoint)[:secret_key_base]
    host = Application.get_env(:streamlabs_intro, StreamlabsIntroWeb.Endpoint)[:url][:host]
    Jason.encode!(%{
      "hub.callback" => "https://#{host}/api/#{topic}/#{id}",
      "hub.topic" => url,
      "hub.mode" => if unsub do "unsubscribe" else "subscribe" end,
      "hub.lease_seconds" => if Mix.env() == :prod do 864000 else 0 end,
      "hub.secret" => if Mix.env() == :prod do secret else nil end
    })
  end
end
