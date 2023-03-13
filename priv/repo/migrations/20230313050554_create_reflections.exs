defmodule GoodDay.Repo.Migrations.CreateReflections do
  use Ecto.Migration

  def change do
    create table(:reflections) do
      add :date, :date
      add :workday_quality, :integer
      add :work_other_people_amount, :integer
      add :help_other_people_amount, :integer
      add :interrupted_amount, :integer
      add :made_progress_amount, :integer
      add :made_quality_work_amount, :integer
      add :made_work_amount, :integer
      add :workday_feeling, :integer
      add :breaks_amount, :integer
      add :meeting_amount, :integer
      add :most_productive_time, :integer
      add :least_productive_time, :integer

      timestamps()
    end

    create unique_index(:reflections, :date)
  end
end
