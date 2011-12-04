module SimpleForm
  module Components
    module HTML5
      def initialize(*)
        @html5 = false
      end

      def html5
        @html5 = true
      end

      def html5?
        @html5
      end
    end
  end
end