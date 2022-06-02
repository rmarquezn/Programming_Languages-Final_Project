# Feistel Cipher
# Rodrigo Márquez - A01022943
# Vicente Santamaría - A01421801

originalFile = "original.txt"
encryptedFile = "encriptado.txt"

import Bitwise

defmodule Feistel do
  @moduledoc """
  Implementation of the Feistel Cipher Algorithm
  """

  @doc """
  Asks for the input file, the key and the iterations of the cipher
  """
  def encriptarMsg(file, key, vueltas) do
    msgBits = file |> File.read!() |> stringToBinary()
    keyBits = stringToBinary(key)
    msgBits |> msgSplit()
  end

  defp stringToBinary(str) do
    # Converts the string into an integer bitstring
    # "msg" <> <<0>> , RETURNS a BITSTRING
    str
    |> IO.inspect(binaries: :as_binaries)
  end

  defp msgSplit(lst) do
    if rem(String.length(lst), 2) === 1 do
      IO.puts("impar")
    else
      IO.puts("par")
    end
  end

  # xor => bxor(a,b)
end

IO.puts(Feistel.encriptarMsg("prueba.txt", "llave", 2))
