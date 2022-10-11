require 'vega'
require 'erb'
require_relative 'employee'

class Visualizer
  class << self
    TEMPLATE = 'templates/visualizer.html.erb'.freeze
    OUTPUT = 'visualizer.html'.freeze

    def title
      'Visualizer'
    end

    def position_chart
      data = DB[:employees].group_and_count(:position).all

      Vega.lite
          .data(data)
          .mark(type: "bar", tooltip: true)
          .encoding(
            x: {field: "position", type: "nominal"},
            y: {field: "count", type: "quantitative"}
          )
    end

    def nationality_chart
      data = DB[:employees].group_and_count(:nationality).all

      Vega.lite
          .data(data)
          .mark(type: "bar", tooltip: true)
          .encoding(
            x: {field: "nationality", type: "nominal"},
            y: {field: "count", type: "quantitative"}
          )
    end

    def render(template = TEMPLATE)
      ERB.new(File.read "#{template}").result(binding)
    end

    def write(output = OUTPUT)
      File.open(output, 'w') do |file|
        file.write render
      end
    end
  end
end

Visualizer.write
