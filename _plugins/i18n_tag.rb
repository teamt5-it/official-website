module Jekyll
  class I18nTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]
      path = @text.split('.')
      if site.data[page['locale']][page['i18n-prefix']]&.dig(*path)
        site.data[page['locale']][page['i18n-prefix']].dig(*path)
      else
        site.data[page['locale']].dig(*path)
      end
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::I18nTag)
