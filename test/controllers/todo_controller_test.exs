defmodule Tudu.TodoControllerTest do
  use Tudu.ConnCase

  import Tudu.Factory
  import Tudu.ControllerCase

  alias Tudu.Repo
  alias Tudu.Todo

  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{description: "123"}

  setup %{conn: conn} do
    user = insert(:user)
    todo = insert(:todo, user_id: user.id)
    conn = conn
    |> authenticate(user)
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn, user: user, todo: todo}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, todo_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 1
  end

  test "shows chosen resource", %{conn: conn, todo: todo} do
    conn = get conn, todo_path(conn, :show, todo)
    assert json_response(conn, 200)["data"] == %{
      "id" => todo.id,
      "user_id" => todo.user_id,
      "title" => todo.title,
      "description" => todo.description,
      "completed" => todo.completed
    }
  end

  test "prevent show todo", %{conn: conn, todo: todo} do
    assert_error_sent 404, fn ->
      user = insert(:new_user)
      conn = authenticate(conn, user)
      get conn, todo_path(conn, :show, todo.id)
    end
  end

  test "prevent delete todo", %{conn: conn, todo: todo} do
    assert_error_sent 404, fn ->
      user = insert(:new_user)
      conn = authenticate(conn, user)
      delete conn, todo_path(conn, :delete, todo)
    end
  end

  test "prevent update todo", %{conn: conn, todo: todo} do
    assert_error_sent 404, fn ->
      user = insert(:new_user)
      conn = authenticate(conn, user)
      put conn, todo_path(conn, :update, todo), todo: @valid_attrs
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, todo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, todo: todo} do
    conn = put conn, todo_path(conn, :update, todo), todo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, todo: todo} do
    conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, todo: todo} do
    conn = delete conn, todo_path(conn, :delete, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
