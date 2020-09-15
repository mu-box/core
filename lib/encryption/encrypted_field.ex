defmodule Encryption.EncryptedField do
  alias Encryption.AES  # alias our AES encrypt & decrypt functions (3.1 & 3.2)

  @behaviour Ecto.Type  # Check this module conforms to Ecto.type behavior.
  def type, do: :binary # :binary is the data type ecto uses internally

  # cast/1 simply calls to_string on the value and returns a "success" tuple
  def cast(nil) do
    {:ok, nil}
  end
  def cast(value) do
    {:ok, to_string(value)}
  end

  # dump/1 is called when the field value is about to be written to the database
  def dump(nil) do
    {:ok, nil} # ciphertext is :binary data
  end
  def dump(value) do
    ciphertext = value |> to_string |> AES.encrypt
    {:ok, ciphertext} # ciphertext is :binary data
  end

  # load/1 is called when the field is loaded from the database
  def load(value) do
    {:ok, AES.decrypt(value)} # decrypted data is :string type.
  end

  # embed_as/1 dictates how the type behaves when embedded (:self or :dump)
  def embed_as(_), do: :self # preserve the type's higher level representation

  # equal?/2 is called to determine if two field values are semantically equal
  def equal?(value1, value2), do: value1 == value2
end
