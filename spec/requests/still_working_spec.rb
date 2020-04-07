RSpec.describe "still-working" do
  describe "GET /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.still_working.options").sample }

    context "without session data" do
      it "shows the form" do
        visit still_working_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.still_working.title"))
        I18n.t("coronavirus_form.questions.still_working.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(still_working: selected_option)
      end

      it "shows the form with prefilled response" do
        visit still_working_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.still_working.title"))
        expect(page.find("input##{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.still_working.options").sample }

    it "updates the session store" do
      post still_working_path, params: { still_working: selected_option }

      expect(session[:still_working]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post still_working_path, params: { still_working: selected_option }

      expect(response).to redirect_to(next_question_path)
    end
  end
end
