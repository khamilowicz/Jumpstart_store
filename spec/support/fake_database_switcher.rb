# class FakeDatabaseSwitcher
#   class << self
#     def save klass, collection
#       klass.send "add_to_#{klass.to_s.downcase}s", collection
#     end
#   end
# end