require "spec_helper"

describe Address do

  it{ should respond_to(:country)}
  it{ should respond_to(:city)}
  it{ should respond_to(:zip_code)}
  it{ should respond_to(:street)}
  it{ should respond_to(:house_nr)}
  it{ should respond_to(:door_nr)}

  it{ should validate_numericality_of(:zip_code)}
  it{ should_not allow_value(-1).for(:zip_code)}

  it{ should validate_numericality_of(:house_nr)}
  it{ should_not allow_value(-1).for(:house_nr)}

  it{ should validate_numericality_of(:door_nr)}
  it{ should_not allow_value(-1).for(:door_nr)}

  it{ should belong_to(:user)} 

  describe "to_s" do
    let(:address){ Address.create({
      country: "USA",
      city: "Washington",
      zip_code: "80130",
      street: "Pensylwania",
      house_nr: "10",
      door_nr: "15"
      })}

      it{ "#{address}".should eq("USA 80-130 Washington Pensylwania 10/15")}
    end
  end