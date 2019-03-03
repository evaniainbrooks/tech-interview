# frozen_string_literal: true

require_relative '../binary_tree'

describe BinaryTree do
  describe "#valid?" do
    context "with a simple invalid tree" do
      subject do
        left = BinaryTree.root_node(50)
        right = BinaryTree.root_node(500)
        BinaryTree.new(left, right, 5)
      end

      it { is_expected.not_to be_valid }
    end

    context "with a simple valid tree" do
      subject do
        left = BinaryTree.root_node(5)
        right = BinaryTree.root_node(500)
        BinaryTree.new(left, right, 50)
      end

      it { is_expected.to be_valid }
    end

    context "with a complex invalid tree" do
      #     100
      #  80     800
      #20 200  500 1000
      subject do
        left = BinaryTree.root_node(20)
        right = BinaryTree.root_node(200)
        left_subtree = BinaryTree.new(left, right, 80)

        left = BinaryTree.root_node(500)
        right = BinaryTree.root_node(1000)
        right_subtree = BinaryTree.new(left, right, 800)

        BinaryTree.new(left_subtree, right_subtree, 100)
      end

      it { is_expected.not_to be_valid }
    end

    context "with a complex valid tree" do
      #     100
      #  80      800
      #20 90   500 1000
      subject do
        left = BinaryTree.root_node(20)
        right = BinaryTree.root_node(90)
        left_subtree = BinaryTree.new(left, right, 80)

        left = BinaryTree.root_node(500)
        right = BinaryTree.root_node(1000)
        right_subtree = BinaryTree.new(left, right, 800)

        BinaryTree.new(left_subtree, right_subtree, 100)
      end

      it { is_expected.to be_valid }
    end

    context "with only a root node" do
      subject { BinaryTree.root_node(100) }

      it { is_expected.to be_valid }
    end
  end
end
