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
      # Correr feistel así
      feistelRound(l, r, k)
    else
      # Añadir caracter a r y correr feistel
      feistelRound(l, '0' ++ r, k)
    end
  end

  defp feistelRound(l0, r0, llave) do
    xor(r0, llave)
    |> IO.inspect()
    |> prueba(&1, l0)

    # e1 = xor(r0, llave) |> to_charlist()
    # r1 = xor(l0, e1) |> IO.puts()
    # l1 = r0 |> IO.puts()
    # e2 = xor(r1, llave)
    # r2 = xor(l1, e2)
    # l2 = r1
    # IO.puts(l2 ++ r2)
  end

  defp xor(a, b) do
    for x <- 0..(length(a) - 1) do
      # IO.puts(bxor(Enum.at(a, x), Enum.at(b, rem(x, length(b)))))
      to_charlist(bxor(Enum.at(a, x), Enum.at(b, rem(x, length(b)))))
    end
  end

  defp prueba(a, b) do
    IO.puts(b)
  end

  @doc """
  Función que desencripta un archivo encriptado
  """
  def decrypt do
    0
  end
end

Feistel.encrypt("prueba.txt", "llave")
