class CardController < ApplicationController
  require "payjp"
  before_action :set_card

  def new  # カード登録
    card = Card.where(user_id: current_user.id)
    redirect_to action: "index" if card.present?
  end

  def create # payjpとCardのデータベースを作成
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]

    if params['payjp-token'].blank?
      redirect_to action: "new"
    else

      customer = Payjp::Customer.create(
        description: 'test',
        email: current_user.email,
        card: params['payjp-token'],
        metadata: {user_id: current_user.id}
      )
    @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
    if @card.save
      redirect_to action: "index"
    else
      redirect_to action: "create"
    end
  end
end
  
private

  def set_card
    @card = Card.find_by(user_id: current_user.id) if Card.where(user_id: current_user.id).present?
  end
end


#   def delete # カード削除
#     card = Card.find_by(user_id: current_user.id)
#     if card.blank?
#     else
#       Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
#       customer = Payjp::Customer.retrieve(card.customer_id)
#       customer.delete
#       card.delete
#     end
#     redirect_to action: "new"
#   end
  
#   def show # カード情報
#     card = Card.find_by(user_id: current_user.id)
#     if card.blank?
#       redirect_to action: "new" 
#     else
#       Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
#       customer = Payjp::Customer.retrieve(card.customer_id)
#       @default_card_information = customer.cards.retrieve(card.card_id)
#     end
#   end
# end















# def pay 
#   Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
#   if params['payjp-token'].blank?
#     redirect_to action: "new"
    
#   else
#     customer = Payjp::Customer.create(
#       description: '登録テスト', 
#       email: current_user.email, 
#       card: params['payjp-token'],
#       metadata: {user_id: current_user.id}
#       )
#     @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
#     if @card.save
#       redirect_to action: "show"
#     else
#       redirect_to action: "pay"
#     end
#   end
# end