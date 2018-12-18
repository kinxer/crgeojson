require "./spec_helper"

describe MultiPoint do
  describe ".new" do
    it "creates a new multipoint with the given points" do
      first = Point.new 10.0, 15.0
      second = Point.new 20.0, 25.0

      multipoint = MultiPoint.new first, second

      multipoint[0].should eq Point.new(10.0, 15.0)
      multipoint[1].should eq Point.new(20.0, 25.0)
    end
  end

  describe "#type" do
    it %(returns "MultiPoint") do
      multipoint = MultiPoint.new Point.new(0, 0)

      multipoint.type.should eq "MultiPoint"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      multipoint = MultiPoint.new Point.new(first), Point.new(second)

      reference_json = %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      multipoint.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPoint matching the json" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      result = MultiPoint.from_json %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPoint.new Point.new(first), Point.new(second)

      result.should eq reference
    end
  end

  describe "#==" do
    first_point = Point.new 10.0, 15.0
    second_point = Point.new 20.0, 25.0

    it "is true for the same object" do
      result = MultiPoint.new first_point, second_point

      result.should eq result
    end

    it "is true for a different MultiPoint with the same coordinates" do
      first = MultiPoint.new first_point, second_point

      second = MultiPoint.new first_point, second_point

      first.should eq second
    end

    it "is false for a different MultiPoint with different coordinates" do
      first = MultiPoint.new first_point, second_point

      second = MultiPoint.new second_point

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiPoint.new first_point, second_point

      second = "Something else"

      first.should_not eq second
    end
  end
end

describe MultiLineString do
  describe ".new" do
    it "creates a new multilinestring with the given points" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      linestring = LineString.new first, second

      multilinestring = MultiLineString.new linestring

      multilinestring[0].should eq LineString.new(Position.new(10.0, 15.0), Position.new(20.0, 25.0))
    end
  end

  describe "#type" do
    it %(returns "MultiLineString") do
      linestring = LineString.new Position.new(0, 0), Position.new(1, 0)

      multilinestring = MultiLineString.new linestring

      multilinestring.type.should eq "MultiLineString"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = LineStringCoordinates.new Position.new(0, 0), Position.new(0, 1)
      second = LineStringCoordinates.new Position.new(1, 0), Position.new(0, 1)

      multilinestring = MultiLineString.new LineString.new(first), LineString.new(second)

      reference_json = %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      multilinestring.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiLineString matching the json" do
      first = LineStringCoordinates.new Position.new(0, 0), Position.new(0, 1)
      second = LineStringCoordinates.new Position.new(1, 0), Position.new(0, 1)

      result = MultiLineString.from_json %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiLineString.new LineString.new(first), LineString.new(second)

      result.should eq reference
    end
  end

  describe "#==" do
    first_linestring = LineString.new Position.new(1, 2), Position.new(3, 2)
    second_linestring = LineString.new Position.new(1, 2), Position.new(1, 7)

    it "is true for the same object" do
      result = MultiLineString.new first_linestring, second_linestring

      result.should eq result
    end

    it "is true for a different MultiLineString with the same coordinates" do
      first = MultiLineString.new first_linestring, second_linestring

      second = MultiLineString.new first_linestring, second_linestring

      first.should eq second
    end

    it "is false for a different MultiLineString with different coordinates" do
      first = MultiLineString.new first_linestring, second_linestring

      second = MultiLineString.new second_linestring

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiLineString.new first_linestring, second_linestring

      second = "Something else"

      first.should_not eq second
    end
  end
end

describe MultiPolygon do
  describe ".new" do
    it "creates a new multipolygon with the given polygons" do
      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      polygon_one = Polygon.new first, second, third
      polygon_two = Polygon.new second, first, third

      multipolygon = MultiPolygon.new polygon_one, polygon_two

      multipolygon[0].should eq Polygon.new first, second, third
      multipolygon[1].should eq Polygon.new second, first, third
    end
  end

  describe "#type" do
    it %(returns "MultiPolygon") do
      polygon = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      multipolygon = MultiPolygon.new polygon

      multipolygon.type.should eq "MultiPolygon"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = PolyRings.new [Position.new(0, 0), Position.new(0, 1), Position.new(1, 0), Position.new(0, 0)]
      second = PolyRings.new [Position.new(0, 2), Position.new(0, 3), Position.new(1, 2), Position.new(0, 2)]

      multipolygon = MultiPolygon.new Polygon.new(first), Polygon.new(second)

      reference_json = %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      multipolygon.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPolygon matching the json" do
      first = PolyRings.new [Position.new(0, 0), Position.new(0, 1), Position.new(1, 0), Position.new(0, 0)]
      second = PolyRings.new [Position.new(0, 2), Position.new(0, 3), Position.new(1, 2), Position.new(0, 2)]

      result = MultiPolygon.from_json %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPolygon.new Polygon.new(first), Polygon.new(second)

      result.should eq reference
    end
  end

  describe "#==" do
    first_polygon = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)
    second_polygon = Polygon.new Position.new(0, 0), Position.new(2, 0), Position.new(0, 7)

    it "is true for the same object" do
      result = MultiPolygon.new first_polygon, second_polygon

      result.should eq result
    end

    it "is true for a different MultiPolygon with the same coordinates" do
      first = MultiPolygon.new first_polygon, second_polygon

      second = MultiPolygon.new first_polygon, second_polygon

      first.should eq second
    end

    it "is false for a different MultiPolygon with different coordinates" do
      first = MultiPolygon.new first_polygon, second_polygon

      second = MultiPolygon.new second_polygon

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiPolygon.new first_polygon, second_polygon

      second = "Something else"

      first.should_not eq second
    end
  end
end
