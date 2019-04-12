module Dcard::LoadData
  def self.load_from_dcard; end

  def load_from_dcard(data)
    new_values = self.class.load_from_dcard(data)
    assign_attributes(new_values)
    self
  end
end
