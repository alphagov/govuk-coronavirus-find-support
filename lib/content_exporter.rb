require "csv"

class ContentExporter
  class << self
    def extract_results_links
      result_links = I18n.t("results_link")
      groups = I18n.t("coronavirus_form.groups")
      result_links.each_with_object([]) do |group, row|
        group[1].each do |subgroup|
          subgroup[1].fetch(:items).each do |result|
            row << {
              group_title: groups[group[0]].fetch(:title),
              subgroup_title: subgroup[1].fetch(:title),
              text: result.fetch(:text),
              href: result.fetch(:href, ""),
              show_to_nations: result.fetch(:show_to_nations, []).join(" OR "),
            }
          end
        end
      end
    end

    def generate_results_link_csv
      data = extract_results_links
      column_names = data.map(&:keys).flatten.uniq
      values = data.map(&:values)
      CSV.generate do |csv|
        csv << column_names.map(&:to_s)
        values.each { |value| csv << value }
      end
    end
  end
end
