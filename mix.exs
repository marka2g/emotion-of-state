defmodule EmotionOfState.MixProject do
  use Mix.Project

  def project do
    [
      app: :emotion_of_state,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: EmotionOfState]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:flow, "~> 0.14"}]
  end
end
