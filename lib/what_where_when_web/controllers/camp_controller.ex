defmodule WhatWhereWhenWeb.CampController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.ThemeCamps
  alias WhatWhereWhen.ThemeCamps.Camp

  def index(conn, _params) do
    camps = ThemeCamps.list_camps()
    render(conn, "index.html", camps: camps)
  end

  def show(conn, %{"id" => id}) do
    camp = ThemeCamps.get_camp_with_members!(id)
    render(conn, "show.html", camp: camp)
  end

  def edit(conn, %{"id" => id}) do
    camp = ThemeCamps.get_camp!(id)
    changeset = ThemeCamps.change_camp(camp)
    render(conn, "edit.html", camp: camp, changeset: changeset)
  end

  def update(conn, %{"id" => id, "camp" => camp_params}) do
    camp = ThemeCamps.get_camp!(id)

    case ThemeCamps.update_camp(camp, camp_params) do
      {:ok, camp} ->
        conn
        |> put_flash(:info, "Camp updated successfully.")
        |> redirect(to: Routes.camp_path(conn, :show, camp))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", camp: camp, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    camp = ThemeCamps.get_camp!(id)
    {:ok, _camp} = ThemeCamps.delete_camp(camp)

    conn
    |> put_flash(:info, "Camp deleted successfully.")
    |> redirect(to: Routes.camp_path(conn, :index))
  end
end
