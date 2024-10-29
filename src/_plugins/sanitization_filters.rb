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
	end
end

Liquid::Template.register_filter(Jekyll::SanitizationFilters)
