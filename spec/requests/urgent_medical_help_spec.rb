RSpec.describe "urgent-medical-help" do
  let(:selected_yes) { I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").first }
  let(:selected_no) { I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").last }

  describe "GET /urgent-medical-help" do
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
        page.set_rack_session(urgent_medical_help: selected_no)
      end

      it "shows the form with prefilled response" do
        visit urgent_medical_help_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))
        expect(page.find("input#option_#{selected_no.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    it "updates the session store" do
      post urgent_medical_help_path, params: { urgent_medical_help: selected_no }

      expect(session[:urgent_medical_help]).to eq(selected_no)
    end

    it "redirects to the next question for a no response" do
      post urgent_medical_help_path, params: { urgent_medical_help: selected_no }

      expect(response).to redirect_to(need_help_with_path)
    end

    it "redirects to the next question for a yes response" do
      post urgent_medical_help_path, params: { urgent_medical_help: selected_yes }

      expect(response).to redirect_to(get_help_from_nhs_path)
    end

    it "shows an error when no radio button selected" do
      post urgent_medical_help_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.custom_select_error"))
    end
  end
end
