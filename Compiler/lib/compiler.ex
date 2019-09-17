defmodule Compiler do
  @moduledoc """
  Documentation for Compilador
  """
  @commands %{
    
    "\thelp\t" => "Help",  
    "\ta\t" => "Print AST tree",
    "\ts\t" => "Generate Assembler",
    "\tt\t" => "Print Token List\n\n\n"
    
  }

  def main(args) do
    args
    |> parse_args
    |> process_args
  end

  def parse_args(args) do
    OptionParser.parse(args, switches: [help: :boolean])
  end

  defp process_args({_ ,["help"], _}) do
    print_help_message()
  end
  
  defp process_args({_ ,["-"], _}) do
    print_tutorial_message()
  end



  defp process_args({_, ["t", file_name], _}) do
    print_token_list(file_name)
  end

  defp process_args({_, ["a", file_name], _}) do
    print_ast(file_name)
  end

  defp process_args({_, ["s", file_name], _}) do
    print_assembler(file_name)
  end



#Función que imprime la lista de tokens
  defp print_token_list(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Lexer.lexer()
    |> IO.inspect(label: "\nLexer output")
  end

#Función que imprime el árbol AST
  defp print_ast(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Lexer.lexer()
    |> Parser.parseProgram()
    |> IO.inspect(label: "\nParser output")
  end

#Función que imprime el emsanblador
  defp print_assembler(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Lexer.lexer()
    |> Parser.parseProgram()
    |> CodeGenerator.generateCode()
  end

#Función que muestra ayuda

  defp print_help_message do
    IO.puts("\nCompilator help file_name \n")
    IO.puts("\nThe compiler supports following options:\n")
    @commands
    |> Enum.map(fn {comman, description} -> IO.puts("  #{comman} - #{description}") end)
  end
  
#Función que muestra apoyo

  defp print_tutorial_message do
    IO.puts("\nError")
    IO.puts("\nPara utilizar este compilador agrega el archivo .c que deseas compilar con algunas de las siguientes opciones:\n")
    @commands
    |> Enum.map(fn {comman, description} -> IO.puts("  #{comman} - #{description}") end)
  end


end
