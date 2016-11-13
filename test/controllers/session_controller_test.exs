defmodule Tudu.SessionControllerTest do
  use Tudu.ConnCase
  
  alias Tudu.User

  @valid_attrs %{email: "user@gmail.com", password: "validPassword"}

  setup do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert changeset
    token = User.generate_token(user)

    conn = build_conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn, user: user, token: token}
  end

  test "Cannot authenticate a non existing user", %{conn: conn} do
    conn = post conn, session_path(conn, :login),
      user: %{email: "non-existing@example.com", password: "validPassword"}
    assert json_response(conn, 422)
  end

  test "Cannot authenticate invalid password", %{conn: conn} do
    conn = post conn, session_path(conn, :login),
      user: %{email: "user@gmail.com", password: "123"}
    assert json_response(conn, 422)
  end

  test "Authenticate a valid user", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :login), user: @valid_attrs
    assert json_response(conn, 200)["data"]["token"] != nil
    assert json_response(conn, 200)["data"]["user"]["id"] == user.id
  end

  test "validate token", %{conn: conn, token: token, user: user} do
    conn = conn
    |> put_req_header("token", token)
    |> put_req_header("user_id", Integer.to_string(user.id))
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 200)["data"]["email"] == @valid_attrs.email
  end

  test "validate fails if invalid token", %{conn: conn} do
    conn = put_req_header(conn, "token", "invalid-token")
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401)
  end

  test "validate fails if valid token and empty user_id", %{conn: conn, token: token} do
    conn = put_req_header(conn, "token", token)
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401)
  end

  test "validate fails if empty headers", %{conn: conn} do
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401)
  end

  test "validate fails if invalid user_id", %{conn: conn, token: token} do
    conn = conn
    |> put_req_header("token", token)
    |> put_req_header("user_id", Integer.to_string(-1))
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401)
  end

  test "validate fails if valid user_id and empty token", %{conn: conn, user: user} do
    conn = put_req_header(conn, "user_id", Integer.to_string(user.id))
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401)
  end
end
