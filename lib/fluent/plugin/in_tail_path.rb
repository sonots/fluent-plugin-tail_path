require 'fluent/plugin/in_tail'

class RouterWrap
  attr_accessor :tail_watcher

  def initialize(router, path_key)
    @router = router
    @path_key = path_key
    @tail_watcher = nil
  end

  def emit(tag, time, record)
    record[@path_key] = @tail_watcher.path unless @path_key.nil?
    @router.emit(tag, time, record)
  end

  def emit_array(tag, array)
    @router.emit_array(tag, array)
  end

  def emit_stream(tag, es)
    es.each {|time,record|
      record[@path_key] = @tail_watcher.path unless @path_key.nil?
    }
    @router.emit_stream(tag, es)
  end
end

class Fluent::NewTailPathInput < Fluent::NewTailInput
  Fluent::Plugin.register_input('tail_path', self)

  config_param :path_key, :string, :default => nil

  def configure(conf)
    super
    @router = RouterWrap.new(@router, @path_key)
  end

  def receive_lines(lines, tail_watcher)
    @router.tail_watcher = tail_watcher
    super
  end
end

