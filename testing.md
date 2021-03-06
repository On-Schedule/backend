### Testing
##### Running tests
- you can run the entire test suite with `bundle exec rspec`
- you can run an individual test suite with `bundle exec rspec <file path>` for example: `bundle exec rspec spec/requests/post_user_endpoint_spec.rb`
- you can run an individual test or an entier describe block with `bundle exec rspec <file path>:<line number>` where the `<line number>` is the line a the test or describe block starts on


#### Tests for each endpoint
##### POST user endpoint
- happy path testing includes:
  - endpoint returns a 201 response with a new user object
- Edge case & Sad path testing includes:
  - endpoint returns a 400 response and appropriate errors if the request body is blank
  - endpoint returns a 400 response and appropriate error if the password and confirmation don't match
  - endpoint returns a 400 response and appropriate error if the email is in an invalid format
  - endpoint returns a 400 response and appropriate error if email is not unique


##### GET user endpoint
- happy path testing includes:
  - endpoint returns a 200 response and user object if id and valid api_key are provided
- Edge case & Sad path testing includes:
  - endpoint returns a 401 unauthorized error if a user doesn't exist
  - endpoint returns a 401 unauthorized error if the api_key and user id dont match
  - endpoint returns a 401 unauthorized error if no api_key is provided
  - endpoint returns a 401 unauthorized error if api_key is blank


##### POST user login endpoint
- happy path testing includes:
  - endpoint returns a 200 response and user object if email and password are valid
- Edge case & Sad path testing includes:
  - endpoint returns a 400 invalid login error if a user doesn't exist
  - endpoint returns a 400 invalid login error if the email and password dont match
  - endpoint returns a 400 invalid login error if no password is provided
  - endpoint returns a 400 invalid login error if no email is provided

##### POST project endpoint
- happy path testing includes:
  - endpoint returns a 201 response with a new project object
- Edge case & Sad path testing includes:
  - endpoint returns a 201 response with a new project object ignoring repeated days of the week
  - endpoint returns a 400 error if days of week is not provided
  - endpoint returns a 400 error if days of week is empty
  - endpoint returns a 400 error if days of week includes invalid days of the week
  - endpoint returns a 400 error if hours per day is lees then 1
  - endpoint returns a 400 error if hours per day is greater then 24
  - endpoint returns a 400 error if hours per day is blank
  - endpoint returns a 400 error if hours per day is not a integer
  - endpoint returns a 400 error if start date is not provided
  - endpoint returns a 400 error if start date is blank
  - *endpoint returns a 400 error if start date is not a date*
  - endpoint returns a 400 error if end date is not provided
  - endpoint returns a 400 error if end date is blank
  - *endpoint returns a 400 error if end date is not a date*
  - endpoint returns a 401 unauthorized error if a user doesn't exist
  - endpoint returns a 401 unauthorized error if the api_key and user id dont match
  - endpoint returns a 401 unauthorized error if user is not provided
  - endpoint returns a 401 unauthorized error if api_key is not provided
  - endpoint returns only a 401 unauthorized error and not a 400 bad request error if both are valid
