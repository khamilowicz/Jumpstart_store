class PaymillManager
  def transaction user, token, currency, description="New store"
        amount = user.cart.total_price.cents
    par = {
      amount: amount.to_s,
      currency: currency,
      token: token,
      description: description
    }
    trans = Paymill::Transaction.create(par)
    trans.response_code == 20000 ? true : false
  end

  def error_message
    ##TODO: paymillmanager error message
  end
end