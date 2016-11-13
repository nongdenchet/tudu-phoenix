defmodule Tudu.TodoView do
  use Tudu.Web, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, Tudu.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, Tudu.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      user_id: todo.user_id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed}
  end
end
