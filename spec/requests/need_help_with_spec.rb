RSpec.describe "need-help-with" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[get_food feel_safe])
    allow_any_instance_of(QuestionsHelper).to receive(:first_question_seen?).and_return(true)
  end

  describe "GET /need-help-with" do
    let(:selected) { [I18n.t("coronavirus_form.groups.feeling_unsafe.title")] }

    context "without session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:first_question_seen?).and_return(false)
      end

      # it "redirects to filter question" do
      #   get need_help_with_path

      #   expect(response).to redirect_to(need_help_with_path)
      # end
    end

    context "with session data" do
      before do
        page.set_rack_session(need_help_with: selected)
      end

      it "shows the form without prefilled response" do
        visit need_help_with_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
        expect(page.find("input#option_#{selected.first.parameterize.underscore}")).not_to be_checked
      end
    end
  end

  describe "POST /need-help-with" do
    let(:selected) { ["Being unemployed or not having any work"] }

    it "updates the session store" do
      post need_help_with_path, params: { need_help_with: selected }

      expected_questions = I18n.t("coronavirus_form.groups.being_unemployed.questions").stringify_keys.keys
      expected_groups = [:being_unemployed]

      expect(session[:need_help_with]).to eq(selected)
      expect(session[:selected_groups]).to eq(expected_groups)
      expect(session[:questions_to_ask]).to eq(expected_questions)
      expect(response).to redirect_to(get_food_path)
    end

    context "doesn't know what help they need" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[feel_safe get_food])
      end
      let(:selected) { ["I’m not sure"] }

      it "updates the session with all questions" do
        post need_help_with_path, params: { need_help_with: selected }

        all_questions = I18n.t("coronavirus_form.groups").map { |_, group| group[:questions].keys if group[:title] }.compact.flatten.map(&:to_s)

        expect(session[:need_help_with]).to eq(selected)
        expect(session[:selected_groups]).to be_empty
        expect(session[:questions_to_ask]).to eq(all_questions)

        expect(response).to redirect_to(feel_safe_path)
      end
    end

    it "redirects to the next question" do
      post need_help_with_path, params: { need_help_with: selected }

      expect(response).to redirect_to(get_food_path)
    end

    it "shows an error when no checkboxes are selected" do
      post need_help_with_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.custom_select_error"))
      expect(response).to render_template("need_help_with")
    end
  end
end
