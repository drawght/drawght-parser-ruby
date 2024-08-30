module Drawght
  require_relative "drawght/compiler"

  def self.new(template)
    Compiler.new template
  end
end
