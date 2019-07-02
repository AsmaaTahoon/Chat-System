class ApplicationSerializer < ActiveModel::Serializer
  attributes :name, :token, :chatsCount
end
