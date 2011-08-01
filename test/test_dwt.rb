require 'helper'

class TestDwt < Test::Unit::TestCase
  should "update page with template" do
    dwt = DWT.new
    dwt.template = File.dirname(__FILE__) + '/files/simple-02.dwt'
    dwt.files = File.dirname(__FILE__) + '/files/simple-01.html'
    assert_equal File.open(File.dirname(__FILE__) + '/files/simple-02.html').read, dwt.apply
  end

  should "not touch coude outside html tag" do
    dwt = DWT.new
    dwt.template = File.dirname(__FILE__) + '/files/simple-01.dwt'
    dwt.files = File.dirname(__FILE__) + '/files/simple-03.html'
    assert_equal File.open(File.dirname(__FILE__) + '/files/simple-03.html').read, dwt.apply
  end
end
