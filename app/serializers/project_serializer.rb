class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :start_date, :end_date, :name, :company_id, :hours_per_day
end
