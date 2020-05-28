RSpec.describe "self-employed" do
  let(:options) { I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[self_employed have_you_been_made_unemployed feel_safe])
  end

  describe "GET /self-employed" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get self_employed_path

        expect(response).to redirect_to(nation_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit self_employed_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.title"))
        I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options").each do |_, option|
          expect(page.body).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(self_employed: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit self_employed_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get self_employed_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /self-employed" do
    let(:positive_response) { I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.skip_next_question_options").sample }
    let(:negative_response) do
      (I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options").map { |_, option| option[:label] } -
        I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.skip_next_question_options")).sample
    end

    it "updates the session store" do
      post self_employed_path, params: { self_employed: positive_response }

      expect(session[:self_employed]).to eq(positive_response)
    end

    it "redirects to the next question for no response" do
      post self_employed_path, params: { self_employed: negative_response }

      expect(session[:questions_to_ask]).to eq(%w[self_employed have_you_been_made_unemployed are_you_off_work_ill feel_safe])
      expect(response).to redirect_to(have_you_been_made_unemployed_path)
    end

    it "removes irrelevant question for yes response" do
      post self_employed_path, params: { self_employed: positive_response }

      expect(session[:questions_to_ask]).to eq(%w[self_employed feel_safe])
    end

    it "shows an error when no radio button selected" do
      post self_employed_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.custom_select_error"))
    end
  end
end
