require "csv"

module ContentImporter
module_function

  def import_results_links(csv_path)
    csv = CSV.read(csv_path, { headers: true })
    output = csv.each_with_object({}) do |csv_row, results_links|
      support_and_advice = csv_row.fetch("support_and_advice")
      group_key = csv_row.fetch("group_key").to_sym
      subgroup_key = csv_row.fetch("subgroup_key").to_sym

      link_type = support_and_advice.downcase == "true" ? "support_and_advice" : "items"
      results_links[group_key] = {} if results_links.dig(group_key).nil?
      results_links[group_key][subgroup_key] = {} if results_links.dig(group_key, subgroup_key).nil?
      if results_links.dig(group_key, subgroup_key, link_type).nil?
        results_links[group_key][subgroup_key][link_type] = []
      end

      show_to_nations = csv_row.fetch("show_to_nations")
      nations = show_to_nations.split(" OR ") unless show_to_nations.nil?

      results_links[group_key][subgroup_key][link_type] << {
        id: sprintf("%04d", csv_row.fetch("id")), # Zero pad it!
        text: csv_row.fetch("text"),
        href: csv_row.fetch("href"),
        show_to_nations: nations,
      }.reject { |_key, value| value.blank? }
    end
    output.deep_stringify_keys
  end

  def overwrite_locale_links(input_locale_path, locale_hash, output_locale_path = input_locale_path)
    existing_locale_file = YAML.load_file(input_locale_path)
    existing_locale_file["en"]["results_link"].keys.each do |group_key|
      existing_locale_file["en"]["results_link"][group_key].keys.each do |subgroup_key|
        subgroup = existing_locale_file["en"]["results_link"][group_key][subgroup_key]
        subgroup["items"] = [] # Clear out old items in case we removed some on the sheet
        subgroup["support_and_advice"] = [] unless subgroup["support_and_advice"].nil? # ditto s&a links
        merged_locale = subgroup.merge(locale_hash[group_key][subgroup_key])
        existing_locale_file["en"]["results_link"][group_key][subgroup_key] = merged_locale
      end
    end

    File.open(output_locale_path, "w") do |file|
      file.write(existing_locale_file.to_yaml)
    end
  end
end
