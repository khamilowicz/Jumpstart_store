module PresenterHelper
  def presentify collection
    klass = Array(collection).first.class.to_s + 'Presenter'
    if klass != 'NilClassPresenter' && klass.constantize
      method = 'new_from_array'
      klass.constantize.send method, collection
    end
  end
end