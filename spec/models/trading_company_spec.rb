require 'rails_helper'

RSpec.describe TradingCompany, type: :model do
  before do
    @trading_company = FactoryBot.build(:trading_company)
  end

    describe '商社新規登録' do
      context '新規登録できるとき' do
        it '入力項目が存在すれば登録できる' do
          expect(@trading_company).to be_valid
        end
      end
      context '新規登録できないとき' do
        it 'tc_nameが空では登録できない' do
          @trading_company.tc_name = ''
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include("Tc name can't be blank")
        end
        it 'tc_contact_personが空では登録できない' do
          @trading_company.tc_contact_person = ''
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include("Tc contact person can't be blank")
        end
        it '電話番号が空だと保存できないこと' do
          @trading_company.tc_telephone = ''
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include("Tc telephone can't be blank")
        end
        it '電話番号は、10桁以上11桁以内の半角数値以外を含んだものでは保存できないこと' do
          @trading_company.tc_telephone = '012345678-9'
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include('Tc telephone is invalid')
        end
        it '電話番号は、9桁以下の半角数値では保存できないこと' do
          @trading_company.tc_telephone = '012345678'
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include('Tc telephone is invalid')
        end
        it '電話番号は、12桁以上の半角数値では保存できないこと' do
          @trading_company.tc_telephone = '012345678901'
          @trading_company.valid?
          expect(@trading_company.errors.full_messages).to include('Tc telephone is invalid')
        end
      end
    end
end
