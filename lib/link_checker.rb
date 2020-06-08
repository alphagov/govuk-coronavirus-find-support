require "uri"

module LinkCheckerMethods
module_function

  def gather_urls object
    urls = Set[]
    if object.class == String
      urls.merge(Set.new(URI.extract(object, %w[http https]).to_set))
    elsif object.class == Hash
      object.each do |_, value|
        urls.merge(gather_urls(value))
      end
    elsif object.class == Array
      object.each do |value|
        urls.merge(gather_urls(value))
      end
    end
    urls
  end

  def get_urls_from_locale_files
    urls = Dir.glob("config/locales/*.yml")
      .map { |locale_filename| gather_urls YAML.safe_load(File.read(locale_filename)) }
      .reduce(:+)

    gov_urls = []
    other_urls = []
    urls.each do |url|
      if URI(url).host.ends_with? ".gov.uk"
        gov_urls << url
      else
        other_urls << url
      end
    end
    [gov_urls, other_urls]
  end
end
