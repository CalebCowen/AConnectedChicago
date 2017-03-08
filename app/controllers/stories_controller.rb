class StoriesController < ApplicationController
  def new
    @story = Story.new
  end

  def create
    @story = current_user.stories.create(story_params)
    current_user.neighborhood.stories << @story
    if @story.save
      flash[:success] = "Your Story has been sent to a Community Leader for approval."
      redirect_to user_path(current_user)
    else
      flash[:error] = "Invalid info"
      render :new
    end
  end

  private

  def story_params
    params.require(:story).permit(:title,
                                  :author,
                                  :description,
                                  :address,
                                  :body)
  end
end