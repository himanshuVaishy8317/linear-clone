defmodule LinearClone.Issues.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(todo in_progress done canceled)
  @priorities ~w(no_priority urgent high medium low)

  schema "issues" do
    field :title, :string
    field :description, :string
    field :status, :string, default: "todo"
    field :priority, :string, default: "medium"
    field :identifier, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :description, :status, :priority, :identifier])
    |> validate_required([:title])
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:priority, @priorities)
    |> maybe_put_identifier()
    |> unique_constraint(:identifier)
  end

  defp maybe_put_identifier(changeset) do
    case get_field(changeset, :identifier) do
      nil ->
        suffix = :crypto.strong_rand_bytes(3) |> Base.encode16()
        put_change(changeset, :identifier, "LIN-" <> suffix)

      _ ->
        changeset
    end
  end
end
