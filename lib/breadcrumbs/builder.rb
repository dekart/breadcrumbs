module Breadcrumbs
  class Builder
    attr_accessor :items

    def self.default_options
      @default_options ||= {
        :separator        => " &rarr; ",

        :container_tag    => :span,
        :container_class  => :breadcrumbs,
        :container_id     => :breadcrumbs,

        :item_tag         => nil,
        :item_class       => nil,
        :linkify_item     => true,
        
        :current_tag      => :span,
        :current_class    => :current,
        :linkify_current  => false
      }
    end

    def initialize(template)
      @template = template
      @items = []
    end

    def <<(value)
      self.items.push(value)

      return self
    end

    def >>(value)
      self.items.unshift(value)

      return self
    end

    def separator(&block)
      @separator_block = block
    end

    def item(&block)
      @item_block = block
    end

    def current(&block)
      @current_block = block
    end

    def wrap(&block)
      @wrap_block = block
    end

    def breadcrumbs_for(*args)
      self.items.unshift(*@template.breadcrumbs_for(*args))
    end

    def to_html(options = {})
      yield(self) if block_given?

      options.reverse_merge!(self.class.default_options)

      returning result = "" do
        item_codes = []

        @items.each_with_index do |item, index|
          item_codes << (
            if index < @items.size - 1
              if @item_block
                @template.capture(item, index, @items, &@item_block)
              else
                code = item_code(item, options[:linkify_item])

                if options[:item_tag]
                  @template.content_tag(options[:item_tag], code, :class => options[:item_class])
                else
                  code
                end
              end
            else
              if @current_block
                @template.capture(item, index, @items, &@current_block)
              else
                code = item_code(item, options[:linkify_current])

                if options[:current_tag]
                  @template.content_tag(options[:current_tag], code, :class => options[:current_class])
                else
                  code
                end
              end
            end
          )
        end
        
        result << item_codes.join(@separator_block ? @template.capture(&@separator_block) : options[:separator])

        result.replace(
          if @wrap_block
            @template.capture(result, &@wrap_block)
          else
            @template.content_tag(options[:container_tag], result, 
              :class  => options[:container_class],
              :id     => options[:container_id]
            )
          end
        )

        block_given? ? @template.concat(result) : result
      end
    end

    def item_code(item, linkify)
      if linkify && item.is_a?(Array)
        @template.link_to(*item)
      elsif item.is_a?(Array)
        item.first
      else
        item
      end
    end
  end
end