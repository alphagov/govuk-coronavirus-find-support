RSpec.describe "still-working" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(still_working feel_safe))
  end

  describe "GET /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").sample }

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get still_working_path

        expect(response).to redirect_to(controller: "need_help_with", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit still_working_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
        I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(still_working: selected_option)
      end

      it "shows the form with prefilled response" do
        visit still_working_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").sample }

    it "updates the session store" do
      post still_working_path, params: { still_working: selected_option }

      expect(session[:still_working]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post still_working_path, params: { still_working: selected_option }

      expect(response).to redirect_to(controller: "feel_safe", action: "show")
    end

    xit "shows an error when no radio button selected" do
      post still_working_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.custom_select_error"))
    end
  end
end
