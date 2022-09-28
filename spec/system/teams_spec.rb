require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "Teams", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
  end

  context 'チームの新規登録ができるとき'do
    it 'ログインしたユーザーはチーム新規登録できる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 班一覧ページへのボタンがあることを確認する
      expect(page).to have_content('班一覧')
      # 班一覧ページへのボタンを押す
      click_link '班一覧'      
      # 班一覧ページに遷移する
      expect(current_path).to eq(teams_path)
      # 新規班作成ページへのボタンがあることを確認する
      expect(page).to have_content('新規班作成')
      # 新規班作成ページへのボタンを押す
      click_link '新規班作成'      
      # 作成ページに遷移する
      expect(current_path).to eq(new_team_path)
      # フォームに情報を入力する
      fill_in 'team_team_name', with: @team.team_name
      fill_in 'team_affiliation', with: @team.affiliation
      choose '稼働中'
      # 送信するとTeamモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Team.count }.by(1)
      # 班一覧ページに遷移する
      expect(current_path).to eq(teams_path)
      # 班一覧ページには先ほど作成した班が存在することを確認する
      expect(page).to have_content(@team_team_name)
    end
  end
  context 'チーム登録ができないとき'do
    it 'ログインしていないと班一覧ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 班一覧ページへのボタンがないことを確認する
      expect(page).to have_no_content('班一覧')
    end
  end
end

RSpec.describe "編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.create(:team)
  end

  context 'チームの編集ができるとき'do
    it 'ログインしたユーザーはチームの編集ができる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      # 班一覧ページに遷移する
      visit teams_path
      # 班の編集ページへのリンクがあることを確認する
      expect(page).to have_content(@team.team_name)
      # 班の編集ページへのリンクを押す
      click_link @team.team_name      
      # フォームに情報を入力する
      fill_in 'team_team_name', with: @team.affiliation
      fill_in 'team_affiliation', with: @team.team_name
      choose '休み'
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Team.count }.by(0)
    end
  end
  context 'チームの編集ができないとき'do
    it 'ログインしていないと班一覧ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 班一覧ページへのボタンがないことを確認する
      expect(page).to have_no_content('班一覧')
    end
    it 'ログインしていないと班詳細ページに遷移できない' do
      # 班詳細ページに遷移する
      visit edit_team_path(@team.id)
      # ログインページへ遷移したことを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

