# frozen_string_literal: true
module SimpleForm
  module Components
    module InputGroups
      module Prepends
        def prepend(wrapper_options = nil)
          span_tag = content_tag(:span, options[:prepend], class: "input-group-text")
          template.content_tag(:div, span_tag, class: "input-group-prepend")
        end
      end

      module Appends
        def append(wrapper_options = nil)
          span_tag = content_tag(:span, options[:append], class: "input-group-text")
          template.content_tag(:div, span_tag, class: "input-group-append")
        end
      end
    end
  end
end
