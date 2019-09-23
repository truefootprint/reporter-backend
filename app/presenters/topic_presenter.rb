class TopicPresenter < ApplicationPresenter
  def present(record)
    { name: interpolate(record.name) }
  end

  private

  def interpolate(string)
    context ? context.apply(string) : string
  end

  def context
    options[:interpolation_context]
  end
end
