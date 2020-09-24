defmodule AppWeb.AccountController do
  use AppWeb, :controller

  alias App.{Hosting,Accounts}
  alias App.Hosting.Account

  def new(%{assigns: %{current_user: user}} = conn, %{"team_id" => team_id}) do
    if Accounts.can_access_team(user, Accounts.get_team!(team_id), "scope", "edit") do
      changeset = Hosting.change_account(%Account{})
      render(conn, "new.html", changeset: changeset, team: Accounts.get_team!(team_id), action: Routes.team_account_path(conn, :create, team_id))
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end
  def new(conn, _params) do
    changeset = Hosting.change_account(%Account{})
    render(conn, "new.html", changeset: changeset, team: nil, action: Routes.account_path(conn, :create))
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"account" => account_params} = params) do
    if !Map.has_key?(params, "team_id") or Accounts.can_access_team(user, Accounts.get_team!(Map.get(params, "team_id")), "scope", "edit") do
      case Hosting.create_account(account_params) do
        {:ok, account} ->
          target = case Map.get(params, "team_id") do
            nil -> Routes.account_account_path(conn, :new_creds, account)
            team_id -> Routes.team_account_account_path(conn, :new_creds, team_id, account)
          end

          redirect(conn, to: target)

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, Map.get(params, "team_id")))
    end
  end

  def new_creds(%{assigns: %{current_user: user}} = conn, %{"account_id" => id}) do
    account = Hosting.get_account!(id) |> App.Repo.preload([:hosting_adapter])
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      action = if account.team_id do
        Routes.team_account_account_path(conn, :create_creds, account.team_id, account)
      else
        Routes.account_account_path(conn, :create_creds, account)
      end
      fields = account.hosting_adapter |> App.Repo.preload([:fields]) |> Map.get(:fields)
      changeset = {
        fields |> Enum.reduce(%{}, fn (field, acc) -> Map.put(acc, field.key, "") end),
        fields |> Enum.reduce(%{}, fn (field, acc) -> Map.put(acc, field.key, :string) end)
      } |> Ecto.Changeset.change()

      render(conn, "new_creds.html", changeset: changeset, fields: fields, account: account, action: action)
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def create_creds(%{assigns: %{current_user: user}} = conn, %{"account_id" => id, "creds" => creds}) do
    account = Hosting.get_account!(id) |> App.Repo.preload([:hosting_adapter])
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      target = if account.team_id do
        Routes.team_account_path(conn, :show, account.team_id, account)
      else
        Routes.account_path(conn, :show, account)
      end

      if Hosting.try_creds(account.hosting_adapter, creds) do
        for field <- account.hosting_adapter |> App.Repo.preload([:fields]) |> Map.get(:fields) do
          Hosting.Credential.changeset(%Hosting.Credential{}, %{hosting_account_id: account.id, hosting_credential_field_id: field.id, value: Map.get(creds, field.key)})
          |> App.Repo.insert()
        end

        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: target)
      else
        back = if account.team_id do
          Routes.team_account_account_path(conn, :new_creds, account.team_id, account)
        else
          Routes.account_account_path(conn, :new_creds, account)
        end
        conn
        |> put_flash(:info, "Creds incorrect. Please try again.")
        |> redirect(to: back)
      end
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def show(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    account = Hosting.get_account!(id)
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      render(conn, "show.html", account: account |> App.Repo.preload([:creds]))
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def edit(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    account = Hosting.get_account!(id)
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      action = if account.team_id do
        Routes.team_account_path(conn, :update, account.team_id, account)
      else
        Routes.account_path(conn, :update, account)
      end
      changeset = Hosting.change_account(account)
      render(conn, "edit.html", account: account, changeset: changeset, action: action)
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def update(%{assigns: %{current_user: user}} = conn, %{"id" => id, "account" => account_params} = params) do
    account = Hosting.get_account!(id)

    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      case Hosting.update_account(account, account_params) do
        {:ok, account} ->
          target = case Map.get(params, "team_id") do
            nil -> Routes.account_path(conn, :show, account)
            team_id -> Routes.team_account_path(conn, :show, team_id, account)
          end

          conn
          |> put_flash(:info, "Account updated successfully.")
          |> redirect(to: target)

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", account: account, changeset: changeset)
      end
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def edit_creds(%{assigns: %{current_user: user}} = conn, %{"account_id" => id}) do
    account = Hosting.get_account!(id) |> App.Repo.preload([:hosting_adapter, :creds])
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      action = if account.team_id do
        Routes.team_account_account_path(conn, :update_creds, account.team_id, account)
      else
        Routes.account_account_path(conn, :update_creds, account)
      end
      fields = account.hosting_adapter |> App.Repo.preload([:fields]) |> Map.get(:fields)
      changeset = {
        fields |> Enum.reduce(%{}, fn (field, acc) ->
          cred = Enum.find(account.creds, %Hosting.Credential{}, fn (cred) -> field.id == cred.hosting_credential_field_id end)
          Map.put(acc, field.key, cred.value)
        end),
        fields |> Enum.reduce(%{}, fn (field, acc) -> Map.put(acc, field.key, :string) end)
      } |> Ecto.Changeset.change()

      render(conn, "edit_creds.html", changeset: changeset, fields: fields, account: account, action: action)
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def update_creds(%{assigns: %{current_user: user}} = conn, %{"account_id" => id, "creds" => creds}) do
    account = Hosting.get_account!(id) |> App.Repo.preload([:hosting_adapter, :creds])
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      target = if account.team_id do
        Routes.team_account_path(conn, :show, account.team_id, account)
      else
        Routes.account_path(conn, :show, account)
      end

      if Hosting.try_creds(account.hosting_adapter, creds) do
        for field <- account.hosting_adapter |> App.Repo.preload([:fields]) |> Map.get(:fields) do
          Enum.find(account.creds, %Hosting.Credential{}, fn (cred) -> field.id == cred.hosting_credential_field_id end)
          |> Hosting.Credential.changeset(%{value: Map.get(creds, field.key)})
          |> App.Repo.update()
        end

        conn
        |> put_flash(:info, "Credentials updated successfully.")
        |> redirect(to: target)
      else
        back = if account.team_id do
          Routes.team_account_account_path(conn, :edit_creds, account.team_id, account)
        else
          Routes.account_account_path(conn, :edit_creds, account)
        end
        conn
        |> put_flash(:info, "Creds incorrect. Please try again.")
        |> redirect(to: back)
      end
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end

  def delete(%{assigns: %{current_user: user}} = conn, %{"id" => id} = params) do
    account = Hosting.get_account!(id) |> App.Repo.preload([:creds])
    if !account.team_id or Accounts.can_access_team(user, Accounts.get_team!(account.team_id), "scope", "edit") do
      for cred <- account.creds do
        App.Repo.delete(cred)
      end
      {:ok, _account} = Hosting.delete_account(account)

      target = case Map.get(params, "team_id") do
        nil -> Routes.dash_path(conn, :index)
        team_id -> Routes.team_path(conn, :show, team_id)
      end
      conn
      |> put_flash(:info, "Account deleted successfully.")
      |> redirect(to: target)
    else
      conn
      |> put_flash(:info, "That page is not available.")
      |> redirect(to: Routes.team_path(conn, :show, account.team_id))
    end
  end
end
