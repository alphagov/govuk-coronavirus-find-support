task :link_checker, [:date] => [:environment] do |_, args|
  links = []
  results_groups = I18n.t("results_link")
  results_groups.each do |_, results_group|
    results_group.each do |_, results_set|
      links << results_set[:items].map{ |k| k[:href] }
    end
  end

  urls = links.compact.flatten.reject(&:nil?)

  link_checker = GdsApi::LinkCheckerApi.new(
    "https://link-checker-api.publishing.service.gov.uk",
    bearer_token: ENV["LINK_CHECKER_API_BEARER_TOKEN"],
  )

  puts "LINKS TO CHECK #{urls.length}"

  link_report_batch = link_checker.create_batch(
    urls,
    checked_within: 5,
  )

  state = :in_progress

  while state == :in_progress
    link_report = link_checker.get_batch(link_report_batch.id)
    state = link_report.status
    puts "LINKS TO CHECK #{link_report.totals.pending}"
    sleep(3)
  end

  puts "Broken links #{link_report.totals.broken}"
  puts "Cautious links #{link_report.totals.caution}"

  link_report.links.each do |link|
    next unless link.status == :broken || link.status == :caution

    puts "#{link.uri}: #{link.problem_summary}"
  end
end

task :internal_link_checker, [:date] => [:environment] do |_, args|
  links = []
  results_groups = I18n.t("results_link")
  results_groups.each do |_, results_group|
    results_group.each do |_, results_set|
      links << results_set[:items].map{ |k| k[:href] }
    end
  end

  base_paths = links
    .compact
    .flatten
    .reject(&:nil?)
    .select { |url| url.match(/^https:\/\/www.gov.uk/) }
    .map { |url| url.gsub(/^https:\/\/www.gov.uk/, "") }

  publishing_api = GdsApi::PublishingApi.new(
    "https://publishing-api.publishing.service.gov.uk",
    bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"],
  )

  content_ids = publishing_api.lookup_content_ids(base_paths: base_paths)

  content_ids.each_pair do |slug, content_id|
    content_item = publishing_api.get_live_content(content_id)
    unpublish = content_item.to_h["unpublishing"]
    puts "#{slug}: #{unpublish['type']} at #{unpublish['unpublished_at']}" if unpublish
  end

end
