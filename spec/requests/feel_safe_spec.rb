RSpec.describe "feel-safe" do
  let(:options) { I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[feel_safe get_food])
  end

  describe "GET /feel-safe" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get feel_safe_path

        expect(response).to redirect_to(need_help_with_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit feel_safe_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
        I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options").each do |_, option|
          expect(page.body).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(feel_safe: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit feel_safe_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get feel_safe_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /feel-safe" do
    it "updates the session store" do
      post feel_safe_path, params: { feel_safe: selected_option_text }

      expect(session[:feel_safe]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post feel_safe_path, params: { feel_safe: selected_option_text }

      expect(response).to redirect_to(get_food_path)
    end

    it "shows an error when no radio button selected" do
      post feel_safe_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.custom_select_error"))
    end
  end
end
