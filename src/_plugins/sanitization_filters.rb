module Jekyll
	module SanitizationFilters
    def clean_content(input, length = 160)
      input = input.to_s

      transformed = input
      .gsub(/<\/?[^>]*>/, '')
      .gsub(/\n+/, ' ')
      .gsub(/ {2,}/, ' ')
      .strip

       truncated = transformed[0...length]

       truncated
    end
	end
end

Liquid::Template.register_filter(Jekyll::SanitizationFilters)
