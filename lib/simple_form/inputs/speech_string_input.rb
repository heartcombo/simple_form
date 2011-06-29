module SimpleForm
  module Inputs
    class SpeechStringInput < StringInput
      
      def input
        input_html_options ||= {}
        input_html_options.merge!({:"x-webkit-speech" => "", :speech => "", :lang => "en", :"x-webkit-grammar" =>"builtin:search"})
        @builder.text_field(attribute_name, input_html_options)  
      end

    end
  end
end
