# WithTempdir

I often use the filesystem to mock out directories and files for tests, so I created a convenient way to provide those:

## Installation

Add this line to your application's Gemfile:

    gem 'with_tempdir'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install with_tempdir

## Usage

If using with [rspec](http://rspec.info/), include this into your `spec_helper.rb`, inside the `RSpec.configure` block:

`config.include WithTempdir`

Then you can use it in your tests.

Create a randomly named empty directory in your system's temp directory:

```
  with_tempdir { |dir|
      # expect and assert 
  }
```
The yielded variable is the name of your directory.

Create a directory with some empty files:

```
  with_tempdir('bar', :foo) { |dir|
      # expect and assert 
  }
```
You can use symbols and strings as file names. A file name can contain a relative path:

```
  with_tempdir('some/deep/tree/bar') { |dir|
      # expect and assert 
  }
```

You can provide files with content:

```
  with_tempdir('bar' => 'yay, content!', :foo => 'hoge') { |dir|
      # expect and assert
  }
```

You can have empty files and files with content:

```
  with_tempdir('foo', 'bar' => 'yay, content!', :baz => 'hoge') { |dir|
      # expect and assert
  }
```
 
To take advantage of the implicit hash conversion, the hash elements have to come as last parameters.

Otherwise, you have to use explicit hashes:
  
```
  with_tempdir({ 'foo' => 'yay, content!' }, 'bar', { :baz => 'lorem ipsum' }) { |dir|
      # expect and assert
  }
```

If you want to also have a list of files yielded into the block, use `with_tempdir_and_files` instead of `with_tempdir`:

```
  with_tempdir_and_files('foo', { :bar => 'lorem ipsum' }) { |dir, files|
      # expect and assert
  }
```

There is no option to create multiple temp directories yet. You can work around by adding prefixes to your file names to create subdirectories of the temp directory.

There is no option yet to define a name for the created directories.

If you know how to integrate nicely with other testing frameworks, please open an issue or a pull request.

Have fun and create an issue for your questions and comments.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/with_tempdir/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
