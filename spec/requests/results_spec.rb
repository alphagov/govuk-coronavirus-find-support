RSpec.describe "results" do
  describe "GET /results" do
    it "redirects to the session expired path if a user hasn't seen the last question" do
      get results_path
      expect(response).to redirect_to(session_expired_path)
    end
  end
end
