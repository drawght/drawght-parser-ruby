module Drawght
  require_relative "drawght/compiler"

  def self.load(template)
    Compiler.new template
  end
end
