RSpec.describe ProjectActivity do
  describe "validations" do
    subject(:project_activity) { FactoryBot.build(:project_activity) }

    it "has a valid default factory" do
      expect(project_activity).to be_valid
    end

    it "requires an order" do
      project_activity.order = nil
      expect(project_activity).to be_invalid
    end

    it "requires a natural number for order" do
      project_activity.order = 1.5
      expect(project_activity).to be_invalid

      project_activity.order = 0
      expect(project_activity).to be_invalid
    end
  end

  describe ".visible_to" do
    it "returns project_activities visible to the viewpoint" do
      pa1, _pa2 = FactoryBot.create_list(:project_activity, 2)
      visibility = FactoryBot.create(:visibility, subject: pa1)

      viewpoint = Viewpoint.new(users: visibility.visible_to)

      expect(ProjectActivity.visible_to(viewpoint)).to eq [pa1]
    end
  end

  describe ".with_visible_project_questions" do
    it "filters the scope of project_activities and project_questions" do
      pa1, _pa2 = FactoryBot.create(:project_activity)
      pq1, _pq2 = FactoryBot.create(:project_question, project_activity: pa1)
      visibility = FactoryBot.create(:visibility, subject: pq1)

      viewpoint = Viewpoint.new(users: visibility.visible_to)
      scope = ProjectActivity.with_visible_project_questions(viewpoint)

      expect(scope).to eq [pa1]
      expect(scope.flat_map(&:project_questions)).to eq [pq1]
    end
  end

  describe ".project_questions" do
    it "returns the project questions for the collection of project activities" do
      project_activity = FactoryBot.create(:project_activity)

      pq1  = FactoryBot.create(:project_question, project_activity: project_activity)
      _pq2 = FactoryBot.create(:project_question)

      scope = ProjectActivity.where(id: project_activity.id)
      expect(scope.project_questions).to eq [pq1]
    end
  end
end
