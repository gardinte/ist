ExUnit.start(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Ist.Repo, :manual)

# Ignore migration modules being reloaded.
# See https://github.com/Dania02525/apartmentex/issues/12
Code.compiler_options(ignore_module_conflict: true)
