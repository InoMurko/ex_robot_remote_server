defmodule RobotRemoteServerEx do
  use GenServer

  @ignore_exports [
    :__info__,
    :module_info,
    :get_keyword_names,
    :get_keyword_types,
    :get_keyword_documentation,
    :get_keyword_arguments,
    :init,
    :start_link,
    :code_change,
    :handle_cast,
    :handle_call,
    :handle_info,
    :child_spec,
    :terminate
  ]
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  #debug
  def handle_call(:get_state, _, state) do
    {:reply, {:ok, state}, state}
  end

  ###########################################################################
  ###
  ### Robotframework shared remote keywords declaration
  ### For each function declare specs using @spec and doc
  ### @doc!
  ###########################################################################

  #functions here
  @spec print_to_elixir_console() :: :ok
  def print_to_elixir_console() do
    IO.puts "YOLO"
  end

  ###########################################################################
  ###
  ### Robotframework shared remote keywords declaration STOP
  ###########################################################################

  @doc """
  Stops the Elixir Application. RobotFramework requirement.
  """
  @spec stop_remote_server(String.t(), Integer) :: :ok
  def stop_remote_server(_test, _value), do: :ok

  def run_keyword(function, args) do
    :erlang.apply(__MODULE__, String.to_atom(function), args)
  end

  def get_keyword_types(_), do: []

  def get_keyword_names do
    Enum.reject(
      Keyword.keys(__MODULE__.module_info(:exports)),
      fn x ->
        Enum.member?(@ignore_exports, x)
      end
    )
    |> Enum.map(fn x -> Atom.to_string(x) end)
  end

  def get_keyword_documentation(function) do
    fun = String.to_atom(function)
    {_, _, _, _, _, _, docs} = Code.fetch_docs(__MODULE__)

    item =
      Enum.find(docs, fn x ->
        case x do
          {{:function, ^fun, _arity}, _, _, _, _} -> true
          _ -> false
        end
      end)
    case item do
      {_, _, _, %{"en" => doc}, _} -> doc
      {_, _, _, _, _} -> ""
    end
  end

  def get_keyword_tags(_), do: []

  # TODO get exact types from AST
  def get_keyword_arguments(function) do
    fun = String.to_atom(function)
    {_, _, _, _, _, _, docs} = Code.fetch_docs(__MODULE__)

    item =
      Enum.find(docs, fn x ->
        case x do
          {{:function, ^fun, _arity}, _, _, _, _} -> true
          _ -> false
        end
      end)

    {{:function, ^fun, arity}, _, _, _, _} = item
    gen_params(arity)
    # function = String.to_atom(fun)
    # s(__MODULE__, function)
  end

  defp gen_params(0), do: ""

  defp gen_params(number) do
    for _ <- 1..number do
      "str1"
    end
  end
end
