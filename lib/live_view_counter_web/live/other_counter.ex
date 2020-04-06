defmodule LiveViewCounterWeb.OtherCounter do
  use Phoenix.LiveView

  def mount(%{"name" => name}, _session, socket) do
    state = assign(socket, :session_name, name) |> assign(:val, LiveViewCounterWeb.Cache.get(name))
    LiveViewCounterWeb.Endpoint.subscribe(name)
    {:ok, state, layout: { LiveViewCounterWeb.LayoutView, "app.html"}}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :val, &(&1 + 1))
    LiveViewCounterWeb.Cache.put(socket.assigns.session_name, socket.assigns.val + 1)
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), socket.assigns.session_name, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, &(&1 - 1))
    LiveViewCounterWeb.Cache.put(socket.assigns.session_name, socket.assigns.val - 1)
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), socket.assigns.session_name, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  def render(assigns) do
    LiveViewCounterWeb.PageView.render("other_counter.html", assigns)
  end
end
