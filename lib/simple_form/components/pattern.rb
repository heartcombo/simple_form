module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Pattern
      def pattern
        input_html_options[:pattern] ||= pattern_source
        nil
      end

      private

      def pattern_source
        pattern = options[:pattern]
        if pattern.is_a?(String)
          pattern
        elsif pattern_validator = find_pattern_validator and
              with = pattern_validator.options[:with]
        then
          source = evaluate_format_validator_option(with).source
          convert_regexp_from_ruby_to_ecma source
        end
      end

      def convert_regexp_from_ruby_to_ecma(source)
        source.sub('\\A' , '^').sub('\\Z' , '$').sub('\\z' , '$')
      end

      def find_pattern_validator
        find_validator(:format)
      end

      def evaluate_format_validator_option(option)
        if option.respond_to?(:call)
          option.call(object)
        else
          option
        end
      end
    end
  end
end
