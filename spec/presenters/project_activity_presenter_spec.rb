RSpec.describe ProjectActivityPresenter do
  it "presents a project activity" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    FactoryBot.create(:project_activity, id: 111, activity: activity, order: 5, state: "not_started")

    presented = described_class.present(ProjectActivity.last)
    expect(presented).to eq(id: 111, name: "Activity name", state: "not_started")
  end

  it "orders by the order column" do
    FactoryBot.create(:project_activity, id: 111, order: 5)
    FactoryBot.create(:project_activity, id: 222, order: 6)
    FactoryBot.create(:project_activity, id: 333, order: 4)

    presented = described_class.present(ProjectActivity.all)
    expect(presented.map { |h| h.fetch(:id) }).to eq [333, 111, 222]
  end

  it "can present visible project activities only" do
    pa1  = FactoryBot.create(:project_activity, id: 111)
    _pa2 = FactoryBot.create(:project_activity, id: 222)

    visibility = FactoryBot.create(:visibility, subject: pa1)
    Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

    presented = described_class.present(ProjectActivity.all, visible: true)
    expect(presented.map { |h| h.fetch(:id) }).to eq [111]
  end

  it "can present with project questions" do
    project_activity = FactoryBot.create(:project_activity)
    question = FactoryBot.create(:question, text: "Question text")
    FactoryBot.create(:project_question, id: 555, subject: project_activity, question: question)

    presented = described_class.present(project_activity, project_questions: true)
    expect(presented).to include(project_questions: [{ id: 555, text: "Question text" }])
  end

  it "passes options through when presenting project questions" do
    project_activity = FactoryBot.create(:project_activity)
    question = FactoryBot.create(:question, text: "Question text")
    FactoryBot.create(:project_question, id: 555, subject: project_activity, question: question)

    presented = described_class.present(project_activity, project_questions: { by_topic: true })
    expect(presented.dig(:project_questions, :by_topic)).to be_present
  end
end
