require 'rails_helper'

RSpec.describe "Admin::V1::Licenses as without authentication", type: :request do
  let(:game) { create(:game) }

  context "GET /games/:game_id/licenses" do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }
    let!(:categories) { create_list(:license, 5, game: game) }

    before(:each) { get url }
    include_examples "unauthenticated access"
  end
  
  context "GET /categories/:id" do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/categories/#{license.id}" }

    before(:each) { get url }
    include_examples "unauthenticated access"
  end
  


  context "POST /games/:game_id/licenses" do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }

    before(:each) { post url }
    include_examples "unauthenticated access"
  end

  context "PATCH /categories/:id" do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/categories/#{license.id}" }

    before(:each) { patch url }
    include_examples "unauthenticated access"
  end

  context "DELETE /categories/:id" do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/categories/#{license.id}" }

    before(:each) { delete url }
    include_examples "unauthenticated access"
  end
end