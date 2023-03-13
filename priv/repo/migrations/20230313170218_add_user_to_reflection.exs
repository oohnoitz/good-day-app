defmodule GoodDay.Repo.Migrations.AddUserToReflection do
  use Ecto.Migration

  def change do
    alter table(:reflections) do
      add(:user_id, references(:users))
    end

    drop unique_index(:reflections, [:date])
    create unique_index(:reflections, [:user_id, :date])
  end
end
