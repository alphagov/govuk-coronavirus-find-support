RSpec.describe "afford-rent-mortgage-bills" do
  describe "GET /afford-rent-mortgage-bills" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.options").sample }

    context "without session data" do
      it "shows the form" do
        visit afford_rent_mortgage_bills_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.title"))
        I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(afford_rent_mortgage_bills: selected_option)
      end

      it "shows the form with prefilled response" do
        visit afford_rent_mortgage_bills_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /afford-rent-mortgage-bills" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.options").sample }

    it "updates the session store" do
      post afford_rent_mortgage_bills_path, params: { afford_rent_mortgage_bills: selected_option }

      expect(session[:afford_rent_mortgage_bills]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post afford_rent_mortgage_bills_path, params: { afford_rent_mortgage_bills: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post afford_rent_mortgage_bills_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.afford_rent_mortgage_bills.custom_select_error"))
    end
  end
end
