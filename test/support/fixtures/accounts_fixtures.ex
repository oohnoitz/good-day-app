defmodule GoodDay.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoodDay.Accounts` context.
  """

  @doc """
  Generate a reflection.
  """
  def reflection_fixture(attrs \\ %{}) do
    {:ok, reflection} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-03-12]
      })
      |> GoodDay.Accounts.create_reflection()

    reflection
  end
end
