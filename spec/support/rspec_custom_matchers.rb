RSpec::Matchers.define :have_short_product do |product|
  match_for_should do |page_content|
   selector = ".product.#{product.title_param}" 
   page_content.should have_selector(selector)
   within(selector){
    page_content.should have_content(product.title)
  }
end

end

RSpec::Matchers.define :have_inline_order do |order|
  match do |page_content|
    page_content.should have_content(order.created_at.strftime("%e %b %Y"))
  end
end

RSpec::Matchers.define :have_inline_product do |product|
  match do |page_content|
    selector = ".product.inline.#{product.title_param}" 
    page_content.should_not have_selector(selector)
    within(selector){
      page_content.should have_content(product.title)
    }
  end
end

RSpec::Matchers.define :have_review do |review|
  match do |page_content|
    within('.review'){
      page_content.should have_selector('.reviewer', text: review.reviewer.to_s)
      page_content.should have_selector('.title', text: review.title)
      page_content.should have_selector('.body', text: review.body)
      page_content.should have_note(review.note)
    }
  end

  failure_message_for_should do |page_content|
    "Expected #{page_content.find('.review').native} to have #{review.reviewer}, #{review.title}, #{review.body} and #{review.note} stars"
  end
end

RSpec::Matchers.define :have_note do |note|
  match do |page_content|
    within(".note"){
      page_content.all(".star").size.should == 5
      page_content.all(".star.full").size.should == note.ceil

      if note.round != note
        page_content.all(".star.half").size.should == 1 
      else
        page_content.all(".star.half").size.should == 0
      end
    }
  end
end

RSpec::Matchers.define :have_short_order do |order|
  match do |page_content|
    page_content.should have_selector(".order")
    within('.order'){
      page_content.should have_content(order.date_of_purchase.strftime("%e %b %Y"))
      page_content.should have_content(order.total_price)
      page_content.should have_link("Show")
    }
  end

  failure_message_for_should do |page_content|
    "Expected #{page_content.find(".order").native} to have #{order.date_of_purchase}, #{order.total_price}, and link 'Show order'"
  end
end

RSpec::Matchers.define :show_its_content do 
  match do |page_content|
    page_content.should == 'lolo'
  end

  failure_message_for_should do |page_content|
    "#{page_content.find("body").native}"
  end
end

RSpec::Matchers.define :include_products do |*products|
  match do |arr|
    titles = arr.collect(&:title)
    products.collect(&:title).each do |title|
      titles.include?(title).should be_true
    end
  end
  
end
