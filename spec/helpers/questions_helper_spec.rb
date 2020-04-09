RSpec.describe QuestionsHelper, type: :helper do
  before do
    allow(helper).to receive(:questions_to_ask).and_return(%w(question_1 question_2))
  end

  describe "#determine_user_questions" do
    it "returns questions in correct order" do
      groups = %i(paying_bills getting_food)
      expected_questions = %w(afford_rent_mortgage_bills afford_food get_food)

      expect(helper.determine_user_questions(groups)).to eq(expected_questions)
    end

    it "returns all questions when no groups selected" do
      groups = []
      all_questions = I18n.t("coronavirus_form.groups").map { |_, group| group[:questions].keys if group[:title] }.compact.flatten

      expect(helper.determine_user_questions(groups)).to eq(all_questions)
    end
  end

  describe "#next_question" do
    it "returns the next question key" do
      expect(helper.next_question("question_1")).to eq("question_2")
    end

    it "returns the final compulsory question for the final item" do
      expect(helper.next_question("question_2")).to eq("able_to_leave")
    end

    it "returns the first question for the need help with question" do
      expect(helper.next_question("need_help_with")).to eq("question_1")
    end
  end

  describe "#previous_question" do
    it "returns the previous question key" do
      expect(helper.previous_question("question_2")).to eq("question_1")
    end

    it "returns the filter question page key for the first item" do
      expect(helper.previous_question("question_1")).to eq("need_help_with")
    end

    it "returns the last question for the able to leave question" do
      expect(helper.previous_question("able_to_leave")).to eq("question_2")
    end
  end
end
