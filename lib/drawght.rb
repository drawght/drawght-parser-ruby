module Drawght
  autoload :Compiler, "#{__dir__}/drawght/compiler"
  autoload :Markup, "#{__dir__}/drawght/markup"

  def self.load(template)
    Compiler.new template
  end

  def self.compile(template, data)
    load(template).compile data
  end
end
