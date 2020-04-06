defmodule LiveViewCounterWeb.Counter do
  use Phoenix.LiveView

  @topic "live"

  def mount(_params, _session, socket) do
    LiveViewCounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :val, 0), layout: { LiveViewCounterWeb.LayoutView, "app.html"}}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :val, &(&1 + 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, &(&1 - 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  def render(assigns) do
    LiveViewCounterWeb.PageView.render("counter.html", assigns)
  end
end
