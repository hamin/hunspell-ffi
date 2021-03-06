# encoding: utf-8
require 'ffi'
class Hunspell  
  module C
    extend FFI::Library
    ffi_lib ['libhunspell', 'libhunspell-1.2', 'libhunspell-1.2.so.0']
    attach_function :Hunspell_create, [:string, :string], :pointer
    attach_function :Hunspell_spell, [:pointer, :string], :bool
    attach_function :Hunspell_suggest, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_add, [:pointer, :string], :int
    attach_function :Hunspell_add_with_affix, [:pointer, :string, :string], :int
    attach_function :Hunspell_remove, [:pointer, :string], :int
    attach_function :Hunspell_stem, [:pointer, :pointer, :string], :int    
  end
  
  def initialize(affpath, dicpath)
    warn("Hunspell could not find aff-file #{affpath}") unless File.exist?(affpath)
    warn("Hunspell could not find dic-file #{affpath}") unless File.exist?(dicpath)
    @handler = C.Hunspell_create(affpath, dicpath)
  end
  
  # Returns true for a known word or false.
  def spell(word)
    C.Hunspell_spell(@handler, word)
  end
  alias_method :check, :spell
  alias_method :check?, :check  
  
  # Returns an array with suggested words or returns and empty array.
  def suggest(word)
    ptr = FFI::MemoryPointer.new(:pointer, 1)    
    len = Hunspell::C.Hunspell_suggest(@handler, ptr, word)
    str_ptr = ptr.read_pointer
    str_ptr.null? ? [] : str_ptr.get_array_of_string(0, len).compact
  end
  
  # Add word to the run-time dictionary
  def add(word)
    C.Hunspell_add(@handler, word)
  end
  
  # Add word to the run-time dictionary with affix flags of
  # the example (a dictionary word): Hunspell will recognize
  # affixed forms of the new word, too.
  def add_with_affix(word, example)
    C.Hunspell_add_with_affix(@handler, word, example)
  end
    
  # Remove word from the run-time dictionary
  def remove(word)
    C.Hunspell_remove(@handler, word)
  end
  
  def stem(word)
    ptr = FFI::MemoryPointer.new(:pointer,1)    
    len = Hunspell::C.Hunspell_stem(@handler, ptr, word)
    str_ptr = ptr.read_pointer
    str_ptr.null? ? [] : str_ptr.get_array_of_string(0, len).compact
  end
end
