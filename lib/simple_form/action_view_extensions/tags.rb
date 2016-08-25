module ActionView
  module Helpers
    module Tags
      class Base
        def add_default_name_and_id_for_value(tag_value, options)
          if tag_value.nil?
            add_default_name_and_id(options)
          else
            specified_id = options["id"]
            add_default_name_and_id(options)

            if specified_id.blank? && options["id"].present?
              tag_value = options[:sanitized_value] || tag_value

              options["id"] += "_#{sanitized_value(tag_value)}"
            end
          end

          options.delete('sanitized_value')
        end

        def sanitized_value(value)
          value = @options[:sanitized_value] || value

          value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase
        end
      end
    end
  end
end
