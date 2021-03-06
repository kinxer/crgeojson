require "../spec_helper"

describe CoordinateTree do
  describe "::Root" do
    describe ".new" do
      it "creates a Root without children" do
        root = Root.new

        root.cloned_children.should eq [] of CoordinateTree
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        expect_raises(Exception, "Roots do not have leaf values!") do
          Root.new.leaf_value
        end
      end
    end

    describe "#each" do
      it "enumerates the children added to the Root" do
        root = Root.new
        branch = Branch.new root
        leaf = Leaf.new root, 3

        children = Array(CoordinateTree).new
        root.each { |child| children << child }

        children.should eq [branch, leaf]
      end
    end
  end

  describe "::Branch" do
    describe ".new" do
      it "creates a Branch with the given parent and without children" do
        parent = Root.new
        branch = Branch.new parent

        branch.cloned_children.should eq [] of CoordinateTree
      end

      it "adds the Branch to its parent" do
        parent = Root.new
        branch = Branch.new parent

        parent.cloned_children.should eq [branch]
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        expect_raises(Exception, "Branches do not have leaf values!") do
          Branch.new(Root.new).leaf_value
        end
      end
    end

    describe "#each" do
      it "enumerates the children added to the Branch" do
        parent = Root.new
        big_branch = Branch.new parent
        lil_branch = Branch.new big_branch
        leaf = Leaf.new big_branch, 5

        children = Array(CoordinateTree).new
        big_branch.each { |child| children << child }

        children.should eq [lil_branch, leaf]
      end
    end
  end

  describe "::Leaf" do
    describe ".new" do
      it "creates a Leaf with the given parent and leaf value" do
        parent = Root.new
        leaf = Leaf.new parent, 7.0

        leaf.leaf_value.should eq 7.0
      end

      it "adds the Leaf to its parent" do
        parent = Root.new
        leaf = Leaf.new parent, 11.0

        parent.cloned_children.should eq [leaf]
      end
    end

    describe "#leaf_value" do
      it "returns the leaf value given in the constructor" do # is this unnecessary repetition?
        leaf = Leaf.new Root.new, 13.0

        leaf.leaf_value.should eq 13.0
      end
    end

    describe "#each" do
      it "throws an error" do
        expect_raises(Exception, "Leaves have no children to enumerate!") do
          Leaf.new(Root.new, 19.0).each { |child| child }
        end
      end
    end
  end

  describe ".from_geojson" do
    it "deserializes just a root" do
      tree = CoordinateTree.new(JSON::PullParser.new "[]")

      tree.should eq Root.new
    end

    it "deserializes a root with leaves" do
      tree = CoordinateTree.new(JSON::PullParser.new "[23, 29]")

      root = Root.new
      leaf1 = Leaf.new root, 23
      leaf2 = Leaf.new root, 29

      tree.should eq root
    end

    it "deserializes a root with a single branch" do
      tree = CoordinateTree.new(JSON::PullParser.new "[[]]")

      root = Root.new
      branch = Branch.new root

      tree.should eq root
    end

    it "deserializes a root with multiple branches" do
      tree = CoordinateTree.new(JSON::PullParser.new "[[], []]")

      root = Root.new
      branch1 = Branch.new root
      branch2 = Branch.new root

      tree.should eq root
    end

    it "deserializes a root with branches and leaves" do
      tree = CoordinateTree.new(JSON::PullParser.new "[[31, 37], [41, 43]]")

      root = Root.new
      branch1 = Branch.new root
      leaf11 = Leaf.new branch1, 31
      leaf12 = Leaf.new branch1, 37
      branch2 = Branch.new root
      leaf21 = Leaf.new branch2, 41
      leaf22 = Leaf.new branch2, 43

      tree.should eq root
    end
  end
end
