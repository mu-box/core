# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias App.Accounts

roles = [
  %{
    name: "Owner",
    permissions: %{
      # TODO
    }
  },
]

Enum.each(roles, fn(data) ->
  Accounts.create_role!(data)
end)
