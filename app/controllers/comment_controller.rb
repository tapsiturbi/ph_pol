class CommentController < ApplicationController
  # Show either all comments or all replies under a comment
  # - can pass either Comment.id (:id) or Career.id(:career_id)
  def show
    # show all posts of career
    if params.has_key?(:career_id)
      @career = Career.find(params[:career_id])
      @comments = @career.posts(nil)
      @target_comment = nil

    # show all replies of a comment
    elsif params.has_key?(:id)
      @target_comment = Comment.find(params[:id])
      if @target_comment.commentable_type != "Career"
        raise
      end

      @career = Career.find(@target_comment.commentable_id)
      @comments = @target_comment.hash_tree
    end

    if current_user.present?
      @user_votes = current_user.get_votes_of_pol(@career.politician.id)
    end

    @hide_lowscores = params.has_key?(:hide_lowscores) && params[:hide_lowscores] == "0" ? false : true;
  end

  # Create comment - called via AJAX from listing#show
  def create
    @career = Career.find(params[:career_id])
    @politician = @career.politician

    # clean up dangerous html elements
    comment_html = Sanitize.clean(params[:comment][:comment], Sanitize::Config::RELAXED)

    @comment = Comment.new(comment: comment_html, user_id: current_user.id)

    @parent_comment = nil
    if params.has_key?(:parent_comment_id)
      @parent_comment = Comment.find(params[:parent_comment_id])
    end

    Comment.transaction do
      @comment.save
      @career.add_comment(@comment)

      if !@parent_comment.nil?
        @parent_comment.add_child @comment
      end

      flash[:notice] = "Comment successfully created."
    end
  end

end