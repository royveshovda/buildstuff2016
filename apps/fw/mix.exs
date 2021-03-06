defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1.4"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Fw, []},
     applications:
      [
        :logger,
        :nerves_interim_wifi,
        :elixir_ale,
        :gpio_rpi,
        :nerves_ntp,
        :logic,
        :ui
      ]
    ]
  end

  def deps do
    [
      {:nerves, "~> 0.3.4"},
      {:elixir_ale, "~> 0.5.6"},
      {:gpio_rpi, "~> 0.1.0"},
      {:nerves_interim_wifi, "~> 0.1.0"},
      {:nerves_ntp, "~> 0.1.1"},
      {:logic, in_umbrella: true},
      {:ui, in_umbrella: true},
      {:contract, in_umbrella: true}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
