defmodule GoodDayWeb.ReflectionLive.FormComponent do
  use GoodDayWeb, :live_component

  alias GoodDay.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Hope you had a good day today! Tell us about it:</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reflection-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" />
        <.input
          field={@form[:workday_quality]}
          type="select"
          label="🤔 How was your workday?"
          options={[
            [key: "", value: ""],
            [key: "😭 Terrible", value: :terrible],
            [key: "🙁 Bad", value: :bad],
            [key: "😐 OK", value: :ok],
            [key: "🙂 Good", value: :good],
            [key: "😍 Awesome", value: :awesome]
          ]}
        />
        <.input
          field={@form[:work_other_people_amount]}
          type="select"
          label="👥 I worked with other people..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:help_other_people_amount]}
          type="select"
          label="🤲 I helped other people..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:interrupted_amount]}
          type="select"
          label="🚨 My work was interrupted..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:made_progress_amount]}
          type="select"
          label="🎯 I made progress towards my goals..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:made_quality_work_amount]}
          type="select"
          label="✨ I did high-quality work..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:made_work_amount]}
          type="select"
          label="🚀 I did a lot of work..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:breaks_amount]}
          type="select"
          label="☕ I took breaks today..."
          options={[
            [key: "", value: ""],
            [key: "None of the day", value: :none],
            [key: "A little of the day", value: :little],
            [key: "Some of the day", value: :some],
            [key: "Much of the day", value: :much],
            [key: "Most or all of the day", value: :most]
          ]}
        />
        <.input
          field={@form[:meeting_amount]}
          type="select"
          label="🗣️ How many meetings did you have today?"
          options={[
            [key: "", value: ""],
            [key: "None", value: :none],
            [key: "1", value: :one],
            [key: "2", value: :two],
            [key: "3-4", value: :few],
            [key: "5 or more", value: :many]
          ]}
        />
        <.input
          field={@form[:workday_feeling]}
          type="select"
          label="💭 How do you feel about your workday?"
          options={[
            [key: "", value: ""],
            [key: "😬 Tense or nervous", value: :tense],
            [key: "😟 Stressed or upset", value: :stress],
            [key: "😢 Sad or depressed", value: :sad],
            [key: "🥱 Bored", value: :bored],
            [key: "☺️ Calm or relaxed", value: :calm],
            [key: "😌 Serene or content", value: :serene],
            [key: "🙂 Happy or elated", value: :happy],
            [key: "😀 Excited or alert", value: :excited]
          ]}
        />
        <.input
          field={@form[:most_productive_time]}
          type="select"
          label="📈 Today, I felt most productive:"
          options={[
            [key: "", value: ""],
            [key: "🌅 In the morning (9:00-11:00)", value: :morning],
            [key: "🕛 Mid-day (11:00-13:00)", value: :midday],
            [key: "🕑 Early afternoon (13:00-15:00)", value: :earlyafternoon],
            [key: "🕔 Late afternoon (15:00-17:00)", value: :lateafternoon],
            [key: "🌃 Outside of typical work hours", value: :nonwork],
            [key: "📅 Equally throughout the day", value: :equally]
          ]}
        />
        <.input
          field={@form[:least_productive_time]}
          type="select"
          label="📉 Today, I felt least productive:"
          options={[
            [key: "", value: ""],
            [key: "🌅 In the morning (9:00-11:00)", value: :morning],
            [key: "🕛 Mid-day (11:00-13:00)", value: :midday],
            [key: "🕑 Early afternoon (13:00-15:00)", value: :earlyafternoon],
            [key: "🕔 Late afternoon (15:00-17:00)", value: :lateafternoon],
            [key: "🌃 Outside of typical work hours", value: :nonwork],
            [key: "📅 Equally throughout the day", value: :equally]
          ]}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reflection: reflection} = assigns, socket) do
    changeset = Accounts.change_reflection(reflection)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"reflection" => reflection_params}, socket) do
    changeset =
      socket.assigns.reflection
      |> Accounts.change_reflection(reflection_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"reflection" => reflection_params}, socket) do
    reflection_params = Map.put(reflection_params, "user_id", socket.assigns.current_user_id)
    save_reflection(socket, socket.assigns.action, reflection_params)
  end

  defp save_reflection(socket, :edit, reflection_params) do
    current_user_id = socket.assigns.current_user_id

    with %{user_id: ^current_user_id} <- socket.assigns.reflection,
         {:ok, _reflection} <-
           Accounts.update_reflection(socket.assigns.reflection, reflection_params) do
      {:noreply,
       socket
       |> put_flash(:info, "Reflection updated successfully")
       |> push_patch(to: socket.assigns.patch)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}

      _error ->
        {:noreply,
         socket
         |> put_flash(:error, "You do not have permission to update this reflection.")
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp save_reflection(socket, :new, reflection_params) do
    case Accounts.create_reflection(reflection_params) do
      {:ok, _reflection} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reflection created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
