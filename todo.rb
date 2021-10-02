# frozen_string_literal: true

require 'sinatra/reloader'

# class Todo
class Todo < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    @data = data_hash.sort_by! { |item| item['completed'] ? 1 : 0 }

    erb :index
  end

  post '/item' do
    new_item = {
      id: SecureRandom.uuid,
      name: params['name'],
      completed: false
    }

    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    data_hash.push(new_item)

    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

  post '/done' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    element = data_hash.find { |elem| elem['id'].eql?(params['id']) }
    element['completed'] = true

    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

  post '/delete' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    data_hash.delete_if { |elem| elem['id'].eql?(params['id']) }

    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end
end
