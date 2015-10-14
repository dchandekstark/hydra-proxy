module Hydra::Proxy
  class VirtualObject

    class << self
      attr_accessor :proxy_classes
    end

    private

    attr_reader :__key, :__proxies

    public

    def initialize(key)
      @__key = key
      @__proxies = self.class.proxy_classes.map { |klass| klass.new(key) }
      self
    end

    protected

    def method_missing(name, *args, &block)
      # send to loaded proxies first ...
      __proxies.select(&:loaded?).each do |proxy|
        begin
          return proxy.send(name, *args, &block)
        rescue NoMethodError
          next
        end
      end
      # ... otherwise load and send to proxies in reverse order
      __proxies.reverse.each do |proxy|
        begin
          return proxy.send(name, *args, &block)
        rescue NoMethodError
          next
        end
      end
      super
    end

  end
end
