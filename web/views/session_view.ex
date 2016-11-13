defmodule Tudu.SessionView do
  use Tudu.Web, :view

  def render("session.json", %{user: user, token: token}) do
    %{data: %{token: token, user: render(Tudu.UserView, "user.json", user: user)}}
  end

  def render("message.json", %{message: message}) do
    %{error: message}
  end
end
