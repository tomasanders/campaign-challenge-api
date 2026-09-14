class Api::ScoresController < ApplicationController
  def index
    participant = Participant.find_by(id: params[:participant_id])
    score = participant&.score

    if score
      render json: { score: score }
    else
      head :not_found
    end
  end

  def create
    participant = Participant.find_by(id: params[:participant_id])

    unless participant
      return render_error(:participant, "does not exist")
    end

    if participant.created_at < 24.hours.ago
      return render_error(:participant, "is no longer eligible")
    end

    if participant.score.present?
      return render_error(:participant_id, "has already submitted a score")
    end

    score = participant.build_score(score_params)

    if score.save
      render json: { score: score }, status: :created
    else
      render json: { errors: score.errors.to_hash }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render_error(:participant, "has already submitted a score")
  end

  private

  def score_params
    params.permit(:score, :duration_ms)
  end

  def render_error(field, message)
    render json: { errors: { field => [ message ] } }, status: :unprocessable_entity
  end
end
