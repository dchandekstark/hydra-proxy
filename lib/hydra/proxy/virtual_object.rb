module Hydra::Proxy
  class VirtualObject

    class << self
      attr_accessor :index_proxy_class, :repo_proxy_class
    end

    private

    attr_reader :__key, :__index_proxy, :__repo_proxy

    public

    def initialize(key)
      @__key = key
      @__index_proxy = self.class.index_proxy_class.new(key)
      @__repo_proxy = self.class.repo_proxy_class.new(key)
      self
    end

    protected

    def method_missing(name, *args, &block)
      __index_proxy.send(name, *args, &block)
    rescue NoMethodError
      __repo_proxy.send(name, *args, &block)
    end

  end
end
