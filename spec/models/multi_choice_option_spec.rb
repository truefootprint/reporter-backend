RSpec.describe MultiChoiceOption do
  describe "validations" do
    subject(:multi_choice_option) { FactoryBot.build(:multi_choice_option) }

    it "has a valid default factory" do
      expect(multi_choice_option).to be_valid
    end

    it "requires text" do
      multi_choice_option.text = " "
      expect(multi_choice_option).to be_invalid
    end

    it "must be unique per question/text" do
      existing = FactoryBot.create(:multi_choice_option)

      multi_choice_option.text = existing.text
      expect(multi_choice_option).to be_valid

      multi_choice_option.question = existing.question
      expect(multi_choice_option).to be_invalid

      multi_choice_option.text = "Something else"
      expect(multi_choice_option).to be_valid
    end

    it "must belong to a multi-choice question" do
      question = FactoryBot.create(:free_text_question)

      expect { multi_choice_option.question = question }
        .to raise_error(ActiveRecord::AssociationTypeMismatch)

      multi_choice_option.question_id = question.id
      expect(multi_choice_option).to be_invalid

      expect(multi_choice_option.errors.full_messages).to include(
        "Can't belong to a FreeTextQuestion"
      )
    end

    it "requires an order" do
      multi_choice_option.order = nil
      expect(multi_choice_option).to be_invalid
    end

    it "requires a natural number for order" do
      multi_choice_option.order = 1.5
      expect(multi_choice_option).to be_invalid

      multi_choice_option.order = 0
      expect(multi_choice_option).to be_invalid
    end
  end
end
