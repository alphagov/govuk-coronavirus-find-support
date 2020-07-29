RSpec.describe "still-working" do
  let(:options) { I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options") }
  let(:selected_option) { options.keys.sample }
  let(:selected_option_text) { I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options.#{selected_option}.label") }

  before do
    allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[are_you_off_work_ill feel_safe])
  end

  describe "GET /still-working" do
    context "without any questions to ask in the session data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(nil)
      end

      it "redirects to filter question" do
        get are_you_off_work_ill_path

        expect(response).to redirect_to(need_help_with_path)
      end
    end

    context "without session data" do
      it "shows the form" do
        visit are_you_off_work_ill_path

        expect(page).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
        I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options").each do |_, option|
          expect(page).to have_content(option[:label])
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(are_you_off_work_ill: selected_option_text)
      end

      it "shows the form without prefilled response" do
        visit are_you_off_work_ill_path

        expect(page).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
        expect(page.find("input##{selected_option}")).not_to be_checked
      end
    end

    context "without this question in the sesion data" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[foo])
      end

      it "redirects to session expired" do
        get are_you_off_work_ill_path

        expect(response).to redirect_to session_expired_path
      end
    end
  end

  describe "POST /still-working" do
    it "updates the session store" do
      post are_you_off_work_ill_path, params: { are_you_off_work_ill: selected_option_text }

      expect(session[:are_you_off_work_ill]).to eq(selected_option_text)
    end

    it "redirects to the next question" do
      post are_you_off_work_ill_path, params: { are_you_off_work_ill: selected_option_text }

      expect(response).to redirect_to(feel_safe_path)
    end

    it "shows an error when no radio button selected" do
      post are_you_off_work_ill_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.custom_select_error"))
    end
  end
end
