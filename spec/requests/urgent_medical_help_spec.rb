RSpec.describe "urgent-medical-help" do
  describe "GET /urgent-medical-help" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").sample }

    context "without session data" do
      it "shows the form" do
        visit urgent_medical_help_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))
        I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(urgent_medical_help: selected_option)
      end

      it "shows the form with prefilled response" do
        visit urgent_medical_help_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").sample }

    it "updates the session store" do
      post urgent_medical_help_path, params: { urgent_medical_help: selected_option }

      expect(session[:urgent_medical_help]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post urgent_medical_help_path, params: { urgent_medical_help: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post urgent_medical_help_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.custom_select_error"))
    end
  end
end
