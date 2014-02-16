class CommentsController < ApplicationController
  def create
    @comment = Comment.create(factual_id: params[:factual_id], content: params[:content])

    render partial: 'comment'
  end
end
