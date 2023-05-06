defmodule GoodDayWeb.ReflectionLive.Index do
  use GoodDayWeb, :live_view

  alias GoodDay.Accounts
  alias GoodDay.Accounts.Reflection

  @impl true
  def handle_params(params, _url, socket) do
    reflections = Accounts.current_week_of_reflections_for_user(socket.assigns.current_user.id)
    socket = assign(socket, reflections: reflections)

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
    Enum.reduce(reflections, 0, fn reflection, acc ->
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
    Enum.reduce(reflections, 0, fn reflection, acc ->
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
        Enum.reduce(reflections, 0, fn reflection, acc ->
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

  def chart(%{reflections: []} = assigns), do: ~H()

  def chart(assigns) do
    ~H"""
    <h2 class="mt-6 text-xl font-semibold">What did your good and not-so-good days look like?</h2>
    <div class="space-y-2 text-sm text-zinc-500">
      <p>First, let's look at how you responded to each question over the week.</p>
      <p>
        Is there any relationship to how you answered the first
        <em class="font-semibold">How was your workday</em>
        question? We show how you reported the quality of your workday and how you felt about it at the top - see if there are any patterns on the Good days that you can control.
      </p>
    </div>

    <div class="mt-2 overflow-x-auto px-4 sm:overflow-visible bg-slate-50">
      <table class="py-4 w-[40rem] sm:w-full flex">
        <thead class="flex text-left text-[0.8125rem] leading-7 text-zinc-700">
          <tr class="flex flex-col pr-2 gap-1">
            <th class="h-8 font-normal text-right">&nbsp;</th>
            <th class="h-8 font-normal text-right">How was your workday?</th>
            <th class="h-8 font-normal text-right">How do you feel about your workday?</th>
            <th class="h-8 font-normal text-right">I worked with other people</th>
            <th class="h-8 font-normal text-right">I helped other people</th>
            <th class="h-8 font-normal text-right">My work was interrupted</th>
            <th class="h-8 font-normal text-right">I made progress towards my goals</th>
            <th class="h-8 font-normal text-right">I did high-quality work</th>
            <th class="h-8 font-normal text-right">I did a lot of work</th>
            <th class="h-8 font-normal text-right">I took breaks today</th>
            <th class="h-8 font-normal text-right">How many meetings did you have today?</th>
          </tr>
        </thead>
        <tbody id="reflections-chart-1" class="flex gap-1">
          <tr :for={row <- @reflections} id={"#graph-1-#{row.id}"} class="flex flex-col gap-1">
            <td class="h-8 text-center uppercase font-mono tracking-wide">
              <.link navigate={~p"/r/#{row}/edit"}>
                <%= Timex.format!(row.date, "{WDshort}") %>
              </.link>
            </td>
            <td class="h-8 w-16 text-center text-xl">
              <%= icon_workday(row.workday_quality) %>
            </td>
            <td class="h-8 w-16 text-center text-xl">
              <%= icon_feeling(row.workday_feeling) %>
            </td>
            <td class={["h-8 w-16", heatmap_blue(row.work_other_people_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.help_other_people_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.interrupted_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.made_progress_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.made_quality_work_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.made_work_amount)]}></td>
            <td class={["h-8 w-16", heatmap_blue(row.breaks_amount)]}></td>
            <td class={["h-8 w-16", heatmap_pink(row.meeting_amount)]}></td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="p-4 text-zinc-500 bg-slate-50">
      <div class="flex gap-4">
        <div>
          <h3 class="font-semibold">Amount of day</h3>
          <ul class="mt-1">
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_blue(:none)]}></div>
              None of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_blue(:little)]}></div>
              A little of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_blue(:some)]}></div>
              Some of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_blue(:much)]}></div>
              Much of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_blue(:most)]}></div>
              Most or all of the day
            </li>
          </ul>
        </div>

        <div>
          <h3 class="font-semibold">Meetings</h3>
          <ul class="mt-1">
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_pink(:none)]}></div>
              None of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_pink(:one)]}></div>
              A little of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_pink(:two)]}></div>
              Some of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_pink(:few)]}></div>
              Much of the day
            </li>
            <li class="flex items-center gap-2 text-sm">
              <div class={["h-2 w-2", heatmap_pink(:many)]}></div>
              Most or all of the day
            </li>
          </ul>
        </div>
      </div>
    </div>

    <h2 class="mt-6 text-xl font-semibold">What time of the day are you most productive?</h2>

    <div class="mt-2 overflow-y-auto px-4 sm:overflow-visible bg-slate-50">
      <table class="py-4 w-[40rem] sm:w-full flex">
        <thead class="flex text-left text-[0.8125rem] leading-7 text-zinc-700">
          <tr class="flex flex-col pr-2 gap-1">
            <th class="h-8 font-normal text-right">&nbsp;</th>
            <th class="h-8 font-normal text-right">In the morning (9:00-11:00)</th>
            <th class="h-8 font-normal text-right">Mid-day (11:00-13:00)</th>
            <th class="h-8 font-normal text-right">Early afternoon (13:00-15:00)</th>
            <th class="h-8 font-normal text-right">Late afternoon (15:00-17:00)</th>
            <th class="h-8 font-normal text-right">Outside of typical work hours</th>
            <th class="h-8 font-normal text-right">Equally throughout the day</th>
          </tr>
        </thead>
        <tbody id="reflections-chart-2" phx-update="stream" class="flex gap-1">
          <tr
            :for={
              %{most_productive_time: time} = row <-
                @reflections
            }
            id={"#chart-2-#{row.id}"}
            class="flex flex-col gap-1"
          >
            <td class="h-8 text-center uppercase font-mono tracking-wide">
              <%= Timex.format!(row.date, "{WDshort}") %>
            </td>
            <td class={["h-8 w-16", heatmap_most(time == :morning)]}></td>
            <td class={["h-8 w-16", heatmap_most(time == :midday)]}></td>
            <td class={["h-8 w-16", heatmap_most(time == :earlyafternoon)]}></td>
            <td class={["h-8 w-16", heatmap_most(time == :lateafternoon)]}></td>
            <td class={["h-8 w-16", heatmap_most(time == :nonwork)]}></td>
            <td class={["h-8 w-16", heatmap_most(time == :equally)]}></td>
          </tr>
        </tbody>
      </table>
    </div>

    <h2 class="mt-6 text-xl font-semibold">What time of the day are you least productive?</h2>

    <div class="mt-2 overflow-y-auto px-4 sm:overflow-visible bg-slate-50">
      <table class="py-4 w-[40rem] sm:w-full flex">
        <thead class="flex text-left text-[0.8125rem] leading-6 text-zinc-700">
          <tr class="flex flex-col pr-2 gap-1">
            <th class="h-8 font-normal text-right">&nbsp;</th>
            <th class="h-8 font-normal text-right">In the morning (9:00-11:00)</th>
            <th class="h-8 font-normal text-right">Mid-day (11:00-13:00)</th>
            <th class="h-8 font-normal text-right">Early afternoon (13:00-15:00)</th>
            <th class="h-8 font-normal text-right">Late afternoon (15:00-17:00)</th>
            <th class="h-8 font-normal text-right">Outside of typical work hours</th>
            <th class="h-8 font-normal text-right">Equally throughout the day</th>
          </tr>
        </thead>
        <tbody id="reflections-graph-3" class="flex gap-1">
          <tr
            :for={%{least_productive_time: time} = row <- @reflections}
            id={"#graph-3-#{row.id}"}
            class="flex flex-col gap-1"
          >
            <td class="h-8 text-center uppercase font-mono tracking-wide">
              <%= Timex.format!(row.date, "{WDshort}") %>
            </td>
            <td class={["h-8 w-16", heatmap_least(time == :morning)]}></td>
            <td class={["h-8 w-16", heatmap_least(time == :midday)]}></td>
            <td class={["h-8 w-16", heatmap_least(time == :earlyafternoon)]}></td>
            <td class={["h-8 w-16", heatmap_least(time == :lateafternoon)]}></td>
            <td class={["h-8 w-16", heatmap_least(time == :nonwork)]}></td>
            <td class={["h-8 w-16", heatmap_least(time == :equally)]}></td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
