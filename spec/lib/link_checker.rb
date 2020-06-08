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
end
