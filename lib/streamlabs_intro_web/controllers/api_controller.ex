defmodule StreamlabsIntroWeb.ApiController do
  use StreamlabsIntroWeb, :controller

  plug :check_hash when action in [:send]

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

  defp check_hash(conn, _) do
    {:ok, body, _} =  conn |> read_body()
    [hash] = conn |> get_req_header("x-hub-signature")
    hash = String.downcase(hash)
    secret = Application.get_env(:streamlabs_intro, StreamlabsIntroWeb.Endpoint)[:secret_key_base]
    expected_hash = String.downcase("sha256=#{:crypto.hmac(:sha256, secret, body) |> Base.encode16()}")
    if hash == expected_hash do
      conn
    else
      conn
      |> put_status(401)
      |> text("failed check")
      |> halt()
    end
  end
end
