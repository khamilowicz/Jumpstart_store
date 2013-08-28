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

  def order_link user
      if user.guest?
        "You need to log in to purchase products"
      else
        link_to 'Order', new_order_path, class: 'btn btn-primary'
      end
  end
end