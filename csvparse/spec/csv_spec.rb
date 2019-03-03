require_relative '../csv'

shared_examples "a csv parser" do
  subject { described_class.parse(body, delimiter, quote_char) }

  it "returns the expected result" do
    expect(subject).to eq(expected_result)
  end
end

describe CSV do
  describe '.parse' do
    let(:instance) { instance_double(CSV) }
    let(:body) { 'something' }
    before { allow(CSV).to receive(:new) { instance } }

    it 'creates a new instance of CSV and calls parse!' do
      expect(instance).to receive(:parse!).once

      described_class.parse(body)
    end
  end

  describe "#parse!" do
    let(:delimiter) { CSV::DEFAULT_DELIMITER }
    let(:quote_char) { CSV::DEFAULT_QUOTE_CHAR }

    context "with unquoted row" do
      let(:body) { "a,b,c\nd,e,f" }
      let(:expected_result ) { [["a", "b", "c"], ["d", "e", "f"]] }

      it_behaves_like "a csv parser"
    end

    context "with quoted row" do
      let(:body) { "\"a\",\"b\",\"c\"\n\"d\",\"e\",\"f\"" }
      let(:expected_result) { [["a", "b", "c"], ["d", "e", "f"]] }

      it_behaves_like "a csv parser"
    end

    context "with mixed quoted/unquoted row" do
      let(:body) { "\"a\",b,\"c\"\nd,\"e\",f" }
      let(:expected_result) { [["a", "b", "c"], ["d", "e", "f"]] }

      it_behaves_like "a csv parser"
    end

    context "with newline in quoted column" do
      let(:body) { "\"a\",b,\"c\"\nd,\"e\nnewlineinside\",f" }
      let(:expected_result) { [["a", "b", "c"], ["d", "e\nnewlineinside", "f"]] }

      it_behaves_like "a csv parser"
    end

    context "with tab as delimiter" do
      let(:delimiter)  { "\t" }
      let(:body) { "each\tword\tis\ta\tnew\tcolumn" }
      let(:expected_result) { [["each", "word", "is", "a", "new", "column"]] }

      it_behaves_like "a csv parser"
    end

    context "with quoted tab as delimiter" do
      let(:delimiter)  { "\t" }
      let(:quote_char) { "|" }
      let(:body) { "|the '\t' won't create new columns because it was|\tin\tquotes" }
      let(:expected_result) { [["the '\t' won't create new columns because it was", "in", "quotes"]] }

      it_behaves_like "a csv parser"
    end

    context "with alternative quote" do
      let(:delimiter)  { "\t" }
      let(:quote_char) { "|" }
      let(:body) { "|alternate|\t|\"quote\"|\n\n|character|\t|hint: |||" }
      let(:expected_result) { [["alternate", "\"quote\""], [""], ["character", "hint: |"]] }

      it_behaves_like "a csv parser"
    end
  end
end
