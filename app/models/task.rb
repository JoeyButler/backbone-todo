class Task < ActiveRecord::Base
  attr_accessible :completed_at, :content

  # I wanted to demonstrate the use of at least one validation.
  validates :content, :presence => {:message => 'Tasks cannot be blank'}
end
