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
    msgList = file |> File.read!() |> msgSplit()
    # keyBits = IO.inspect(key, binaries: :as_binaries)

    l0 = hd(msgList)
    r0 = tl(msgList)
    IO.puts("okey")
    IO.puts()
  end

  defp msgSplit(lst) do
    list = lst
    size = byte_size(lst)
    # impar
    if rem(size, 2) === 1 do
      # Cambiar a 32
      list = lst <> <<72>>
      # IO.inspect(list, binaries: :as_binaries)
      size = byte_size(list)
      IO.puts(list)
      left = binary_part(list, 0, div(size, 2))
      right = binary_part(list, div(size, 2), div(size, 2))
      [left, right]
    else
      left = binary_part(list, 0, div(size, 2))
      right = binary_part(list, div(size, 2), div(size, 2))
      [left, right]
    end
  end

  # xor => bxor(a,b)
end

IO.puts(Feistel.encriptarMsg("prueba.txt", "llave", 2))
