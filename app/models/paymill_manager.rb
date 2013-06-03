class PaymillManager
  def self.transaction user, token, currency, description="New store"
        amount = (user.cart.total*100).to_i
    par = {
      amount: amount.to_s,
      currency: currency,
      token: token,
      description: description
    }
    trans = Paymill::Transaction.create(par)
    trans.response_code == 20000 ? true : false
  end
end