# Feistel Cipher
# Rodrigo Márquez - A01022943
# Vicente Santamaría - A01421801

import Bitwise

defmodule Feistel do
  @doc """
  Función que encripta el archivo con la llave del usuario
  """
  def encrypt(file, key) do
    file
    # Leer el archivo
    |> File.stream!()
    # Convierte cada renglón en charlist
    |> Enum.map(&to_charlist(&1))
    # Divide cada renglón en 2
    |> Enum.map(&Enum.split(&1, ceil(length(&1) / 2)))
    # Convierte cada tupla en una lista
    |> Enum.map(&Tuple.to_list(&1))
    # Paralelizar?
    |> Enum.map(&splitMsg(&1, to_charlist(key)))

    # |> encriptar(&1) # Encripta cada renglón (sublista)

    IO.puts("encrypt ok")
  end

  defp splitMsg(line, k) do
    l = Enum.at(line, 0)
    r = Enum.at(line, 1)

    if length(l) === length(r) do
      IO.puts("par")
      # Correr feistel así
      feistelRound(l, r, k)
    else
      IO.puts("impar")
      # Añadir caracter a r y correr feistel
      feistelRound(l, '0' ++ r, k)
    end
  end

  defp feistelRound(l0, r0, llave) do
    # IO.puts("left")
    # IO.puts(length(l0))
    # IO.puts(l0)
    # IO.puts("right")
    # IO.puts(length(r0))
    # IO.puts(r0)
    # IO.puts("llave")
    # IO.puts(length(llave))

    # for n <- [1, 2, 3, 4, 5], do: IO.puts(n * 2)

    Enum.each(0..(length(r0) - 1), fn x ->
      bxor(Enum.at(r0, x), Enum.at(llave, rem(x, length(llave))))
    end)

    # for (i,i=<r0.length,i++){
    #   xor(r0[i], key[i mod key.length])
    #                         10
    #                         11 mod 10 = 1
    #                         msg mide 20
    #                         key mide 10
    #                         i 1-10
    #                         i 11-20 mg i,  key 11 mod 10 = 1 12mod10 2
    # }

    # bxor(a,b)
  end

  @doc """
  Función que desencripta un archivo encriptado
  """
  def decrypt do
    0
  end
end

Feistel.encrypt("prueba.txt", "llave")
