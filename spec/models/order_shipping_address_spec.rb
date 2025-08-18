require 'rails_helper'

RSpec.describe OrderShippingAddress, type: :model do
  describe '購入情報の保存' do
    # letを使用して、各テストの独立性を高め、状態のリークを防ぎます。
    let(:seller) { FactoryBot.create(:user) }
    let(:buyer) { FactoryBot.create(:user) }
    let(:item) { FactoryBot.create(:item, user: seller) }
    # テスト対象のオブジェクトもletで定義します。
    let(:order_shipping_address) { FactoryBot.build(:order_shipping_address, user_id: buyer.id, item_id: item.id) }

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(order_shipping_address).to be_valid
      end
      it 'buildingは空でも保存できること' do
        order_shipping_address.building = ''
        expect(order_shipping_address).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'tokenが空では登録できないこと' do
        order_shipping_address.token = nil
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Token can't be blank")
      end
      it 'postcodeが空だと保存できないこと' do
        order_shipping_address.postcode = ''
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Postcode can't be blank")
      end
      it 'postcodeが半角のハイフンを含んだ正しい形式でないと保存できないこと' do
        order_shipping_address.postcode = '1234567'
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include('Postcode is invalid. Include hyphen(-)')
      end
      it 'prefecture_idを選択していないと保存できないこと' do
        order_shipping_address.prefecture_id = 1
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'cityが空だと保存できないこと' do
        order_shipping_address.city = ''
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("City can't be blank")
      end
      it 'blockが空だと保存できないこと' do
        order_shipping_address.block = ''
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Block can't be blank")
      end
      it 'phone_numberが空だと保存できないこと' do
        order_shipping_address.phone_number = ''
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが9桁以下だと保存できないこと' do
        order_shipping_address.phone_number = '090123456'
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include('Phone number is invalid. Input only number')
      end
      it 'phone_numberが12桁以上だと保存できないこと' do
        order_shipping_address.phone_number = '090123456789'
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include('Phone number is invalid. Input only number')
      end
      it 'phone_numberに半角数字以外が含まれている場合は保存できないこと' do
        order_shipping_address.phone_number = '090-1234-5678'
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include('Phone number is invalid. Input only number')
      end
      it 'userが紐付いていないと保存できないこと' do
        order_shipping_address.user_id = nil
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("User can't be blank")
      end
      it 'itemが紐付いていないと保存できないこと' do
        order_shipping_address.item_id = nil
        order_shipping_address.valid?
        expect(order_shipping_address.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end