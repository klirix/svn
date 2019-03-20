defmodule StreamlabsIntroWeb.StreamLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div style="display: flex" >
        <div style="display: flex;flex-direction: column">
          <iframe
            src="https://player.twitch.tv/?channel=<%= @name %>"
            height="200"
            width="400"
            scrolling="true"
            allowfullscreen="true">
          </iframe>
          <div>
            <h2> Events: </h2>
            <%= for event <- @events do %>
            <p><%= Jason.encode!(event) %></p>
            <% end %>
          </div>
        </div>
        <iframe frameborder="0"
          scrolling="no"
          id="chat_embed"
          src="https://www.twitch.tv/embed/<%= @name %>/chat"
          height="500"
          width="350">
        </iframe>
      </div>
    """
  end

  def mount(%{ :streamer => name, :id => id }, socket) do
    if connected?(socket), do: StreamlabsIntro.StreamRouter.subscribe(self(), id)
    {:ok, assign(socket, counter: 0, events: [], name: name, id: id)}
  end

  def handle_info({:stream_event, event}, socket) do
    IO.inspect(["Client", event])
    {:noreply, update(socket, :events, &([event | &1]))}
  end
end
