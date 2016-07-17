defmodule Orientex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :orientex,
      version: "0.0.2",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      name: "Orientex",
      deps: deps(),
      description: description(),
      package: package(),
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:db_connection, "~>1.0-rc"},
    ]
  end

  defp description do
    """
    An OrientDB network binary protocol driver for Elixir 1.3+ using DBConnection.
    """
  end

  defp package do
    [
      files: ["config", "lib", "test", ".gitignore", "LICENSE*", "mix.exs", "README*"],
      maintainers: ["Austin S. Morris"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/austinsmorris/orientex"},
    ]
  end
end
