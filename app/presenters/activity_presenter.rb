class ActivityPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }
  end
end
