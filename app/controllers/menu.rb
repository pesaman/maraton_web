enable :sessions

get '/registrar' do
 erb :registrar
end

get '/loogin_user' do
 erb :login
end

get '/logout' do
  session.clear
  session[:logout] = "Has cerrado sesión correctamente"
  redirect to '/'
end

get '/menudeck' do
  user_d = User.where(user_id: current_user.id)
  p @decks = Deck.all
  erb :menudeck
end

before '/menudeck' do
  unless session[:email]
    session[:error] = "No has iniciado sesión"
    #i need to redirect to index to avoid go to /secret again
    redirect to '/'
  end
end

get '/scores' do
  @options1 = []
  @options2 = []
  @options3 = []
  current_game = Game.last
  current_g = current_game.id
  @answer_game = AnswerGame.where(game_id: current_g)
  @answer_game.each do |answer|
    user_ans = answer.user_answer
    @options1 << Option.find(user_ans).option
    @options2 << Option.find(user_ans).answer
    @options3 << answer.question
  end
  p @options1
  p @options2
  p @options3
  erb :score
end

get '/all_scores' do
  @user_game = Game.where(user_id: current_user.id)
  erb :all_scores
end

get '/show_deck/:id' do
  deck_id = params[:id]
  @deck = Deck.find(deck_id)
  @deck_questions = @deck.questions 
  @game = Game.create(user_id: current_user.id, deck_id: deck_id)
  @gamelast = Game.last
  # p @games = @deck.games
  # p @games.current_user.id
  erb :show_deck 
end



post "/result" do
  correct_answers = 0
  incorrect_answers = 0
  questionid = []
  idquest = ""
  gameid = [] 
  answers = []
  scores = []
  answer_value = params

  answer_value.each do |key, data_game|
      #value es ej: {"1"=>{"193"=>"f"}} 
      #data_game es ej: {"1"=>{"22"=>{"1"=>"f"}}}
        
    question_id = data_game.keys
    questionid << question_id[0].to_i
    game_answer = data_game.values
    #game_answer es ej:  [{"23"=>{"1"=>"f"}}]   
    game_answer[0].each do |game_id, answer| 
      gameid << game_id.to_i 
      # answer es ej: {"1"=>"f"}  
      answer.each do |option_id, letter|
        optionid = option_id.to_i
        answers << optionid   
          if letter == "t" 
            scores << score = 1
            correct_answers += 1  
          else 
            incorrect_answers += 0 
            scores << score = 0
          end
      end  
    end
  end

 #score = correct_answers 
 # ans_game =[]
 # p ans_game << gameid << questionid << answers << scores
 # questionid.zip(answers).each do |quest, answer|
 #    AnswerGame.create(game_id: gameid2, question_id: quest, user_answer: answer, score: score)
 # end
gameid.zip(questionid, answers, scores).each do |game, quest, answer, score|
  AnswerGame.create(game_id: game, question_id: quest, user_answer: answer, score: score)
  # puts "#{game} game"
  # puts "#{quest}quest"
  # puts "#{answer}answer"
  # puts "#{score} score"
end
  redirect to ("/scores")
  #redirect to ("/scores/#{correct_answers}")
end


post '/registrar_user' do
  email = params[:email]
  password  = params[:password] 
  existe = User.find_by(email: email)
  user  = User.new(email: email, password: password)
  user.save
  if user.valid?
      session[:user_id] = user.id
      session[:correct_user] = "Usuario Creado con Exito"
      redirect to("/loogin_user")
  else 
    if existe
      session[:incorrect_user] = "Usuario ya Existe Intenta de Nuevo"
      redirect to '/registrar'
      else
      session[:incorrect_user] = "No puedes dejar campos vacios"
      redirect to '/registrar'
    end
  end
end

post '/loogin' do
  email = params[:email]
  password  = params[:password] 
  user_validate = User.autentic(email, password)
    if user_validate 
       session[:email] = email
       session[:user_id] = user_validate.id
       redirect to '/menudeck'
    else 
       session[:incorrect_login] = "Email y/o password incorrectos"
       redirect to '/loogin_user'
    end
end