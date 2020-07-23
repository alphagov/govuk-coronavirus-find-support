require "spec_helper"

RSpec.describe WriteResponsesHelper, type: :helper do
  before do
    Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
  end

  after do
    Timecop.return
  end

  describe "#write_responses" do
    context "if the last question" do
      let(:questions_to_ask) { %w[afford_food get_food] }
      subject(:write_responses) { helper.write_responses }

      it "saves the session data to the database" do
        session[:foo] = "bar"
        session[:questions_to_ask] = questions_to_ask

        expect { write_responses }.to(change { FormResponse.count })
        expect(write_responses.form_response).to eq({ "foo" => "bar", "questions_to_ask" => questions_to_ask })
        expect(write_responses.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
      end

      it "does not save the form response to the database when the SMOKE_TEST header is present" do
        allow_any_instance_of(WriteResponsesHelper).to receive(:smoke_tester?).and_return(true)
        session[:questions_to_ask] = questions_to_ask

        expect { write_responses }.not_to(change { FormResponse.count })
      end

      it "does not save the session id or csrf token to the database" do
        session[:questions_to_ask] = questions_to_ask
        session[:session_id] = SecureRandom.uuid
        session["_csrf_token"] = SecureRandom.uuid

        expect(write_responses.form_response["session_id"]).to be_nil
        expect(write_responses.form_response["_csrf_token"]).to be_nil
      end
    end
  end
end
