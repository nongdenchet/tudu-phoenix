defmodule Tudu.Todos.Create do
	use Tudu.Web, :controller

	alias Tudu.Todo

	def process(%{"todo" => todo_params}, user) do
  	user
  	|> build_assoc(:todos)
  	|> Todo.changeset(todo_params)
  	|> Repo.insert
	end
end
