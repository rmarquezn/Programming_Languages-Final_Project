# Feistel Cipher
# Rodrigo Márquez - A01022943
# Vicente Santamaría - A01421801
import Bitwise

defmodule Feistel do

  def mainEncrypt() do
    key = IO.gets("Ingresa la llave: ")

    measure fn  ->
      encrypt("original.txt", key)
    end

  end

  def mainDecrypt() do
    key = IO.gets("Ingresa la llave: ")

    measure fn  ->
      decrypt("encriptado.txt", key)
    end

  end
  # Función que encripta el archivo con la llave del usuario
  def encrypt(file, key) do
    File.write("encriptado.txt", "")
    file
    # Lee el archivo
    |> File.stream!()
    # Quita los saltos de linea
    |> Enum.map(&String.trim/1)
    # Convierte cada renglón en charlist
    #|> Enum.map(&to_charlist(&1))
    |> Enum.map(fn x -> if x == "", do: '\n', else: to_charlist(x) end)
    # Divide cada renglón en 2
    |> Enum.map(&Enum.split(&1, ceil(length(&1) / 2)))
    # Convierte cada tupla en una lista
    |> Enum.map(&Tuple.to_list(&1))
    # Paralelizar?
    |> Enum.map(&splitMsg(&1, to_charlist(key)))

  end

  # Función que divide la lista
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

  # Función que realiza una ronda del encriptado Feistel
  defp feistelRound(l0, r0, llave) do
    # Se corren 2 rondas de cifrado
    e1 = xor(r0, llave)
    r1 = xor(l0, e1)
    l1 = r0
    e2 = xor(r1, llave)
    r2 = xor(l1, e2)
    l2 = r1

    encMsg = l2 ++ r2

    filewriter("encriptado.txt", Enum.join(encMsg, ","))
    filewriter("encriptado.txt", "\n")
  end

  # Función XOR
  defp xor(a, b) do
    for x <- 0..(length(a) - 1) do
      bxor(Enum.at(a, x), Enum.at(b, rem(x, length(b))))
    end
  end

  # Función que escribe en un archivo
  defp filewriter(file, data) do
    File.open(file, [:append])
      |> elem(1)
      |> IO.binwrite(data)
  end

  # Función qpara medir el tiempo de ejecución
  def measure(func) do
    func
      |> :timer.tc
      |> elem(0)
      |> Kernel./(1_000_000)
  end

  # Función que desencripta un archivo encriptado
  def decrypt(file, key) do
    File.write("desencriptado.txt", "")
    file
    # Leer el archivo
    |> File.stream!()
    # Quita los saltos de linea
    |> Enum.map(&String.trim/1)
    # Convierte cada renglón a una lista de enteros
    |> Enum.map(&String.split(&1, ","))
    #Convertir lista de string a lista de enteros
    |> Enum.map(&Enum.map(&1, fn(x) -> String.to_integer(x) end))
    #|> IO.inspect(charlists: :as_lists)
    # Divide cada elemento a la mitad
    |> Enum.map(&Enum.split(&1, floor(length(&1) / 2)))
    # Convierte cada tupla en lista
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&decryptRound(&1, to_charlist(key)))
  end

  # Función que realiza una ronda del desencriptado Feistel
  defp decryptRound(line, key) do
    l2 = Enum.at(line, 0)
    r2 = Enum.at(line, 1)

    r1 = l2
    e2 = xor(r1, key)
    l1 = xor(r2, e2)
    r0 = l1
    e1 = xor(r0, key)
    l0 = xor(r1, e1)

    msg = to_string(l0) <> String.trim_trailing(to_string(r0), "z")
    filewriter("desencriptado.txt", String.trim_leading(msg) <> "\n")
  end
end

# Feistel.encrypt("original.txt", "llave")
# Feistel.decrypt("encriptado.txt", "llave")
