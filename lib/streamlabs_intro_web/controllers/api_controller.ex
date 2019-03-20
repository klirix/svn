defmodule StreamlabsIntroWeb.ApiController do
  use StreamlabsIntroWeb, :controller

  def confirm(conn, %{ "hub.challenge" => ch }), do: text(conn, ch)

  def send(conn, %{"event" => event, "id" => id, "data" => data}) do
    streamer = StreamlabsIntro.StreamRouter.get(id)
    case event do
      "follow" ->
        for follow <- data do
          StreamlabsIntro.Streamer.event(streamer,
            "#{follow["from_name"]} just started following "
          )
        end
      "status" ->
        case data do
          [] ->
            StreamlabsIntro.Streamer.event(streamer,"Stream just has ended.")
          [status] ->
            StreamlabsIntro.Streamer.event(streamer,
              "stream is called #{status["title"]} now"
            )
        end
    end
    conn |> text("ok")
  end
end
