defmodule Tudu.UserView do
  use Tudu.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Tudu.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Tudu.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
end
