RSpec.describe "still-working" do
  describe "GET /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").sample }

    context "without session data" do
      it "shows the form" do
        visit still_working_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
        I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").each do |option|
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

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.options").sample }

    it "updates the session store" do
      post still_working_path, params: { still_working: selected_option }

      expect(session[:still_working]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post still_working_path, params: { still_working: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post still_working_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.custom_select_error"))
    end
  end
end
