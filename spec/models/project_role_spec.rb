RSpec.describe ProjectRole do
  describe "validations" do
    subject(:project_role) { FactoryBot.build(:project_role) }

    it "has a valid default factory" do
      expect(project_role).to be_valid
    end

    it "requires a unique role per project" do
      existing = FactoryBot.create(:project_role)

      project_role.project = existing.project
      project_role.role = existing.role

      expect(project_role).to be_invalid
    end

    it "requires an order" do
      project_role.order = nil
      expect(project_role).to be_invalid
    end

    it "requires a natural number for order" do
      project_role.order = 1.5
      expect(project_role).to be_invalid

      project_role.order = 0
      expect(project_role).to be_invalid
    end
  end
end
