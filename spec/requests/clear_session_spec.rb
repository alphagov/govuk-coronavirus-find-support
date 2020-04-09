RSpec.describe "clear-session" do
  let(:selected_no) { I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.options").last }

  describe "GET /clear-session" do
    context "with session data" do
      it "clears the session id" do
        post urgent_medical_help_path, params: { urgent_medical_help: selected_no }
        initial_session_id = session["session_id"]
        get clear_session_path
        expect(session["session_id"]).to_not eq(initial_session_id)
      end

      it "clears responses held in the session" do
        post urgent_medical_help_path, params: { urgent_medical_help: selected_no }
        expect(session[:urgent_medical_help]).to eq(selected_no)
        get clear_session_path
        expect(session[:have_you_been_made_unemployed]).to be_nil
      end

      it "redirects the user to root" do
        get clear_session_path
        expect(response).to redirect_to("/")
      end
    end
  end
end
