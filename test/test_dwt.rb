require 'helper'

class TestDwt < Test::Unit::TestCase
  should "update page with template" do
    dwt = DWT.new
    dwt.template = File.dirname(__FILE__) + '/files/Templates/simple-02.dwt'
    dwt.files = File.dirname(__FILE__) + '/files/simple-01.html'
    assert_equal File.open(File.dirname(__FILE__) + '/files/simple-02.html').read, dwt.apply
  end

  should "not touch coude outside html tag" do
    dwt = DWT.new
    dwt.template = File.dirname(__FILE__) + '/files/Templates/simple-01.dwt'
    dwt.files = File.dirname(__FILE__) + '/files/outside-html-01.html'
    assert_equal File.open(File.dirname(__FILE__) + '/files/outside-html-01.html').read, dwt.apply
  end

  should "modify href, src, action attributes" do
    dwt = DWT.new
    dwt.template = File.dirname(__FILE__) + '/files/Templates/link-attribute-01.dwt'
    dwt.files = File.dirname(__FILE__) + '/files/simple-01.html'
    assert_equal File.open(File.dirname(__FILE__) + '/files/link-attribute-01.html').read, dwt.apply
  end
end
