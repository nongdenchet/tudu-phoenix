defmodule Tudu.TodoTest do
  use Tudu.ModelCase
  import Tudu.Factory
  alias Tudu.Todo

  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    user = insert(:user)
    values = Map.put(@valid_attrs, :user_id, user.id)
    changeset = Todo.changeset(%Todo{}, values)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Todo.changeset(%Todo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
