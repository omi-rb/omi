# Omi

> 🚧 Under construction 🚧
>
> Omi is following a [Readme Driven Development][rdd] approach.
> Much of this readme and Omi's [documentation][docs]
> is currently aspirational
> or in heavy flux.

## What is Omi?

Omi is a Ruby-based framework for building command line interface tools.

### Goals

- Get the features from complex command line tools
  like the GitHub, AWS, and Google Cloud CLIs
  while focusing on your tool's functionality.
- Make robust command line tools not only easy and fun to build,
  but also to test, package, and distribute.

### Motivation

Command line interfaces have continued
to evolve and adapt with the modern technology stack
and continue to be essentials tools for
end-users, developers, data engineers, and system administrators.

The modern technology stack includes
a wide range of tools and services
that can be accessed via the command line.
Providing a robust CLI is a hallmarks
of mature service providers and software packages.

Automation and scripting in the modern stack
also demands a fluent interface for integration
that supports common formats like JSON and
easily connects with cloud and network services
over HTTP, gRPC, and other protocols.

Ruby has long been a language well-suited
for building fluent, robust command line interfaces,
and there are many great examples in the ecosystem.
However, much of the investment in tooling
to build complex CLIs has shifted in recent years
to other languages like Go, Rust, and JavaScript/TypeScript.

The motivation to build Oni comes from a love for Ruby
and a desire to give the community
an outstanding tool for building CLIs
that meets or exceeds what Ruby's current ecosystem
and other languages have to offer.

### Philosophy

- Embrace the Ruby language
  and confidently use Ruby-specific design patterns and idioms where possible
  in both internal implementation and developer-facing APIs
- Don't be too clever.
  Oni's aim is to provide a batteries-included framework for building CLIs
  that provide the same features as prominent tools like
  the GitHub CLI and those offered by major cloud providers.
  The intent is not to come up with new avant-garde CLI experiences
  but to make battle-tested and familiar patterns
  easy to include with your own tools.

## Installation

Install from RubyGems:

```shell
gem install omi
```

Or add to your `Gemfile`:

```shell
bundle add omi
```

## Usage

Omi can be used to build CLIs of all sizes,
from standalone scripts with a single command
to large multi-command tools like the [GitHub CLI](https://cli.github.com/).

Here are a few examples to demonstrate
how Omi aspires to work for different use case.

See the [documentation][docs] for detailed usage information.

### Standalone script with a single command

```ruby
#!/usr/bin/env ruby

require "omi/main"
require "net/http"

plugin :output, formats: [:json], query: :jmespath

flag :username, :u, :string, desc: "The GitHub user to find"

run! do
  uri = URI("https://api.github.com/users/#{inputs[:username]}")
  req = Net::HTTP::Get.new(uri)
  req["Accept"] = "application/vnd.github+json"
  req["X-GitHub-Api-Version"] = "2022-11-28"

  res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

  output(res.body)
end
```

```shell
$ ruby ./github_user.rb --username tbhb -o json --query "email"
tony@tonyburns.net
```

### Standalone script with multiple commands

```ruby
#!/usr/bin/env ruby

require "omi/main"
require "net/http"

def make_gh_request(url)
  uri = URI("https://api.github.com/repos/#{inputs[:repo]}/issues")
  req = Net::HTTP::Get.new(uri)
  req["Accept"] = "application/vnd.github+json"
  req["X-GitHub-Api-Version"] = "2022-11-28"

  Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
end

plugin :output, formats: [:json], query: :jmespath

shared_arg :repo, :string, desc: "The GitHub repository to use"

include_arg :repo
command :issues do
  res = make_gh_request("https://api.github.com/repos/#{inputs[:repo]}/issues")
  output(res.body)
end

include_arg :repo
flag :base, :string, desc: "The base branch"
command :pulls do
  res = make_gh_request("https://api.github.com/repos/#{inputs[:repo]}/pulls/?base=#{base}")
  output(res.body)
end

run!
```

```shell
$ ruby ./github_issues_and_pulls.rb issues omi-rb/omi --output jmespath=".[].user.login"
[
  "tbhb"
]

$ ruby ./github_issues_and_pulls.rb pulls omi-rb/omi --base main --output jmespath=".[].[number, title]"
[
  ["1234", "Amazing new feature"]
]
```

### Gem with classes per command

```shell
omi create my_cli --modular
omi generate command foo --arg foo:string --flag bar --flag baz:string
```

**lib/my_cli/commands/foo.rb**:

```ruby
module MyCli
  class Foo < Omi::Command
    arg :foo, :string

    flag :bar
    flag :baz, :string

    def run
      output(inputs)
    end
  end
end
```

**lib/my_cli/cli.rb**:

```ruby
module MyCli
  class Cli < Omi::Application
    include_command MyCli::Foo
  end
end
```

```shell
$ exe/my_cli foo qux --bar --baz hello
{
  "foo": "qux",
  "bar": true,
  "baz": "hello"
}
```

## Contributing

Omi is currently in its first iteration of development.
The architecture, design, and API
are likely to change heavily
leading up to v1.0.

Contributions at this time are encouraged via [discussions][discussions].

## License

Copyright © 2023 Tony Burns &lt;<tony@tonyburns.net>&gt;

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

## Code of Conduct

Everyone interacting in the Omi project's
codebases, issue trackers, chat rooms and mailing lists
is expected to follow
the [code of conduct][coc].

[coc]: https://github.com/omi-rb/omi/blob/main/CODE_OF_CONDUCT.md
[discussions]: https://github.com/omi-rb/discussions
[docs]: https://omi-rb.sh/docs
[rdd]: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html
