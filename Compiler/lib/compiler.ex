defmodule COMPILER do
  @moduledoc """
  Documentation for COMPILER.
  """

  @doc """
  Hello world.

  ## Examples

      iex> COMPILER.hello()
      :world

  """
  def start() do
    IO.puts("Starting")
    rawText = "



    int main(){
    return 60;
    }

    "
    tokens = Lexer.lexer(rawText)
    Parser.parseProgram(tokens)
  end
end
