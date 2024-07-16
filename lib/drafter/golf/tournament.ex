defmodule Drafter.Golf.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name]

  embedded_schema do
    field(:name, :string)
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(:name)
  end

  def from_params(params) do
    clean_params = changeset(params).changes()
    struct(__MODULE__, clean_params)
  end
end
