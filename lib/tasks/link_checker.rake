require "uri"
require "./lib/link_checker"

desc "This task scans the locale file(s) pulling out all urls, then performs liveness checking on each url, and presents the results."
task link_checker: :environment do
  link_checker = LinkChecker.files_at("config/locales/*.yml")

  puts "LINKS TO CHECK #{link_checker.urls.length}"

  link_report = link_checker.report

  puts "Broken links #{link_report.totals.broken}"
  puts "Cautious links #{link_report.totals.caution}"

  link_report.links.each do |link|
    next unless link.status == :broken || link.status == :caution

    puts "#{link.uri}: #{link.problem_summary}"
  end
end
