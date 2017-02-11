defmodule Tudu.Todos.Delete do
	use Tudu.Web, :controller

	def process(%{"id" => id}, user) do
		user
		|> assoc(:todos)
		|> Repo.get!(id)
		|> Repo.delete!
	end
end
