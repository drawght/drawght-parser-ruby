require "minitest/autorun"
require_relative "../lib/drawght"

describe "drawght compiler" do
  describe "when compile" do
    it "convert variables" do
      template = "{name} v{version} ({release date}/{start-at})";
      data = {
        name: "Drawght",
        version: "0.1.0",
        "release date" => "2021-07-01",
        "start-at" => "2021-06-30",
      }
      result = Drawght.load(template).compile data

      expect(result).must_equal "Drawght v0.1.0 (2021-07-01/2021-06-30)"
    end

    it "convert hash objects" do
      template = "{product.name} - {package.name} v{package.version} ({package.release})"
      data = {
        product: {
          name: "Drawght",
        },
        package: {
          name: "drawght-compiler",
          version: "0.1.0",
          release: "2021-07-01",
        }
      }
      drawght = Drawght.load template
      result = drawght.compile data

      expect(result).must_equal "Drawght - drawght-compiler v0.1.0 (2021-07-01)"
    end

    it "convert list" do
      skip
    end

    it "convert item in a list" do
      skip
    end

    it "convert list of objects" do
      skip
    end
  end
end
