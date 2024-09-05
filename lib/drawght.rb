module Drawght
  autoload :Compiler, "#{__dir__}/drawght/compiler"

  def self.load(template)
    Compiler.new template
  end

  def self.compile(template, data)
    load(template).compile data
  end
end
