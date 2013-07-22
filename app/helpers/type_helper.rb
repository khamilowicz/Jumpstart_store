module TypeHelper

  def collection_from_known collection, known
    collection.map{|c| known.include?(c) ? [true, c] : [false, c]}
  end

  def check_it collection, item
    Array(collection).include?(item)
  end
end