module Rack
  class RESTfulController
    @@collection_methods = {}
    @@member_methods = {:edit => :get}

    module App
      def call(env)
        @request = Rack::Request.new(env)
        @params = (@request.params || {}).merge(env['restful.params'])
        
        if env['restful.action'] && respond_to?(env['restful.action'])
          body = send(env['restful.action'])
          case body
          when String
            [200, {'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s}, [body]]
          when Array
            body
          end
        else
          body = "Not Found: #{@request.path}"
          [404, {'Content-Type' => 'text/plain', 'Content-Length' => body.length.to_s}, [body]]
        end
      end
    end

    def self.as(klass)
      a = klass.new
      a.extend(App)
      a
    end

    def initialize(app, options = {})
      @app = app
      @options = options

      if(options.include?(:collection))
        @@collection_methods.merge!(options[:collection])
      end

      if(options.include?(:member))
        @@member_methods.merge!(options[:member])
      end
    end

    def call(env)
      req = Rack::Request.new(env)

      env['restful.params'] = {}

      if req.get? && req.path == '/'
        env['restful.action'] = :index
      elsif req.get? && (match = req.path.match(/^\/(.+?)(?:\/(.+))?$/))
        if(match[2] && @@member_methods[match[2].to_sym] == :get)
          env['restful.action'] = match[2].to_sym
          env['restful.params'] = {'id' => match[1]}
        elsif(match[2] && @@member_methods[match[2].to_sym] != :get)
        elsif(!match[2] && @@collection_methods[match[1].to_sym] == :get)
          env['restful.action'] = match[1].to_sym
        else
          env['restful.action'] = :show
          env['restful.params'] = {'id' => match[1]}
        end
      elsif req.post? && req.path == '/'
        env['restful.action'] = :create
      elsif (req.put? || mimic_put?(req)) && (match = req.path.match(/^\/(.+?)(?:\/(.+))?$/))
        if(match[2] && @@member_methods[match[2].to_sym] == :put)
          env['restful.action'] = match[2].to_sym
          env['restful.params'] = {'id' => match[1]}
        elsif(match[2] && @@member_methods[match[2].to_sym] != :put)
        else
          env['restful.action'] = :update
          env['restful.params'] = {'id' => match[1]}
        end
      elsif (req.delete? || mimic_delete?(req)) && (match = req.path.match(/^\/(.+)$/))
        env['restful.action'] = :destroy
        env['restful.params'] = {'id' => match[1]}
      end

      env['restful.params'].merge!('action' => env['restful.action'].to_s)
      
      @app.call(env)
    end

    def mimic_put?(req)
      req.post? && req.params['_method'] == 'put'
    end

    def mimic_delete?(req)
      req.post? && req.params['_method'] == 'delete'
    end
  end
end
