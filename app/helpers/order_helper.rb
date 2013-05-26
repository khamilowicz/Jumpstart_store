module OrderHelper
  def change_status_link order
    case order.status
    when 'pending'
      link_to "Cancel" 
    when 'shipped'
      link_to "Mark as returned"
    when 'paid'
      link_to "Mark as shipped"
    end
  end
end