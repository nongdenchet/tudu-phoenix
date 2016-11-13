defmodule Tudu.SessionController do
  use Tudu.Web, :controller
  alias Tudu.User

  plug :require_authenticate when action in [:validate]
  plug :scrub_params, "user" when action in [:login]

  def login(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    if user && User.check_password(user, user_params["password"]) do
      token = User.generate_token(user)
      conn
      |> put_status(200)
      |> render(Tudu.SessionView, "session.json", %{user: user, token: token})
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Tudu.SessionView, "message.json", message: "Invalid")
    end
  end

  def validate(conn, _params) do
    conn
    |> put_status(200)
    |> render(Tudu.UserView, "show.json", user: conn.assigns.current_user)
  end
end
