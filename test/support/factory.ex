defmodule Tudu.Factory do
  use ExMachina.Ecto, repo: Tudu.Repo

  def todo_factory do
    %Tudu.Todo{
      title: "Something I need to do",
      description: "List of steps I need to complete"
    }
  end

  def user_factory do
    %Tudu.User{
      email: "user@gmail.com",
      password: "validPassword"
    }
  end

  def new_user_factory do
    %Tudu.User{
      email: "user123@gmail.com",
      password: "validPassword"
    }
  end
end
