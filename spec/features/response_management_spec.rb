RSpec.describe "Response management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", auth.merge(name: "Programme name", description: "Description")
    parsed_json.fetch(:id)
  end

  let(:project_type_id) do
    post "/project_types", auth.merge(name: "Project Type")
    parsed_json.fetch(:id)
  end

  let(:project_id) do
    post "/projects", auth.merge(programme_id: programme_id, project_type_id: project_type_id, name: "Project")
    parsed_json.fetch(:id)
  end

  let(:activity_id) do
    post "/activities", auth.merge(name: "Activity name"); parsed_json.fetch(:id)
  end

  let(:project_activity_id) do
    post "/project_activities", auth.merge(project_id: project_id, activity_id: activity_id, order: 1)
    parsed_json.fetch(:id)
  end

  let(:topic_id) do
    post "/topics", auth.merge(name: "Topic name"); parsed_json.fetch(:id)
  end

  let(:question_id) do
    post "/questions", auth.merge(
      topic_id: topic_id,
      type: "FreeTextQuestion",
      data_type: "string",
      text: "Question text",
      expected_length: 10,
    )
    parsed_json.fetch(:id)
  end

  let(:project_question_id) do
    post "/project_questions", auth.merge(
      project_activity_id: project_activity_id,
      question_id: question_id,
      order: 1,
    )
    parsed_json.fetch(:id)
  end

  let(:user_id) do
    post "/users", name: "User name"; parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage responses" do
    get "/responses", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/responses", auth.merge(
      project_question_id: project_question_id,
      user_id: user_id,
      value: "yes",
    )
    expect(response.status).to eq(201)

    post "/responses", auth.merge(
      project_question_id: project_question_id,
      user_id: user_id,
    )
    expect(response.status).to eq(422)
    expect(error_messages).to include("Value can't be blank")

    post "/responses", auth.merge(
      project_question_id: project_question_id,
      user_id: user_id,
      value: "no",
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/responses", auth
    expect(parsed_json.size).to eq(2)

    get "/responses", auth.merge(value: "no")
    expect(parsed_json.size).to eq(1)

    get "/responses/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "no")

    delete "/responses/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "no")

    get "/responses/#{id}", auth
    expect(response.status).to eq(404)

    delete "/responses/#{id}", auth
    expect(response.status).to eq(404)

    get "/responses", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(value: "yes"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/responses/#{id}", auth.merge(value: "pass")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "pass")

    put "/responses/#{id}", auth.merge(value: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Value can't be blank"]
  end
end