module OrderHelper
  def change_status_link order
    case order.status
    when 'pending'
      link_to "Cancel", change_order_status_path(order, 'cancel') 
    when 'shipped'
      link_to "Mark as returned", change_order_status_path(order, 'return') 
    when 'paid'
      link_to "Mark as shipped", change_order_status_path(order, 'ship') 
    end
  end
end