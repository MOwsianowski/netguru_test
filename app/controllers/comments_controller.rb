class CommentsController < ApplicationController

before_action :restriction, only: [:new, :create, :show]

    def index

	    @list = Comment.where("created_at >= ?", 1.week.ago)
	    ranking = {}
        @list.each do |comment|
        	user = comment.user_id
        	if ranking.key?(user)
        		ranking[user] += 1
        	else
        		ranking[user] = 1
        	end
        end

        top10keys = ranking.sort_by { |k,v| -v }.first(10).to_h.keys
        top10values = ranking.sort_by { |k,v| -v }.first(10).to_h.values
 
	end

	def new

		@comment = Comments.new

	end
 
	def create

		@movie = Movie.find(params[:comment][:id])
		@comment = Comment.new(comment_params)
		@comment.user = current_user
		@comment.movie = @movie
		
		if @comment.save
			redirect_to movie_path(@movie)
			flash[:notice] = "Your comment was added"
		else
			flash[:notice] = "Your comment is empty or you already commented this movie. Delete your previous comment to add new one"
			redirect_to movie_path(@movie)
		end	
	end  

	def destroy

		@comment = Comment.find(params[:id])

		if current_user == @comment.user
		@comment.destroy
		flash[:notice] = "You have deleted your comment in that movie"
		redirect_to request.referrer
		else
		flash[:notice] = "Nice try"
		redirect_to root_path
		end
		
	end   

	private

	def comment_params
		params.require(:comment).permit(:text)
	end

	def restriction

		if user_signed_in? 
		@user = current_user
		else
		flash[:notice] = "Please login to add comments."
        redirect_to new_user_session_path  
      	end

	end

end