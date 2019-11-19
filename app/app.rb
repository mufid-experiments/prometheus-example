require 'sinatra'

require './simpleclient-0.8.0.jar'
require './simpleclient_common-0.8.0.jar'
require './simpleclient_httpserver-0.8.0.jar'

REQUEST_COUNTER = Java::IoPrometheusClient::Counter.build().name("hitapp_requests").help("Total requests.").register()
REQUEST_PROCESSING_HG = Java::IoPrometheusClient::Histogram.build().name("hitapp_processing_time_hg").help("Request processing time").register()
REQUEST_PROCESSING_SM = Java::IoPrometheusClient::Summary.build().name("hitapp_processing_time_sm").help("Request processing time")
    .quantile(1.0, 0.1)
    .quantile(0.99, 0.1)
    .quantile(0.9, 0.1)
    .quantile(0.5, 0.1)
    .register()
REQUEST_CONC_GAUGE = Java::IoPrometheusClient::Gauge.build().name("hitapp_requests_concurrent").help("Concurrent request").register();

begin
  prometheus_port = ENV['PORT'].to_i / 100 - 50 + 8080
  server = Java::IoPrometheusClientExporter::HTTPServer.new(prometheus_port)
  puts "Prometheus metric at port #{prometheus_port}"
end

# server(9090)

get '/' do
  start_time = Time.now
  REQUEST_CONC_GAUGE.inc()

  REQUEST_COUNTER.inc()
  duration = Random.rand
  sleep duration
  sleep(duration * 5) if duration > 0.90

  REQUEST_CONC_GAUGE.dec()

  request_time = Time.now - start_time
  REQUEST_PROCESSING_HG.observe(request_time)
  REQUEST_PROCESSING_SM.observe(request_time)

  "diproses dalam #{duration} detik"
end


