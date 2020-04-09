RSpec.describe "need-help-with" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(get_food feel_safe))
    allow_any_instance_of(QuestionsHelper).to receive(:first_question_seen?).and_return(true)
  end

  describe "GET /need-help-with" do
    let(:selected) { ["Feeling unsafe"] }

    context "without user having answered urgent medical help question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:first_question_seen?).and_return(false)
      end

      it "redirects to urgent medical help question" do
        get need_help_with_path

        expect(response).to redirect_to(controller: "urgent_medical_help", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit need_help_with_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
        I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(need_help_with: selected)
      end

      it "shows the form with prefilled response" do
        visit need_help_with_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
        expect(page.find("input#option_#{selected.first.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /need-help-with" do
    let(:selected) { ["Being unemployed or not having any work"] }

    it "updates the session store" do
      post need_help_with_path, params: { need_help_with: selected }

      expected_questions = I18n.t("coronavirus_form.groups.being_unemployed.questions").stringify_keys.keys

      expect(session[:need_help_with]).to eq(selected)
      expect(session[:questions_to_ask]).to eq(expected_questions)
    end

    it "updates the session with all questions if the user selects I'm not sure" do
      selected = ["I’m not sure"]

      post need_help_with_path, params: { need_help_with: selected }

      all_questions = I18n.t("coronavirus_form.groups").map { |_, group| group[:questions].keys if group[:title] }.compact.flatten

      expect(session[:need_help_with]).to eq(selected)
      expect(session[:questions_to_ask]).to eq(all_questions)
    end

    it "redirects to the next question" do
      post need_help_with_path, params: { need_help_with: selected }

      expect(response).to redirect_to(get_food_path)
    end

    it "shows an error when no checkboxes are selected" do
      post need_help_with_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.custom_select_error"))
    end
  end
end
