User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar123",
             password_confirmation: "foobar123",
             admin: true)

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "sample123"
User.create!(name:  name,
             email: email,
             password:              password,
             password_confirmation: password)
end
