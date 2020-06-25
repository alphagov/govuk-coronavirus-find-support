require "spec_helper"

RSpec.describe WriteResponsesHelper, type: :helper do
  before do
    Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
  end

  after do
    Timecop.return
  end

  describe "#write_responses" do
    context "if able to leave is the last question" do
      it "saves the form responses to the database" do
        session[:able_to_leave] = "Yes"
        session[:questions_to_ask] = %w[get_food able_to_leave]

        expect(helper.write_responses.form_response).to eq({ "able_to_leave" => "Yes", "questions_to_ask" => %w[get_food able_to_leave] })
        expect(helper.write_responses.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
      end

      it "does not save the form response to the database when the SMOKE_TEST header is present" do
        allow_any_instance_of(WriteResponsesHelper).to receive(:smoke_tester?).and_return(true)
        session[:questions_to_ask] = %w[get_food able_to_leave]
        before_count = FormResponse.count
        helper.write_responses

        expect(FormResponse.count).to eq(before_count)
      end

      it "does not save the session id or csrf token to the database" do
        session[:questions_to_ask] = %w[get_food able_to_leave]

        expect(helper.write_responses.form_response["session_id"]).to be_nil
        expect(helper.write_responses.form_response["_csrf_token"]).to be_nil
      end
    end
  end
end
