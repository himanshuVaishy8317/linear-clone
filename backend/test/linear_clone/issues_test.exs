defmodule LinearClone.IssuesTest do
  use LinearClone.DataCase

  alias LinearClone.Issues

  describe "issues" do
    alias LinearClone.Issues.Issue

    import LinearClone.IssuesFixtures

    @invalid_attrs %{priority: nil, status: nil, description: nil, title: nil, identifier: nil}

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Issues.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Issues.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      valid_attrs = %{priority: "some priority", status: "some status", description: "some description", title: "some title", identifier: "some identifier"}

      assert {:ok, %Issue{} = issue} = Issues.create_issue(valid_attrs)
      assert issue.priority == "some priority"
      assert issue.status == "some status"
      assert issue.description == "some description"
      assert issue.title == "some title"
      assert issue.identifier == "some identifier"
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Issues.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()
      update_attrs = %{priority: "some updated priority", status: "some updated status", description: "some updated description", title: "some updated title", identifier: "some updated identifier"}

      assert {:ok, %Issue{} = issue} = Issues.update_issue(issue, update_attrs)
      assert issue.priority == "some updated priority"
      assert issue.status == "some updated status"
      assert issue.description == "some updated description"
      assert issue.title == "some updated title"
      assert issue.identifier == "some updated identifier"
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Issues.update_issue(issue, @invalid_attrs)
      assert issue == Issues.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Issues.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Issues.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Issues.change_issue(issue)
    end
  end
end
