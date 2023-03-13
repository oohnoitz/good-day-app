defmodule GoodDayWeb.ReflectionLiveTest do
  use GoodDayWeb.ConnCase

  import Phoenix.LiveViewTest
  import GoodDay.AccountsFixtures

  @create_attrs %{date: "2023-03-12"}
  @update_attrs %{date: "2023-03-13"}
  @invalid_attrs %{date: nil}

  defp create_reflection(_) do
    reflection = reflection_fixture()
    %{reflection: reflection}
  end

  describe "Index" do
    setup [:create_reflection]

    test "lists all reflections", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/reflections")

      assert html =~ "Listing Reflections"
    end

    test "saves new reflection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reflections")

      assert index_live |> element("a", "New Reflection") |> render_click() =~
               "New Reflection"

      assert_patch(index_live, ~p"/reflections/new")

      assert index_live
             |> form("#reflection-form", reflection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reflection-form", reflection: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reflections")

      html = render(index_live)
      assert html =~ "Reflection created successfully"
    end

    test "updates reflection in listing", %{conn: conn, reflection: reflection} do
      {:ok, index_live, _html} = live(conn, ~p"/reflections")

      assert index_live |> element("#reflections-#{reflection.id} a", "Edit") |> render_click() =~
               "Edit Reflection"

      assert_patch(index_live, ~p"/reflections/#{reflection}/edit")

      assert index_live
             |> form("#reflection-form", reflection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reflection-form", reflection: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reflections")

      html = render(index_live)
      assert html =~ "Reflection updated successfully"
    end

    test "deletes reflection in listing", %{conn: conn, reflection: reflection} do
      {:ok, index_live, _html} = live(conn, ~p"/reflections")

      assert index_live |> element("#reflections-#{reflection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reflections-#{reflection.id}")
    end
  end

  describe "Show" do
    setup [:create_reflection]

    test "displays reflection", %{conn: conn, reflection: reflection} do
      {:ok, _show_live, html} = live(conn, ~p"/reflections/#{reflection}")

      assert html =~ "Show Reflection"
    end

    test "updates reflection within modal", %{conn: conn, reflection: reflection} do
      {:ok, show_live, _html} = live(conn, ~p"/reflections/#{reflection}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Reflection"

      assert_patch(show_live, ~p"/reflections/#{reflection}/show/edit")

      assert show_live
             |> form("#reflection-form", reflection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#reflection-form", reflection: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/reflections/#{reflection}")

      html = render(show_live)
      assert html =~ "Reflection updated successfully"
    end
  end
end
