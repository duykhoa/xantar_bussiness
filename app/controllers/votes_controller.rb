class VotesController < ApplicationController
  def create
    vote_params = params[:vote]
    puts vote_params
    vote = Vote.new(
      factual_id: vote_params[:factual_id],
      query: vote_params[:query]["0"].join(' '),
      place: vote_params[:place])
    response = vote.save

    render json: {status: response}
  end
end
