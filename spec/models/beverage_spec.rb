require 'spec_helper'

describe Beverage do

  describe ".brew" do

    let(:user) { User.new(primary_nick: "nick_primary") }

    it "returns a singleton message if there is already a beverage with that name" do
      allow(user).to receive_message_chain(:beverages, :already_exists?) { true }
      expect(Beverage.brew("black coffee in bed", user)).to eq(Util::Constants::THERE_CAN_BE_ONLY_ONE)
    end

    it "returns an encumberance message if the brewer has too much stuff" do
      allow(user).to receive(:can_brew?) { false }
      expect(Beverage.brew("black coffee in bed", user)).to eq(Util::Constants::THATS_ENOUGH_DONTCHA_THINK)
    end

    it "creates a beverage for the user" do
      allow(user).to receive_message_chain(:beverages, :create) { Beverage.new }
      allow(user).to receive_message_chain(:beverages, :already_exists?) { false }
      allow(user).to receive(:can_brew?)  { true }
      expect(Util::Randomizer).to receive(:brew_observation)
      Beverage.brew("black coffee in Moscow", user)
    end

    it "returns an error message if something breaks along the way" do
      allow(user).to receive_message_chain(:beverages, :create) { false }
      allow(user).to receive_message_chain(:beverages, :already_exists?) { false }
      allow(user).to receive(:can_brew?)  { true }
      expect(Beverage.brew("black coffee in Moscow", user)).to eq(Util::Constants::UH_OH)
    end

  end

end
