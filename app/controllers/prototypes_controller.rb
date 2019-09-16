class PrototypesController < ApplicationController
  def topic_and_question_listing
    user = User.find_by!(name: params.fetch(:name))
    project_activities = ActiveActivities.for(user)

    project_activity = project_activities.first

    project_questions = project_activity.project_questions.visible
    chunks = project_questions.chunk { |pq| pq.question.topic }

    presented = chunks.map do |topic, project_questions|
      project_questions = ProjectQuestion.where(id: project_questions.map(&:id))
      inner = ProjectQuestionPresenter.present(project_questions).as_json

      {
        topic_name: topic.name,
        project_questions: inner,
      }
    end

    render json: presented
  end

  def average_water_pump_depth
    project_type = ProjectType.find_by!(name: "Water pump")

    activity = Activity.find_by!(name: "Digging the hole")
    question = Question.find_by!(text: "Depth in meters")

    project_activities = ProjectActivity.where(activity: activity)
    project_questions = ProjectQuestion.where(subject: project_activities, question: question)

    average = Response.where(project_question: project_questions).select("avg(cast(value as float))")

    render json: average
  end

  def mark_workshop_as_finished
    project = Project.find(3)
    workshop = project.project_activities.first

    trigger_question = workshop.project_questions.detect do |pq|
      pq.question.text == "Is the workshop finished?"
    end

    user = User.find_by_name!(params.fetch(:name))

    params = { project_question: trigger_question, user: user, value: "yes" }

    Response.find_by(params)&.destroy
    response = Response.create!(params)

    ResponseTrigger.fire_events(response)

    render json: "ok"
  end
end
