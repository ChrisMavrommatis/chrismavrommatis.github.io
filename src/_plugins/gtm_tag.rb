module Jekyll
  class GTMHeadTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @id = markup.strip
    end

    def render(context)
      gtm_id = context[@id] || @id

      return '' if gtm_id.nil? || gtm_id.empty?

      <<~HTML
        <!-- Google Tag Manager -->
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','#{gtm_id}');</script>
        <!-- End Google Tag Manager -->
      HTML
    end
  end

  class GTMBodyTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @id = markup.strip
    end

    def render(context)
      gtm_id = context[@id] || @id

      return '' if gtm_id.nil? || gtm_id.empty?

      <<~HTML
        <!-- Google Tag Manager (noscript) -->
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=#{gtm_id}"
        height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <!-- End Google Tag Manager (noscript) -->
      HTML
    end
  end
end


Liquid::Template.register_tag('gtm_head', Jekyll::GTMHeadTag)
Liquid::Template.register_tag('gtm_body', Jekyll::GTMBodyTag)
