namespace :content do
  desc "Exports results link content from en.yml to a csv"
  task export_results_to_csv: :environment do
    csv_data = ContentExporter.generate_results_link_csv
    File.open("tmp/results_links.csv", "w") { |file| file.write(csv_data) }
  end
end
