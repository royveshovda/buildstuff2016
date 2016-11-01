# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :nerves, :firmware,
  rootfs_additions: "rootfs-additions"

config :nerves_ntp, :ntpd, "/usr/sbin/ntpd"

config :nerves_ntp, :servers, [
  "0.pool.ntp.org",
  "1.pool.ntp.org",
  "2.pool.ntp.org",
  "3.pool.ntp.org"
]

config :nerves_interim_wifi,
  regulatory_domain: "LT"

config :logger, level: :warn

config :ui, Ui.Endpoint,
  url: [host: "0.0.0.0"],
  http: [port: 80],
  root: Path.dirname(__DIR__),
  check_origin: false,
  secret_key_base: "VWoNyclnlCc/qRKZMhrFvr/P1Vb9tleztCuVZus8Y1ue3GevILInN4msrnfrnVMQ",
  render_errors: [view: Ui.ErrorView, accepts: ~w(html json)],
  server: true,
  pubsub: [name: Ui.PubSub,
             adapter: Phoenix.PubSub.PG2]

#config :fw, :wlan0,
# ssid: "XX",
# psk: "YY"Du

#config :extwitter, :oauth, [
# consumer_key: "aaa",
# consumer_secret: "bbb",
# access_token: "ccc",
# access_token_secret: "ddd"
#]

config :ui, :led_hw, Fw.Led
config :ui, :sensor_hw, Fw.Sensor
# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
