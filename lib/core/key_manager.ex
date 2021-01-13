defmodule Core.KeyManager do
  @moduledoc """
  Provides functions to manage SSH keys used for Core
  """

  @ssh_keygen System.find_executable("ssh-keygen")
  @path Application.app_dir(:core, "priv/keys") <> "/"
  @key @path <> "id_rsa"

  @doc """
  Generates a new private/public key set by removing the old key and creating
  a new set. Returns if they keys exist.
  """
  def generate_keys(title) do
    if keys_exist?(title), do: remove_keys(title)
    create_keys(title)
    keys_exist?(title)
  end

  @doc """
  Returns the content of the SSH public key
  """
  def public_key(title) do
    key = File.open!(@key <> "." <> title <> ".pub", [:read])
          |> IO.read(:line)
          |> String.replace("\n", "")
    File.close(@key <> "." <> title <> ".pub")
    key
  end

  @doc """
  Returns the content of the SSH private key
  """
  def private_key(title) do
    key = File.open!(@key <> "." <> title, [:read])
          |> IO.read(:all)
    File.close(@key <> "." <> title)
    key
  end

  @doc """
  Removes the key files from the filesystem
  """
  def remove_keys(title) do
    File.rm! @key <> "." <> title
    File.rm! @key <> "." <> title <> ".pub"
  end

  defp create_keys(title) do
    args = ["-t", "rsa", "-b", "4096", "-N", "", "-f", @key <> "." <> title, "-C", title]
    System.cmd(@ssh_keygen, args)
  end

  defp keys_exist?(title) do
    File.exists?(@key <> "." <> title) && File.exists?(@key <> "." <> title <> ".pub")
  end
end
