module Jekyll
  module RequiredFilter
    # A missing string used to render an empty element and pass the build. It now stops it,
    # because the alternative is a silently unlabelled control shipping to the live site.
    def required(input, key = 'a value')
      return input unless input.nil? || (input.respond_to?(:empty?) && input.empty?)

      raise Jekyll::Errors::FatalException,
            "Missing required string: #{key}. Add it to src/_data/ — never inline the text in a template."
    end
  end
end

Liquid::Template.register_filter(Jekyll::RequiredFilter)
