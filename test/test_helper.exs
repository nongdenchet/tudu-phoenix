# Test data config
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Start test env
ExUnit.start

# Database test config
Ecto.Adapters.SQL.Sandbox.mode(Tudu.Repo, :manual)
