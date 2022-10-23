crumb :root do
  link "トップページ", root_path
end

crumb :schedule_show do |schedule|
  link "予約詳細(#{schedule.id})", schedule_path(schedule)
  parent :root
end

crumb :schedule_edit do |schedule|
  link "予約編集", edit_schedule_path(schedule)
  parent :schedule_show, schedule
end

crumb :schedule_copy do
  link "コピーして登録", copy_schedule_path
  parent :root
end

crumb :schedule_new do
  link "新規予約", new_schedule_path
  parent :root
end

crumb :team_index do
  link "班一覧", teams_path
  parent :root
end

crumb :team_new do
  link "班登録", new_team_path
  parent :team_index
end

crumb :team_edit do |team|
  link "班編集(#{team.team_name})", edit_team_path(team)
  parent :team_index, team
end

crumb :trading_company_index do
  link "商社一覧", trading_companies_path
  parent :root
end

crumb :trading_company_new do
  link "商社登録", new_trading_company_path
  parent :trading_company_index
end

crumb :trading_company_edit do |trading_company|
  link "商社編集(#{trading_company.tc_name})", edit_trading_company_path(trading_company)
  parent :trading_company_index, trading_company
end
# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).