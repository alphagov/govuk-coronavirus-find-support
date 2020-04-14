RSpec.describe "get-food" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(get_food feel_safe))
  end

  describe "GET /get-food" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options").sample }

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get get_food_path

        expect(response).to redirect_to(controller: "need_help_with", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit get_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
        I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(get_food: selected_option)
      end

      it "shows the form without prefilled response" do
        visit get_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(foo))
      end

      it "redirects to session expired" do
        get get_food_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /get-food" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options").sample }

    it "updates the session store" do
      post get_food_path, params: { get_food: selected_option }

      expect(session[:get_food]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post get_food_path, params: { get_food: selected_option }

      expect(response).to redirect_to(controller: "feel_safe", action: "show")
    end

    it "shows an error when no radio button selected" do
      post get_food_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.custom_select_error"))
    end
  end
end
