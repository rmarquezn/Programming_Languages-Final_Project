# Feistel Cipher
# Rodrigo Márquez - A01022943
# Vicente Santamaría - A01421801


defmodule Feistel do
  def main(file) do
    file
      |> File.stream!() # Leer el archivo
      |> Enum.map(&to_charlist(&1)) # Convierte cada renglón en charlist
      |> Enum.map(&Enum.split(&1, floor((length(&1)/2)))) # Divide cada renglón en 2
      |> Enum.map(&Tuple.to_list(&1)) # Convierte cada tupla en una lista
      #|> encriptar(&1) # Encripta cada renglón (sublista)
  end
end
