def login_as(user)
  post "/login", params: {user: {login: user.username, password: user.password}}
end
