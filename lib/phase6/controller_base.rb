require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    # get post put delete
    def invoke_action(name)
      self.send(name)

      unless @already_built_response
        self.render(@req.request_method)
      end
    end
  end
end
