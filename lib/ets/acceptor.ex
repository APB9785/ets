defmodule ETS.Acceptor do
  @moduledoc """
  For processes which may receive ownership of an ETS table unexpectedly, the module
  should include at least one acceptor.  Acceptors are defined by first importing the
  `ETS.Acceptor` module, then calling the `accept` macro.  For example:
  ```
  defmodule Receiver do
    use GenServer
    import ETS.Acceptor

    accept Set, set, _from, _gift, state do
      new_state = Map.put(state, :set, set)
      {:noreply, new_state}
    end
  ```
  See `accept/6` for more details.
  """

  @doc """
  Defines what should happen when ownership of a table is received.
  The first argument must be the ETS module which is used to wrap the table.
  The other arguments declare the variables which may be used in the `do` block:
  the wrapped table, the pid of the previous owner, any additional metadata included,
  and the current state of the process.

  The return value should be in the form {:noreply, new_state}, or one of the similar
  returns expected by `handle_info`/`handle_cast`.
  """
  defmacro accept(module, table, from, gift, state, contents) do
    quote do
      def handle_info(
            {:"ETS-TRANSFER", unquote(table), unquote(from), unquote(gift)},
            unquote(state)
          ) do
        var!(unquote(table)) = unquote(module).wrap_existing!(unquote(table))
        unquote(contents)
      end
    end
  end
end
