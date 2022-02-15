# Concurrent Data Processing in Elixir

There are also some built-in supervisors which we can use without writing (almost) any code, and one of them is `Task.Supervisor`.

```bash
 def start(_type, _args) do
  children = [
    {Task.Supervisor, name: Sender.EmialTaskSupervisor}
  ]

  # See https://hexdocs.pm/elixir/Supervisor.html
  # for other strategies and supported options
  opts = [strategy: :one_for_one, name: Sender.Supervisor]
  Supervisor.start_link(children, opts)
end
```

The child specification could be also be a map. We can rewrite the last change and use a map link this:

```bash
def start(_type, _args) do
  children = [
    children: [
      %{
        id: Sender.EmialTaskSupervisor,
        start: {
          Task.Supervisor,
          :start_link,
          [[name: Sender.EmialTaskSupervisor]]
        }
      }
    ]
  ]
  opts = [strategy: :one_for_one, name: Sender.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Using GenServer

```bash
defmodule SendServer do
  use GenServer  
end
```

The use macro for the GenServer module does two things for us. First, it automatically injects the line @behaviour GenServer in our SendServer module. Second, it provides a default GenServer implementation for us by injecting all functions required by the GenServer behaviour.

The `GenSever` module provides default implementations for several functions required by `GenServer` behaviour functions are known as `callback`, and `init/1` one of them.

We're going to cover the following callback functions for the `GenServer` behaviour:

* handle_call/3
* handle_cast/2
* handle_info/2
* init/1
* terminate/2

### Init Process

```bash
def init(arg) do
   IO.puts("Received arguments: #{arg}")
   max_retries = Keyword.get(arg, :max_retries, 4)
   state = %{emails: [], max_retries: max_retries}
   {:ok, state}
 end
```

There are a number of result values supported by the init/1 callback. The most common ones are:

* {:ok, state}
* {:ok, state, {:contunie, term}}
* :ignore
* {:stop, reason}

The extra option {:continue, term} is great for doing post-initialization work. You may be tempted to add complex logic to your init/ 1 function, such as fetching information from the database to populate the GenServer state, but that’s not desirable because the init/ 1 function is synchronous and should be quick. This is where {:continue, term} becomes really useful. If you return {:ok, state, {:continue, :fetch_from_database}}, the handle_continue/ 2 callback will be invoked after init/ 1.

```bash
def handle_continue(:fetch_from_database, state) do
 # called after init/1
end
```

`{:stop, reason}` will make the supervisor restart it, while :ignore won't trigger a restart.
