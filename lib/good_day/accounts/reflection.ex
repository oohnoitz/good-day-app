defmodule GoodDay.Accounts.Reflection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflections" do
    field :date, :date
    field :workday_quality, Ecto.Enum, values: [terrible: 0, bad: 1, ok: 2, good: 3, awesome: 4]

    field :work_other_people_amount, Ecto.Enum,
      values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :help_other_people_amount, Ecto.Enum,
      values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :interrupted_amount, Ecto.Enum, values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :made_progress_amount, Ecto.Enum,
      values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :made_quality_work_amount, Ecto.Enum,
      values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :made_work_amount, Ecto.Enum, values: [none: 0, little: 1, some: 2, much: 3, most: 4]

    field :workday_feeling, Ecto.Enum,
      values: [tense: 0, stress: 1, sad: 2, bored: 3, calm: 4, serene: 5, happy: 7, excited: 8]

    field :breaks_amount, Ecto.Enum, values: [none: 0, little: 1, some: 2, much: 3, most: 4]
    field :meeting_amount, Ecto.Enum, values: [none: 0, one: 1, two: 2, few: 3, many: 4]

    field :most_productive_time, Ecto.Enum,
      values: [morning: 0, midday: 1, earlyafternoon: 2, lateafternoon: 3, nonwork: 4, equally: 5]

    field :least_productive_time, Ecto.Enum,
      values: [morning: 0, midday: 1, earlyafternoon: 2, lateafternoon: 3, nonwork: 4, equally: 5]

    timestamps()
  end

  @doc false
  def changeset(reflection, attrs) do
    reflection
    |> cast(attrs, [
      :date,
      :workday_quality,
      :work_other_people_amount,
      :help_other_people_amount,
      :interrupted_amount,
      :made_progress_amount,
      :made_quality_work_amount,
      :made_work_amount,
      :workday_feeling,
      :breaks_amount,
      :meeting_amount,
      :most_productive_time,
      :least_productive_time
    ])
    |> then(fn changeset ->
      if is_nil(get_field(changeset, :date)) do
        put_change(changeset, :date, Date.utc_today())
      else
        changeset
      end
    end)
    |> validate_required([
      :date,
      :workday_quality,
      :work_other_people_amount,
      :help_other_people_amount,
      :interrupted_amount,
      :made_progress_amount,
      :made_quality_work_amount,
      :made_work_amount,
      :workday_feeling,
      :breaks_amount,
      :meeting_amount,
      :most_productive_time,
      :least_productive_time
    ])
  end
end
