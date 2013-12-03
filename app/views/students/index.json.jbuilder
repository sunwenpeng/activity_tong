json.array!(@students) do |student|
  json.extract! student, :name, :password
  json.url student_url(student, format: :json)
end
