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
    "#1. Heading 1\n" => "<h1>1. Heading 1</h1>\n",
    "#1.1. Heading 2\n" => "<h2>1.1. Heading 2</h2>\n",
    "#1.2. Heading 2\n" => "<h2>1.2. Heading 2</h2>\n",
    "#99.2. Heading 2\n" => "<h2>99.2. Heading 2</h2>\n",
    "#99.2.101. Heading 3\n" => "<h3>99.2.101. Heading 3</h3>\n",
    "#99.2.101.99. Heading 4\n" => "<h4>99.2.101.99. Heading 4</h4>\n",
    "#99.2.101.99.1. Heading 5\n" => "<h5>99.2.101.99.1. Heading 5</h5>\n",
    "#99.2.101.99.1.100. Heading 6\n" => "<h6>99.2.101.99.1.100. Heading 6</h6>\n",
  }
  invalid_markups = [
    "# Not heading 1",
    "#Not heading 1\n",
    "#1. not heading 1",
    "#1.1 not heading 2",
    "#1.1.1 not heading 3",
    "#1.1.1.1 not heading 4",
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

  template = <<-end
    #1. Heading 1

    #1.1. Heading level 2

    #1.2. Heading level 2

    #1.3. Heading
          level 2

    #1.3.1. Heading level 3

    #1.3.1.1. Heading level 4

    #1.3.1.1.1. Heading level 5

    #1.3.1.1.1.1. Heading level 6
  end

  result = <<-end
    <h1>1. Heading 1</h1>

    <h2>1.1. Heading level 2</h2>

    <h2>1.2. Heading level 2</h2>

    <h2>1.3. Heading
          level 2</h2>

    <h3>1.3.1. Heading level 3</h3>

    <h4>1.3.1.1. Heading level 4</h4>

    <h5>1.3.1.1.1. Heading level 5</h5>

    <h6>1.3.1.1.1.1. Heading level 6</h6>
  end

  it "process long text with valid and invalid markups" do
    expect(heading.process template).must_equal result
  end
end
