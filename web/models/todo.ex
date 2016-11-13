defmodule Tudu.Todo do
  use Tudu.Web, :model

  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    belongs_to :user, Tudu.User

    timestamps()
  end

  @required_fields ~w(user_id title description)
  @optional_fields ~w(completed)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:user_id, :title, :description])
    |> validate_length(:description, min: 10)
  end
end
