defmodule Tudu.Session do
  import Plug.Conn
  import Phoenix.Controller
  
  alias Tudu.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    token = conn
    |> get_req_header("token")
    |> List.first

    Phoenix.Token.verify(Tudu.Endpoint, "user", token)
    |> handle(conn, repo)
  end

  def require_authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(401)
      |> render(Tudu.ErrorView, "403.json")
      |> halt()
    end
  end

  defp handle({:ok, user_id}, conn, repo) do
    user = repo.get!(User, user_id)
    user_id = conn
    |> get_req_header("user_id")
    |> List.first
    if user_id == Integer.to_string(user.id) do
      assign(conn, :current_user, user)
    else
      handle({:error, :invalid}, conn, repo)
    end
  end

  defp handle({:error, :invalid}, conn, _repo) do
    assign(conn, :current_user, nil)
  end

  defp handle({:error, :missing}, conn, _repo) do
    assign(conn, :current_user, nil)
  end
end
