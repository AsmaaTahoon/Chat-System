require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :chat

  before_validation( :on => :create ) do
    max_count = self.chat.messages.collect { | message | message.number }.max
    if (max_count)
      self.number = max_count + 1
    else
      self.number = 1;
    end
  end

end
# Message.__elasticsearch__.create_index!
Message.import force: true
