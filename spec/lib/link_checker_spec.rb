require "./lib/link_checker"
require "gds_api/test_helpers/link_checker_api"

RSpec.describe LinkChecker do
  include GdsApi::TestHelpers::LinkCheckerApi

  describe "gather_urls method" do
    it "should finds http urls in strings" do
      result = LinkChecker.gather_urls "I've hidden an url http://www.example.com in this string"
      expect(result).to eq(Set["http://www.example.com"])
    end

    it "should find https urls in strings" do
      result = LinkChecker.gather_urls "I've hidden an url https://www.example.com in this string"
      expect(result).to eq(Set["https://www.example.com"])
    end

    it "should find multiple urls in strings" do
      result = LinkChecker.gather_urls "
        I've hidden several urls https://www.example.com in this string
        here is another http://www.banana.com in this string
        one more sneaky one over herehttp://govstuff.gov.uk in this string
      "
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "http://govstuff.gov.uk",
      ])
    end

    it "should finds urls in arrays" do
      result = LinkChecker.gather_urls [
        "I've hidden several urls https://www.example.com in this string
          here is another http://www.banana.com in this string",
        "the second member also has an url https://extrahelp.co.uk woah",
        "the second member also has an url http://terror.com",
      ]
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "https://extrahelp.co.uk",
        "http://terror.com",
      ])
    end

    it "should finds urls in strings in Hash" do
      result = LinkChecker.gather_urls({
        "firstHash" => "I've hidden several urls https://www.example.com in
        this string here is another http://www.banana.com in this string",
        "secondHash" => "the second member also has an url https://extrahelp.co.uk woah",
        "thirdHash" => "the second member also has an url http://terror.com",
      })
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "https://extrahelp.co.uk",
        "http://terror.com",
      ])
    end

    it "should search recursively for urls in hashes/arrays" do
      result = LinkChecker.gather_urls({
        "firstHash" => [
          "I've hidden several urls https://www.example.com here",
          [
            "I've hidden https://example.gov.uk here",
            "I've hidden https://www.example.com here",
            "Nothing hidden here",
            { "anotherHash" => "this string here is another http://www.banana.com in this string" },
          ],
          { "secondHash" => "the second member also has an url https://extrahelp.co.uk woah",
            "thirdHash" => "the second member also has an url http://terror.com" },
        ],
      })
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "https://extrahelp.co.uk",
        "https://example.gov.uk",
        "http://terror.com",
      ])
    end

    it "should ignore non string values when searching in hashes/arrays" do
      result = LinkChecker.gather_urls({
        "firstHash" => [
          "I've hidden several urls https://www.example.com here",
          Set[],
          1,
          [
            1.111,
            true,
            "I've hidden https://example.gov.uk here",
            "I've hidden https://www.example.com here",
            "Nothing hidden here",
            { "anotherHash" => "this string here is another http://www.banana.com in this string" },
          ],
          {
            "secondHash" => "the second member also has an url https://extrahelp.co.uk woah",
            "thirdHash" => "the second member also has an url http://terror.com",
            "false" => false,
          },
        ],
      })
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "https://extrahelp.co.uk",
        "https://example.gov.uk",
        "http://terror.com",
      ])
    end
  end

  describe "get_urls_from_locale_files method" do
    it "should separate out gov urls, and example urls" do
      allow(Dir).to receive(:glob).with("config/locales/*.yml") { %i[dummy_path1] }
      allow(File).to receive(:read).with(:dummy_path1) { :dummy_file1 }
      allow(YAML).to receive(:safe_load).with(:dummy_file1) { :dummy_yaml1 }
      allow(LinkChecker).to receive(:gather_urls).with(:dummy_yaml1) {
        Set["http://buildings.org", "http://www.gov.uk/defra", "https://www.abstract.com", "https://www.gov.uk/banana"]
      }

      govuk_urls, other_urls = LinkChecker.get_urls_from_locale_files
      expect(govuk_urls).to match_array(["https://www.gov.uk/banana", "http://www.gov.uk/defra"])
      expect(other_urls).to match_array(["http://buildings.org", "https://www.abstract.com"])
    end

    it "should iterate over all files returned by glob" do
      allow(Dir).to receive(:glob).with("config/locales/*.yml") { %i[dummy_path1 dummy_path2] }
      allow(File).to receive(:read).with(:dummy_path1) { :dummy_file1 }
      allow(File).to receive(:read).with(:dummy_path2) { :dummy_file2 }
      allow(YAML).to receive(:safe_load).with(:dummy_file1) { :dummy_yaml1 }
      allow(YAML).to receive(:safe_load).with(:dummy_file2) { :dummy_yaml2 }
      allow(LinkChecker).to receive(:gather_urls).with(:dummy_yaml1) {
        Set["http://www.gov.uk/houses", "https://www.abstract.com"]
      }
      allow(LinkChecker).to receive(:gather_urls).with(:dummy_yaml2) {
        Set["https://www.gov.uk/bins", "http://www.example.com"]
      }

      govuk_urls, other_urls = LinkChecker.get_urls_from_locale_files
      expect(govuk_urls).to match_array(["https://www.gov.uk/bins", "http://www.gov.uk/houses"])
      expect(other_urls).to match_array(["http://www.example.com", "https://www.abstract.com"])
    end
  end

  describe "find_invalid_govuk_paths" do
    it "should separate out gov urls, and example urls" do
      test_paths = ["/test/path/pub", "/another/test/path/broken", "/a/third/test/path/pub", "/fifth/broken", "/sixth/broken", "/seventh/unpub"]
      test_urls = test_paths.map { |path| "http://www.gov.uk#{path}" }

      mock_client = instance_double("GdsApi::PublishingApi")
      expect(GdsApi::PublishingApi).to receive(:new).with("https://publishing-api.publishing.service.gov.uk", bearer_token: "test_token") {
        mock_client
      }
      expect(mock_client).to receive(:lookup_content_ids).with({ base_paths: test_paths }).and_return(
        {
          "/test/path/pub" => "klm",
          "/a/third/test/path/pub" => "nop",
          "/seventh/unpub" => "qrs",
        },
      )
      published_double = double(parsed_content: { "publication_state" => "published" })
      unpublished_double = double(parsed_content: { "publication_state" => "unpublished" })
      expect(mock_client).to receive(:get_live_content).with("klm").and_return(published_double)
      expect(mock_client).to receive(:get_live_content).with("nop").and_return(published_double)
      expect(mock_client).to receive(:get_live_content).with("qrs").and_return(unpublished_double)

      expect(ENV).to receive(:[]).with("PUBLISHING_API_BEARER_TOKEN").and_return("test_token")

      broken_paths, unpublished_paths = LinkChecker.find_invalid_govuk_paths test_urls
      expect(broken_paths).to match_array(["/another/test/path/broken", "/fifth/broken", "/sixth/broken"])
      expect(unpublished_paths).to match_array(["/seventh/unpub"])
    end
  end

  describe "check_links method" do
    let(:test_urls) do
      [
        "https://www.google.com/test/",
        "http://www.example.com/another/test/",
        "http://banana.org/a/third/test/",
      ]
    end

    def expect_side_effects
      expect(GdsApi::LinkCheckerApi).to receive(:new).with(
        Plek.current.find("link-checker-api"), bearer_token: "test_token"
      ).and_call_original

      expect(ENV).to receive(:[]).with("LINK_CHECKER_API_BEARER_TOKEN").and_return("test_token").once
      allow(ENV).to receive(:[]).with(anything)
    end

    it "if batch is immediately complete it should not call get batch or sleep" do
      expect_side_effects

      stub_link_checker_api_create_batch(
        uris: test_urls, checked_within: 5, status: :complete,
      )

      expect(LinkChecker).to_not receive(:sleep).with(3)
      LinkChecker.check_links test_urls
    end

    it "should call check_batch if batch is not immediately complete" do
      expect_side_effects
      stub_link_checker_api_create_batch(
        uris: test_urls, checked_within: 5, status: :in_progress,
      )
      stub_link_checker_api_get_batch(
        id: 0, status: :completed,
      )
      expect(LinkChecker).to_not receive(:sleep).with(3)

      LinkChecker.check_links test_urls
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
        uris: test_urls, checked_within: 5, status: :in_progress,
      )

      stub = stub_link_checker_api_get_batch(
        id: 0, status: :in_progress,
      )

      expect(LinkChecker).to receive(:sleep).with(3).exactly(5).times

      4.times do
        stub.and_return(build_batch_response(:in_progress))
      end
      stub.and_return(build_batch_response(:completed))

      LinkChecker.check_links test_urls
    end
  end
end
