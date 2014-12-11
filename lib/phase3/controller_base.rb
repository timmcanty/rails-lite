require_relative '../phase2/controller_base'
require 'active_support/all'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      file = File.read("views/#{(ActiveSupport::Inflector.underscore(self.class.to_s)).underscore}/#{template_name}.html.erb")
      template = ERB.new(file)
      render_content(template.result(bind()),"text/html")
    end

    def bind
      binding
    end
  end
end
