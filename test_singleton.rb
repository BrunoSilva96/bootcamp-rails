class TestSingleton
  private_class_method :new

  def self.singleton
    @instance ||= self.new
  end

  private

  def initialize
  end
end

first = TestSingleton.singleton
second = TestSingleton.singleton

p first.object_id
p second.object_id