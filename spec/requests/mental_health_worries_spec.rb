RSpec.describe "mental-health-worries" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(mental_health_worries feel_safe))
  end

  describe "GET /mental-health-worries" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options").sample }

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get mental_health_worries_path

        expect(response).to redirect_to(controller: "need_help_with", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit mental_health_worries_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
        I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(mental_health_worries: selected_option)
      end

      it "shows the form with prefilled response" do
        visit mental_health_worries_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(foo))
      end

      it "redirects to session expired" do
        get mental_health_worries_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /mental-health-worries" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options").sample }

    it "updates the session store" do
      post mental_health_worries_path, params: { mental_health_worries: selected_option }

      expect(session[:mental_health_worries]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post mental_health_worries_path, params: { mental_health_worries: selected_option }

      expect(response).to redirect_to(controller: "feel_safe", action: "show")
    end

    it "shows an error when no radio button selected" do
      post mental_health_worries_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.custom_select_error"))
    end
  end
end
