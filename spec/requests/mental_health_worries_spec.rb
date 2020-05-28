RSpec.describe "mental-health-worries" do
  let(:options) { I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[mental_health_worries feel_safe])
  end

  describe "GET /mental-health-worries" do
    let(:selected) { ["Feeling unsafe"] }

    context "without user having answered the where do you live question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:first_question_seen?).and_return(false)
      end

      it "redirects to where do you live question" do
        get need_help_with_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get mental_health_worries_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit mental_health_worries_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
        I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options").each do |_, option|
          expect(page.body).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(mental_health_worries: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit mental_health_worries_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get mental_health_worries_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /mental-health-worries" do
    it "updates the session store" do
      post mental_health_worries_path, params: { mental_health_worries: selected_option_text }

      expect(session[:mental_health_worries]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post mental_health_worries_path, params: { mental_health_worries: selected_option_text }

      expect(response).to redirect_to(feel_safe_path)
    end

    it "shows an error when no radio button selected" do
      post mental_health_worries_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.custom_select_error"))
    end
  end
end
