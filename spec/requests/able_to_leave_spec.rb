RSpec.describe "able-to-leave" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(able_to_leave feel_safe))
  end

  describe "GET /able-to-leave" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options").sample }

    context "without session data" do
      it "shows the form" do
        visit able_to_leave_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title"))
        I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(able_to_leave: selected_option)
      end

      it "shows the form with prefilled response" do
        visit able_to_leave_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /able-to-leave" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options").sample }

    it "updates the session store" do
      post able_to_leave_path, params: { able_to_leave: selected_option }

      expect(session[:able_to_leave]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post able_to_leave_path, params: { able_to_leave: selected_option }

      expect(response).to redirect_to(controller: "feel_safe", action: "show")
    end

    it "shows an error when no radio button selected" do
      post able_to_leave_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.errors.radio_field", field: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title").downcase))
    end
  end
end
