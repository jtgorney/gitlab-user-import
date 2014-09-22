require 'net/http'
require 'rubygems'
require 'json'
require 'csv'

# Login credentials
gitlabUsername = ARGV[0]
gitlabPassword = ARGV[1]
gitlabApiRoot = ARGV[2]
userFile = ARGV[3]

# Check for existing file
if !File.exist?(userFile)
	puts "Input file does not exist."
	abort
end

# Import data into the gitlab service for ACM

# Get the session private token so we can make calls
sessionUrl = URI.parse("#{gitlabApiRoot}/session")
sessionRes = Net::HTTP.post_form(sessionUrl, {
	"login" => gitlabUsername,
	"password" => gitlabPassword
}).body
sessionJson = JSON.parse(sessionRes)

# Store the private token
privateKey = sessionJson["private_token"]

# Generic password
password = "gitlabuser"

# Now that we have the private key we can loop and call CSV
CSV.foreach(userFile) do |row|
	# Import the user into gitlab
	firstName = row[0]
	lastName = row[1]
	email = row[2]
	username = email.split('@').first
	puts "Creating user:"
	puts username
	puts email
	puts password
	# Call the API
	userUrl = URI.parse("#{gitlabApiRoot}/users")
	http = Net::HTTP::new(userUrl.host, userUrl.port)
	request = Net::HTTP::Post.new(userUrl.request_uri)
	request.set_form_data({
		"username" => username,
		"password" => password,
		"email" => email,
		"name" => firstName + " " + lastName
	})
	request["PRIVATE-TOKEN"] = privateKey
	response = http.request(request)
	responseJson = JSON.parse(response.body)
	# Determine success of call
	if responseJson["message"] == "404 Not Found"
		puts "Error: Could not add user. Must already exist."
	else
		puts "Success: User created!"
	end
	puts ""
end