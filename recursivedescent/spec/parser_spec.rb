# frozen_string_literal: true

require_relative '../parser'

shared_examples "a parser" do
  subject { described_class.new(lexer) }

  it "returns the expected result" do
    expect do
      subject.parse!

    end.not_to raise_error
  end
end

describe Parser do
  describe "#parse!" do
    let(:lexer) { instance_double(Lexer) }
    before do
      token_objects = tokens.map { |tok| Lexer::Symbol.new(tok, 'dummy') }
      allow(lexer).to receive(:all_tokens) { token_objects }
    end

    context "with simple numeric assignment" do
      let(:tokens) { [Lexer::Symbol::IDENT, Lexer::Symbol::ASSIGN, Lexer::Symbol::NUMERIC, Lexer::Symbol::EOF] }

      it_behaves_like "a parser"
    end

    context "with expression assignment" do
      let(:tokens) { [Lexer::Symbol::IDENT, Lexer::Symbol::ASSIGN, Lexer::Symbol::NUMERIC, Lexer::Symbol::PLUS, Lexer::Symbol::NUMERIC, Lexer::Symbol::EOF] }

      it_behaves_like "a parser"
    end

    context "with nested expression assignment" do
      let(:tokens) do
        [
          Lexer::Symbol::IDENT,
          Lexer::Symbol::ASSIGN,
          Lexer::Symbol::NUMERIC,
          Lexer::Symbol::MULTIPLY,
            Lexer::Symbol::LPAREN,
            Lexer::Symbol::NUMERIC,
            Lexer::Symbol::PLUS,
            Lexer::Symbol::NUMERIC,
            Lexer::Symbol::RPAREN,
          Lexer::Symbol::EOF
        ]
      end

      it_behaves_like "a parser"
    end
  end
end
