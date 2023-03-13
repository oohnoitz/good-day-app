defmodule GoodDayWeb.ReflectionLive.Index do
  use GoodDayWeb, :live_view

  alias GoodDay.Accounts
  alias GoodDay.Accounts.Reflection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :reflections, Accounts.list_reflections())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reflection")
    |> assign(:reflection, Accounts.get_reflection!(id))
  end

  defp apply_action(socket, :new, _params) do
    date = Date.utc_today()

    socket
    |> assign(:page_title, "Reflection for #{date}")
    |> assign(:reflection, %Reflection{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reflections")
    |> assign(:reflection, nil)
  end

  @impl true
  def handle_info({GoodDayWeb.ReflectionLive.FormComponent, {:saved, reflection}}, socket) do
    {:noreply, stream_insert(socket, :reflections, reflection)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reflection = Accounts.get_reflection!(id)
    {:ok, _} = Accounts.delete_reflection(reflection)

    {:noreply, stream_delete(socket, :reflections, reflection)}
  end
end
