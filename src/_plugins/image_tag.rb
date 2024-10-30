module Jekyll
  class ImageTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @params = {}

      # Parse the markup to get attributes
      markup.scan(/(\w+)\s*=\s*["']?([^"'\s]+)["']?/) do |key, value|
        @params[key.strip.to_sym] = value.strip
      end

      # Additionally handle class with spaces
      if markup =~ /class\s*=\s*["']?([^"']+)["']?/
        @params[:class] = $1.strip
      end
    end

    def render(context)
      # Evaluate Liquid variables in the context
      evaluated_params = @params.transform_values { |v| context[v] || v }

      # Check for required attributes and return an empty string if missing
      required_attributes = [:url, :alt]
      return '' if required_attributes.any? { |attr| evaluated_params[attr].nil? }

      # Generate the HTML for the img tag
      img_tag = "<img src=\"#{evaluated_params[:url]}\" alt=\"#{evaluated_params[:alt]}\""
      img_tag += " class=\"#{evaluated_params[:class]}\"" if evaluated_params[:class]
      img_tag += " width=\"#{evaluated_params[:width]}\"" if evaluated_params[:width]
      img_tag += " height=\"#{evaluated_params[:height]}\"" if evaluated_params[:height]
      img_tag += " />"

      # Wrap in a picture tag (if needed) or return just the img tag
      "<picture>#{img_tag}</picture>"
    end
  end
end

# Register the custom tag with Liquid
Liquid::Template.register_tag('image', Jekyll::ImageTag)
