require "spec_helper"

describe ListItem do

	it{ should belong_to(:product)}
	it{ should belong_to(:holder)}
	it{ should validate_numericality_of(:quantity)}
	it{ should_not allow_value(0).for(:quantity)}
	it{ should_not allow_value(-1).for(:quantity)}

	context "instance" do


		let(:product){ mock_model('Product')}
		let(:list_item){ ListItem.new}

		describe "#add" do
			context "product" do

				before(:each) do
					list_item.add product: product
				end

				it "create new list item for new product on list" do
					list_item.product.should be(product)
					list_item.quantity.should eq(1)
				end

				it "increases quantity if product is already added" do
					list_item.add product: product
					list_item.product.should be(product)
					list_item.quantity.should eq(2)
				end

				it "throws error if trying to assign new product to old list_item" do
					expect{list_item.add product: mock_model("Product")}
					.to raise_error(ListItem::DiffrentProductAssignment)
				end
			end
		end

		describe "#remove" do
			context "product" do
				before(:each) do
					list_item.add product: product
				end
				it "should decrease quantity if larger than 1" do
					list_item.add product: product
					list_item.remove product: product
					list_item.quantity.should eq(1)
				end

				it "raises Empty if quantity becomes 0" do
					expect{ list_item.remove product: product}
					.to raise_error(ListItem::Empty)
				end

				it "raises ProductNotPresent if products doesn't match" do
					expect{ list_item.remove product: mock_model("Product")}
					.to raise_error(ListItem::ProductNotPresent)
				end
			end
		end
	end

	it "class .add adds new list_item if there is none with given product" do
		#MAGIC - Doesn't work in that context VVV
		product = Product.new
		product.stub(:valid? => true)
		ListItem.count.should eq(0)
		ListItem.add product: product
		ListItem.count.should eq(1)
		ListItem.first.product.should eq(product)
	end

	context "class" do
		describe ".add" do
			it "increases quanity of list_item with given product" do
				product = Product.new
				product.stub(:valid? => true)
				ListItem.add product: product
				ListItem.add product: product
				ListItem.count.should eq(1)
				list_item = ListItem.first
				list_item.quantity.should eq(2)
			end
		end

		describe ".remove" do
			let(:product){ FactoryGirl.create(:product) }
			let(:list_item){ ListItem.first }

			before(:each) do
				ListItem.add product: product
			end

			it "decreases quantity of product if there is at least 2" do
				ListItem.add product: product
				list_item.reload.quantity.should eq(2)
				ListItem.remove product: product
				list_item.reload.quantity.should eq(1)
			end

			it "removes product from list if all are removed" do
				ListItem.remove product: product
				ListItem.all.should be_empty
			end

			it 'raises error ProductNotPresent if product is not on the list' do 
				expect{ ListItem.remove product: mock_model("Product")}
				.to raise_error(ListItem::ProductNotPresent)
			end
		end
	end
end
end
