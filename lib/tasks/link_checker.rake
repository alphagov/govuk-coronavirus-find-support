require "uri"
require "./lib/link_checker"

desc "This task scans the locale file(s) pulling out all urls, then performs liveness checking on each url, and presents the results."
task :link_checker, [:date] => [:environment] do |_, _args|
  govuk_urls, other_urls = LinkChecker.get_urls_from_locale_files

  puts "LINKS TO CHECK #{govuk_urls.length + other_urls.length}"

  broken_paths, unpublished_paths = LinkChecker.find_invalid_govuk_paths(govuk_urls)
  link_report = LinkChecker.check_links(other_urls + broken_paths.map { |path| "https://www.gov.uk#{path}" })

  puts "Broken links #{link_report.totals.broken}"
  puts "Cautious links #{link_report.totals.caution}"

  puts "Unpublished GOV.UK links #{unpublished_paths.length}"

  link_report.links.each do |link|
    next unless link.status == :broken || link.status == :caution

    puts "#{link.uri}: #{link.problem_summary}"
  end

  unpublished_paths.each do |path|
    puts "www.gov.uk#{path}: unpublished"
  end
end
