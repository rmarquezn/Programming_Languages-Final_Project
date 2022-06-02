# Feistel Cipher
# Rodrigo Márquez - A01022943
# Vicente Santamaría - A01421801

defmodule Feistel do
  @doc """
  Función que encripta el archivo con la llave del usuario
  """
  def encrypt(file) do
    file
    # Leer el archivo
    |> File.stream!()
    # Convierte cada renglón en charlist
    |> Enum.map(&to_charlist(&1))
    # Divide cada renglón en 2
    |> Enum.map(&Enum.split(&1, ceil(length(&1) / 2)))
    # Convierte cada tupla en una lista
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&feistelRound(&1))

    # |> encriptar(&1) # Encripta cada renglón (sublista)

    IO.puts("encrypt ok")
  end

  defp feistelRound(line) do
    l0 = Enum.at(line, 0)
    r0 = Enum.at(line, 1)

    IO.puts("left")
    IO.puts(length(l0))
    IO.puts(l0)
    IO.puts("right")
    IO.puts(length(r0))
    IO.puts(r0)
  end

  @doc """
  Función que desencripta un archivo encriptado
  """
  def decrypt do
    0
  end
end

Feistel.encrypt("prueba.txt")
