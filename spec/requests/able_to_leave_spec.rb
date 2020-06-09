RSpec.describe "able-to-leave" do
  let(:options) { I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[afford_food able_to_leave feel_safe])
  end

  describe "GET /able-to-leave" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get able_to_leave_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit able_to_leave_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.title"))
        I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.options").each do |_, option|
          expect(page).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(able_to_leave: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit able_to_leave_path

        expect(page).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end
  end

  describe "POST /able-to-leave" do
    it "updates the session store" do
      post able_to_leave_path, params: { able_to_leave: selected_option_text }

      expect(session[:able_to_leave]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post able_to_leave_path, params: { able_to_leave: selected_option_text }

      expect(response).to redirect_to(feel_safe_path)
    end

    it "shows an error when no radio button selected" do
      post able_to_leave_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.custom_select_error"))
    end
  end
end
