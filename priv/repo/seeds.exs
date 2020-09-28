# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Core.Repo.insert!(%Core.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Core.Accounts

roles = [
  %{
    name: "Owner",
    permissions: %{
      scope: :admin,
      scale: :admin,
      deploy: :admin,
      evars: :admin,
      certs: :admin,
      billing: :admin,
    }
  },
  %{
    name: "DevOps",
    permissions: %{
      scope: :write,
      scale: :write,
      deploy: :write,
      evars: :admin,
      certs: :admin,
      billing: :none,
    }
  },
  %{
    name: "SysAdmin",
    permissions: %{
      scope: :write,
      scale: :write,
      deploy: :read,
      evars: :admin,
      certs: :admin,
      billing: :none,
    }
  },
  %{
    name: "Developer",
    permissions: %{
      scope: :read,
      scale: :read,
      deploy: :write,
      evars: :none,
      certs: :none,
      billing: :none,
    }
  },
  %{
    name: "Auditor",
    permissions: %{
      scope: :read,
      scale: :read,
      deploy: :read,
      evars: :none,
      certs: :none,
      billing: :none,
    }
  },
  %{
    name: "External",
    permissions: %{
      scope: :none,
      scale: :none,
      deploy: :none,
      evars: :none,
      certs: :none,
      billing: :none,
    }
  },
  %{
    name: "Billing",
    permissions: %{
      scope: :none,
      scale: :none,
      deploy: :none,
      evars: :none,
      certs: :none,
      billing: :admin,
    }
  },
]

Enum.each(roles, fn(data) ->
  Accounts.create_role(data)
end)
