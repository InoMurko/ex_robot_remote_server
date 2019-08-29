defmodule RobotRemoteServerEx.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(Plug.Static, from: ".", at: "/")
  plug(:match)
  plug(:dispatch)

  post "/RPC2" do
    RobotRemoteServerEx.RpcController.index(conn)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
