RSpec.describe "clear-session" do
  describe "GET /clear-session" do
    context "with session data" do
      before do
        post afford_food_path, params: { afford_food: "Yes" }
      end

      it "clears the session id" do
        initial_session_id = session["session_id"]
        get clear_session_path
        expect(session["session_id"]).to_not eq(initial_session_id)
      end

      it "clears responses held in the session" do
        expect(session["afford_food"]).to eq("Yes")
        get clear_session_path
        expect(session["afford_food"]).to be_nil
      end

      it "redirects the user to root" do
        get clear_session_path
        expect(response).to redirect_to("/")
      end
    end
  end
end
