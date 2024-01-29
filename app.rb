# app.rb

require 'sinatra'
require 'sinatra/cors'
require 'json'



configure do
    enable :cross_origin
  end
  
  set :allow_origin, '*'
  set :allow_methods, 'GET,HEAD,POST,PUT,DELETE,OPTIONS'
  set :allow_headers, 'content-type,if-modified-since'
  set :expose_headers, 'location,link'
  
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

# Lista de tareas (almacenadas en memoria)
tasks = [{"id":1,"title":"Ir al banco","description":"Debo ir al bancoooooo"},{"id":2,"title":"Hacer las
compras","description":"Debo ir al super"},{"id":3,"title":"Enviar trabajos","description":"Entrega maxima a las
23h50"}]

# Rutas para la API CRUD de tareas

# Obtener todas las tareas
get '/tasks' do
  tasks.to_json
end

# Obtener una tarea por ID
get '/tasks/:id' do
  task_id = params[:id].to_i
  task = tasks.find { |t| t[:id] == task_id }
  
  if task
    task.to_json
  else
    status 404
    { message: 'Tarea no encontrada' }.to_json
  end
end

# Crear una nueva tarea
post '/tasks' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  new_task = { id: tasks.length + 1, title: data['title'], description: data['description'] }
  tasks << new_task
  
  { message: 'Tarea creada con éxito', task: new_task }.to_json
end

# Actualizar una tarea por ID
put '/tasks/:id' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  task_id = params[:id].to_i
  task_index = tasks.index { |t| t[:id] == task_id }
  
  if task_index
    tasks[task_index][:title] = data['title'] if data['title']
    tasks[task_index][:description] = data['description'] if data['description']
    
    { message: 'Tarea actualizada con éxito', task: tasks[task_index] }.to_json
  else
    status 404
    { message: 'Tarea no encontrada' }.to_json
  end
end

# Eliminar una tarea por ID
delete '/tasks/:id' do
  task_id = params[:id].to_i
  tasks.reject! { |t| t[:id] == task_id }
  
  { message: 'Tarea eliminada con éxito' }.to_json
end

# Inicia la aplicación de Sinatra
#run Sinatra::Application

configure do
    set :tasks, tasks
    
  end

