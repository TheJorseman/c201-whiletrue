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
  def main() do
    IO.puts("Starting")
    rawText = "



    int main(){
    return 60;
    }

    "
    tokens = Lexer.lexer(rawText)
    root = Parser.parseProgram(tokens)
    IO.inspect "Code Generator"
    IO.inspect root
    CodeGenerator.generateCode(root)
  end
end
