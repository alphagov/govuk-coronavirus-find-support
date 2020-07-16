class LinkChecker
  def self.gather_data(path)
    Dir.glob(path).map do |filename|
      YAML.safe_load(File.read(filename))
    end
  end

  def self.files_at(path)
    data = gather_data(path)
    new(data)
  end

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def urls
    @urls ||= extract_urls(data)
  end

  def report
    @report ||= generate_report
  end

private

  def extract_urls(yaml_node)
    # Gather urls in a Set to allow simple combination and duplicate removal
    urls = Set[]
    case yaml_node
    when String
      urls.merge(Set.new(URI.extract(yaml_node, %w[http https]).to_set))
    when Hash
      yaml_node.each_value do |value|
        urls.merge(extract_urls(value))
      end
    when Array
      yaml_node.each do |value|
        urls.merge(extract_urls(value))
      end
    end
    urls
  end

  def generate_report
    link_report = link_checker.create_batch(urls, checked_within: 5)

    while link_report.status == :in_progress
      link_report = link_checker.get_batch(link_report.id)
      if link_report.status == :in_progress
        sleep(3)
      end
    end
    link_report
  end

  def link_checker
    @link_checker ||= GdsApi::LinkCheckerApi.new(
      Plek.current.find("link-checker-api"),
      bearer_token: ENV["LINK_CHECKER_API_BEARER_TOKEN"],
    )
  end
end
