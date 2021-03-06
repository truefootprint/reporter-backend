RSpec.describe DataTypeParser do
  specify { expect(described_class.parse("hello", "string")).to eq("hello") }

  specify { expect(described_class.parse("123", "number")).to eq(123) }
  specify { expect(described_class.parse("123.4", "number")).to eq(123.4) }

  specify { expect(described_class.parse("true", "boolean")).to eq(true) }
  specify { expect(described_class.parse("Y", "boolean")).to eq(true) }
  specify { expect(described_class.parse("yes", "boolean")).to eq(true) }
  specify { expect(described_class.parse("Pass", "boolean")).to eq(true) }

  specify { expect(described_class.parse("false", "boolean")).to eq(false) }
  specify { expect(described_class.parse("N", "boolean")).to eq(false) }
  specify { expect(described_class.parse("no", "boolean")).to eq(false) }
  specify { expect(described_class.parse("Fail", "boolean")).to eq(false) }

  it "raises an error if it doesn't know how to parse the data type" do
    expect { described_class.parse("hello", "unknown") }
      .to raise_error(ArgumentError, /unknown data type/i)
  end

  describe ".parse_response" do
    it "parses the response's value based on the question's data type" do
      q = FactoryBot.create(:question, data_type: "boolean")
      pq = FactoryBot.create(:project_question, question: q)
      r = FactoryBot.create(:response, project_question: pq, value: "yes")

      expect(described_class.parse_response(r)).to eq(true)
    end

    describe "when the response is for a photo upload question" do
      let(:question) { FactoryBot.create(:question, data_type: "photo") }
      let(:project_question) { FactoryBot.create(:project_question, question: question) }
      let(:response) { FactoryBot.create(:response, project_question: project_question, photos: [attachment]) }

      def attachment
        { io: file_fixture("water-pump-working.png").open, filename: "upload.png" }
      end

      it "returns the response's photos" do
        expect(described_class.parse_response(response)).to eq(response.photos)
      end
    end
  end
end
