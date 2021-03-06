module ProductsHelper
  def product_price product
    text = "<b>$#{product.price}</b>"
    if product.on_discount?
      text = "Was <strike>$#{product.base_price}</strike>. Now, only " + text
    else
      text = "Only " + text
    end
    raw text
  end

  def adding_text product
    return 'Sorry, we have no more' if product.out_of_stock?
    product.users.include?(current_user) ? "Add more" : "Add to cart"
  end

  def adding_class product
    klass = []
    klass << (product.belongs_to_user? ? 'many' : 'single')
    klass << ( product.out_of_stock? ? 'disabled' : '')
    klass.join(' ')
  end

  def quantity product
    if product.belongs_to_user?
      text = content_tag :div, class: 'quantity' do
        "#{product.quantity_for_user} in cart"
      end
    else
      ''
    end
  end

  def remove product
    text = ''
    if product.users.include?(current_user)
      text = content_tag :div, class: 'remove' do
        link_to "Remove from cart", remove_from_cart_path({user_id: current_user, product: product}), remote: true
      end
    end
    text
  end

  def saving_text product
    "You pay only #{product.discount}%!" if product.on_discount?
  end
end