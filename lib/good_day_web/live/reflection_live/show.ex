defmodule GoodDayWeb.ReflectionLive.Show do
  use GoodDayWeb, :live_view

  alias GoodDay.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:reflection, Accounts.get_reflection!(id))}
  end

  defp page_title(:show), do: "Show Reflection"
  defp page_title(:edit), do: "Edit Reflection"
end
