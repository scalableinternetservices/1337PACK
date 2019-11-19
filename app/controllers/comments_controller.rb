class CommentsController < ApplicationController
    # do :set_comment function only just before show, edit ... actions
    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    # allow following to diable authentification
    skip_before_action :verify_authenticity_token

    # POST /comment
    def create
        # require event_id, check if there is current user
        @comment = Comment.new(comment_params.merge({user_id: comment_params[:user_id]}))
        if @comment.save
            render json: @comment, status: :created
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    # GET /comments
    def index
        if comment_params.key?("event_id")
            to_render = Comment.where(event_id: comment_params[:event_id]).order("created_at ASC")
        else
            to_render = Comment.all
        end
        render json: to_render
    end

    # GET /comments/{id}
    def show
        to_render = [Comment.find(comment_params[:id])]
        to_render += Comment.where(parent_id: comment_params[:id]).order("created_at ASC")
        render json: to_render
    end

    # update content if failed show error message
    # PUT/Patch /comments/{id}
    def update
        if @comment.update(comment_params)
            head :no_content
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    # DELETE /comments/{id}
    def destroy
        if @comment.destroy
            Comment.where(parent_id: comment_params[:id]).destroy_all
            head :no_content
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    private
        def set_comment
            @comment = Comment.find(comment_params[:id])
        end

        def comment_params
            # params needed for create a comment
            params.permit(:id, :event_id, :user_id, :user_name, :content, :parent_id)
        end
end
