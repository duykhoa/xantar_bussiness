class PromotionsController < ApplicationController
  def create
    promotion_params = params[:promotion]
    promotion = Promotion.new(factual_id: promotion_params[:factual_id], query: promotion_params[:query]["0"].join(' '))
    promotion.save!

    render nothing: true
  end
end
