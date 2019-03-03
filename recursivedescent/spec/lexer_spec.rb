# frozen_string_literal: true

require_relative '../lexer'

shared_examples "a lexer" do
  subject { described_class.new(body) }
  let(:tokens) { subject.all_tokens(include_eof: true) }

  it "returns the expected result" do
    expect(tokens).to eq(Array(expected))
  end
end

describe Lexer do
  describe Lexer::Symbol do
    describe "#==" do
      subject { described_class.new(described_class::NUMERIC, '1') }

      context "with symbol type" do
        it "returns true" do
          result = subject == described_class::NUMERIC

          expect(result).to be_truthy
        end
      end

      context "with object" do
        it "returns true" do
          result = subject == described_class.new(subject.type, subject.data)

          expect(result).to be_truthy
        end
      end
    end
  end

  describe "#next_token" do
    context "with empty" do
      let(:body) { '' }
      let(:expected) { Lexer::Symbol::EOF }
      it_behaves_like "a lexer"
    end

    context "with number" do
      let(:body) { '12345' }
      let(:expected) { [Lexer::Symbol.new(Lexer::Symbol::NUMERIC, body), Lexer::Symbol::EOF] }
      it_behaves_like "a lexer"
    end

    context "with literal" do
      let(:body) { '"hello world"' }
      let(:expected) { [Lexer::Symbol.new(Lexer::Symbol::LITERAL, body), Lexer::Symbol::EOF] }

      it_behaves_like "a lexer"
    end

    context "with identifier" do
      let(:body) { 'hello_world' }
      let(:expected) { [Lexer::Symbol.new(Lexer::Symbol::IDENT, body), Lexer::Symbol::EOF] }

      it_behaves_like "a lexer"
    end

    context "with basic arithmetic expression" do
      let(:body) { '1 + 2' }
      let(:expected) { [Lexer::Symbol::NUMERIC, Lexer::Symbol::PLUS, Lexer::Symbol::NUMERIC, Lexer::Symbol::EOF] }

      it_behaves_like "a lexer"
    end
  end
end
