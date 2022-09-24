require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

    describe 'ユーザー新規登録' do
      context '新規登録できるとき' do
        it '入力項目が存在すれば登録できる' do
          expect(@user).to be_valid
        end
        it 'adminがtrueでも登録できる' do
          @user.admin = 'true'
          expect(@user).to be_valid
        end
      end
      context '新規登録できないとき' do
        it 'nameが空では登録できない' do
          @user.name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Name can't be blank")
        end
        it 'nameは全角（漢字・ひらがな・カタカナ）でないと登録できない' do
          @user.name = 'a1ｱ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Name is invalid. Input full-width characters')
        end
        it 'emailが空では登録できない' do
          @user.email ="" 
          @user.valid?
          expect(@user.errors.full_messages).to include("Email can't be blank")      
        end
        it '重複したemailが存在する場合は登録できない' do
          @user.save
          another_user = FactoryBot.build(:user)
          another_user.email = @user.email
          another_user.valid?
          expect(another_user.errors.full_messages).to include('Email has already been taken')
        end
        it 'emaiは@を含まないと登録できない' do
          @user.email = 'testmail'
          @user.valid?
          expect(@user.errors.full_messages).to include('Email is invalid')
        end
        it 'passwordが空では登録できない' do
            @user.password = ''
            @user.valid?
            expect(@user.errors.full_messages).to include("Password can't be blank")
        end
        it 'passwordが5文字以下では登録できない' do
          @user.password = '00000'
          @user.password_confirmation = '00000'
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
        end
        it 'passwordが129文字以上では登録できない' do
          @user.password = Faker::Internet.password(min_length: 129)
          @user.password_confirmation = @user.password
          @user.valid?
          expect(@user.errors.full_messages).to include("Password is too long (maximum is 128 characters)")
        end
        it 'passwordは半角数字のみでは登録できない' do
          @user.password = '111111'
          @user.password_confirmation = @user.password
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is invalid. Include both letters and numbers')
        end
        it 'passwordは半角英字のみでは登録できない' do
          @user.password = 'abcdef'
          @user.password_confirmation = @user.password
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is invalid. Include both letters and numbers')
        end  
        it 'passwordとpassword_confirmationが不一致では登録できない' do
            @user.password = '123456'
            @user.password_confirmation = '1234567'
            @user.valid?
            expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it 'adminが空では登録できない' do
          @user.admin = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Admin is not included in the list")
        end
      end
  end
end
