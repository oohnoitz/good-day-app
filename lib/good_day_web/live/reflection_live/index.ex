defmodule GoodDayWeb.ReflectionLive.Index do
  use GoodDayWeb, :live_view

  alias GoodDay.Accounts
  alias GoodDay.Accounts.Reflection

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :reflections, Accounts.current_week_of_reflections(),
       dom_id: &"reflections-#{&1.date}"
     )}
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
    |> assign(:page_title, "Reflections")
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

  def icon_workday(icon) do
    case icon do
      :terrible -> "😭"
      :bad -> "☹️"
      :ok -> "😐"
      :good -> "☺️"
      :awesome -> "🥰"
    end
  end

  def icon_feeling(icon) do
    case icon do
      :tense -> "😧"
      :stress -> "😟"
      :sad -> "😢"
      :bored -> "🥱"
      :calm -> "😐"
      :serene -> "😌"
      :happy -> "☺️"
      :excited -> "😀"
    end
  end

  def heatmap_blue(shade) do
    case shade do
      :none -> "bg-gray-100"
      :little -> "bg-blue-100"
      :some -> "bg-blue-300"
      :much -> "bg-blue-400"
      :most -> "bg-blue-600"
    end
  end

  def heatmap_pink(shade) do
    case shade do
      :none -> "bg-gray-100"
      :one -> "bg-red-100"
      :two -> "bg-red-300"
      :few -> "bg-red-400"
      :many -> "bg-red-600"
    end
  end

  def heatmap_most(true), do: "bg-blue-400"
  def heatmap_most(false), do: "bg-white"

  def heatmap_least(true), do: "bg-red-400"
  def heatmap_least(false), do: "bg-white"
end
