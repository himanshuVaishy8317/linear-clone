defmodule LinearClone.IssuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinearClone.Issues` context.
  """

  @doc """
  Generate a issue.
  """
  def issue_fixture(attrs \\ %{}) do
    {:ok, issue} =
      attrs
      |> Enum.into(%{
        description: "some description",
        identifier: "some identifier",
        priority: "some priority",
        status: "some status",
        title: "some title"
      })
      |> LinearClone.Issues.create_issue()

    issue
  end
end
