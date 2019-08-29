defmodule RobotRemoteServerEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :robot_remote_server_ex,
      version: "1.0.0",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      elixir: "~> 1.3",
      build_embedded: Mix.env() in [:prod],
      start_permanent: Mix.env() in [:prod],
      deps: deps()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      applications: [],
      mod: {RobotRemoteServerSup, []}
    ]
  end

  defp deps do
    [{:xmlrpc, "~> 1.0"}, {:plug, "~> 1.0"}, {:plug_cowboy, "~> 2.0"}]
  end
end
