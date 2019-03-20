defmodule StreamlabsIntroWeb.ApiController do
  use StreamlabsIntroWeb, :controller

  # plug :check_hash when action in [:send]

  def confirm(conn, %{ "hub.challenge" => ch }), do: text(conn, ch)

  def send(conn, %{"event" => event, "id" => id, "data" => data}) do
    streamer = StreamlabsIntro.StreamRouter.get(id)
    IO.inspect(data)
    case event do
      "follows" ->
        StreamlabsIntro.Streamer.event(streamer,
            "#{data["from_id"]} just started following "
          )
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

  # Disabled this one because there's no convenient way to save original body bytes
  # defp check_hash(conn, _) do
  #   {:ok, body, _} =  conn |> read_body()
  #   [hash] = conn |> get_req_header("x-hub-signature")
  #   # IO.inspect(conn)
  #   hash = String.downcase(hash)
  #   secret = Application.get_env(:streamlabs_intro, StreamlabsIntroWeb.Endpoint)[:secret_key_base]
  #   expected_hash = String.downcase("sha256=#{:crypto.hmac(:sha256, secret, body) |> Base.encode16()}")
  #   # IO.inspect([hash, expected_hash])
  #   if hash == expected_hash do
  #     conn
  #   else
  #     conn
  #     |> put_status(401)
  #     |> text("failed check")
  #     |> halt()
  #   end
  # end
end
