class TasksController < ApplicationController
  def index
    # Ignore the fact that this should be paginated with something like Kaminari.
    load_tasks
    @task = Task.new
  end

  # The point of the validation was to have a scenario where we go down the
  # "unhappy path" of a user story.
  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = 'Added new task'
      redirect_to :action => :index
    else
      flash[:error] = 'Failed to add new task'
      load_tasks
      render :action => :index
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    flash[:notice] = 'Removed task'
    redirect_to :action => :index
  end

  protected

  # While you could make the argument that this is an uncessary refactoring
  # I believe that the DRY principle is more important to adhere to because
  # you are defining a single source for an idea.
  #
  # I've seen bugs crop up so many times because a resource that is needed on
  # the new or edit actions isn't setup when an error occurs on the model. Doing
  # this from the get-go makes it more likely that someone will place the view's
  # dependencies in a single location.
  #
  # This is also an example of how code should be exemplary. You should strive
  # for setting up expectations for how you would like updates to proceed.
  # Obviously this will only be a general direction, we wouldn't want to
  # overdesign the solution, aka you ain't gonna need it principle (YAGNI).
  # The dark side of exemplary code leds you down the path of broken windows,
  # as mentioned in "The Pragmatic Programmer".
  def load_tasks
    @tasks = Task.all
  end
end
