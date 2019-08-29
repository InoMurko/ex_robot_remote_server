# Robot Remote Server in Elixir

**Description**

The application is an elixir application, that exposes an API on http://localhost:8889/RPC2*.
It's meant as an interface between Robotframework and the Elixir platform it is running in.

Probably needs more work so that you're able to include it as a library... but it's a first step.

Usage:
iex -S mix run --no-start
Application.ensure_all_started(:robot_remote_server_ex)