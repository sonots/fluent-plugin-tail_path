require 'fluent/plugin/in_tail'

class Fluent::NewTailPathInput < Fluent::NewTailInput
  Fluent::Plugin.register_output('in_taiL_path', self)

  config_param :path_key, :string, :default => nil

  def configure(conf)
    super
  end

  if method_defined?(:parse_line) # fluentd < 0.10.50

    # Override to add path field
    def convert_line_to_event(line, es, tail_watcher)
      begin
        line.chomp!  # remove \n
        time, record = parse_line(line)
        if time && record
          record[@path_key] ||= tail_watcher.path unless @path_key.nil? # custom
          es.add(time, record)
        else
          log.warn "pattern not match: #{line.inspect}"
        end
      rescue => e
        log.warn line.dump, :error => e.to_s
        log.debug_backtrace(e)
      end
    end

  else # fluentd >= 0.10.50

    # Override to add path field
    def convert_line_to_event(line, es, tail_watcher)
      begin
        line.chomp!  # remove \n
        @parser.parse(line) { |time, record|
          if time && record
            record[@path_key] ||= tail_watcher.path unless @path_key.nil? # custom
            es.add(time, record)
          else
            log.warn "pattern not match: #{line.inspect}"
          end
        }
      rescue => e
        log.warn line.dump, :error => e.to_s
        log.debug_backtrace(e)
      end
    end

  end

  # Override to pass tail_watcher to convert_line_to_event
  def parse_singleline(lines, tail_watcher)
    es = ::Fluent::MultiEventStream.new
    lines.each { |line|
      convert_line_to_event(line, es, tail_watcher)
    }
    es
  end

  # Override to pass tail_watcher to convert_line_to_event
  def parse_multilines(lines, tail_watcher)
    lb = tail_watcher.line_buffer
    es = ::Fluent::MultiEventStream.new
    lines.each { |line|
      if @parser.parser.firstline?(line)
        if lb
          convert_line_to_event(lb, es, tail_watcher)
        end
        lb = line
      else
        if lb.nil?
          log.warn "got incomplete line before first line from #{tail_watcher.path}: #{lb.inspect}"
        else
          lb << line
        end
      end
    }
    tail_watcher.line_buffer = lb
    es
  end
end
