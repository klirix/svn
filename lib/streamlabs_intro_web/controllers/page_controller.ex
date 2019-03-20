defmodule StreamlabsIntroWeb.PageController do
  use StreamlabsIntroWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _params) do
    base = if Mix.env() =="prod" do "http://localhost:4000" else "https://sev.askh.at" end
    render(conn, "index.html",
      logged_in: get_session(conn, :logged_in),
      redirect_url: "/login"
    )
  end

  def login(conn, %{"code" => code}) do
    conn
    |> put_session(:code, code)
    |> put_session(:logged_in, true)
    |> redirect(to: "/")
  end

  def stream(conn, %{"streamer" => streamer}) do
    case Twitch.streamer_info(streamer) do
      {:ok, %{ body: body }} ->
        case Jason.decode(body) do
          {:ok, %{"data" => [%{"id" => id, "login" => streamer}] }} ->
            LiveView.Controller.live_render(conn, StreamlabsIntroWeb.StreamLive, session: %{
              streamer: streamer, id: id
            })
          _ ->
            streamer_not_found(conn)
        end
      _ ->
        streamer_not_found(conn)
    end
  end

  defp streamer_not_found(conn) do
    conn
    |> put_flash(:error, "Streamer not found")
    |> redirect(to: "/")
  end

end
