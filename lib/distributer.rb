class Distributer
  attr_reader :distributer

  def initialize(distributer)
    @distributer = distributer
  end

  def make_transfers
    distributer.make_transfers
  end
end
