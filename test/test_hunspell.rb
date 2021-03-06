# encoding: utf-8
require "test/unit"
require File.expand_path(File.dirname(__FILE__)) + '/../lib/hunspell-ffi'
class TestHunspell < Test::Unit::TestCase  
  def setup
    @dict_dir = File.dirname(__FILE__)
    @dict = Hunspell.new("#{@dict_dir}/cakes.aff", "#{@dict_dir}/cakes.dic")
  end
  
  def test_basic_spelling
    assert @dict.spell("Baumkuchen") == true
    assert @dict.check("Baumkuchen") == true # check alias
    assert @dict.spell("Bomcuken") == false
    assert_equal ["Baumkuchen"], @dict.suggest("Baumgurken")
    assert_equal [], @dict.suggest("qwss43easd")
  end
  
  def test_dict_modifications
    assert @dict.spell("Neuer Kuchen") == false
    @dict.add("Neuer Kuchen")
    assert @dict.spell("Neuer Kuchen") == true
    @dict.remove("Neuer Kuchen")
    assert @dict.spell("Neuer Kuchen") == false
    # TODO test add_with_affix
  end   
  
  def test_stemming
    en_dict = Hunspell.new( "/Applications/OpenOffice.org.app/Contents/share/uno_packages/cache/uno_packages/ew4NXe_/dict-en.oxt/en_US.aff", "/Applications/OpenOffice.org.app/Contents/share/uno_packages/cache/uno_packages/ew4NXe_/dict-en.oxt/en_US.dic")
    assert en_dict.stem('fishing') == %w[fishing fish]
  end
   
end