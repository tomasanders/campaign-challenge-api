class Api::ParticipantsController < ApplicationController
  def index
    render json: Participant.all
  end

  def create
    participant = Participant.new(participant_params)

    if participant.save
      render json: { participant: participant, message: "Signup successful" }, status: :created
    else
      render json: { errors: participant.errors.to_hash }, status: :unprocessable_entity
    end
  end

  private

  def participant_params
    params.permit(:first_name, :last_name, :email, :age, :country_code, :marketing_opt_in)
  end
end
