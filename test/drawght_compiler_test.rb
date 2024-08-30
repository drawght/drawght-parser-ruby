require "minitest/autorun"
require_relative "../lib/drawght"

describe "drawght compiler" do
  def compile(template, data)
    Drawght::Compiler.new(template).compile(data)
  end

  describe "when compile" do
    it "convert variables" do
      template = "{name} v{version} ({release date}/{start-at})";
      result = compile template, {
        name: "Drawght",
        version: "0.1.0",
        "release date": "2021-07-01",
        "start-at" => "2021-06-30",
      }

      expect(result).must_equal "Drawght v0.1.0 (2021-07-01/2021-06-30)"
    end

    it "convert hash objects" do
      template = "{product.name} - {package.name} v{package.version} ({package.release})"
      result = compile template, {
        product: {
          name: "Drawght",
        },
        package: {
          name: "drawght-compiler",
          version: "0.1.0",
          release: "2021-07-01",
        }
      }

      expect(result).must_equal "Drawght - drawght-compiler v0.1.0 (2021-07-01)"
    end

    it "convert list" do
      template = "- {tags}"
      result = compile template, {
        tags: %w[Text Test Tagged]
      }

      expect(result).must_equal "- Text\n- Test\n- Tagged"
    end

    it "convert item in a list" do
      template = '{languages#2.name} site "https:{languages#2.url}" and {languages#1.name} site "https:{languages#1.url}"'
      result = compile template, {
        languages: [
          { name: "Go", url: "//go.dev/" },
          { name: "Ruby", url: "//www.ruby-lang.org/" },
        ]
      }

      expect(result).must_equal %{Ruby site "https://www.ruby-lang.org/" and Go site "https://go.dev/"}
    end

    it "convert list of objects" do
      skip
    end
  end
end
