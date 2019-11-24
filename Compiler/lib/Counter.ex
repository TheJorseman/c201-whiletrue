defmodule Counter do
  use Agent
  @moduledoc """
  Este modulo sirve como contador para las etiquetas de salto en las operaciones binarias
  lógicas. Tiene funciones para inicializar, obtener el valor actual e incrementarlo.
  """
  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
    __MODULE__
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end

end
