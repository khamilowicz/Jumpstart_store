require 'spec_helper'

describe User do

  context "who is registered" do

    it{ should validate_confirmation_of(:password)}

    it{should allow_value('john.smith@gmail.co.uk').for(:email)}
    it{should_not allow_value('shabada').for(:email)}
    it{should validate_uniqueness_of(:email)}

    it{should validate_presence_of(:first_name)}
    it{should validate_presence_of(:last_name)}

    it{should respond_to(:address)}
    it{ should have_one(:address)}
    it{ 
      should ensure_length_of(:nick).
      is_at_least(2).
      is_at_most(32)
    }
  end

  context "who is guest" do
    subject{ User.new }
    before(:each) do
      subject.guest = true
    end

    its(:guest?){ should be_true}

    it{ should allow_value(nil).for(:email)}
    it{ should allow_value(nil).for(:last_name)}
    it{ should allow_value(nil).for(:first_name)}
  end

  describe '' do 

    context "concerning products" do

      before :each do
        @user = User.new
        @user.stub(valid?: true, guest?: true)
        @user.save
      end

      subject{ @user}

      let(:product){ Product.new.tap{|p| p.stub(valid?: true); p.quantity = 2; p.start_selling}}
      let(:product_2){ Product.new.tap{|p| p.stub(valid?: true); p.quantity = 1; p.start_selling}}
      let(:product_3){ Product.new.tap{|p| p.stub(valid?: true)}}

      let(:product_not_on_sale){ Product.new.tap{|p| p.stub(valid?: true)}}
      let(:product_2_presenter){ ProductPresenter.new product_2 }


      describe ".add product:" do
        let(:user){@user}

        its(:products){should be_empty}
        it{ 
          user.add product: product 
          user.products.
          should include(product)
        }

        it{ 
          user.add product: product_not_on_sale
          user.products.
          should_not include(product_not_on_sale)
        }

        it{ 
          user.add product: product
          user.where_product(product)
          .first.quantity.should eq(1)
        }

        it{ 
          user.add product: product_not_on_sale
          user.where_product(product_not_on_sale)
          .first.should be_nil
        }

        it "cannot add products beyond its quantity" do
          product.quantity.times{
           user.add product: product 
          }
          expect{ user.add product: product }.
          to_not change{ user.where_product(product)
          .first.quantity}
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
          it{ subject.products.should_not include(product_3)}
          it{ subject.products.should include(product, product_2)}
          # it{ subject.cart.products.should_not include(product_3)}
          # it{ subject.cart.products.should include(product, product_2)}
        end

        describe ".transfer_products" do
          let(:user_2){ User.new.tap{|u| u.stub(:valid? => true); u.save}}
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
          it{ subject.products.should_not include(product_3, product)}
          it{ subject.products.should include(product_2)}
          # it{ subject.cart.products.should_not include(product_3, product)}
          # it{ subject.cart.products.should include(product_2)}

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
              }.to change{ProductPresenter.new(product_2).quantity_in_warehouse}.by(1)
            end
          end
        end
    end
    
    context "concerning status" do
      it{ expect{ subject.promote_to_admin}.to change{ subject.admin?}.from(false).to(true)}
    end
  end
end