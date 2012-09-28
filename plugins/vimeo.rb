# syntax {% vimeo numeric_vimeo_id %}
# Example - {% vimeo 46506653 %} for https://vimeo.com/46506653



module Jekyll
  class Vimeo < Liquid::Tag
    @width = 960
    @height = 540

    def initialize(name, id, tokens)
      super
      @id = id
    end

    def render(context)
      %(<iframe width="#{@width}" height="#{@height}" src="http://player.vimeo.com/video/#{@id}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>)
    end
  end
end

Liquid::Template.register_tag('vimeo', Jekyll::Vimeo)