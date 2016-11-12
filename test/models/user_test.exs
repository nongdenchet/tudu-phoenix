defmodule Tudu.UserTest do
  use Tudu.ModelCase
  alias Tudu.User

  @valid_user %{email: "user@gmail.com", password: "password"}
  @invalid_attrs %{}

  test "changeset with invalid email" do
    changeset = User.changeset(%User{}, %{email: "user", password: "12345678"})
    refute changeset.valid?
  end

  test "changeset with invalid password attrs" do
    changeset = User.changeset(%User{}, %{email: "user@gmail.com", password: "123"})
    refute changeset.valid?
  end

  test "changeset with valid attrs" do
    changeset = User.changeset(%User{}, %{email: "user@gmail.com", password: "12345678"})
    assert changeset.valid?
  end

  test "password_hash value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_user)
    assert Comeonin.Bcrypt.checkpw(@valid_user.password,
      Ecto.Changeset.get_change(changeset, :password_hash))
  end
end
