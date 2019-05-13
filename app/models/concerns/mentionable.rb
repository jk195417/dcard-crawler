module Mentionable
  def mentions
    # result = []
    # content&.scan(/B\d+/) { |floor_with_B| result << floor_with_B[1..-1].to_i }
    # return result
    content&.scan(/B\d+/) || []
  end
end
