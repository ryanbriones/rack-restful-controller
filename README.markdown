# Rack::RESTfulController

I had a crazy idea the other day. Write a class that _looks_ like a "RESTful" Rails controller. Pass it to Rack. And with the help of a little middleware action... voilà!

Only today, when I fleshed it out completely did I think, "This could be useful for writing a quick prototype then moving it to Rails when it's ready." It's _probably_ useful for that too.

This is the fruition of those things.

## Install

    gem install rack-restful-controller -s http://gemcutter.org

## Usage

### config.ru

    require 'rack/restful-controller'
    
    class Foo
      def index
        "this is the index" # return a string, it becomes [200, {...}, ["this is the index"]]
      end
    
      def show
      end
    
      def create
        [302, {'Location' => '/42', ...}, ["body"]] # return an array, and it's just passed along to Rack
      end
    
      def edit
      end
    
      def update
      end
    
      def destroy
      end
    
      def foo
      end
    
      def bar
      end
    end
    
    use Rack::RESTfulController, :collection => {:foo => :get}, :member => {:bar => :get}
    run Rack::RESTfulController.as(Foo)

## Caveats

* Rack::RESTfulController#call isn't really that robust, but it works. Welcome to suggestions.
* I don't really like the name of Rack::RESTfulController.as, but it was the best I could think of at the time.

## TODO

* TEST
* Write a *few* helper methods; redirect_to, *_path, *_url

## License

Copyright (c) 2009 Ryan Carmelo Briones &lt;<ryan.briones@brionesandco.com>&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
