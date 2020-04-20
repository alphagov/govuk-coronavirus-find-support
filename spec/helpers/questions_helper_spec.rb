RSpec.describe QuestionsHelper, type: :helper do
  before do
    allow(helper).to receive(:session_questions).and_return(%w(get_food afford_food))
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

      expect(helper.determine_user_questions(groups)).to eq(all_questions.map(&:to_s))
    end
  end

  describe "#next_question" do
    it "returns the next question key" do
      expect(helper.next_question("get_food")).to eq("afford_food")
    end

    it "returns the final compulsory question for the final item" do
      expect(helper.next_question("afford_food")).to eq("able_to_leave")
    end

    it "returns the first question for the need help with question" do
      expect(helper.next_question("need_help_with")).to eq("get_food")
    end
  end

  describe "#previous_question" do
    it "returns the previous question key" do
      expect(helper.previous_question("afford_food")).to eq("get_food")
    end

    it "returns the filter question page key for the first item" do
      expect(helper.previous_question("get_food")).to eq("need_help_with")
    end

    it "returns the last question for the able to leave question" do
      expect(helper.previous_question("able_to_leave")).to eq("afford_food")
    end
  end

  describe "#questions_to_ask" do
    it "returns questions to ask the user" do
      expect(helper.questions_to_ask).to eq(%w(get_food afford_food))
    end

    it "does not include a question that has been removed since the user made their selection" do
      allow(helper).to receive(:all_questions).and_return(%w(get_food))

      expect(helper.questions_to_ask).to eq(%w(get_food))
    end

    it "does not include a question that has been added since the user made their selection" do
      allow(helper).to receive(:all_questions).and_return(%w(get_food afford_food question_3))

      expect(helper.questions_to_ask).to eq(%w(get_food afford_food))
    end

    context "when the session questions_to_ask is equal to all_questions" do
      let(:all_questions) { %w(feel_safe afford_food) }

      before do
        allow(helper).to receive(:session_questions).and_return(all_questions)
        allow(helper).to receive(:all_questions).and_return(all_questions)
      end

      it "returns all_questions" do
        expect(helper.questions_to_ask).to eq(all_questions)
      end
    end
  end

  describe "#remove_questions" do
    it "removes all questions from array" do
      expect(helper.remove_questions(%w(get_food))).to eq(%w(afford_food))
    end
  end
end
