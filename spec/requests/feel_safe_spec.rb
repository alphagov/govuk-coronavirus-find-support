RSpec.describe "feel-safe" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(feel_safe get_food))
  end

  describe "GET /feel-safe" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options").sample }

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get feel_safe_path

        expect(response).to redirect_to(controller: "need_help_with", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit feel_safe_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
        I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(feel_safe: selected_option)
      end

      it "shows the form with prefilled response" do
        visit feel_safe_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /feel-safe" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options").sample }

    it "updates the session store" do
      post feel_safe_path, params: { feel_safe: selected_option }

      expect(session[:feel_safe]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post feel_safe_path, params: { feel_safe: selected_option }

      expect(response).to redirect_to(controller: "get_food", action: "show")
    end

    it "shows an error when no radio button selected" do
      post feel_safe_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.errors.radio_field", field: I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title").downcase))
    end
  end
end
