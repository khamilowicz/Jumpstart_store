module PresenterHelper

  def presentify *collection
    #why (collection.first).first? in case of active::relation, otherwise gives me relation instead of real thing
    klass = Array(collection.first).first.class.to_s + 'Presenter'
    if klass != 'NilClassPresenter' && klass.constantize
      method = 'new_from_array'
      return klass.constantize.send method, *collection
    end
    collection.first
  end
end