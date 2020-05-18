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
end
