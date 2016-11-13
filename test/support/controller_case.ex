defmodule Tudu.ControllerCase do
  alias Tudu.User

  def authenticate(conn, user) do
    conn
    |> Plug.Conn.put_req_header("token", User.generate_token(user))
    |> Plug.Conn.put_req_header("user_id", Integer.to_string(user.id))
  end
end
