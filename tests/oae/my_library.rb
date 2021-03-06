#!/usr/bin/env ruby

#
# == Description
#
# Login as existing user and view my messages
#

require 'drb'
config = DRbObject.new nil, "druby://localhost:#{ENV['DRB_PORT']}"

require config.lib_base_dir + "/tsung-api.rb"
require config.lib_base_dir + "/#{config.product}/common/authentication.rb"
require config.lib_base_dir + "/#{config.product}/library/content.rb"

# Test info - default test case setup
test = File.basename(__FILE__)
probability = config.tests[test]
config.log.info_msg("Test: #{test}")
config.log.info_msg("Probability: #{config.tests[test]}")

# Create session
sess = Session.new(config, 'my_library', probability)

# Login
username = '%%_username%%'
password = '%%_user_password%%'

login_txn = sess.add_transaction("login")
login_req = login_txn.add_requests
config.log.info_msg("#{test}: Loggin in as: #{username}")
auth = Authentication.new(login_req)
auth.login(username, password)

# view my messages
my_library_txn = sess.add_transaction("my_library")
my_library_req = my_library_txn.add_requests
config.log.info_msg("#{test}: Viewing My Library as: #{username}")
content = Content.new(my_library_req)
content.my_library(username)

# Logout
logout_txn = sess.add_transaction("logout")
logout_req = logout_txn.add_requests
config.log.info_msg("#{test}: Logging out")
auth = Authentication.new(logout_req)
auth.logout
