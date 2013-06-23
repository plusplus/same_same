samesame
========

Ruby version of clustering algorithms from "Algorithms of the Intelligent Web"

## Status

Pretty much direct port of the sameple code from the book (Java).


### Todo
  * **Expand specs**. The basics have specs, but some of the computation specs are just testing the thing doesn't blow up, NOT that the calculation is right. Lots of higher level code doesn't have any specs
  * **Refactor**. Some of the classes and methods are filthy. Things like `Cluster` are just thin wrappers that delegate to arrays.
  * **Push in more data and see what happens**

## Installation

Add this line to your application's Gemfile:

    gem 'samesame'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install samesame

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
