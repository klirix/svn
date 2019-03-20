defmodule Twitch do

  @hub_link "https://api.twitch.tv/helix/webhooks/hub"
  def streamer_info(name) do
    HTTPoison.get "https://api.twitch.tv/helix/users?login=#{name}", headers()
  end

  def sub_to_streamer(id, unsub \\ false) do
    HTTPoison.post @hub_link, sub_payload(id, "follows", unsub), headers()
    HTTPoison.post @hub_link, sub_payload(id, "status", unsub), headers()
  end

  defp headers do
    [
      "Client-ID": "8q5p1n7lvfv6vdiworpac5geon43sq"
    ]
  end

  defp sub_payload id, topic, unsub do
    url = case topic do
      "follows" ->
        "https://api.twitch.tv/helix/users/follows?to_id=#{id}"
      "status" ->
        "https://api.twitch.tv/helix/streams?user_id=#{id}"
    end
    Jason.encode!(%{
      "hub.callback" => "https://hello.dev/api/#{topic}/#{id}",
      "hub.topic" => url,
      "hub.mode" => if unsub do "unsubscribe" else "subscribe" end
    })
  end
end
