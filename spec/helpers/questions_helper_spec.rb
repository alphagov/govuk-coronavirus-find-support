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
  end

  describe "#next_question" do
    it "returns the next question key" do
      expect(helper.next_question("question_1")).to eq("question_2")
    end

    it "returns the results page key for the final item" do
      expect(helper.next_question("question_2")).to eq("results")
    end
  end

  describe "#previous_question" do
    it "returns the previous question key" do
      expect(helper.previous_question("question_2")).to eq("question_1")
    end

    it "returns the filter question page key for the first item" do
      expect(helper.previous_question("question_1")).to eq("need_help_with")
    end
  end
end
