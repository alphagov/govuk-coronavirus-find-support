RSpec.describe "need-help-with" do
  describe "GET /need-help-with" do
    let(:selected) { ["Feeling unsafe"] }

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

      expected_key = "being_unemployed".to_sym

      expect(session[:need_help_with]).to eq(selected)
      expect(session[:selected_groups]).to include(expected_key)
    end

    it "updates the session with an empty hash if the user selects I'm not sure" do
      selected = ["I’m not sure"]

      post need_help_with_path, params: { need_help_with: selected }

      expect(session[:need_help_with]).to eq(selected)
      expect(session[:selected_groups]).to be_empty
    end

    xit "redirects to the next question" do
      post need_help_with_path, params: { need_help_with: selected }

      expect(response).to redirect_to(next_question_path)
    end

    it "shows an error when no checkboxes are selected" do
      post need_help_with_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.custom_select_error"))
    end
  end
end
