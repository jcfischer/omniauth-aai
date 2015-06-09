require 'spec_helper'

describe Omniauth::HasCurrentUser do

  def test_to_squawk_prepends_the_word_squawk
    assert_equal "squawk! Hello World", "Hello World".to_squawk
  end

end
