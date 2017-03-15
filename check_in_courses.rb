# frozen_string_literal: true
require 'pry'
require 'mechanize'
require 'dotenv/load'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

# Log in
cookies_file = 'cookies.yml'

if File.exist?('cookies.yaml')
  agent.cookie_jar.load('cookies.yaml')
else
  login_page = agent.get('https://moodle.itech-bs14.de/login/index.php')
  login_form = login_page.form(action: 'https://moodle.itech-bs14.de/login/index.php')
  login_form.field_with(id: 'username').value = ENV['username']
  login_form.field_with(id: 'password').value = ENV['password']
  login_form.submit

  agent.cookie_jar.save(cookies_file, session: true)
end

ae_page = agent.get('https://moodle.itech-bs14.de/course/index.php?categoryid=5')

links = ae_page.search('.courses a')

href = links.map do |link|
  link.attribute('href').to_s
end

href.each do |link|
  course = agent.get(link)
  check_in_form = course.form(action: 'https://moodle.itech-bs14.de/enrol/index.php')

  if !check_in_form.nil?
    return check_in_form.submit if course.search('.fstatic').count != 0
    check_in_form.field_with(name: 'enrolpassword').value = ENV['check_in_password']
    check_in_form.submit
  else
    next
  end
end

# lock_page = agent.get('https://moodle.itech-bs14.de/enrol/index.php?id=35')

# p 'Add start id'
# start_id = gets.chomp
# p 'Add end_id'
# end_id = gets.chomp

# user_name = homepage.search('.usertext').text
#
# if user_name != 0
# end
