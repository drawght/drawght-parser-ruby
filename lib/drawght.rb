module Drawght
  require_relative "drawght/compiler"

  def self.load(template)
    Compiler.new template
  end

  def self.compile(template, data)
    load(template).compile data
  end
end
