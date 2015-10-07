# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# The metricize filter takes complex events containing a number of metrics
# and splits these up into multiple events, each holding a single metric.
#
# Example:
#
#     Assume the following filter configuration:
#
#     filter {
#       %PLUGIN% {
#         metrics => [ "metric1", "metric2" ]
#       }
#     }
#
#     Assuming the following event is passed in:
# 
#     {
#          type => "type A"
#          metric1 => "value1"
#          metric2 => "value2"
#     }
#
#     This will result in the following 2 events being generated in addition to the original event:
#
#     {                               {
#         type => "type A"                type => "type A"
#         metric => "metric1"             metric => "metric2"
#         value => "value1"               value => "value2"
#     }                               }
#     

class LogStash::Filters::Metricize < LogStash::Filters::Base

  config_name "metricize"

  # A new matrics event will be created for each metric field in this list.
  # All fields in this list will be removed from generated events.
  config :metrics, :validate => :array, :required => true

  # Name of the field the metric name will be written to.
  config :metric_field_name, :validate => :string, :default => "metric"

  # Name of the field the metric value will be written to.
  config :value_field_name, :validate => :string, :default => "value"

  # Flag indicating whether the original event should be dropped or not.
  config :drop_original_event, :validate => :boolean, :default => false

  public
  def register
    # Nothing to do
  end

  public
  def filter(event)
    
    base_event = event.clone
    @metrics.each do |field|
      base_event.remove(field)
    end  

    @metrics.each do |metric|
      if event[metric]
        clone = base_event.clone
        clone[@metric_field_name] = metric
        clone[@value_field_name] = event[metric]
        @logger.debug("Created metricized event ", :clone => clone, :event => event)
        yield clone
      end
    end

    if @drop_original_event
      event.cancel()
    end

    base_event.cancel()
  end

end # class LogStash::Filters::Metricize
