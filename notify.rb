#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'net/https'
require 'json'
require 'uri'

def error(s)
  puts "ERROR: #{s}"
  exit 1
end

def blank?(s)
  s.nil? || s == '' || s == [] || s == {}
end

def send(uri, message = {})
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(message)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  # openssl is broken, can't seem to deal with flowdock's wildcard cert properly
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  http.start do |con|
    response = con.request req
    error("Request failed: #{response.message}: #{response.body}") unless response.kind_of?(Net::HTTPSuccess)
  end
end

# export WERCKER_BUILD_ID=522eeba48a8d9f4406004303
# export WERCKER_APPLICATION_ID="510a2efc5ff9d06a77000574"
# export WERCKER_RESULT=failed
# export WERCKER_FAILED_STEP_DISPLAY_NAME="Run tests"
# export WERCKER_FAILED_STEP_MESSAGE=""
# export WERCKER_STARTED_BY="Peter de Ruijter"
# export WERCKER_APPLICATION_NAME="one"
# export WERCKER_APPLICATION_OWNER_NAME="wrdevos"
# export WERCKER_GIT_COMMIT="9c72e232762ec230cc23798732ab1701b4143efa"
# export WERCKER_GIT_BRANCH="master"

STEP_PREFIX = "WERCKER_FLOWDOCK_NOTIFY"

from_address = ENV["#{STEP_PREFIX}_FROM_ADDRESS"]
flow_api_token = ENV["#{STEP_PREFIX}_FLOW_API_TOKEN"]
passed_extra_message = ENV["#{STEP_PREFIX}_PASSED_EXTRA_MESSAGE"]
failed_extra_message = ENV["#{STEP_PREFIX}_FAILED_EXTRA_MESSAGE"]

error("flow_api_token required") if blank?(flow_api_token)
error("from_address required") if blank?(from_address)

result = ENV['WERCKER_RESULT']
application = ENV['WERCKER_APPLICATION_NAME']
branch = ENV['WERCKER_GIT_BRANCH']
started_by = ENV['WERCKER_STARTED_BY']
build_id = ENV['WERCKER_BUILD_ID']
step_name = ENV['WERCKER_FAILED_STEP_DISPLAY_NAME']
step_message = ENV['WERCKER_FAILED_STEP_DISPLAY_MESSAGE']
commit_id = ENV['WERCKER_GIT_COMMIT']
build_passed = result == "passed"
symbol = build_passed ? '✓' : '✗'

subject = "#{symbol} Build of #{branch} by #{started_by} #{result}"

content = if step_name
  buf = <<-EOF
    <p>
      Step <strong>'#{step_name}'</strong> failed.<br/>
      Commit ID <strong>#{commit_id[0..15]}</strong>.
    </p>
    EOF
  if step_message.to_s.length > 0
    buf += <<-EOF
    <p>Message:</p>
    <pre>#{step_message}</pre>
    EOF
  end
  buf
else
  "<p>Commit ID #{commit_id[0..15]}</p>"
end

if build_passed
  content += passed_extra_message.to_s
else
  content += failed_extra_message.to_s
end

message = {
  'from_address' => from_address,
  'source' => 'Wercker',
  'subject' => subject,
  'content' => content,
  'project' => application,
  'link' => "https://app.wercker.com/#build/#{build_id}"
}

uri = URI.parse("https://api.flowdock.com/v1/messages/team_inbox/#{flow_api_token}")

send(uri, message)

