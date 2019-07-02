class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  before_validation( :on => :create ) do
    max_count = self.application.chats.collect { | chat | chat.number }.max
    if (max_count)
      self.number = max_count + 1
    else
      self.number = 1;
    end
  end

end
