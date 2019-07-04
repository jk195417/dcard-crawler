module Mentionable
  def mentions
    content&.scan(/[bB]\d+/) || []
  end
end
