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
