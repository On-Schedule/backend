class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :company_id, :first_name, :last_name, :api_key
end
