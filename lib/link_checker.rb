require "uri"

module LinkCheckerMethods
module_function

  def gather_urls object
    urls = Set[]
    if object.class == String
      urls.merge(Set.new(URI.extract(object, %w[http https]).to_set))
    elsif object.class == Hash
      object.each do |_, value|
        urls.merge(gather_urls(value))
      end
    elsif object.class == Array
      object.each do |value|
        urls.merge(gather_urls(value))
      end
    end
    urls
  end
end
