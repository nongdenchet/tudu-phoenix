defmodule Tudu.User do
  use Tudu.Web, :model

  @secret "secret@apidez.com"

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/(\w+)@([\w.]+)/)
    |> unique_constraint(:email)
    |> hash_password
  end

  def check_password(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password_hash)
  end

  def generate_token(user) do
    Phoenix.Token.sign(Tudu.Endpoint, "user", user.id)
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end
end
