require 'sinatra'
require './PiSofa'

class PiSofaSite < Sinatra::Base

  configure do
    @@piSofa = PiSofa.new
  end

  before do
    expires 0, :public, :must_revalidate, :'no-cache'
  end

  get '/' do
    erb :index
  end

  get '/moveToUp/:id' do
    id = params[:id].to_i
    @@piSofa.moveToUp(id)
    status 200
  end

  get '/moveToFeet/:id' do
    id = params[:id].to_i
    @@piSofa.moveToFeet(id)
    status 200
  end

  get '/moveToFlat/:id' do
    id = params[:id].to_i
    @@piSofa.moveToFlat(id)
    status 200
  end

  get '/stopAll' do
    @@piSofa.stopAll
    status 200
  end

  get '/parentalMode' do
    erb @@piSofa.parentalMode
  end

  get '/crazyMode' do
    if @@crazyMode
      @@crazyMode = false
      @@seatId = [0,0,1,1,2,2]
    @@direction = [     @@piSofaAPI.up,@@piSofaAPI.down,
                        @@piSofaAPI.up,@@piSofaAPI.down,
                        @@piSofaAPI.up,@@piSofaAPI.down]
    else
      @@crazyMode = true
      @@seatId = [1,2,0,2,1,0]
      @@direction = [     @@piSofaAPI.down,@@piSofaAPI.down,
                          @@piSofaAPI.down,@@piSofaAPI.up,
                          @@piSofaAPI.up,@@piSofaAPI.up]
    end
    erb @@crazyMode.to_s
  end

  get '/showData' do
    erb @@piSofa.getPositions
  end

  get '/showData2' do
    erb :showData2
  end
  
  get '/manUpPress/:id' do
    id = params[:id].to_i
    @@piSofa.startManualMove(id, @@piSofa.up)
    status 200
  end

  get '/manDownPress/:id' do
    id = params[:id].to_i
    @@piSofa.startManualMove(id, @@piSofa.down)
    status 200
  end


  get '/manUpRelease/:id' do
    id = params[:id].to_i
    @@piSofa.stopManualMove(id)
    status 200
  end

  get '/manDownRelease/:id' do
    id = params[:id].to_i
    @@piSofa.stopManualMove(id)
    status 200
  end
end
