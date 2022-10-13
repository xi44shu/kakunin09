require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "TradingCompanies", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @trading_company = FactoryBot.build(:trading_company)
  end

  context '商社の新規登録ができるとき'do
    it 'ログインしたユーザーは商社新規登録できる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 商社一覧ページへのボタンがあることを確認する
      expect(page).to have_content('商社一覧')
      # 商社一覧ページへのボタンを押す
      click_link '商社一覧'      
      # 商社一覧ページに遷移する
      expect(current_path).to eq(trading_companies_path)
      # 新しく商社を登録ページへのボタンがあることを確認する
      expect(page).to have_content('新しく商社を登録')
      # 新しく商社を登録ページへのボタンを押す
      click_link '新しく商社を登録'      
      # 作成ページに遷移する
      expect(current_path).to eq(new_trading_company_path)
      # フォームに情報を入力する
      fill_in 'trading_company_tc_name', with: @trading_company.tc_name
      fill_in 'trading_company_tc_contact_person', with: @trading_company.tc_contact_person
      fill_in 'trading_company_tc_telephone', with: @trading_company.tc_telephone
      # 送信するとTradingCompanyモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { TradingCompany.count }.by(1)
      # 商社一覧ページに遷移する
      expect(current_path).to eq(trading_companies_path)
      # 商社一覧ページには先ほど作成した商社が存在することを確認する
      expect(page).to have_content(@trading_company_tc_name)
    end
  end
  context '商社登録ができないとき'do
    it 'ログインしていないと商社一覧ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 商社一覧ページへのボタンがないことを確認する
      expect(page).to have_no_content('商社一覧')
    end
  end
end

RSpec.describe "編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @trading_company = FactoryBot.create(:trading_company)
  end

  context '商社の編集ができるとき'do
    it 'ログインしたユーザーは商社の編集ができる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      # 商社一覧ページに遷移する
      visit trading_companies_path
      # 商社の編集ページへのリンクがあることを確認する
      expect(page).to have_content('編集')
      # 商社の編集ページへのリンクを押す
      click_link '編集'      
      # フォームに情報を入力する
      fill_in 'trading_company_tc_name', with: @trading_company.tc_contact_person
      fill_in 'trading_company_tc_contact_person', with: @trading_company.tc_name
      # 編集してもTradingCompanyモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { TradingCompany.count }.by(0)
    end
  end
  context '商社の編集ができないとき'do
    it 'ログインしていないと商社一覧ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 商社一覧ページへのボタンがないことを確認する
      expect(page).to have_no_content('商社一覧')
    end
    it 'ログインしていないと商社編集ページに遷移できない' do
      # 商社編集ページに遷移する
      visit edit_trading_company_path(@trading_company.id)
      # ログインページへ遷移したことを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end