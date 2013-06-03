module ProductsHelper
  def product_price product
    text = "$#{product.price}"
    if product.price != product.base_price
      text = "$#{product.base_price}, only" + text
    end
    raw text
  end

  def adding_text product
    if product.users.include?(current_user)
      "Add more"
    else
      "Add to cart"
    end
  end

  def quantity product
    text = ''
    if product.users.include?(current_user)
      text = content_tag :div, class: 'quantity' do
        "#{product.quantity_for(current_user)} in cart"
      end
    end
    text
  end

def remove product
  text = ''
  if product.users.include?(current_user)
    text = content_tag :div, class: 'remove' do
      link_to "Remove from cart", remove_from_cart_user_product_path(current_user, product), remote: true 
    end
  end
  text
end

def saving_text product
  "You save #{(100*(product.base_price - product.price)/product.base_price).round.to_i}%!" if product.price != product.base_price
end
end