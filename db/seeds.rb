User.create!(name:  "Guest User",
             email: "guest@example.com",
             password:              "foobar123",
             password_confirmation: "foobar123",
             admin: true,
             activated:    true,
             activated_at: Time.zone.now)

19.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@example.com"
  password = "foobar123"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated:    true,
               activated_at: Time.zone.now)
end

users = User.all
users.each do |user|
  10.times do |n|
    title = "#{user.name} title-#{n}"
    content = "content-#{n}"
    @post = user.posts.build(title: title, content: content)
    @post.save
  end
end

user  = users.first
following = users[1..10]
followers = users[1..19]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

category_names = ["DTM", "DAW", "Logic", "Cubase", "ProTools", "音楽理論"]
category_names.each do |name|
  Category.create!(name: name)
end
