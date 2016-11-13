defmodule Tudu.TodoController do
  use Tudu.Web, :controller
  
  alias Tudu.Todo

  plug :require_authenticate

  def index(conn, _params, user) do
    todos = Repo.all(from t in Todo, where: t.user_id == ^user.id)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, user) do
    changeset =
      user
      |> build_assoc(:todos)
      |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", todo_path(conn, :show, todo))
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Tudu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    todo = Repo.get!(user_todos(user), id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, user) do
    todo = Repo.get!(user_todos(user), id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, todo} ->
        render(conn, "show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Tudu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    todo = Repo.get!(user_todos(user), id)
    Repo.delete!(todo)
    send_resp(conn, :no_content, "")
  end

  defp user_todos(user) do
    assoc(user, :todos)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
