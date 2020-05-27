namespace :content do
  desc "Exports results link content from en.yml to a csv"
  task export_results_to_csv: :environment do
    csv_data = ContentExporter.generate_results_link_csv
    File.open("tmp/results_links.csv", "w") { |file| file.write(csv_data) }
  end

  desc "Imports results link content from a csv"
  task :import_locale_links, [:file_path] => :environment do |_, args|
    new_result_links = ContentImporter.import_results_links(args.fetch(:file_path))
    ContentImporter.overwrite_locale_links("config/locales/en.yml", new_result_links)
  rescue KeyError
    puts "Please provide a file path"
  end

  desc "Imports results link content from a google sheet"
  task import_locale_links_from_google_sheet: :environment do
    sheet_id = ENV.fetch("GOOGLE_SHEET_ID")
    csv_path = "tmp/result_links_sheet_import.csv"
    ContentImporter::FromSheet.new(sheet_id, csv_path).download

    Rake::Task["content:import_locale_links"].invoke(csv_path)
  end
end
