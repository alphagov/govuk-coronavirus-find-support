RSpec.describe "have-you-been-evicted" do
  describe "GET /have-you-been-evicted" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.have_you_been_evicted.options").sample }

    context "without session data" do
      it "shows the form" do
        visit have_you_been_evicted_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.have_you_been_evicted.title"))
        I18n.t("coronavirus_form.questions.have_you_been_evicted.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(have_you_been_evicted: selected_option)
      end

      it "shows the form with prefilled response" do
        visit have_you_been_evicted_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.have_you_been_evicted.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /have-you-been-evicted" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.have_you_been_evicted.options").sample }

    it "updates the session store" do
      post have_you_been_evicted_path, params: { have_you_been_evicted: selected_option }

      expect(session[:have_you_been_evicted]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post have_you_been_evicted_path, params: { have_you_been_evicted: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post have_you_been_evicted_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.have_you_been_evicted.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.have_you_been_evicted.custom_select_error"))
    end
  end
end
