RSpec.describe "clear-session" do
  let(:selected_feeling_unsafe) { [I18n.t("coronavirus_form.groups.feeling_unsafe.title")] }

  describe "GET /clear-session" do
    context "without a redirect parameter" do
      context "with session data" do
        it "clears the session id" do
          post need_help_with_path, params: { need_help_with: selected_feeling_unsafe }
          initial_session_id = session["session_id"]
          get clear_session_path
          expect(session["session_id"]).to_not eq(initial_session_id)
        end

        it "clears responses held in the session" do
          post need_help_with_path, params: { need_help_with: selected_feeling_unsafe }
          expect(session[:need_help_with]).to eq(selected_feeling_unsafe)
          get clear_session_path
          expect(session[:have_you_been_made_unemployed]).to be_nil
        end

        it "redirects the user to root" do
          get clear_session_path
          expect(response).to redirect_to("/")
        end
      end
    end

    context "with an external redirect parameter" do
      it "clears the session id" do
        post need_help_with_path, params: { need_help_with: selected_feeling_unsafe }
        initial_session_id = session["session_id"]
        get clear_session_path, params: { ext_r: true }
        expect(session["session_id"]).to_not eq(initial_session_id)
      end

      it "clears responses held in the session" do
        post need_help_with_path, params: { need_help_with: selected_feeling_unsafe }
        expect(session[:need_help_with]).to eq(selected_feeling_unsafe)
        get clear_session_path, params: { ext_r: true }
        expect(session[:have_you_been_made_unemployed]).to be_nil
      end

      it "redirects the user to an external website" do
        get clear_session_path, params: { ext_r: true }
        expect(response).to redirect_to(I18n.t("leave_this_website.link_redirect_to"))
      end
    end
  end
end
