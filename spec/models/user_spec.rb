require 'spec_helper'

describe User do

  subject{ FactoryGirl.create(:user, :logged) }

  it{should respond_to(:address)}

  context "who is registered" do

    it{ should validate_confirmation_of(:password)}

    it{should allow_value('john.smith@gmail.co.uk').for(:email)}
    it{should_not allow_value('shabada').for(:email)}
    it{should validate_uniqueness_of(:email)}

    it{should validate_presence_of(:first_name)}
    it{should validate_presence_of(:last_name)}

    it{ should have_one(:address)}

  end

  context "who is guest" do
    subject{ User.create_guest}

    its(:guest?){ should be_true}

    it{ should allow_value(nil).for(:email)}
    it{ should allow_value(nil).for(:last_name)}
    it{ should allow_value(nil).for(:first_name)}

  end

  it{ 
    should ensure_length_of(:nick).
    is_at_least(2).
    is_at_most(32)
  }

  context "concerning products" do
    subject{FactoryGirl.create(:user, :guest)}

    let(:product){ FactoryGirl.create(:product, :on_sale, quantity: 2) }
    let(:product_not_on_sale){ FactoryGirl.create(:product, on_sale: false) }
    let(:product_2){ FactoryGirl.create(:product) }
    let(:product_2_presenter){ ProductPresenter.new product_2 }
    let(:product_3){ FactoryGirl.create(:product) }

    describe ".add product:" do
      its(:products){should be_empty}
      it{ 
        subject.add product: product 
        subject.products.
        should include(product)
      }

      it{ 
        subject.add product: product_not_on_sale
        subject.products.
        should_not include(product_not_on_sale)
      }

      it{ 
        expect{ subject.add product: product}.
        to change{ ProductUser.quantity subject, product}.
        from(0).
        to(1)
      }

      it{ 
        expect{ subject.add product: product_not_on_sale}.
        to_not change{ProductUser.quantity subject, product_not_on_sale}.
        by(1)
      }

      it "cannot add products beyond its quantity" do
        product.quantity.times{
          expect{ subject.add product: product }.
          to change{ ProductUser.quantity subject, product}.
          by(1)
        }
        expect{ subject.add product: product }.
        to_not change{ ProductUser.quantity subject, product}.
        by(1)
      end
    end

    context "which he has" do
      before(:each) do
        subject.add product: product
        subject.add product: product_2
      end

      its(:products){should_not include(product_3)}
      its(:products){should include(product, product_2)}

      describe ".cart" do
        it{ subject.cart.products.should_not include(product_3)}
        it{ subject.cart.products.should include(product, product_2)}
      end

      describe ".transfer_products" do
        let(:user_2){ FactoryGirl.create(:user)}
        before(:each) do
          User.transfer_products from: subject, to: user_2
        end
        its(:products){ should be_empty}
        it{ user_2.products.should include(product, product_2)}
        
      end

      describe ".remove product" do 
        before(:each) do
          subject.remove product: product
         end

        its(:products){should_not include(product)}
        its(:products){should include(product_2)}
        it{ subject.cart.products.should_not include(product_3, product)}
        it{ subject.cart.products.should include(product_2)}

        describe "many times" do

          before do
            subject.add product: product
            subject.add product: product

            subject.remove product: product
            subject.remove product: product_2
          end

          its(:products){ should eq([product])}
        end

        it "returns product to magazine" do
          expect{ subject.remove product: product_2
            }.to change{ProductPresenter.new(product_2).quantity_in_magazine}.by(1)
          end
        end
      end

      # context "concerning orders" do
      #   it{ 
      #     expect{subject.make_purchase}.
      #     to change{subject.orders.size}.
      #     from(0).
      #     to(1)
      #   }
      # end
    end
    
    context "concerning status" do
      it{ expect{ subject.promote_to_admin}.to change{ subject.admin?}.from(false).to(true)}
    end
  end