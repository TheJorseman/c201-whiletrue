defmodule Compiler do
  #import Printex
  @moduledoc """
  Documentation for Compilador
  """
  @commands %{

    "\t-h\t" => "Help",
    "\t-a\t" => "Print AST tree",
    "\t-tutorial\t" => "Tutorial",
    "\t-O1\t" => "Optimizador Nivel 1",
    "\t-O2\t" => "Optimizador Nivel 2",
    "\t-s\t" => "Generate Assembler",
    "\t-t\t" => "Print Token List\n\n\n"
  }

  def main(args) do
    case args do
  ["-h"] ->    print_help_message()
  ["-tutorial"] ->    print_tutorial_message()
  ["-a",file_name] ->    print_ast(file_name)
  ["-s",file_name] ->    print_assembler(file_name)
  ["-O1",file_name] ->    compile_optimization_l1(file_name)
  ["-O2",file_name] ->    compile_optimization_l2(file_name)
  ["-t",file_name] ->    print_token_list(file_name)
  [file_name]      ->     compile_file(file_name)

    end
  end

  def compile_optimization_l2(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly = String.replace_trailing(file_path, ".c", ".s")
    try do
      File.read!(file_path)
      File.write!(assembly,File.read!(file_path)
      |> Lexer.lexer()
      |> Parser.parseProgram()
      |> Optimizer.optimizer_2())
      |> Linker.final(assembly)
    IO.puts("Compiled file\n\n")
    :successfulComp
    rescue
      e in RuntimeError -> IO.puts(IO.ANSI.red() <> "Error: " <> e.message)
      {:error, e.message}
    end
  end

  def compile_optimization_l1(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly = String.replace_trailing(file_path, ".c", ".s")
    try do
      File.read!(file_path)
      File.write!(assembly,File.read!(file_path)
      |> Lexer.lexer()
      |> Parser.parseProgram()
      |> Optimizer.optimizer_1()
      |> CodeGenerator.generateCode())
      |> Linker.final(assembly)
    IO.puts("Compiled file\n\n")
    :successfulComp
    rescue
      e in RuntimeError -> IO.puts(IO.ANSI.red() <> "Error: " <> e.message)
      {:error, e.message}
    end
  end
#Función que genera todo el proceso de compilación
  def compile_file(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly = String.replace_trailing(file_path, ".c", ".s")

    try do
      File.read!(file_path)

      File.write!(assembly,File.read!(file_path)
      |> Lexer.lexer()
      |> Parser.parseProgram()
      |> CodeGenerator.generateCode())
      |> Linker.final(assembly)
    IO.puts("Compiled file\n\n")
    :successfulComp
    rescue
      e in RuntimeError -> IO.puts(IO.ANSI.red() <> "Error: " <> e.message)
      {:error, e.message}
    end
  end



#Función que imprime la lista de tokens
  def print_token_list(file_path) do
    IO.puts("Compiling file: " <> file_path)
   try do
    File.read!(file_path)
    |> Lexer.lexer()
    |> IO.inspect(label: "\nLexer output")
   IO.puts("\n")
  :successfulComp
    rescue
      e in RuntimeError -> IO.puts("Error: " <> e.message )
      {:error, e.message}
    end
  end

#Función que imprime el árbol AST
  defp print_ast(file_path) do
    IO.puts("Compiling file: " <> file_path)
   try do
    File.read!(file_path)
    |> Lexer.lexer()
    |> Parser.parseProgram()
    |> IO.inspect(label: "\nParser output")
   IO.puts("\n")
  :successfulComp
    rescue
      e in RuntimeError -> IO.puts("Error: " <> e.message )
      {:error, e.message}
    end
  end

#Función que imprime el ensamblador y genera el archivo
  defp print_assembler(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly = String.replace_trailing(file_path, ".c", ".s")

     try do
      File.read!(file_path)
      File.write!(assembly,File.read!(file_path)
      |> Lexer.lexer()
      |> Parser.parseProgram()
      |> CodeGenerator.generateCode())
        IO.puts ("Generated file\n\n")
     IO.puts("\n")
    :successfulComp
     rescue
      e in RuntimeError -> IO.puts("Error: " <> e.message )
      {:error, e.message}
     end
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


#Función que genera compilación para pruebas
def compiler_test(string) do

  try do
    Lexer.lexer(string)
    |> Parser.parseProgram()
    |> CodeGenerator.generateCodeNoP()
  :successfulComp
  rescue
    e in RuntimeError -> IO.puts("Error: " <> e.message )
    {:error, e.message}
  end
end

# Función que genera compilación para pruebas del optimizador
def optimizer_test(string) do

  try do
    Lexer.lexer(string)
    |> Parser.parseProgram()
    |> Optimizer.optimizer_1()
    |> CodeGenerator.generateCodeNoP()
  rescue
    e in RuntimeError -> IO.puts("Error: " <> e.message )
    {:error, e.message}
  end
end

end
