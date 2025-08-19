require 'rails_helper'

RSpec.describe User, type: :model do
  # `before`とインスタンス変数`@user`の代わりに`let`を使用します。
  # これでコードがクリーンになり、テストデータは必要な時にだけ生成されます。
  let(:user) { build(:user) }

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'すべての項目が正しく入力されていれば登録できる' do
        expect(user).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'nicknameが空では登録できない' do
        user.nickname = ''
        user.valid?
        expect(user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'emailが空では登録できない' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include("Email can't be blank")
      end

      it '重複したemailが存在する場合は登録できない' do
        user.save
        another_user = build(:user, email: user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'emailは@を含まないと登録できない' do
        user.email = 'testmail'
        user.valid?
        expect(user.errors.full_messages).to include('Email is invalid')
      end

      it 'passwordが空では登録できない' do
        user.password = ''
        user.valid?
        expect(user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが5文字以下では登録できない' do
        user.password = '1a2b3' # 5文字
        user.password_confirmation = '1a2b3'
        user.valid?
        expect(user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが129文字以上では登録できない' do
        # Faker::Internet.passwordはエラーになるため、単純な文字列生成に修正
        user.password = Faker::Alphanumeric.alphanumeric(number: 129)
        user.password_confirmation = user.password
        user.valid?
        expect(user.errors.full_messages).to include('Password is too long (maximum is 128 characters)')
      end

      it 'passwordが半角英字のみでは登録できない' do
        user.password = 'abcdef'
        user.password_confirmation = 'abcdef'
        user.valid?
        expect(user.errors.full_messages).to include('Password には英字と数字の両方を含めて設定してください')
      end

      it 'passwordが半角数字のみでは登録できない' do
        user.password = '123456'
        user.password_confirmation = '123456'
        user.valid?
        expect(user.errors.full_messages).to include('Password には英字と数字の両方を含めて設定してください')
      end

      it 'passwordに全角文字が含まれていると登録できない' do
        user.password = 'ａａａ１１１'
        user.password_confirmation = 'ａａａ１１１'
        user.valid?
        expect(user.errors.full_messages).to include('Password には英字と数字の両方を含めて設定してください')
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        user.password = '1a2b3c'
        user.password_confirmation = '1a2b3d' # 不一致な値
        user.valid?
        expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'last_nameが空では登録できない' do
        user.last_name = ''
        user.valid?
        expect(user.errors.full_messages).to include("Last name can't be blank")
      end

      it 'last_nameが半角では登録できない' do
        user.last_name = 'yamada'
        user.valid?
        expect(user.errors.full_messages).to include('Last name 全角文字を使用してください')
      end

      it 'first_nameが空では登録できない' do
        user.first_name = ''
        user.valid?
        expect(user.errors.full_messages).to include("First name can't be blank")
      end

      it 'first_nameが半角では登録できない' do
        user.first_name = 'taro'
        user.valid?
        expect(user.errors.full_messages).to include('First name 全角文字を使用してください')
      end

      it 'last_name_kanaが空では登録できない' do
        user.last_name_kana = ''
        user.valid?
        expect(user.errors.full_messages).to include("Last name kana can't be blank")
      end

      it 'last_name_kanaが全角カタカナ以外では登録できない' do
        user.last_name_kana = 'やまだ' # ひらがな
        user.valid?
        expect(user.errors.full_messages).to include('Last name kana 全角カタカナを使用してください')
      end

      it 'first_name_kanaが空では登録できない' do
        user.first_name_kana = ''
        user.valid?
        expect(user.errors.full_messages).to include("First name kana can't be blank")
      end

      it 'first_name_kanaが全角カタカナ以外では登録できない' do
        user.first_name_kana = 'たろう' # ひらがな
        user.valid?
        expect(user.errors.full_messages).to include('First name kana 全角カタカナを使用してください')
      end

      it 'birth_dateが空では登録できない' do
        user.birth_date = ''
        user.valid?
        expect(user.errors.full_messages).to include("Birth date can't be blank")
      end
    end
  end
end