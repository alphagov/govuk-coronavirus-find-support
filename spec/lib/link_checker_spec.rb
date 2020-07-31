require "./lib/link_checker"
require "gds_api/test_helpers/link_checker_api"

RSpec.describe LinkChecker do
  include GdsApi::TestHelpers::LinkCheckerApi

  let(:http_url) { "http://example.com" }
  let(:https_url) { "https://example.com" }
  let(:urls) { Set[http_url, https_url] }
  let(:data_string) { "this #{http_url} and this #{https_url}" }
  let(:data) { data_string }
  subject { described_class.new(data) }

  describe "#urls" do
    it "returns the url" do
      expect(subject.urls).to eq(urls)
    end

    context "when the data is an array" do
      let(:data) { [data_string] }

      it "returns the url" do
        expect(subject.urls).to eq(urls)
      end
    end

    context "when the data is a hash" do
      let(:data) { { label: data_string } }

      it "returns the url" do
        expect(subject.urls).to eq(urls)
      end
    end

    context "when the data is a deeper structure" do
      let(:data) do
        {
          firstHash: [
            "I've hidden several urls https://www.example.com here",
            [
              "I've hidden https://example.gov.uk here",
              "I've hidden https://www.example.com here",
              "Nothing hidden here",
              { "anotherHash" => "this string here is another http://www.banana.com in this string" },
            ],
            {
              secondHash: "the second member also has an url https://extrahelp.co.uk woah",
              thirdHash: "the second member also has an url http://terror.com",
            },
          ],
        }
      end

      it "should search recursively for urls in hashes/arrays" do
        expect(subject.urls).to eq(Set[
                                       "https://www.example.com",
                                       "http://www.banana.com",
                                       "https://extrahelp.co.uk",
                                       "https://example.gov.uk",
                                       "http://terror.com",
                                   ])
      end
    end
  end

  describe "#report" do
    def expect_side_effects
      expect(GdsApi::LinkCheckerApi).to receive(:new).with(
        Plek.current.find("link-checker-api"), bearer_token: "test_token"
      ).and_call_original

      # Setup stubs/mocks as they are needed for the expectation above
      expect(ENV).to receive(:[]).with("LINK_CHECKER_API_BEARER_TOKEN").and_return("test_token").once
      allow(ENV).to receive(:[]).with(anything)
    end

    it "if batch is immediately complete it should not call get batch or sleep" do
      expect_side_effects

      stub_link_checker_api_create_batch(
        uris: urls, checked_within: 5, status: :complete,
      )

      expect(subject).to_not receive(:sleep).with(3)
      subject.report
    end

    it "should call check_batch if batch is not immediately complete" do
      expect_side_effects
      stub_link_checker_api_create_batch(
        uris: urls, checked_within: 5, status: :in_progress,
      )
      stub_link_checker_api_get_batch(
        id: 0, status: :completed,
      )
      expect(subject).to_not receive(:sleep).with(3)

      subject.report
    end

    def build_batch_response(status)
      {
        body: link_checker_api_batch_report_hash(id: 0, status: status).to_json,
        status: 200,
        headers: { "Content-Type" => "application/json" },
      }
    end

    it "if batch is not complete after checking, it should recheck after sleeping" do
      expect_side_effects

      stub_link_checker_api_create_batch(
        uris: urls, checked_within: 5, status: :in_progress,
      )

      stub = stub_link_checker_api_get_batch(
        id: 0, status: :in_progress,
      )

      expect(subject).to receive(:sleep).with(3).exactly(5).times

      4.times do
        stub.and_return(build_batch_response(:in_progress))
      end
      stub.and_return(build_batch_response(:completed))

      subject.report
    end
  end
end
