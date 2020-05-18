require "csv"

module ContentExporter
  extend self
  def extract_results_links
    result_links = I18n.t("results_link")
    result_links.each_with_object([]) do |group, row|
      group[1].each do |subgroup|
        group_key = group[0]
        subgroup[1].fetch(:items).each { |result| row << format_result_item_row(result, group_key, subgroup) }
        subgroup[1].fetch(:support_and_advice_items, []).each do |result|
          row << format_result_item_row(result, group_key, subgroup, true)
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

private

  def format_result_item_row(result, group_key, subgroup, support_and_advice = false)
    {
      id: result.fetch(:id),
      status: "Live",
      group_and_subgroup: group_and_subgroup_string(group_key, subgroup, support_and_advice),
      text: result.fetch(:text),
      href: result.fetch(:href, ""),
      show_to_nations: result.fetch(:show_to_nations, []).join(" OR "),
      group_key: group_key.to_s,
      subgroup_key: subgroup[0].to_s,
      support_and_advice: support_and_advice,
    }
  end

  def group_and_subgroup_string(group_key, subgroup, support_and_advice)
    groups = I18n.t("coronavirus_form.groups")
    titles = [groups[group_key].fetch(:title), subgroup[1].fetch(:title)]
    titles << "Support and Advice" if support_and_advice
    titles.join(" | ")
  end
end
