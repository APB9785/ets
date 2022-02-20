defmodule ETS.TestServer do
  @moduledoc """
  A test process for receiving ETS table ownership messages.
  """
  use GenServer

  import ETS.Acceptor

  alias ETS.Bag
  alias ETS.KeyValueSet
  alias ETS.Set

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  accept KeyValueSet, kv_set, from, "kv_set", state do
    send(from, {:thank_you, kv_set})
    {:noreply, state}
  end

  accept Set, set, from, "set", state do
    send(from, {:thank_you, set})
    {:noreply, state}
  end

  accept Bag, bag, from, "bag", state do
    send(from, {:thank_you, bag})
    {:noreply, state}
  end
end
