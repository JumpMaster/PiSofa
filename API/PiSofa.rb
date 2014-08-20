gem 'pi_piper', '= 1.3.2'
#gem 'pi_piper', '= 2.0.beta.4'

require 'pi_piper'
require './PiSeat'

class PiSofa
  include PiPiper

  def initialize
    puts Gem.loaded_specs["pi_piper"].version.version

    @up, @down = 1, 2
    @crazyMode = false

    @switchRelay = PiPiper::Pin.new(:pin => 27, :direction => :out)
    @switchRelay.on

    @@seat = []
    @@seat << PiSeat.new(1,7,11,5300,8300)
    @@seat << PiSeat.new(2,22,8,4900,8000)
    @@seat << PiSeat.new(3,9,10,4900,8000)

    sofa0pinUp, sofa0pinDown = 17,4
    sofa1pinUp, sofa1pinDown = 3,2
    sofa2pinUp, sofa2pinDown = 18,23

    @@seatPin = [[0,1],[0,2],[1,1],[1,2],[2,1],[2,2]]

    after :pin => sofa0pinUp, :goes => :high do
      @@seat[@@seatPin[0][0]].buttonReleased(@@seatPin[0][1])
    end

    after :pin => sofa0pinUp, :goes => :low do
      @@seat[@@seatPin[0][0]].buttonPressed(@@seatPin[0][1])
    end

    after :pin => sofa0pinDown, :goes => :high do
      @@seat[@@seatPin[1][0]].buttonReleased(@@seatPin[1][1])
    end

    after :pin => sofa0pinDown, :goes => :low do
      @@seat[@@seatPin[1][0]].buttonPressed(@@seatPin[1][1])
    end

    after :pin => sofa1pinUp, :goes => :high do
      @@seat[@@seatPin[2][0]].buttonReleased(@@seatPin[2][1])
    end

    after :pin => sofa1pinUp, :goes => :low do
      @@seat[@@seatPin[2][0]].buttonPressed(@@seatPin[2][1])
    end

    after :pin => sofa1pinDown, :goes => :high do
      @@seat[@@seatPin[3][0]].buttonReleased(@@seatPin[3][1])
    end

    after :pin => sofa1pinDown, :goes => :low do
      @@seat[@@seatPin[3][0]].buttonPressed(@@seatPin[3][1])
    end

    after :pin => sofa2pinUp, :goes => :high do
      @@seat[@@seatPin[4][0]].buttonReleased(@@seatPin[4][1])
    end

    after :pin => sofa2pinUp, :goes => :low do
      @@seat[@@seatPin[4][0]].buttonPressed(@@seatPin[4][1])
    end

    after :pin => sofa2pinDown, :goes => :high do
      @@seat[@@seatPin[5][0]].buttonReleased(@@seatPin[5][1])
    end

    after :pin => sofa2pinDown, :goes => :low do
      @@seat[@@seatPin[5][0]].buttonPressed(@@seatPin[5][1])
    end
  end

  def up
    @up
  end

  def down
    @down
  end

  def toggleParentalMode
    @switchRelay.read
    if (@switchRelay.off?)
      @switchRelay.on
    else
      @switchRelay.off
    end
  end

  def isParentalMode
    @switchRelay.read
    return @switchRelay.off?.to_s
  end

  def stopAll
    @@seat.each do |seat|
      if seat.isMoving()
        seat.stopMoving()
      end
    end
  end

  def getPositions
    returnValue = ""
    @@seat.each_with_index do |seat, i|
      position = seat.getPosition()
      returnValue += "Sofa#{i+1} = #{position}\n"
    end

    returnValue
  end

  def moveToUp(id)
    if id == 0
      @@seat.each do |seat|
        seat.moveToUp()
      end
    else
      @@seat[id-1].moveToUp()
    end
  end

  def moveToFeet(id)
    if id == 0
      @@seat.each do |seat|
        seat.moveToFeet()
      end
    else
      @@seat[id-1].moveToFeet()
    end
  end

  def moveToFlat(id)
    if id == 0
      @@seat.each do |seat|
        seat.moveToFlat()
      end
    else
      @@seat[id-1].moveToFlat()
    end
  end

  def startManualMove(id, direction)
    if id == 0
      @@seat.each do |seat|
        seat.startMoving(direction)
      end
    else
      @@seat[id-1].startMoving(direction)
    end
  end

  def stopManualMove(id)
    if id == 0
      @@seat.each do |seat|
        seat.stopMoving()
      end
    else
      @@seat[id-1].stopMoving()
    end
  end

  def toggleCrazyMode
    @crazyMode = !@crazyMode

    if @crazyMode
      @@seatPin = @@seatPin.shuffle
      @@seatPin = @@seatPin.shuffle
    else
      @@seatPin = @@seatPin.sort
    end
  end

  def isCrazyMode
    @crazyMode
  end
end
