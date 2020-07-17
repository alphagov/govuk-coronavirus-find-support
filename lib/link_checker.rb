require "uri"

module LinkChecker
module_function

  def gather_urls(yaml_node)
    urls = Set[]
    if yaml_node.class == String
      urls.merge(Set.new(URI.extract(yaml_node, %w[http https]).to_set))
    elsif yaml_node.class == Hash
      yaml_node.each do |_, value|
        urls.merge(gather_urls(value))
      end
    elsif yaml_node.class == Array
      yaml_node.each do |value|
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
      if URI(url).host.ends_with? "www.gov.uk"
        gov_urls << url
      else
        other_urls << url
      end
    end
    [gov_urls, other_urls]
  end

  def find_invalid_govuk_paths(govuk_urls)
    publishing_api = GdsApi::PublishingApi.new(
      "https://publishing-api.publishing.service.gov.uk",
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"],
    )
    govuk_paths = govuk_urls.map { |url| URI(url).path }

    published_content = publishing_api.lookup_content_ids(
      base_paths: govuk_paths,
    ).to_set

    broken_paths = govuk_paths - published_content.map { |a| a.first.to_s }

    unpublished_paths = published_content.map { |content| content.first unless is_published?(content, publishing_api) }.compact

    [broken_paths.to_a, unpublished_paths]
  end

  def check_links(urls)
    link_checker = GdsApi::LinkCheckerApi.new(
      Plek.current.find("link-checker-api"),
      bearer_token: ENV["LINK_CHECKER_API_BEARER_TOKEN"],
    )

    link_report = link_checker.create_batch(
      urls, checked_within: 5
    )

    while link_report.status == :in_progress
      link_report = link_checker.get_batch(link_report.id)
      if link_report.status == :in_progress
        sleep(3)
      end
    end
    link_report
  end

  def is_published?(content, publishing_api)
    publishing_api.get_live_content(content.last).parsed_content["publication_state"] == "published"
  end
end
