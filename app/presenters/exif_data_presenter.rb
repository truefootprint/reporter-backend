class ExifDataPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_user(record))
      .merge(present_photos(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end

  def present_photos(record)
    present_nested(:photos, AttachmentPresenter) { record.photos }
  end
end
