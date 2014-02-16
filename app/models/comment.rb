class Comment < ActiveRecord::Base
  default_scope { order('created_at desc') }
end
