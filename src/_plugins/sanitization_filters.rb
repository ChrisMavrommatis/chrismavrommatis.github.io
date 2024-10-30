module Jekyll
	module SanitizationFilters
		def format_excerpt(input, length = 400)
			input = input.to_s
			transformed = input
			.gsub('<p>', '')
			.gsub('</p>', '')
			.gsub('</h2>', ': ')
			.gsub('</h3>', ': ')
			.gsub('</h4>', ': ')
			.gsub(/\s+/, ' ') # Replace multiple spaces with a single space
			.strip
	
		  # Truncate to the specified length
		  truncated = transformed.length > length ? "#{transformed[0, length]}..." : transformed
		  truncated
		end

    def format_meta_description(input, length = 160)
      input = input.to_s

      transformed = input
      .gsub('.', '. ')
      .gsub('</h2>', ': ')
      .gsub('</h3>', ': ')
      .gsub('</h4>', ': ')
      .gsub(/<\/?[^>]*>/, '') # Remove HTML tags
      .gsub(/\n+/, ' ') # Remove new lines
      .gsub(/ {2,}/, ' ') # Replace multiple spaces with a single space
      .strip

       # Truncate to the specified length
       truncated = transformed[0...length]

       # Return the final description
       truncated
    end
	end
end

Liquid::Template.register_filter(Jekyll::SanitizationFilters)
