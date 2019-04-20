# frozen_string_literal: true

require_relative '../json'

shared_examples_for "a json parser" do
  it "returns the expected result" do
    result = described_class.parse(body)

    expect(result).to eq(expected_result)
  end
end

describe JSON do
  describe ".parse" do
    context "with empty object" do
      let(:body) { "{}" }
      let(:expected_result) { {} }
      it_behaves_like "a json parser"
    end
    context "with empty array" do
      let(:body) { "[]" }
      let(:expected_result) { [] }
      it_behaves_like "a json parser"
    end

    context "with simple array" do
      let(:body) { "[1,2,3,4,5]" }
      let(:expected_result) { [1,2,3,4,5] }
      it_behaves_like "a json parser"
    end

    context "with simple object" do
      let(:body) { "{a: 25}" }
      let(:expected_result) { { 'a' => 25 } }
      it_behaves_like "a json parser"
    end

    context "with nested object" do
      let(:body) { "{a: {b: 25}}" }
      let(:expected_result) { { 'a' => {'b' => 25}} }
      it_behaves_like "a json parser"
    end

    context "with nested array" do
      let(:body) { "[1,2,[3, 4], [5]]" }
      let(:expected_result) { [1,2,[3,4],[5]] }
      it_behaves_like "a json parser"
    end

    context "with boolean values" do
      let(:body) { "{a: false, b: true}" }
      let(:expected_result) { { 'a' => false, 'b' => true } }
      it_behaves_like "a json parser"
    end

    context "with array of strings" do
      let(:body) { '["hello", "world"]' }
      let(:expected_result) { ['hello', 'world'] }
      it_behaves_like "a json parser"
    end
  end
end
