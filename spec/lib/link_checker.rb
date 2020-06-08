require "./lib/link_checker"

RSpec.describe LinkCheckerMethods do
  describe "gather_urls method" do
    it "should finds http urls in strings" do
      result = LinkCheckerMethods.gather_urls "I've hidden an url http://www.example.com in this string"
      expect(result).to eq(Set["http://www.example.com"])
    end
    it "should find https urls in strings" do
      result = LinkCheckerMethods.gather_urls "I've hidden an url https://www.example.com in this string"
      expect(result).to eq(Set["https://www.example.com"])
    end
    it "should find multiple urls in strings" do
      result = LinkCheckerMethods.gather_urls "
        I've hidden several urls https://www.example.com in this string
        here is another http://www.banana.com in this string
        one more sneaky one over herehttp://govstuff.gov.uk in this string
      "
      expect(result).to eq(Set[
        "https://www.example.com",
        "http://www.banana.com",
        "http://govstuff.gov.uk"
      ])
    end
    it "should finds urls in arrays" do
      result = LinkCheckerMethods.gather_urls [
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
      result = LinkCheckerMethods.gather_urls({
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
      result = LinkCheckerMethods.gather_urls({
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
      result = LinkCheckerMethods.gather_urls({
        "firstHash" => [
          "I've hidden several urls https://www.example.com here", Set[], 1,
          [
            1.111,
            true,
            "I've hidden https://example.gov.uk here",
            "I've hidden https://www.example.com here",
            "Nothing hidden here",
            { "anotherHash" => "this string here is another http://www.banana.com in this string" },
          ],
          { "secondHash" => "the second member also has an url https://extrahelp.co.uk woah",
            "thirdHash" => "the second member also has an url http://terror.com", "false" => false }
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
      allow(LinkCheckerMethods).to receive(:gather_urls).with(:dummy_yaml1) {
        Set["http://buildings.org", "http://defra.gov.uk", "https://www.abstract.com", "https://banana.gov.uk"]
      }

      govuk_urls, other_urls = LinkCheckerMethods.get_urls_from_locale_files
      expect(govuk_urls).to match_array(["https://banana.gov.uk", "http://defra.gov.uk"])
      expect(other_urls).to match_array(["http://buildings.org", "https://www.abstract.com"])
    end

    it "should iterate over all files returned by glob" do
      allow(Dir).to receive(:glob).with("config/locales/*.yml") { %i[dummy_path1 dummy_path2] }
      allow(File).to receive(:read).with(:dummy_path1) { :dummy_file1 }
      allow(File).to receive(:read).with(:dummy_path2) { :dummy_file2 }
      allow(YAML).to receive(:safe_load).with(:dummy_file1) { :dummy_yaml1 }
      allow(YAML).to receive(:safe_load).with(:dummy_file2) { :dummy_yaml2 }
      allow(LinkCheckerMethods).to receive(:gather_urls).with(:dummy_yaml1) {
        Set["http://houses.gov.uk", "https://www.abstract.com"]
      }
      allow(LinkCheckerMethods).to receive(:gather_urls).with(:dummy_yaml2) {
        Set["https://bins.gov.uk", "http://www.example.com"]
      }

      govuk_urls, other_urls = LinkCheckerMethods.get_urls_from_locale_files
      expect(govuk_urls).to match_array(["https://bins.gov.uk", "http://houses.gov.uk"])
      expect(other_urls).to match_array(["http://www.example.com", "https://www.abstract.com"])
    end
  end
end
