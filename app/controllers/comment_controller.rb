class CommentController < ApplicationController
  include ApplicationHelper

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
    #puts "-- START ------------------"
    #puts params
    @career = Career.find(params[:career_id])
    @politician = @career.politician

    # clean up dangerous html elements
    comment_html = Sanitize.clean(params[:pol_image][:comment], Sanitize::Config::RELAXED)

    @comment = Comment.new(comment: comment_html, user_id: current_user.id)

    @parent_comment = nil
    if params.has_key?(:parent_comment_id)
      @parent_comment = Comment.find(params[:parent_comment_id])
    end

    # image
    @new_image = nil
    #@image = PolImage.new
    if params[:pol_image].has_key?(:remote_file_url) && !params[:pol_image][:remote_file_url].blank?
      @new_image = PolImage.new
      @new_image.remote_file_url = params[:pol_image][:remote_file_url]
    elsif params[:pol_image].has_key?(:file) && !params[:pol_image][:file].blank?
      @new_image = PolImage.new
      @new_image.file = params[:pol_image][:file]
    end

    # link_url
    @external_link = nil
    if params.has_key?(:link_url) && !params[:link_url].blank?
      og_data = http_get_og_data(params[:link_url])

      #{ images: all_imgs, title: subject, desc: og_desc, link: url }
      @external_link = ExternalLink.new(link_url: params[:link_url], image_url: (og_data[:images].nil? || og_data[:images].empty? ? "" : og_data[:images].first), title: og_data[:title], description: og_data[:desc])
    end

    Comment.transaction do

      if !@new_image.nil?
        @new_image.save
        @comment.pol_image = @new_image
      end

      @comment.save
      @career.add_comment(@comment)

      if !@parent_comment.nil?
        @parent_comment.add_child @comment
      end

      if !@external_link.nil?
        @external_link.comment = @comment
        @external_link.save
      end

      flash[:notice] = "Comment successfully created."
    end

    redirect_to listing_path(@politician.id)
  end

end