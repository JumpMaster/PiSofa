gem 'pi_piper', '= 1.3.2'
#gem 'pi_piper', '= 2.0.beta.4'

require 'pi_piper'

class PiSeat

  def initialize(seat, pinDownRelay, pinUpRelay, feetUpTime, flatTime)
    self.setRelays(pinUpRelay, pinDownRelay)
    self.setTimings(feetUpTime, flatTime)

    @seat = seat
    @dClickTime = 500
    @clickTime = 200
    @bounceTime = 150
    @moveBuffer = 500

    @dClicked = false
    @bounced = false

    @moving = 0
    @moveTarget = 0
    @pressTime = 0
    @moveStartTime = 0
    @moveTarget = 0
    @up = 1
    @down = 2

    @seatPos = 0

  end

  def getPosition
    getCurrentPos()
  end

  def isMoving
    @moving != 0
  end

  def setTimings(feetUpTime, flatTime)
    @posFeetUp = feetUpTime
    @posFlat = flatTime
  end

  def setRelays(pinUpRelay, pinDownRelay)
    @upRelayPin = pinUpRelay
    @downRelayPin = pinDownRelay
    @upRelay = PiPiper::Pin.new(:pin => pinUpRelay, :direction => :out)
    @downRelay = PiPiper::Pin.new(:pin => pinDownRelay, :direction => :out)
  end

  def buttonPressed(direction)
    time = (Time.now.to_f*1000).to_i

    if (direction == @up)
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - #{@upRelayPin} pressed")
    else
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - #{@downRelayPin} pressed")
    end

    if time-@pressTime < @bounceTime
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - Bounce detected")
      @bounced = true
      return
    end

    if @moving == direction && !@dClicked && time-@pressTime < @dClickTime
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - Double Clicked")
      if @moving > 0
        direction == @up ? @moveTarget = 0 : @moveTarget = @posFlat
        moveToTarget()
        @dClicked = true
      end
    else
      @pressTime = time
      @dClicked = false

      if @moving != 0
        if defined?(@moveThread)
          Thread.kill(@moveThread)
        end
        stopMoving()
      else
        startMoving(direction)
      end
    end
  end

  def buttonReleased(direction)
    time = (Time.now.to_f*1000).to_i

    if (direction == @up)
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - #{@upRelayPin} released")
    else
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - #{@downRelayPin} released")
    end

    if @moving == 0 || @bounced || @dClicked
      @bounced = false
      return
    end

    if (time-@pressTime <= @clickTime) && (direction == @down && getCurrentPos() < @posFlat || direction == @up && getCurrentPos() > 0)

      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - Quick Click")

      currentPos = getCurrentPos()

      if direction == @up
        @moveTarget = currentPos > @posFeetUp ? @posFeetUp : 0
      else
        @moveTarget = currentPos < @posFeetUp ? @posFeetUp : @posFlat
      end

      moveToTarget()

    else
      puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - Slow Click")
      stopMoving()
    end
  end

  def startMoving(direction)
    if direction == @up
      @downRelay.on
    elsif direction == @down
      @upRelay.on
    end

    @moving = direction
    @moveStartTime = (Time.now.to_f*1000).to_i
  end

  def stopMoving()
    time = (Time.now.to_f*1000).to_i

    if @moving == @up
      @downRelay.off
      @seatPos -= (time-@moveStartTime)
    elsif @moving == @down
      @upRelay.off
      @seatPos += (time-@moveStartTime)
    end

    if @seatPos < 0
      @seatPos = 0
    elsif @seatPos > @posFlat
      @seatPos = @posFlat
    end

    @moving = 0
    @moveStartTime = 0
    puts Time.now.strftime("%d/%m/%y %H:%M:%S:%L - S#{@seat} - Stopped @ #{@seatPos}")
  end

  def getCurrentPos()
    time = (Time.now.to_f*1000).to_i

    case @moving
      when 0
        currentPos = @seatPos
      when @up
        currentPos = @seatPos - (time-@moveStartTime)
      when @down
        currentPos = @seatPos + (time-@moveStartTime)
    end

    if currentPos > @posFlat
      return @posFlat
    elsif currentPos < 0
      return 0
    else
      return currentPos
    end
  end

  def moveToTarget
    currentPos = getCurrentPos()
    if @moveTarget > currentPos
      if @moving == @up
        stopMoving()
        startMoving(@down)
      elsif !isMoving()
        startMoving(@down)
      end
      sleepTime = @moveTarget-currentPos
      if @moveTarget == @posFlat
        sleepTime += @moveBuffer
      end
      moveSleepThread(sleepTime.to_f/1000)
    elsif @moveTarget < currentPos
      if @moving == @down
        stopMoving()
        startMoving(@up)
      elsif !isMoving()
        startMoving(@up)
      end
      sleepTime = currentPos-@moveTarget
      if @moveTarget == 0
        sleepTime += @moveBuffer
      end
      moveSleepThread(sleepTime.to_f/1000)
    end
  end

  def moveSleepThread(sleepTime)
    if defined?(@moveThread)
      Thread.kill(@moveThread)
    end

    @moveThread = Thread.new do
      sleep(sleepTime)
      stopMoving()
      @seatPos = @moveTarget
    end
  end

  def moveToUp
    @moveTarget = 0
    moveToTarget()
  end

  def moveToFeet
    @moveTarget = @posFeetUp
    moveToTarget()
  end

  def moveToFlat
    @moveTarget = @posFlat
    moveToTarget()
  end
end
