defmodule LinearClone.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :string, null: false
      add :description, :text
      add :status, :string, null: false, default: "todo"
      add :priority, :string, null: false, default: "medium"
      add :identifier, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:issues, [:identifier])
  end
end
