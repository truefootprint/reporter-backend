RSpec.describe CreateOrUpdate do
  include described_class

  let(:attributes) { FactoryBot.attributes_for(:user, id: 1, name: "new name") }

  it "creates a record if it doesn't exist" do
    expect { create_or_update!(User, where: { id: 1 }, attributes: attributes) }
      .to change(User, :count).by(1)

    user = User.last

    expect(user.id).to eq(1)
    expect(user.name).to eq("new name")
  end

  it "updates a record if it exists" do
    user = FactoryBot.create(:user, id: 1, name: "old name")

    expect { create_or_update!(User, where: { id: 1 }, attributes: attributes) }
      .not_to change(User, :count)

    expect(user.reload.name).to eq("new name")
  end

  it "does not update created_at if it exists" do
    user = FactoryBot.create(:user, id: 1, name: "old name", created_at: "2020-01-01")

    expect { create_or_update!(User, where: { id: 1 }, attributes: attributes) }
      .not_to change { user.reload.created_at }
  end

  it "does not update updated_at if none of the attributes have changed" do
    user = FactoryBot.create(:user, id: 1, name: "old name", updated_at: "2020-01-01")

    expect { create_or_update!(User, where: { id: 1 }, attributes: { name: "old name" }) }
      .not_to change { user.reload.updated_at }
  end

  it "only updates the first record it finds" do
    user1 = FactoryBot.create(:user, name: "name")
    user2 = FactoryBot.create(:user, name: "name")

    create_or_update!(User, where: { name: "name" }, attributes: { name: "new name" })

    expect(user1.reload.name).to eq("new name")
    expect(user2.reload.name).to eq("name")
  end

  it "errors if the attributes are invalid" do
    expect { create_or_update!(User, where: { id: 1 }, attributes: { name: nil }) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end
end
