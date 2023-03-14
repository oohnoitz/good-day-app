defmodule GoodDayWeb.ReflectionLive.Index do
  use GoodDayWeb, :live_view

  alias GoodDay.Accounts
  alias GoodDay.Accounts.Reflection

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :reflections,
       Accounts.current_week_of_reflections_for_user(socket.assigns.current_user.id),
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
    socket
    |> assign(:page_title, "New Reflection")
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
    current_user_id = socket.assigns.current_user.id
    reflection = Accounts.get_reflection!(id)

    with %{user_id: ^current_user_id} <- reflection,
         {:ok, _} <- Accounts.delete_reflection(reflection) do
      {:noreply, stream_delete(socket, :reflections, reflection)}
    else
      _error ->
        {:noreply, socket}
    end
  end

  def icon_workday(icon) do
    case icon do
      :terrible -> "😭"
      :bad -> "🙁"
      :ok -> "😐"
      :good -> "🙂"
      :awesome -> "😍"
    end
  end

  def icon_feeling(icon) do
    case icon do
      :tense -> "😬"
      :stress -> "😟"
      :sad -> "😢"
      :bored -> "🥱"
      :calm -> "☺️"
      :serene -> "😌"
      :happy -> "🙂"
      :excited -> "😀"
    end
  end

  def heatmap_blue(shade) do
    case shade do
      :none -> "bg-blue-100"
      :little -> "bg-blue-200"
      :some -> "bg-blue-400"
      :much -> "bg-blue-500"
      :most -> "bg-blue-800"
    end
  end

  def heatmap_pink(shade) do
    case shade do
      :none -> "bg-red-100"
      :one -> "bg-red-200"
      :two -> "bg-red-400"
      :few -> "bg-red-500"
      :many -> "bg-red-800"
    end
  end

  def heatmap_most(true), do: "bg-blue-500"
  def heatmap_most(false), do: "bg-slate-50"

  def heatmap_least(true), do: "bg-red-500"
  def heatmap_least(false), do: "bg-slate-50"

  def summary_good(reflections) do
    Enum.reduce(reflections, 0, fn {_id, reflection}, acc ->
      if reflection.workday_quality in [:good, :awesome] do
        acc + 1
      else
        acc
      end
    end)
  end

  def summary_good_percentage(reflections) do
    round(summary_good(reflections) / Enum.count(reflections) * 100)
  end

  def summary_okay(reflections) do
    Enum.reduce(reflections, 0, fn {_id, reflection}, acc ->
      if reflection.workday_quality in [:good, :awesome] do
        acc
      else
        acc + 1
      end
    end)
  end

  def summary_okay_percentage(reflections) do
    round(summary_okay(reflections) / Enum.count(reflections) * 100)
  end

  def summary_average(reflections) do
    mapping = [terrible: 0, bad: 1, ok: 2, good: 3, awesome: 4]

    average =
      round(
        Enum.reduce(reflections, 0, fn {_id, reflection}, acc ->
          acc + Keyword.get(mapping, reflection.workday_quality, 0)
        end) / Enum.count(reflections)
      )

    case average do
      0 -> icon_workday(:terrible) <> " Terrible"
      1 -> icon_workday(:bad) <> " Bad"
      2 -> icon_workday(:ok) <> " OK"
      3 -> icon_workday(:good) <> " Good"
      4 -> icon_workday(:awesome) <> " Awesome"
    end
  end
end
