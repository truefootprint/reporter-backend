RSpec.describe DefaultActivity do
  describe "validations" do
    subject(:default_activity) { FactoryBot.build(:default_activity) }

    it "has a valid default factory" do
      expect(default_activity).to be_valid
    end

    it "requires an order" do
      default_activity.order = nil
      expect(default_activity).to be_invalid
    end

    it "requires a natural number for order" do
      default_activity.order = 1.5
      expect(default_activity).to be_invalid

      default_activity.order = 0
      expect(default_activity).to be_invalid
    end
  end
end
