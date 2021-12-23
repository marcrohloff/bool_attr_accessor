# frozen_string_literal: true

module BoolAttrAccessor
  class Implementation # rubocop:disable Style/Documentation

    attr_reader :raw, :reader, :writer, :bang

    def initialize(mod, raw, reader, writer, bang)
      @module = mod
      @raw    = raw
      @reader = reader
      @writer = writer
      @bang   = bang
    end

    def create(attribute, default)
      attribute_base = check_name!(attribute)
      ivar_name      = "@#{attribute_base}"

      make_query_method(attribute_base, ivar_name, default)
      make_reader_method(attribute_base, ivar_name, default) if reader
      make_raw_writer_method(attribute_base, ivar_name)      if writer && raw
      make_checked_writer_method(attribute_base, ivar_name)  if writer && !raw
      make_bang_method(attribute_base, ivar_name)            if bang

      :"#{attribute_base}?"
    end

    private

    def check_name!(name)
      root_name = name.to_s.sub(/\?$/, '')
      raise(NameError, "Invalid attribute name #{name.inspect}") if root_name.match?(/[?!=]/)

      root_name
    end

    def make_query_method(attribute_base, ivar_name, default)
      # rubocop:disable Style/DoubleNegation
      @module.class_eval(<<-QUERY_METHOD, __FILE__, __LINE__ + 1)
        def #{attribute_base}?                                        # def attribute?
          defined?(#{ivar_name}) ? !!#{ivar_name} : #{!!default}      #   defined?(@attribute) ? !!@attribute : !!default
        end                                                           # end
      QUERY_METHOD
      # rubocop:enable Style/DoubleNegation
    end

    def make_reader_method(attribute_base, ivar_name, default)
      @module.class_eval(<<-READER_METHOD, __FILE__, __LINE__ + 1)
        def #{attribute_base}                                         # def attribute?
          defined?(#{ivar_name}) ? #{ivar_name} : #{default.inspect}  #   defined?(@attribute) ? @attribute : default
        end                                                           # end
      READER_METHOD
    end

    def make_raw_writer_method(attribute_base, ivar_name)
      @module.class_eval(<<-WRITER_METHOD, __FILE__, __LINE__ + 1)
        def #{attribute_base}=(value)                                 # def attribute=(value)
          #{ivar_name} = value                                        #   @attribute = value
        end                                                           # end
      WRITER_METHOD
    end

    def make_checked_writer_method(attribute_base, ivar_name)
      @module.class_eval(<<-WRITER_METHOD, __FILE__, __LINE__ + 1)
        def #{attribute_base}=(value)                                 # def attribute=(value)
          #{ivar_name} = !!value                                      #   @attribute = !!value
        end                                                           # end
      WRITER_METHOD
    end

    def make_bang_method(attribute_base, ivar_name)
      @module.class_eval(<<-BANG_METHOD, __FILE__, __LINE__ + 1)
        def #{attribute_base}!                                      # def attribute!
          #{ivar_name} = true                                       #   @attribute = true
        end                                                         # end
      BANG_METHOD
    end

  end
end
