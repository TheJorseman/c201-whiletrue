defmodule Linker do
  def final(asm_code, path) do
    # Path.basename regresa el ultimo componente del path
    #   o el path completo si no tiene separador  de directorio /

    # Nombre del archivo con codigo ensamblador
    asm_name = Path.basename(path)
    # Se elimina la extensión .s
    bin_name = Path.basename(path, ".s")
    # Directorio destino
    destination = Path.dirname(path)
    path = "#{destination} / #{asm_name}"
    File.write(path,asm_code)
    System.cmd("gcc",[asm_name,"-o#{bin_name}"],cd: destination)
  end
end
