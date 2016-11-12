defmodule Tudu.SessionView do
  use Tudu.Web, :view

  def render("session.json", %{token: token}) do
    %{data: %{token: token}}
  end

  def render("message.json", %{message: message}) do
    %{error: message}
  end
end
