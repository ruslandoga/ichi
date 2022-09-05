defmodule I.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias I.Repo
      import Ecto
      import Ecto.Query
    end
  end

  setup tags do
    I.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(I.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end
end
