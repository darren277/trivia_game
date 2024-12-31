# TriviaGame

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Assorted Notes

PATH_TO_ELIXIR: /home/ubuntu/.elixir-install/installs/elixir/1.18.1-otp-27/bin/elixir

echo "export PATH=$PATH:/home/ubuntu/.elixir-install/installs/elixir/1.18.1-otp-27/bin" >> ~/.bashrc

mix phx.server

## Install Asset Dependencies

```
mix assets.setup

cd assets
npm install
npm run deploy
```
