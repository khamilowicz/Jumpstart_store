module OrderHelper
  def change_status_link order
    case order.status
    when 'pending'
      link_to "Cancel", order_change_status_path(order, {status: 'cancel'}) 
    when 'shipped'
      link_to "Mark as returned", order_change_status_path(order, {status: 'return'}) 
    when 'paid'
      link_to "Mark as shipped", order_change_status_path(order, {status: 'ship'}) 
    end
  end
end