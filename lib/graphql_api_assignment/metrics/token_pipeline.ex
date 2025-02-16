defmodule GraphqlApiAssignment.Metrics.TokenPipeline do
  @moduledoc false
  import Telemetry.Metrics, only: [distribution: 2, counter: 2]

  @distribution_event_name [:token_pipeline, :duration]
  @millisecond_unit {:native, :millisecond}
  @counter_event_name [:token_pipeline, :duration]

  def metrics do
    [
      distribution(
        "grapql_api.token_generation.duration",
        event_name: @distribution_event_name,
        unit: @millisecond_unit,
        description: "Time to generate auth tokens",
        tags: [:metadata],
        reporter_options: [buckets: [100, 200, 300, 500, 1000, 5000]]
      ),
      counter(
        "grapql_api.total.count",
        event_name: @counter_event_name,
        measurement: :count,
        description: "Total generated auth tokens"
      )
    ]
  end

  def inc_total_count do
    :telemetry.execute(@counter_event_name, %{count: 1})
  end
end
