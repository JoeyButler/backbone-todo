# I tend to export the RUBYOPT environment variable with -Ispec.
# E.g. `RUBYOPT=-Ispec`
require_relative '../spec_helper'

# Write a comment about Cucumber tests and when they are appropriate.
describe 'Tasks' do
  describe 'GET /tasks' do

    it 'displays all of the tasks' do
      task = Task.create!(:content => 'lorem ipsum')
      visit tasks_path
      page.should have_content('lorem ipsum')
    end

    # TODO: Add test for displaying the "completed" status for a task.
  end

  describe 'POST /tasks' do
    it 'creates a new task' do
      visit tasks_path
      within '#new_task' do
        fill_in 'task_content', :with => 'a new task'
      end
      click_on 'Add'
      page.should have_content 'Added new task'
      find('#tasks').should have_content 'a new task'
    end

    it 'displays feedback to the user if the task creation failed' do
      visit tasks_path
      within '#new_task' do
        fill_in 'task_content', :with => ''
      end
      click_on 'Add'
      page.should have_content 'Failed to add new task'

      # IMO the most natural language to use here is 'Tasks cannot be blank',
      # as opposed to 'Content cannot be blank'. In order to achieve this I
      # updated the locale definition in `config/locales/en.yml`.
      # More details: http://stackoverflow.com/questions/808547/fully-custom \
      # -validation-error-message-with-rails
      find('#new_task').should have_content 'Tasks cannot be blank'
      find('#tasks').should_not have_content 'a new task'
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'removes the task from the list' do
      task = Task.create!(:content => 'delete me')
      visit tasks_path
      page.has_css? '#tasks a.delete-task'
      # Since we aren't running the javascript driver we need to send the DELETE
      # request manually.
      # delete task_path(task)
      page.driver.submit :delete, "/tasks/#{task.id}", {}
      page.should have_content 'Removed task'
      page.should_not have_content 'delete me'
    end
  end

end

