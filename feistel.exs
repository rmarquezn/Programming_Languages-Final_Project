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
    # Lee el archivo
    |> File.stream!()
    # Quita los saltos de linea
    |> Enum.map(&String.trim/1)
    # Convierte cada renglón en charlist
    |> Enum.map(&to_charlist(&1))
    # Divide cada renglón en 2
    |> Enum.map(&Enum.split(&1, ceil(length(&1) / 2)))
    # Convierte cada tupla en una lista
    |> Enum.map(&Tuple.to_list(&1))
    # Paralelizar?
    |> Enum.map(&splitMsg(&1, to_charlist(key)))

    # IO.puts("encrypt ok")
  end

  defp splitMsg(line, k) do
    # Divide el mensaje en 2 mitades
    l = Enum.at(line, 0)
    r = Enum.at(line, 1)

    if length(l) === length(r) do
      # Si las mitades son del mismo tamaño se envían a encriptar
      feistelRound(l, r, k)
    else
      # Si una mitad es mas corta se le añade un caracter y
      # luego se mandan a encriptar
      feistelRound(l, r ++ 'z', k)
    end
  end

  defp feistelRound(l0, r0, llave) do
    # Se corren 2 rondas de cifrado
    e1 = xor(r0, llave)
    r1 = xor(l0, e1)
    l1 = r0
    e2 = xor(r1, llave)
    r2 = xor(l1, e2)
    l2 = r1

    IO.puts("mensaje encriptado:")

    encMsg = l2 ++ r2
    #IO.puts(encMsg)

    new_data = IO.inspect(encMsg, charlists: :as_lists)
    # |> Enum.map(&Enum.join(&1, ","))
    # |> IO.inspect()
    # IO.puts(new_data)
    #IO.puts(encMsg)

    # File.write("encriptado.txt", new_data, charlists: :as_lists)


    filewriter = fn (filename, data) ->
      File.open(filename, [:append])
      |> elem(1)
      |> IO.binwrite(data)
    end


    Enum.map(IO.inspect(encMsg, encMsg: :as_lists), fn x ->
      filewriter.("encriptado.txt", to_string(x))
    end)



    encMsg = l2 ++ r2




    # IO.puts(l2 ++ r2)
    # |> IO.write("encriptado.txt", encMsg)

    # IO.inspect(encMsg, charlists: :as_lists)
    # File.write("encriptado.txt", encMsg)
  end

  defp xor(a, b) do
    for x <- 0..(length(a) - 1) do
      bxor(Enum.at(a, x), Enum.at(b, rem(x, length(b))))
    end
  end

  @doc """
  Función que desencripta un archivo encriptado
  """
  def decrypt(file, key) do
    IO.puts("decrypting...")

    file
    # Leer el archivo
    |> File.stream!()
    # Quita los saltos de linea
    |> Enum.map(&String.trim/1)
    # Quita los brackets
    |> Enum.map(&String.trim(&1, "["))
    |> Enum.map(&String.trim(&1, "]"))
    # Convierte cada renglón a una lista de enteros
    |> Enum.map(&String.split(&1, ", "))
    # Divide cada elemento a la mitad
    |> Enum.map(&Enum.split(&1, floor(length(&1) / 2)))
    # Convierte cada tupla en lista
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&decryptRound(&1, key))
  end

  defp decryptRound(line, key) do
    l2 = Enum.at(line, 0)
    r2 = Enum.at(line, 1)

    IO.inspect(l2)
    IO.inspect(r2)
    IO.inspect(key)
  end
end

Feistel.encrypt("prueba.txt", "llave")
# Feistel.decrypt("pruebaEncriptado.txt", "llave")
