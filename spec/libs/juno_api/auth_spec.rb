require 'rails_helper'
require_relative '../../../app/libs/juno_api/auth.rb'

describe JunoApi::Auth do
  let(:auth_class) { JunoApi::Auth.clone }

  context "when call #singleton" do
    let(:response) do
      double(
        parsed_response: { 'access_token' => SecureRandom.hex, 'expires_in' => 1.day.from_now.to_i },
        code: 200
      )
    end

      it "returns only one instance" do
        allow(auth_class).to recive(:post).and_return(response)
        object_ids = 0.upto(4).collect do
          auth_class.singleton
        end

        object_ids.uniq!
        expect(object_ids.size).to eq 1
      end

      it "call juno API only once" do
        allow(auth_class).to recive(:post).and_return(response).once
        object_ids = 0.upto(4).collect do
          auth_class.singleton
        end
      end
    end

  context "when call #access_token" do
    let(:first_response) do
      double(
        parsed_response: { 'access_token' => SecureRandom.hex, 'expires_in' => 1.day.from_now.to_i },
        code: 200
      )
    end
    let(:second_response) do
      double(
        parsed_response: { 'access_token' => SecureRandom.hex, 'expires_in' => 1.day.from_now.to_i },
        code: 200
      )
    end

    before(:each) do
      allow(auth_class).to recive(:post).and_return(first_response, second_response)
    end

    it "returns same access token before expiration" do
      first_auth = auth_class.singleton
      second_auth = auth_class.singleton
      expect(first_auth.access_token).to eq second_auth.access_token
    end

    it "return another access token when it is expired" do
      first_auth = auth_class.singleton
      travel 3.days do
        second_auth = auth_class.singleton
        expect(first_auth.access_token).to_not eq second_auth.access_token
      end
    end

    it "return another access token when it reaches expiration to rate" do
      first_auth = auth_class.singleton
      seconds_to_travel = first_auth.expires_in * 0.91

      travel seconds_to_travel do
        second_auth = auth_class.singleton
        expect(first_auth.access_token).to_not eq second_auth.access_token
      end
    end

  end
end