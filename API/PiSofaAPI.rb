require 'pi_piper'

class PiSofaAPI

  def initialize
    @relay1 = PiPiper::Pin.new(:pin => 9, :direction => :out)
    @relay2 = PiPiper::Pin.new(:pin => 10, :direction => :out)
    @relay3 = PiPiper::Pin.new(:pin => 22, :direction => :out)
    @relay4 = PiPiper::Pin.new(:pin => 21, :direction => :out)
    @relay5 = PiPiper::Pin.new(:pin => 17, :direction => :out)
    @relay6 = PiPiper::Pin.new(:pin => 4, :direction => :out)
    @relay7 = PiPiper::Pin.new(:pin => 1, :direction => :out)
    #@relay8 = PiPiper::Pin.new(:pin => 0, :direction => :out)

    @relays = [@relay1,@relay2,@relay3,@relay4,@relay5,@relay6,@relay7]
    @downRelays = [@relay1,@relay3,@relay5]
    @upRelays = [@relay2,@relay4,@relay6]

    @up = 1
    @down = 2

    allOff

    @feetUp = [5300,4800,5100]
    @flat = [8200,7900,7900]
    @sofaPos = [0,0,0]
    @sofaMoving = [0,0,0]
    @buffer = 500
    @sofaPressTime = [0,0,0]
    @threads = []

    PiPiper::Pin.new(:pin => 18, :direction => :in)
    PiPiper::Pin.new(:pin => 23, :direction => :in)
    PiPiper::Pin.new(:pin => 24, :direction => :in)
    PiPiper::Pin.new(:pin => 25, :direction => :in)
    PiPiper::Pin.new(:pin => 8, :direction => :in)
    PiPiper::Pin.new(:pin => 7, :direction => :in)
  end

  def up
    @up
  end

  def down
    @down
  end

  def positions
    "Sofa1:#{@sofaPos[0]}\nSofa2:#{@sofaPos[1]}\nSofa3:#{@sofaPos[2]}"
  end

  def parentalMode
    @relay7.read
    if (@relay7.off?)
      @relay7.on
    else
      @relay7.off
    end
  end

  def allOff()
    @upRelays.each do |r|
      r.on
    end
    @downRelays.each do |r|
      r.on
    end
  end

  def killThreads()
    @threads.each do |t|
      Thread.kill(t)
    end

    @threads.clear
  end

  def stopAll()
    3.times do |i|
      if @sofaMoving[i] > 0
        stopMoving(i, false)
      end
    end
    killThreads
  end
  
  def startMoving(id, direction, physButton)
    if @sofaMoving[id] != 0 && physButton
      stopMoving(id, false)
      killThreads
    else
      @sofaPressTime[id] = (Time.now.to_f*1000).to_i
      direction == @up ? @upRelays[id].off : @downRelays[id].off
      @sofaMoving[id] = direction
    end
  end

  def stopMoving(id, physButton)
    if @sofaMoving[id] == 0 then return end

    time = (Time.now.to_f*1000).to_i
    pressTime = time - @sofaPressTime[id]

    if @sofaMoving[id] == @up
      if physButton && pressTime < 250 && @sofaPos[id] > 0
        if @sofaPos[id] > @feetUp[id]
	  moveToFeet(id)
        else
          moveToUp(id)
        end
      else
        @upRelays[id].on
        @sofaPos[id] -= pressTime
        @sofaPressTime[id] = 0

        if @sofaPos[id] < 0
          @sofaPos[id] = 0
        end
        @sofaMoving[id] = 0
      end
    end

    if  @sofaMoving[id] == @down
      if physButton && pressTime < 250 && @sofaPos[id] < @flat[id]
        if @sofaPos[id] < @feetUp[id]
          moveToFeet(id)
        else
          moveToFlat(id)
        end
      else
        @downRelays[id].on
        @sofaPos[id] += pressTime
        @sofaPressTime[id] = 0

        if @sofaPos[id] > @flat[id]
          @sofaPos[id] = @flat[id]
        end

        @sofaMoving[id] = 0
      end
    end
  end

  def moveToUp(pos)
    @threads << Thread.new do
      if @sofaPos[pos] > 0
        startMoving(pos,@up,false)
        sleep(((@sofaPos[pos]+@buffer).to_f)/1000)
        stopMoving(pos,false)
      end
      @sofaPos[pos] = 0
    end
  end

  def moveToFeet(pos)
    @threads << Thread.new do
      if @sofaPos[pos] > @feetUp[pos]
        startMoving(pos, @up, false)
        sleep((@sofaPos[pos]-@feetUp[pos]).to_f/1000)
        stopMoving(pos, false)
      elsif @sofaPos[pos] < @feetUp[pos]
        startMoving(pos, @down, false)
        sleep((@feetUp[pos]-@sofaPos[pos]).to_f/1000)
        stopMoving(pos, false)
      end
      @sofaPos[pos] = @feetUp[pos]
    end
  end

  def moveToFlat(pos)
    @threads << Thread.new do
      if @sofaPos[pos] < @flat[pos]
        startMoving(pos,@down,false)
        @downRelays[pos].off
        sleep(((@flat[pos]-@sofaPos[pos])+@buffer).to_f/1000)
        stopMoving(pos, false)
      end
      @sofaPos[pos] = @flat[pos]
    end
  end

end
