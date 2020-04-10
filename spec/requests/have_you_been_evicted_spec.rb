RSpec.describe "have-you-been-evicted" do
  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(have_you_been_evicted feel_safe))
  end

  describe "GET /have-you-been-evicted" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.options").sample }

    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get have_you_been_evicted_path

        expect(response).to redirect_to(controller: "need_help_with", action: "show")
      end
    end

    context "without session data" do
      it "shows the form" do
        visit have_you_been_evicted_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.title"))
        I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.options").each do |option|
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

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w(foo))
      end

      it "redirects to session expired" do
        get have_you_been_evicted_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /have-you-been-evicted" do
    let(:selected_option) { I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.options").sample }

    it "updates the session store" do
      post have_you_been_evicted_path, params: { have_you_been_evicted: selected_option }

      expect(session[:have_you_been_evicted]).to eq(selected_option)
    end

    it "redirects to the next question" do
      post have_you_been_evicted_path, params: { have_you_been_evicted: selected_option }

      expect(response).to redirect_to(controller: "feel_safe", action: "show")
    end

    it "shows an error when no radio button selected" do
      post have_you_been_evicted_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.custom_select_error"))
    end
  end
end
