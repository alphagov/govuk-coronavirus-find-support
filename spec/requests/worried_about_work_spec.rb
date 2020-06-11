RSpec.describe "worried-about-work" do
  let(:options) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[worried_about_work feel_safe])
  end

  describe "GET /worried-about-work" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get worried_about_work_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit worried_about_work_path

        expect(page).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.title"))
        I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options").each do |_, option|
          expect(page).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(worried_about_work: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit worried_about_work_path

        expect(page).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get worried_about_work_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /worried-about-work" do
    it "updates the session store" do
      post worried_about_work_path, params: { worried_about_work: selected_option_text }

      expect(session[:worried_about_work]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post worried_about_work_path, params: { worried_about_work: selected_option_text }

      expect(response).to redirect_to(feel_safe_path)
    end

    it "shows an error when no radio button selected" do
      post worried_about_work_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.custom_select_error"))
    end

    context "when this is the last question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[worried_about_work])
      end

      it "redirects to the results url" do
        post worried_about_work_path, params: { worried_about_work: selected_option_text }

        expect(response).to redirect_to(results_path)
      end
    end
  end
end
