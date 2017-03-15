
get '/registrar' do
 erb :registrar
end

get '/loogin_user' do
 erb :login
end


post '/registrar_user' do
  email = params[:email]
  password  = params[:password] 
  p params
  user = User.create(email: email, password: password)
  redirect to("/loogin_user")
end

post '/loogin' do
  email = params[:email]
  password  = params[:password] 
  user_login = User.find_by(email: email, password: password)
  name_user = email
    if user_login
       erb :menudeck
    else
      redirect to("https://www.google.com.mx/")
    end   
end