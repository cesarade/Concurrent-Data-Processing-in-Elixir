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
