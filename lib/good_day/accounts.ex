defmodule GoodDay.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GoodDay.Repo

  alias GoodDay.Accounts.Reflection

  @doc """
  Returns the list of reflections.

  ## Examples

      iex> list_reflections()
      [%Reflection{}, ...]

  """
  def list_reflections do
    Repo.all(Reflection)
  end

  @doc """
  Gets a single reflection.

  Raises `Ecto.NoResultsError` if the Reflection does not exist.

  ## Examples

      iex> get_reflection!(123)
      %Reflection{}

      iex> get_reflection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reflection!(id), do: Repo.get!(Reflection, id)

  @doc """
  Creates a reflection.

  ## Examples

      iex> create_reflection(%{field: value})
      {:ok, %Reflection{}}

      iex> create_reflection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reflection(attrs \\ %{}) do
    %Reflection{}
    |> Reflection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reflection.

  ## Examples

      iex> update_reflection(reflection, %{field: new_value})
      {:ok, %Reflection{}}

      iex> update_reflection(reflection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reflection(%Reflection{} = reflection, attrs) do
    reflection
    |> Reflection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reflection.

  ## Examples

      iex> delete_reflection(reflection)
      {:ok, %Reflection{}}

      iex> delete_reflection(reflection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reflection(%Reflection{} = reflection) do
    Repo.delete(reflection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reflection changes.

  ## Examples

      iex> change_reflection(reflection)
      %Ecto.Changeset{data: %Reflection{}}

  """
  def change_reflection(%Reflection{} = reflection, attrs \\ %{}) do
    Reflection.changeset(reflection, attrs)
  end
end
