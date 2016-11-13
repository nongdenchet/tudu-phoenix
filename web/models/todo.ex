defmodule Tudu.Todo do
  use Tudu.Web, :model

  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    belongs_to :user, Tudu.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :completed])
    |> validate_required([:title, :description, :completed])
  end
end
