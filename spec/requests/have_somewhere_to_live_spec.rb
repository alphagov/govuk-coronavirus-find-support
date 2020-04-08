RSpec.describe "have-somewhere-to-live" do
  describe "GET /have-somewhere-to-live" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.options").sample }

    context "without session data" do
      it "shows the form" do
        visit have_somewhere_to_live_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.title"))
        I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(have_somewhere_to_live: selected_option)
      end

      it "shows the form with prefilled response" do
        visit have_somewhere_to_live_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /have-somewhere-to-live" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.options").sample }

    it "updates the session store" do
      post have_somewhere_to_live_path, params: { have_somewhere_to_live: selected_option }

      expect(session[:have_somewhere_to_live]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post have_somewhere_to_live_path, params: { have_somewhere_to_live: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post have_somewhere_to_live_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.custom_select_error"))
    end
  end
end
