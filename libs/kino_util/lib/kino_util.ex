defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System utilization"
  alias KinoUtil.Measure

  @interval_update 1_000
  @default_fields %{
    "cpu_percent" => 0,
    "mem_used" => 0,
    "mem_total" => 0,
    "mem_percent" => 0,
    "gpu_percent" => 0,
    "gpu_mem_percent" => 0,
    "gpu_mem_used" => 0,
    "gpu_mem_total" => 0
  }

  @impl true
  def init(attrs, ctx) do
    fields = Map.merge(@default_fields, attrs)

    Process.send(self(), "check_gpu", [])
    Process.send(self(), "update", [])
    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("check_gpu", ctx) do
    fields = ctx.assigns.fields

    has_gpu = Measure.check_gpu()

    Map.merge(fields, %{"has_gpu" => has_gpu})
    broadcast_event(ctx, "has_gpu", has_gpu)
    {:noreply, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("update", ctx) do
    fields = ctx.assigns.fields

    cpu_util = Measure.cpu_util()
    {mem_perc, mem_used, mem_total} = Measure.mem_util()

    values = %{
      "cpu_percent" => cpu_util,
      "mem_percent" => mem_perc,
      "mem_used" => mem_used,
      "mem_total" => mem_total
    }

    values =
      if fields["show_gpu"] do
        {gpu_util, gpu_mem_util, gpu_mem_used, gpu_mem_total} = Measure.gpu_util()

        values_gpu = %{
          "gpu_percent" => gpu_util,
          "gpu_mem_percent" => gpu_mem_util,
          "gpu_mem_used" => gpu_mem_used,
          "gpu_mem_total" => gpu_mem_total
        }

        Map.merge(values, values_gpu)
      else
        values
      end

    fields = Map.merge(fields, values)
    ctx = assign(ctx, fields: fields)
    broadcast_event(ctx, "update", fields)
    Process.send_after(self(), "update", @interval_update)
    {:noreply, ctx}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{fields: ctx.assigns.fields}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns.fields
  end

  @impl true
  def to_source(_attrs) do
    quote do
      :ok
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
