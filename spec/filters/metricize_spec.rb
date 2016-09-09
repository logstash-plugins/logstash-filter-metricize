# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/metricize"

describe LogStash::Filters::Metricize do

  describe "all defaults" do
    config <<-CONFIG
      filter {
        metricize {
          metrics => ["metric1"]
        }
      }
    CONFIG

    sample("message" => "hello world", "metric1" => "value1") do
      insist { subject }.is_a? Array
      insist { subject.length } == 2
      subject.each_with_index do |s,i|
        if i == 0 # last one should be original event
          insist { s.get("metric1") } == "value1"
          reject { s }.include?("metric")
        else
          insist { s.get("metric")} == "metric1"
          insist { s.get("value")} == "value1"
          reject { s }.include?("metric1")
        end
        insist { s.get("message") } == "hello world"
      end
    end
  end

  describe "Complex use" do
    config <<-CONFIG
      filter {
        metricize {
          drop_original_event => true
          metric_field_name => "key"
          value_field_name => "value"
          metrics => ["metric0", "metric1","metric2"]
        }
      }
    CONFIG

    sample("metric1" => "value1", "metric2" => "value2", "metric3" => "value3", "message" => "hello world") do
      insist { subject }.is_a? Array
      insist { subject.length } == 2

      # Verify first metrics event
      insist { subject[0].get("message") } == "hello world"
      insist { subject[0].get("metric3") } == "value3"
      insist { subject[0].get("key") } == "metric1"
      insist { subject[0].get("value") } == "value1"
      reject { subject[0] }.include?("metric1")
      reject { subject[0] }.include?("metric2")

      # Verify second metrics event
      insist { subject[1].get("message") } == "hello world"
      insist { subject[1].get("metric3") } == "value3"
      insist { subject[1].get("key") } == "metric2"
      insist { subject[1].get("value") } == "value2"
      reject { subject[1] }.include?("metric1")
      reject { subject[1] }.include?("metric2")
    end
  end

end
