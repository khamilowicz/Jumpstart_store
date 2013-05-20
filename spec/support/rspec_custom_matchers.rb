# Rspec::Matchers.define :have_product do |expected|
#   match do |actual|
#     actual.should have_content(expected.title)
#   end
# end