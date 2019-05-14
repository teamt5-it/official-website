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
      if site.data[page['lang']][page['i18n_prefix']]&.dig(*path)
        site.data[page['lang']][page['i18n_prefix']].dig(*path)
      else
        site.data[page['lang']].dig(*path)
      end
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::I18nTag)
