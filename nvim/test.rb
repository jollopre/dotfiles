require "securerandom"

class Test
  def random_uuid
    SecureRandom.uuid
  end
end
