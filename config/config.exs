# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :streamlabs_intro, StreamlabsIntroWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rVbAA/aEWhO7RiOUn03C9zh+iRgh3sBWv2Jf0XGgMDM7oogja6h89XEHArH3UPYD",
  render_errors: [view: StreamlabsIntroWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StreamlabsIntro.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "SECRET_SALT"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
