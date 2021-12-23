# frozen_string_literal: true

# Extend module with attr_boolean

class Module # rubocop:disable Style/Documentation

  # battr_accessor(names, ..., options)
  # attr_boolean(names, ..., options)
  #
  # Defines a boolean style attribute for the module or class
  # with a query method (attribute?) and optional writers and defaults
  # If the name does not end with a question mark (?) then it is added
  #
  # ==== Options
  #
  # * <tt>:default</tt> - Sets the default value for the attributes
  #                       (defaults to false).
  # * <tt>:raw</tt>     - Raw mode stores actual values instead of coercing values to booleans.
  #                       (defaults to false).
  # * <tt>:reader</tt>  - Creates a reader method for the attribute (attribute)
  #                       (By default this is enabled when raw mode is enabled).
  # * <tt>:bang</tt>    - Creates a bang method to set the attribute to true (attribute!)
  #                       (defaults to true).
  # * <tt>:writer</tt>  - Creates a write method for the attribute (attribute = vale)
  #                       (defaults to the same value as bang).
  #
  # ==== Examples
  #
  #   class Base
  #     attr_boolean :test?                  # read-write value
  #     attr_boolean :active?, writer: false # read only boolean
  #   end
  #
  # Base.new.test?
  # Base.new.test=(false)
  # Base.new.test!
  # Base.new.active?
  # Base.new.active=(false) # NoMethodFound
  # Base.new.active!         # NoMethodFound
  def battr_accessor(*attributes, # rubocop:disable Metrics/ParameterLists
                     default: false,  # default attribute value
                     raw:     false,  # treat this as a raw attribute allowing non-boolean values
                     reader:  raw,    # create a reader method (attribute)
                     bang:    true,   # create a bang method to set the attribute (attribute!)
                     writer:  bang)   # create a writer method (attribute=)
    impl = BoolAttrAccessor::Implementation.new(self, raw, reader, writer, bang)
    attributes.map do |attribute|
      impl.create(attribute, default)
    end
  end

  alias attr_boolean battr_accessor

end
