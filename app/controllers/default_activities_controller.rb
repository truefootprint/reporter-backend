class DefaultActivitiesController < ApplicationController
  def index
    response.set_header("X-Total-Count", default_activities.count)
    render json: present(default_activities)
  end

  def create
    default_activity = DefaultActivity.create!(default_activity_params)
    render json: present(default_activity), status: :created
  end

  def show
    render json: present(default_activity)
  end

  def update
    default_activity.update!(default_activity_params)
    render json: present(default_activity)
  end

  def destroy
    render json: present(default_activity.destroy)
  end

  private

  def present(object)
    DefaultActivityPresenter.present(object, presentation)
  end

  def default_activity
    @default_activity ||= DefaultActivity.find(default_activity_id)
  end

  def default_activities
    @default_activities ||= DefaultActivity.where(default_activity_params)
  end

  def default_activity_id
    params.fetch(:id)
  end

  def default_activity_params
    params.permit(:project_type_id, :activity_id, :order)
  end
end
