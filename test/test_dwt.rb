require 'helper'

class TestDwt < Test::Unit::TestCase
  should "update page with template" do
    assert_dwt(File.dirname(__FILE__) + '/files/Templates/simple-02.dwt',
               File.dirname(__FILE__) + '/files/simple-01.html',
               File.open(File.dirname(__FILE__) + '/files/simple-02.html').read)
  end

  should "not touch coude outside html tag" do
    assert_dwt(File.dirname(__FILE__) + '/files/Templates/simple-01.dwt',
               File.dirname(__FILE__) + '/files/outside-html-01.html',
               File.open(File.dirname(__FILE__) + '/files/outside-html-01.html').read)
  end

  should "modify href, src, action attributes" do
    assert_dwt(File.dirname(__FILE__) + '/files/Templates/link-attribute-01.dwt',
               File.dirname(__FILE__) + '/files/simple-01.html',
               File.open(File.dirname(__FILE__) + '/files/link-attribute-01.html').read)
  end

  should "modify link attributes, but ignore external location" do
    assert_dwt(File.dirname(__FILE__) + '/files/Templates/link-attribute-02.dwt',
               File.dirname(__FILE__) + '/files/simple-01.html',
               File.open(File.dirname(__FILE__) + '/files/link-attribute-02.html').read)
  end

  should "modify link attributes, but ignore external not relative" do
    assert_dwt(File.dirname(__FILE__) + '/files/Templates/link-attribute-03.dwt',
               File.dirname(__FILE__) + '/files/simple-01.html',
               File.open(File.dirname(__FILE__) + '/files/link-attribute-03.html').read)
  end

  private
    def assert_dwt(template, file, expected)
      dwt = DWT.new
      dwt.template = template
      dwt.files = file
      assert_equal expected, dwt.apply
    end

end
