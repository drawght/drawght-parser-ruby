# frozen_string_literal: true

require "pry-byebug"
require "minitest/autorun"
require_relative "../lib/drawght"

describe "drawght markup heading" do
  heading = Drawght::Markup::Heading.new
  valid_markups = {
    "# Heading 1\n" => "<h1>Heading 1</h1>\n",
    "## Heading 2\n" => "<h2>Heading 2</h2>\n",
    "### Heading\n    level 3\n\n" => "<h3>Heading\n    level 3</h3>\n\n",
  }
  invalid_markups = [
    "# Not heading 1",
  ]

  it "process valid markups" do
    valid_markups.each do |input, result|
      expect(heading.process input).must_equal result
    end
  end

  it "not process invalid markups" do
    invalid_markups.each do |input|
      expect(heading.process input).must_equal input
    end
  end

  template = <<-end
    # Heading 1

    ## Heading 2

    ### Heading
        level 3

    #### Heading level 4
  end

  result = <<-end
    <h1>Heading 1</h1>

    <h2>Heading 2</h2>

    <h3>Heading
        level 3</h3>

    <h4>Heading level 4</h4>
  end

  it "process long text with valid and invalid markups" do
    expect(heading.process template).must_equal result
  end
end
