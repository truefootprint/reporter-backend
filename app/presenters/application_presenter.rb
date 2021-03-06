class ApplicationPresenter
  def self.present(object, *options)
    new(object, *options).as_json
  end

  attr_accessor :object, :options

  def initialize(object, options = {})
    self.object = object
    self.options = options
  end

  def as_json(_options = {})
    if object.is_a?(ActiveRecord::Relation)
      present_scope(object)
    elsif object.is_a?(Array)
      present_collection(object)
    else
      present(object)
    end
  end

  def present_scope(scope)
    scope = modify_scope(scope)
    present_collection(scope)
  end

  def present_collection(collection)
    collection.map { |r| present(r) }
  end

  def present(record)
    record.attributes.symbolize_keys
  end

  def modify_scope(scope)
    scope # override me
  end

  def present_nested(key, presenter, &block)
    nested_options = options[key] or return {}
    nested_options = {} if nested_options == true

    object = block.call(nested_options)
    presented = presenter.present(object, nested_options) if object

    { key => presented }
  end
end
