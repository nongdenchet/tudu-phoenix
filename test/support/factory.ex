defmodule Todos.Factory do
  use ExMachina.Ecto, repo: Tudu.Repo

  def todo_factory do
    %Tudu.Todo{
      title: "Something I need to do",
      description: "List of steps I need to complete"
    }
  end
end
