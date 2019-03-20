defmodule StreamlabsIntroWeb.ApiController do
  use StreamlabsIntroWeb, :controller

  def confirm(conn, %{ "hub.challenge" => ch }), do: text(conn, ch)

  def send(conn, %{"event" => event, "id" => id, "data" => data}) do
    streamer = StreamlabsIntro.StreamRouter.get(id)
    StreamlabsIntro.Streamer.event(streamer, %{event: event, data: data})
    conn |> json(true)
  end
end
