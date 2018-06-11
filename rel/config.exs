# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html

environment :prod do
  set include_erts: true
  set include_src: false
  set include_system_libs: true
  set cookie: :"V$lO>ONPuh3RgS,*Q1?|j;lz:TFiy]iVni|n[Op$AmSjb5/RG85v.u@]LaU?%VkR"
  set post_start_hook: "rel/hooks/post_start"
end

release :ist do
  set version: current_version(:ist)
  set applications: [
    :runtime_tools
  ]
end

