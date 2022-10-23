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