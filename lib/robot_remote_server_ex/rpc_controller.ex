defmodule RobotRemoteServerEx.RpcController do
  #use HTTPoison.Base

  def index(conn) do
    {_adapter, state} = conn.adapter
    body = elem(state, 21)
    {:ok, decoded} = XMLRPC.decode(body)
    function = String.to_atom(decoded.method_name)
    result = :erlang.apply(RobotRemoteServerEx, function, decoded.params)
    encoded = handle_response(function, result)

    conn
    |> Plug.Conn.put_resp_content_type("text/xml")
    |> Plug.Conn.send_resp(200, encoded)
  end

  # Entries in the remote result dictionary
  # Name  Explanation
  # status - Mandatory execution status. Either PASS or FAIL.
  # output - Possible output to write into the log file. Must be given as a single string but can contain multiple messages and different `log levels`__ in format *INFO* First messagen*HTML* <b>2nd</b>n*WARN* Another message. It is also possible to embed timestamps_ to the log messages like *INFO:1308435758660* Message with timestamp.
  # return - Possible return value. Must be one of the supported types.
  # error - Possible error message. Used only when the execution fails.
  # traceback - Possible stack trace to `write into the log file`__ using DEBUG level when the execution fails.
  # continuable - When set to True, or any value considered True in Python, the occurred failure is considered continuable__. New in Robot Framework 2.8.4.
  # fatal - Like continuable, but denotes that the occurred failure is fatal__. Also new in Robot Framework 2.8.4.
  defp handle_response(:run_keyword, result) do
    {:ok, encoded} = XMLRPC.encode(%XMLRPC.MethodResponse{param: %{"status" => "PASS", "return" => result}})

    encoded
  end

  defp handle_response(_, result) do
    {:ok, encoded} = XMLRPC.encode(%XMLRPC.MethodResponse{param: result})
    encoded
  end
end
