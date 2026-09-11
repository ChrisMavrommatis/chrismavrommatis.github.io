module Jekyll
  module RequiredFilter
    def required(input, key = 'a value')
      return input unless input.nil? || (input.respond_to?(:empty?) && input.empty?)

      raise Jekyll::Errors::FatalException,
            "Missing required string: #{key}. Add it to src/_data/ — never inline the text in a template."
    end
  end
end

Liquid::Template.register_filter(Jekyll::RequiredFilter)
