module Hydra::Proxy
  class VirtualProxy

    private

    attr_reader :__key, :__loader
    attr_accessor :__real

    public

    GHOST = "GHOST"
    LOADED = "LOADED"

    # @param key [Object] key used by the loader to load the real object
    # @param loader [Object] loader method/proc that receives :call with key and returns real object
    def initialize(key, loader)
      @__key = key
      @__loader = loader
      @__real = nil
      self
    end

    protected

    def method_missing(name, *args, &block)
      if __real.nil?
        __load
      end
      __real.send(name, *args, &block)
    end

    private

    def __load
      self.__real = __loader.call(__key)
    end

    def __state
      if __real.nil?
        GHOST
      else
        LOADED
      end
    end

    def ghost?
      __state == GHOST
    end

    def loaded?
      __state == LOADED
    end

  end
end
