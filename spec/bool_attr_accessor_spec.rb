# frozen_string_literal: true

RSpec.describe BoolAttrAccessor do

  context 'with default usage' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute
      end)
    end

    specify 'it should implement the necessary methds' do
      a = TestKlass.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)
    end

    specify 'it should not implement the raw reader method by default' do
      a = TestKlass.new
      expect(a).not_to respond_to(:attribute)
      expect { a.attribute }.to raise_exception(NoMethodError)
    end

    specify 'it should query the attribute' do
      a = TestKlass.new
      expect(a.attribute?).to eq(false)
    end

    specify 'it should allow you to set the attribute to true' do
      a = TestKlass.new
      a.attribute!
      expect(a.attribute?).to eq(true)
    end

    specify 'it should allow you to set the attribute multiple times' do
      a = TestKlass.new
      a.attribute!
      expect(a.attribute?).to eq(true)
      a.attribute!
      expect(a.attribute?).to eq(true)
    end

    specify 'it should allow you to set a value' do
      a = TestKlass.new
      expect(a.attribute?).to eq(false)
      a.attribute = true
      expect(a.attribute?).to eq(true)
      a.attribute = false
      expect(a.attribute?).to eq(false)
    end

    specify 'it should allow you to set a truthy value' do
      a = TestKlass.new
      a.attribute = 3
      expect(a.attribute?).to eq(true)
    end

    specify 'it should allow you to set a falsy value' do
      a = TestKlass.new

      a.attribute!
      a.attribute = nil
      expect(a.attribute?).to eq(false)

      a.attribute!
      a.attribute = false
      expect(a.attribute?).to eq(false)
    end

  end

  context 'when validating the name' do

    specify 'it should allow symbolic names' do
      a = Class.new do
        battr_accessor :attribute
      end.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)
    end

    specify 'it should allow string names' do
      a = Class.new do
        battr_accessor 'attribute'
      end.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)
    end

    specify 'it should remove trailing question marks' do
      a = Class.new do
        battr_accessor :attribute?
      end.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)

      a = Class.new do
        battr_accessor 'attribute?'
      end.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)
    end

    specify 'it should not allow variable names ending with an equals sign' do
      expect do
        Class.new do
          battr_accessor :attribute=
        end
      end.to raise_exception(NameError, 'Invalid attribute name :attribute=')

      expect do
        Class.new do
          battr_accessor 'attribute='
        end
      end.to raise_exception(NameError, 'Invalid attribute name "attribute="')
    end

    specify 'it should not allow variable names ending with an exclamation point' do
      expect do
        Class.new do
          battr_accessor :attribute!
        end
      end.to raise_exception(NameError, 'Invalid attribute name :attribute!')

      expect do
        Class.new do
          battr_accessor 'attribute!'
        end
      end.to raise_exception(NameError, 'Invalid attribute name "attribute!"')
    end

  end

  context 'when using aliases' do

    specify 'it should allow `attr_boolean` as an alias' do
      a = Class.new do
        attr_boolean :attribute
      end.new
      expect(a).to respond_to(:attribute?, :attribute=, :attribute!)
    end

  end

  context 'with multiple attributes' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute, :attribute2
      end)
    end

    specify 'it should have all methods' do
      a = TestKlass.new
      expect(a).to respond_to(:attribute?,  :attribute=,  :attribute!)
      expect(a).to respond_to(:attribute2?, :attribute2=, :attribute2!)
    end

  end

  context 'with a default value' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute, default: true
      end)
    end

    specify 'it should query the attribute' do
      a = TestKlass.new
      expect(a.attribute?).to eq(true)
    end

  end

  context 'with the reader enabled' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute, reader: true
      end)
    end

    specify 'it should have the reader methods' do
      a = TestKlass.new
      expect(a).to respond_to(:attribute?, :attribute, :attribute=, :attribute!)
    end

    specify 'it should read the correct values' do
      a = TestKlass.new
      expect(a.attribute).to eq(false)

      a.attribute = 3
      expect(a.attribute).to eq(true)

      a.attribute = nil
      expect(a.attribute).to eq(false)
    end

  end

  context 'with the bang method disabled' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute, bang: false
      end)
    end

    specify 'it should not have the writer methods' do
      a = TestKlass.new
      expect(a).to     respond_to(:attribute?)
      expect(a).not_to respond_to(:attribute, :attribute=, :attribute!)
    end

    specify 'with the bang method disabled but the writer method enabled' do
      a = Class.new do
        battr_accessor :attribute, bang: false, writer: true
      end.new
      expect(a).to     respond_to(:attribute?, :attribute=)
      expect(a).not_to respond_to(:attribute, :attribute!)
    end

    specify 'with the bang method enabled but the writer method disabled' do
      a = Class.new do
        battr_accessor :attribute, bang: true, writer: false
      end.new
      expect(a).to     respond_to(:attribute?, :attribute!)
      expect(a).not_to respond_to(:attribute, :attribute=)
    end

  end

  context 'when the raw option is provided' do

    before do
      stub_const('TestKlass', Class.new do
        battr_accessor :attribute, raw: true
      end)
    end

    specify 'it should have the reader method' do
      a = TestKlass.new
      expect(a).to respond_to(:attribute?, :attribute!, :attribute, :attribute=)
    end

    specify 'it should be able to disable the reader methos' do
      a = Class.new do
        battr_accessor :attribute, raw: true, reader: false
      end.new
      expect(a).to     respond_to(:attribute?, :attribute!, :attribute=)
      expect(a).not_to respond_to(:attribute)
    end

    specify 'it should read the raw value' do
      a = TestKlass.new
      expect(a.attribute).to eq(false)
      expect(a.attribute?).to eq(false)

      a.attribute!
      expect(a.attribute).to eq(true)
      expect(a.attribute?).to eq(true)

      a.attribute = nil
      expect(a.attribute).to eq(nil)
      expect(a.attribute?).to eq(false)

      a.attribute = 3
      expect(a.attribute).to eq(3)
      expect(a.attribute?).to eq(true)

      a.attribute = nil
      expect(a.attribute).to eq(nil)
      expect(a.attribute?).to eq(false)
    end

    specify 'it should read the raw value as truthy' do
      a = Class.new do
        battr_accessor :attribute, raw: true, default: 3
      end.new
      expect(a.attribute).to eq(3)
      expect(a.attribute?).to eq(true)
    end

    specify 'it should read the raw value as falsy' do
      a = Class.new do
        battr_accessor :attribute, raw: true, default: false
      end.new
      expect(a.attribute).to eq(false)
      expect(a.attribute?).to eq(false)

      a = Class.new do
        battr_accessor :attribute, raw: true, default: nil
      end.new
      expect(a.attribute).to eq(nil)
      expect(a.attribute?).to eq(false)
    end

  end

end
