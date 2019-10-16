RSpec.describe "Uploading documents" do
  let(:contract) { file_fixture("water-pump-contract.pdf") }
  let(:evidence) { file_fixture("water-pump-stolen.png") }

  let(:file1) { Rack::Test::UploadedFile.new(contract) }
  let(:file2) { Rack::Test::UploadedFile.new(evidence) }

  before do
    allow(BasicAuth).to receive(:enabled?).and_return(false)
  end

  scenario "provides API endpoints to upload documents" do
    get "/documents"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/documents", file: file1
    expect(response.status).to eq(201)

    post "/documents"
    expect(response.status).to eq(422)
    expect(error_messages).to include("File can't be blank")

    post "/documents", file: file2
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    # Filtering is not supported.

    get "/documents/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    delete "/documents/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    get "/documents/#{id}"
    expect(response.status).to eq(404)

    delete "/documents/#{id}"
    expect(response.status).to eq(404)

    get "/documents"
    expect(response.status).to eq(200)
    expect(parsed_json.size).to eq(1)
    expect(parsed_json.first.dig(:file, :url)).to include("contract.pdf")

    id = parsed_json.first.fetch(:id)

    put "/documents/#{id}", file: file2
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    put "/documents/#{id}", file: nil
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["File can't be blank"]
  end
end