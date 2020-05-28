RSpec.describe "get-food" do
  let(:options) { I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[get_food feel_safe])
  end

  describe "GET /get-food" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get get_food_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit get_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
        I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options").each do |_, option|
          expect(page.body).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(get_food: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit get_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get get_food_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /get-food" do
    it "updates the session store" do
      post get_food_path, params: { get_food: selected_option_text }

      expect(session[:get_food]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post get_food_path, params: { get_food: selected_option_text }

      expect(response).to redirect_to(feel_safe_path)
    end

    it "shows an error when no radio button selected" do
      post get_food_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.custom_select_error"))
    end
  end
end
