require "date"
require "yaml"
require_relative "lib/drawght"

yaml = File.read("example.yaml")
data = YAML.load(yaml, permitted_classes: [Date])

puts "Dataset", yaml
Dir.glob "*.in" do |file|
  template = File.read(file)
  drawght = Drawght.new(template)
  line = "-" * 78
  puts line
  puts template
  puts line
  puts drawght.compile(data)
end
