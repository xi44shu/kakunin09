require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "Schedules", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.build(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '新規予約登録ができるとき'do
    it 'ログインしたユーザーはトップページから新規予約登録できる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # フォームに情報を入力する
      fill_in 'schedule[scheduled_date]', with: @schedule.scheduled_date
      select "午前", from: 'schedule[time_zone_id]'
      select "小", from: 'schedule[size_id]'
      select "仮予約", from: 'schedule[accuracy_id]'
      select "営業", from: 'schedule[first_contact_id]'
      # 送信するとScheduleモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Schedule.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq(root_path)
      # 予約詳細ページへのリンクがあることを確認する
      expect(page).to have_content('予約詳細')      
    end
    it 'ログインしたユーザーは新規予約のページから新規予約登録できる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 新規予約ページへのリンクがあることを確認する
      expect(page).to have_content('新規予約')
      # 予約ページへ移動する
      visit new_schedule_path
      # フォームに情報を入力する
      fill_in 'schedule[scheduled_date]', with: @schedule.scheduled_date
      select "午前", from: 'schedule[time_zone_id]'
      select "小", from: 'schedule[size_id]'
      select "仮予約", from: 'schedule[accuracy_id]'
      select "営業", from: 'schedule[first_contact_id]'
      # 送信するとScheduleモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Schedule.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq(root_path)
      # 予約詳細ページへのリンクがあることを確認する
      expect(page).to have_content('予約詳細')      
    end
  end
  context '新規予約登録ができないとき'do
    it 'ログインしていないと新規予約登録ページに遷移できない' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがないことを確認する
      expect(page).to have_no_content('新規予約')
    end
    it 'ログインしていないとトップページから新規予約登録できない' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # フォームに情報を入力する
      fill_in 'schedule[scheduled_date]', with: @schedule.scheduled_date
      select "午前", from: 'schedule[time_zone_id]'
      select "小", from: 'schedule[size_id]'
      select "仮予約", from: 'schedule[accuracy_id]'
      select "営業", from: 'schedule[first_contact_id]'
      # 登録ボタンを押してもScheduleモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Schedule.count }.by(0)      
      # ログインページへ遷移したことを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end


RSpec.describe "詳細01", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.create(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '予約の詳細が確認できるとき'do
    it 'ログインしているユーザーは詳細ページに遷移して予約の詳細が表示される' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      # トップページに遷移する
      expect(current_path).to eq(root_path)
      # 予約詳細ページへのリンクがあることを確認する
      expect(page).to have_content('予約詳細')
      click_link '予約詳細'      
      # 予約の詳細ページに遷移したことを確認確認する
      expect(current_path).to eq(schedule_path(@schedule.id))
    end
    it 'ログインしていなくても詳細ページに遷移して予約の詳細が表示される' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # 予約詳細ページへのリンクがあることを確認する
      expect(page).to have_content('予約詳細')
      click_link '予約詳細'      
      # 予約の詳細ページに遷移したことを確認確認する
      expect(current_path).to eq(schedule_path(@schedule.id))
    end
  end
end

RSpec.describe "詳細02", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.build(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '予約の詳細が確認できないとき'do
      it '予約がないとき' do
        # Basic認証を通過する
        basic_pass new_user_session_path
        # ログインする
        visit new_user_session_path
        fill_in 'Name', with: @user.name
        fill_in 'Password', with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq(root_path)
        # 予約レコードの数が0を確認する
        expect(Schedule.count).to eq 0
        # トップページに遷移する
        visit root_path
        # 予約詳細ページへのリンクがないことを確認する
        expect(page).to have_no_content('予約詳細')
      end
      it '予約はあるが、予約日が昨日以前のとき' do
        # Basic認証を通過する
        basic_pass new_user_session_path
        # ログインする
        visit new_user_session_path
        fill_in 'Name', with: @user.name
        fill_in 'Password', with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq(root_path)
        # 新規予約ページへのリンクがあることを確認する
        expect(page).to have_content('新規予約')
        # 予約ページへ移動する
        visit new_schedule_path
        # フォームに情報を入力する
        fill_in 'schedule[scheduled_date]', with: (@schedule.scheduled_date)-2
        select "午前", from: 'schedule[time_zone_id]'
        select "小", from: 'schedule[size_id]'
        select "仮予約", from: 'schedule[accuracy_id]'
        select "営業", from: 'schedule[first_contact_id]'
        # 送信するとScheduleモデルのカウントが1上がることを確認する
        expect{
          find('input[name="commit"]').click
        }.to change { Schedule.count }.by(1)
        # トップページに遷移する
        expect(current_path).to eq(root_path)
        # 予約詳細ページへのリンクがないことを確認する
        expect(page).to have_no_content('予約詳細')
        end
        it '予約はあるが、日程が一覧表の範囲より先の日付のとき' do
        # Basic認証を通過する
        basic_pass new_user_session_path
        # ログインする
        visit new_user_session_path
        fill_in 'Name', with: @user.name
        fill_in 'Password', with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq(root_path)
        # 新規予約ページへのリンクがあることを確認する
        expect(page).to have_content('新規予約')
        # 予約ページへ移動する
        visit new_schedule_path
        # フォームに情報を入力する
        fill_in 'schedule[scheduled_date]', with: (@schedule.scheduled_date)+7
        select "午前", from: 'schedule[time_zone_id]'
        select "小", from: 'schedule[size_id]'
        select "仮予約", from: 'schedule[accuracy_id]'
        select "営業", from: 'schedule[first_contact_id]'
        # 送信するとScheduleモデルのカウントが1上がることを確認する
        expect{
          find('input[name="commit"]').click
        }.to change { Schedule.count }.by(1)
        # トップページに遷移する
        expect(current_path).to eq(root_path)
        # 予約詳細ページへのリンクがないことを確認する
        expect(page).to have_no_content('予約詳細')
      end
  end
end

RSpec.describe "編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.create(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '予約の編集ができるとき'do
    it 'ログインしたユーザーは予約の編集ができる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 先ほど作成した予約が存在することを確認する
      visit schedule_path(@schedule.id)
      # 予約編集ページへのリンクがあることを確認する
      expect(page).to have_content('変更')
      click_link '変更'
      # 予約編集ページに遷移する
      expect(current_path).to eq(edit_schedule_path(@schedule.id))
      # フォームに情報を入力する
        fill_in 'schedule[scheduled_date]', with: (@schedule.scheduled_date)+1
        select "午後", from: 'schedule[time_zone_id]'
        select "中", from: 'schedule[size_id]'
        select "本予約", from: 'schedule[accuracy_id]'
        select "伊勢", from: 'schedule[mie_id]'
        select "商社", from: 'schedule[first_contact_id]'
        select "10:00", from: 'schedule[start_time_id]'
        fill_in 'schedule[prime_contractor]', with: @schedule.prime_contractor
        fill_in 'schedule[content]', with: @schedule.content
        # 登録するをクリックしてもscheduleモデルのカウントは変わらないことを確認する
        expect{
          find('input[name="commit"]').click
        }.to change { Schedule.count }.by(0)
    end
  end
  context '予約編集登録ができないとき'do
    it 'ログインしていないと予約編集ページに遷移できない' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # 先ほど作成した予約が存在することを確認する
      visit schedule_path(@schedule.id)
      # 予約編集ページへのリンクがないことを確認する
      expect(page).to have_no_content('変更')
    end
  end
end

RSpec.describe "削除", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.create(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '予約の削除ができるとき'do
    it 'ログインしたユーザーは予約の削除ができる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 先ほど作成した予約が存在することを確認する
      visit schedule_path(@schedule.id)
      # 予約削除ページへのリンクがあることを確認する
      expect(page).to have_content('削除')
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        page.accept_confirm do
          find_link('削除', href: schedule_path(@schedule.id)).click
        end
        sleep 0.5
      }.to change { Schedule.count }.by(-1)
      # トップページに遷移する
      visit root_path
    end
  end
  context '予約削除ができないとき'do
    it 'ログインしていないと予約削除ページに遷移できない' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # 予約詳細ページへのリンクがあることを確認する
      expect(page).to have_content('予約詳細')
      click_link '予約詳細'      
      # 予約の詳細ページに遷移したことを確認する
      expect(current_path).to eq(schedule_path(@schedule.id))
      # 削除のリンクがないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
end

RSpec.describe "コピー", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.build(:team)
    @team.work = 'true'
    @team.save
    @trading_company = FactoryBot.create(:trading_company)
    @schedule = FactoryBot.create(:schedule, user_id:@user.id, team_id:@team.id, trading_company_id:@trading_company.id)
  end

  context '予約をコピーして登録ができるとき'do
    it 'ログインしたユーザーは予約のコピーができる' do
      # Basic認証を通過する
      basic_pass new_user_session_path
      # ログインする
      visit new_user_session_path
      fill_in 'Name', with: @user.name
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 先ほど作成した予約が存在することを確認する
      visit schedule_path(@schedule.id)
      # 予約コピー編集ページへのリンクがあることを確認する
      expect(page).to have_content('コピー')
      click_link 'コピー'
      # 予約編集ページに遷移する
      expect(current_path).to eq(copy_schedule_path(@schedule.id))
      # フォームに情報を入力する
        fill_in 'schedule[scheduled_date]', with: (@schedule.scheduled_date)+1
        select "午後", from: 'schedule[time_zone_id]'
        select "中", from: 'schedule[size_id]'
        select "本予約", from: 'schedule[accuracy_id]'
        select "伊勢", from: 'schedule[mie_id]'
        select "商社", from: 'schedule[first_contact_id]'
        select "10:00", from: 'schedule[start_time_id]'
        fill_in 'schedule[prime_contractor]', with: @schedule.prime_contractor
        fill_in 'schedule[content]', with: @schedule.content
        # 登録するをクリックしてもscheduleモデルのカウントが1増えることを確認する
        expect{
          find('input[name="commit"]').click
        }.to change { Schedule.count }.by(1)
    end
  end
  context '予約編集登録ができないとき'do
    it 'ログインしていないと予約編集ページに遷移できない' do
      # Basic認証を通過する
      basic_pass root_path
      # トップページに遷移する
      visit root_path
      # 先ほど作成した予約が存在することを確認する
      visit schedule_path(@schedule.id)
      # 予約編集ページへのリンクがないことを確認する
      expect(page).to have_no_content('コピー')
    end
  end
end
