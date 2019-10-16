RSpec.describe Unit do
  describe "validations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "has a valid default factory" do
      expect(unit).to be_valid
    end

    it "requires a name" do
      unit.name = " "
      expect(unit).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:unit, name: "Name")

      unit.name = "name"
      expect(unit).to be_invalid
    end

    it "requires a known type" do
      unit.type = "unknown"
      expect(unit).to be_invalid
    end
  end
end