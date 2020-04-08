RSpec.describe "afford-food" do
  describe "GET /afford-food" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.afford_food.options").sample }

    context "without session data" do
      it "shows the form" do
        visit afford_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.afford_food.title"))
        I18n.t("coronavirus_form.questions.afford_food.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(afford_food: selected_option)
      end

      it "shows the form with prefilled response" do
        visit afford_food_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.afford_food.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /afford-food" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.afford_food.options").sample }

    it "updates the session store" do
      post afford_food_path, params: { afford_food: selected_option }

      expect(session[:afford_food]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post afford_food_path, params: { afford_food: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    it "shows an error when no radio button selected" do
      post afford_food_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.afford_food.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.errors.radio_field", field: I18n.t("coronavirus_form.questions.afford_food.title").downcase))
    end
  end
end
