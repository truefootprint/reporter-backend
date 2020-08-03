if @programme && @project
	json.programme_name @project.programme.name
	json.programme_id @project.programme.id
	json.project_name @project.name
	json.project_id @project.id

	json.activity @project.project_activities do |project_activity|
	  json.project_activity_name project_activity.name
	  json.project_activity_graphs project_activity.project_questions do | project_question |
	    json.question_text project_question.text
	    json.question_id project_question.id
	    if project_question.type == "MultiChoiceQuestion"
	    	json.question_reponses_graph project_question.multi_choice_project_question_graph(@startDate, @endDate)
	    elsif project_question.type == "FreeTextQuestion"
	    	json.question_reponses_graph project_question.free_test_project_question_graph(@startDate, @endDate)
	    #elsif project_question.type == "PhotoUploadQuestion"
	    #	json.question_reponses_graph project_question.photo_upload_project_question_graph(@startDate, @endDate)
	    end
	  end
	end
elsif @programme
	json.programme_name @programme.name
	json.programme_id @programme.id
	json.project_name "(Data from all projects in programme)"
	json.project_id 99
	json.activity ["@project.project_activities"] do |project_activity|
	  json.project_activity_name "------"
	  json.project_activity_graphs @programme.questions do | question |
	    json.question_text question.text
	    json.question_id question.id
	    if question.type == "MultiChoiceQuestion"
	    	json.question_reponses_graph question.multi_choice_options_hash(@startDate, @endDate, @programme.project_questions)
	    end
	  end
	end
end