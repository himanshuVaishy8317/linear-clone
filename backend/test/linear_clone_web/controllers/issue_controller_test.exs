defmodule LinearCloneWeb.IssueControllerTest do
  use LinearCloneWeb.ConnCase

  import LinearClone.IssuesFixtures
  alias LinearClone.Issues.Issue

  @create_attrs %{
    priority: "some priority",
    status: "some status",
    description: "some description",
    title: "some title",
    identifier: "some identifier"
  }
  @update_attrs %{
    priority: "some updated priority",
    status: "some updated status",
    description: "some updated description",
    title: "some updated title",
    identifier: "some updated identifier"
  }
  @invalid_attrs %{priority: nil, status: nil, description: nil, title: nil, identifier: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all issues", %{conn: conn} do
      conn = get(conn, ~p"/api/issues")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create issue" do
    test "renders issue when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/issues", issue: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/issues/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "identifier" => "some identifier",
               "priority" => "some priority",
               "status" => "some status",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/issues", issue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update issue" do
    setup [:create_issue]

    test "renders issue when data is valid", %{conn: conn, issue: %Issue{id: id} = issue} do
      conn = put(conn, ~p"/api/issues/#{issue}", issue: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/issues/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "identifier" => "some updated identifier",
               "priority" => "some updated priority",
               "status" => "some updated status",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, issue: issue} do
      conn = put(conn, ~p"/api/issues/#{issue}", issue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete issue" do
    setup [:create_issue]

    test "deletes chosen issue", %{conn: conn, issue: issue} do
      conn = delete(conn, ~p"/api/issues/#{issue}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/issues/#{issue}")
      end
    end
  end

  defp create_issue(_) do
    issue = issue_fixture()

    %{issue: issue}
  end
end
