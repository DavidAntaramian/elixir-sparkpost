<a href="https://www.sparkpost.com"><img src="https://www.sparkpost.com/sites/default/files/attachments/SparkPost_Logo_2-Color_Gray-Orange_RGB.svg" width="200px"/></a>

[Sign up](https://app.sparkpost.com/sign-up?src=Dev-Website&sfdcid=70160000000pqBb) for a SparkPost account and visit our [Developer Hub](https://developers.sparkpost.com) for even more content.

# SparkPost Elixir Library

[![Travis CI](https://travis-ci.org/SparkPost/elixir-sparkpost.svg?branch=master)](https://travis-ci.org/SparkPost/elixir-sparkpost) [![Coverage Status](https://coveralls.io/repos/SparkPost/elixir-sparkpost/badge.svg?branch=master&service=github)](https://coveralls.io/github/SparkPost/elixir-sparkpost?branch=master)

The official [Elixir](http://elixir-lang.org/) package for the [SparkPost API](https://www.sparkpost.com/api).

Capabilities include:
 - convenience functions for easy "I just want to send mail" users
 - advanced functions for unleashing all of Sparkpost's capabilities

## Installation

  1. Add sparkpost and ibrowse to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:sparkpost, "~> 0.1.0"}
    ]
  end
  ```

  2. Ensure sparkpost is started before your application:

  ```elixir
  def application do
    [applications: [:sparkpost]]
  end
  ```

  3. Update your dependencies:

  ```bash
  $ mix deps.get
  ```

## Usage

### Configuration

In your config/config.exs file:

```elixir
config :sparkpost, api_key: "YOUR-API-KEY"
```

### Option 1: Convenience

```elixir
defmodule MyApp.Example do
  def send_message do
    SparkPost.send to: "you@example.com",
         from: "elixir@sparkpostbox.com",
         subject: "Sending email from Elixir is awesome!",
         text: "Hi there!",
         html: "<p>Hi there!</p>"
  end
end
```

### Option 2: Full SparkPost API

```elixir
defmodule MyApp.Example do
  alias SparkPost.{Content, Recipient, Transmission}
  
	def send_message do
    Transmission.send(%Transmission{
        recipients: [ "you@example.com" ],
        return_path: "elixir@sparkpostbox.com",
        content: %Content.Inline{
          subject: "Sending email from Elixir is awesome!",
          from: "elixir@sparkpostbox.com", 
          text: "Hi there!",
          html: "<p>Hi there!</p>"
        }
    })
  end
end
```

Start your app and send a message:

```bash
    $ iex -S mix
    iex> MyApp.Example.send_message
    {:ok, ...}
```

### Contribute

We welcome your contributions!  See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to help out.

### Change Log

[See ChangeLog here](CHANGELOG.md)
