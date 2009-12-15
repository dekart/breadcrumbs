module Breadcrumbs
  module ActionViewExtension
    def breadcrumbs(options = {}, &block)
      @breadcrumbs ||= Breadcrumbs::Builder.new(self)

      @breadcrumbs.items.push(options) if options.any?

      if block_given?
        yield(@breadcrumbs)
      else
        return @breadcrumbs
      end
    end

    def breadcrumbs_for(*args)
      method_name = args.collect{|a|
        a.is_a?(Symbol) ? a : a.class.to_s.demodulize.underscore
      }.join("_") + "_breadcrumbs"

      send(method_name, args.last)
    end
  end
end