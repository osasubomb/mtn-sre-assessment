using OpenTelemetry;
using OpenTelemetry.Trace;
using OpenTelemetry.Resources;
using OpenTelemetry.Metrics;

public static class OpenTelemetryConfig
{
    public static void AddOpenTelemetry(IServiceCollection services)
    {
        services.AddOpenTelemetry()
            .WithTracing(builder =>
            {
                builder
                    .SetResourceBuilder(ResourceBuilder.CreateDefault()
                        .AddService("cartservice", serviceVersion: "1.0"))
                    .AddAspNetCoreInstrumentation()
                    .AddHttpClientInstrumentation()
                    .AddRedisInstrumentation()
                    .AddOtlpExporter(options =>
                    {
                        options.Endpoint = new Uri("http://otel-agent:4317");
                    });
            })
            .WithMetrics(builder =>
            {
                builder
                    .AddMeter("cartservice")
                    .AddRuntimeInstrumentation()
                    .AddOtlpExporter(options =>
                    {
                        options.Endpoint = new Uri("http://otel-agent:4317");
                    });
            });
    }
}