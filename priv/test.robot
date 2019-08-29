*** Settings ***
Library           Remote          http://localhost:8889/RPC2

*** Test Cases ***
Remote Test
  Remote.print_to_elixir_console