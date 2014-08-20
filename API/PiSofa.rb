gem 'pi_piper', '= 1.3.2'
#gem 'pi_piper', '= 2.0.beta.4'

require 'pi_piper'
require './PiSeat'

class PiSofa
  include PiPiper

  def initialize
    puts Gem.loaded_specs["pi_piper"].version.version

    @up, @down = 1, 2

    @switchRelay = PiPiper::Pin.new(:pin => 27, :direction => :out)
    @switchRelay.on

    @@seat = []
    @@seat << PiSeat.new(1,7,11,5300,8300)
    @@seat << PiSeat.new(2,22,8,4900,8000)
    @@seat << PiSeat.new(3,9,10,4900,8000)

    sofa0pinUp, sofa0pinDown = 17,4
    sofa1pinUp, sofa1pinDown = 3,2
    sofa2pinUp, sofa2pinDown = 18,23

    after :pin => sofa0pinUp, :goes => :high do
      @@seat[0].buttonReleased(1)
    end

    after :pin => sofa0pinUp, :goes => :low do
      @@seat[0].buttonPressed(1)
    end

    after :pin => sofa0pinDown, :goes => :high do
      @@seat[0].buttonReleased(2)
    end

    after :pin => sofa0pinDown, :goes => :low do
      @@seat[0].buttonPressed(2)
    end

    after :pin => sofa1pinUp, :goes => :high do
      @@seat[1].buttonReleased(1)
    end

    after :pin => sofa1pinUp, :goes => :low do
      @@seat[1].buttonPressed(1)
    end

    after :pin => sofa1pinDown, :goes => :high do
      @@seat[1].buttonReleased(2)
    end

    after :pin => sofa1pinDown, :goes => :low do
      @@seat[1].buttonPressed(2)
    end

    after :pin => sofa2pinUp, :goes => :high do
      @@seat[2].buttonReleased(1)
    end

    after :pin => sofa2pinUp, :goes => :low do
      @@seat[2].buttonPressed(1)
    end

    after :pin => sofa2pinDown, :goes => :high do
      @@seat[2].buttonReleased(2)
    end

    after :pin => sofa2pinDown, :goes => :low do
      @@seat[2].buttonPressed(2)
    end
  end

  def up
    @up
  end

  def down
    @down
  end

  def parentalMode
    @switchRelay.read
    if (@switchRelay.off?)
      @switchRelay.on
    else
      @switchRelay.off
    end
    return @switchRelay.off?.to_s
  end

  def stopAll
    3.times do |i|
      if @@seat[i].isMoving()
        @@seat[i].stopMoving()
      end
    end
  end

  def getPositions
    returnValue = ""
    3.times do |i|
      position = @@seat[i].getPosition()
      returnValue += "Sofa#{i+1} = #{position}\n"
    end

    returnValue
  end

  def moveToUp(id)
    if id == 0
      3.times do |i|
        @@seat[i].moveToUp()
      end
    else
      @@seat[id-1].moveToUp()
    end
  end

  def moveToFeet(id)
    if id == 0
      3.times do |i|
        @@seat[i].moveToFeet()
      end
    else
      @@seat[id-1].moveToFeet()
    end
  end

  def moveToFlat(id)
    if id == 0
      3.times do |i|
        @@seat[i].moveToFlat()
      end
    else
      @@seat[id-1].moveToFlat()
    end
  end

  def startManualMove(id, direction)
    if id == 0
      3.times do |i|
        @@seat[i].startMoving(direction)
      end
    else
      @@seat[id-1].startMoving(direction)
    end
  end

  def stopManualMove(id)
    if id == 0
      3.times do |i|
        @@seat[i].stopMoving()
      end
    else
      @@seat[id-1].stopMoving()
    end
  end
end
