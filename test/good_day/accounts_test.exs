defmodule GoodDay.AccountsTest do
  use GoodDay.DataCase

  alias GoodDay.Accounts

  describe "reflections" do
    alias GoodDay.Accounts.Reflection

    import GoodDay.AccountsFixtures

    @invalid_attrs %{date: nil}

    test "list_reflections/0 returns all reflections" do
      reflection = reflection_fixture()
      assert Accounts.list_reflections() == [reflection]
    end

    test "get_reflection!/1 returns the reflection with given id" do
      reflection = reflection_fixture()
      assert Accounts.get_reflection!(reflection.id) == reflection
    end

    test "create_reflection/1 with valid data creates a reflection" do
      valid_attrs = %{date: ~D[2023-03-12]}

      assert {:ok, %Reflection{} = reflection} = Accounts.create_reflection(valid_attrs)
      assert reflection.date == ~D[2023-03-12]
    end

    test "create_reflection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_reflection(@invalid_attrs)
    end

    test "update_reflection/2 with valid data updates the reflection" do
      reflection = reflection_fixture()
      update_attrs = %{date: ~D[2023-03-13]}

      assert {:ok, %Reflection{} = reflection} =
               Accounts.update_reflection(reflection, update_attrs)

      assert reflection.date == ~D[2023-03-13]
    end

    test "update_reflection/2 with invalid data returns error changeset" do
      reflection = reflection_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_reflection(reflection, @invalid_attrs)
      assert reflection == Accounts.get_reflection!(reflection.id)
    end

    test "delete_reflection/1 deletes the reflection" do
      reflection = reflection_fixture()
      assert {:ok, %Reflection{}} = Accounts.delete_reflection(reflection)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_reflection!(reflection.id) end
    end

    test "change_reflection/1 returns a reflection changeset" do
      reflection = reflection_fixture()
      assert %Ecto.Changeset{} = Accounts.change_reflection(reflection)
    end
  end
end
