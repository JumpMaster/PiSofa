require 'sinatra'
require 'pi_piper'
require './PiSofaAPI'

class PiSofaSite < Sinatra::Base

  configure do
    @@piSofaAPI = PiSofaAPI.new
    @@crazyMode = false
    @@seatId = [0,0,1,1,2,2]
    @@direction = [	@@piSofaAPI.up,@@piSofaAPI.down,
			@@piSofaAPI.up,@@piSofaAPI.down,
			@@piSofaAPI.up,@@piSofaAPI.down]
  end

  PiPiper.watch :pin => 8 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[0], @@direction[0], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[0], true)
    end
  end

  PiPiper.watch :pin => 7 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[1], @@direction[1], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[1], true)
    end
  end

  PiPiper.watch :pin => 24 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[2], @@direction[2], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[2], true)
    end
  end

  PiPiper.watch :pin => 25 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[3], @@direction[3], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[3], true)
    end
  end

  PiPiper.watch :pin => 18 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[4], @@direction[4], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[4], true)
    end
  end

  PiPiper.watch :pin => 23 do
    if value == 0
      @@piSofaAPI.startMoving(@@seatId[5], @@direction[5], true)
    else
      @@piSofaAPI.stopMoving(@@seatId[5], true)
    end
  end

  before do
    expires 0, :public, :must_revalidate, :'no-cache'
  end

  get '/' do
    erb :index
  end

  get '/moveToUp/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.moveToUp(i)
      end
    else
      @@piSofaAPI.moveToUp(id-1)
    end
    status 200
  end

  get '/moveToFeet/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.moveToFeet(i)
      end
    else
      @@piSofaAPI.moveToFeet(id-1)
    end
    status 200
  end

  get '/moveToFlat/:id' do
    id = params[:id].to_i
    if id == 0
      3.times do |i|
        @@piSofaAPI.moveToFlat(i)
      end
    else
      @@piSofaAPI.moveToFlat(id-1)
    end
    status 200
  end

  get '/stopAll' do
    @@piSofaAPI.stopAll
    status 200
  end

  get '/parentalMode' do
    erb @@piSofaAPI.parentalMode
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
    erb @@piSofaAPI.positions
  end

  get '/manUpPress/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.startMoving(i, @@piSofaAPI.up, false)
      end
    else
      @@piSofaAPI.startMoving(id-1, @@piSofaAPI.up, false)
    end
    status 200
  end

  get '/manDownPress/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.startMoving(i, @@piSofaAPI.down, false)
      end
    else
        @@piSofaAPI.startMoving(id-1, @@piSofaAPI.down, false)
    end
    status 200
  end

  get '/manUpRelease/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.stopMoving(i, false)
      end
    else
      @@piSofaAPI.stopMoving(id-1, false)
    end

    erb @@piSofaAPI.positions
  end

  get '/manDownRelease/:id' do
    id = params[:id].to_i

    if id == 0
      3.times do |i|
        @@piSofaAPI.stopMoving(i, false)
      end
    else
      @@piSofaAPI.stopMoving(id-1, false)
    end

    erb @@piSofaAPI.positions
  end
end
