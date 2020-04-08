RSpec.describe "still-working" do
  describe "GET /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options").sample }

    context "without session data" do
      it "shows the form" do
        visit are_you_off_work_ill_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
        I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(are_you_off_work_ill: selected_option)
      end

      it "shows the form with prefilled response" do
        visit are_you_off_work_ill_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /still-working" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options").sample }

    it "updates the session store" do
      post are_you_off_work_ill_path, params: { are_you_off_work_ill: selected_option }

      expect(session[:are_you_off_work_ill]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post are_you_off_work_ill_path, params: { are_you_off_work_ill: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post are_you_off_work_ill_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.custom_select_error"))
    end
  end
end
