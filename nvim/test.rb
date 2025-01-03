require "securerandom"
require "tempfile"

class Test
  def initialize
    @queue = Thread::Queue.new
  end

  def random_uuid
    SecureRandom.uuid
  end

  def generate_file
    Tempfile.new
  end

  def wait_coordinator
    @queue.pop
  end
end
