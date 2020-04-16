ActionController::Renderers.add :csv do |obj, options|
  filename = options.fetch(:filename, "data")
  content = obj.respond_to?(:to_csv) ? obj.to_csv : obj.to_s
  send_data content, type: Mime[:csv], disposition: "attachment; filename=#{filename}.csv"
end
