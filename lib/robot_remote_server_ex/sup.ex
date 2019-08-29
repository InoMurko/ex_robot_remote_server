defmodule RobotRemoteServerEx.Sup do
  @moduledoc """
  Inits the application process tree
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RobotRemoteServerEx, []),
      {Plug.Cowboy, scheme: :http, plug: RobotRemoteServerEx.Router, options: [port: port()]}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__, max_restarts: 5_000]
    Supervisor.start_link(children, opts)
  end

  defp port do
    port = System.get_env("PORT")

    if port, do: String.to_integer(port), else: 8889
  end
end
