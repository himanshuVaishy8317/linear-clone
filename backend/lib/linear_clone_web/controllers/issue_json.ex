defmodule LinearCloneWeb.IssueJSON do
  alias LinearClone.Issues.Issue

  @doc """
  Renders a list of issues.
  """
  def index(%{issues: issues}) do
    %{data: for(issue <- issues, do: data(issue))}
  end

  @doc """
  Renders a single issue.
  """
  def show(%{issue: issue}) do
    %{data: data(issue)}
  end

  defp data(%Issue{} = issue) do
    %{
      id: issue.id,
      title: issue.title,
      description: issue.description,
      status: issue.status,
      priority: issue.priority,
      identifier: issue.identifier
    }
  end
end
