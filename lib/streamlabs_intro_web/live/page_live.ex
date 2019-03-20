defmodule StreamlabsIntroWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>
        <button phx-click="inc"> inc </button> <%= @counter %>
      </div>
    """
  end

  def mount(_, socket) do
    {:ok, assign(socket, :counter , 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :counter, &(&1+1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :counter, &(&1-1))}
  end
end
