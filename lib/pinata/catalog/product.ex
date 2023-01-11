defmodule Pinata.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def update_price_changeset(product, attrs) do
    current_price = product.unit_price
    product
    |> cast(attrs, [:id, :unit_price])
    |> validate_required([:id, :unit_price])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> validate_change(:unit_price, fn :unit_price, price ->
      if price > current_price do
        [price: "price must be lower than the current price #{current_price}"]
      else
        []
      end
    end)
  end
end
