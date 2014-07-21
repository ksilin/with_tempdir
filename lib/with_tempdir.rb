require_relative 'with_tempdir/version'

module WithTempdir

  def with_tempdir(*filenames)
    puts "filenames: #{filenames.inspect}"
    Dir.mktmpdir do |dir|
      make_tempfiles(dir, filenames)
      yield dir
    end
  end

  def with_tempdir_and_files(filenames = {})
    Dir.mktmpdir do |dir|
      files = make_tempfiles(dir, filenames)
      yield(dir, files)
    end
  end

  def make_tempfiles(dir, filenames)

    puts "filenames orig: #{filenames}"

    # TODO: this sucks, how do I coerce the input nicely?
    if filenames.first.kind_of? Hash
      filenames = filenames.first
    end

    if filenames.kind_of? Array
      filenames = Hash[filenames.flatten.map{|f| [f, '']}]
      puts "filenames are hashed #{filenames}"
    end

    filenames.reduce([]) do |resulting_filenames, file|

      p "writing #{file[1]} to #{file[0]}"
      file_name = File.join(dir, file[0])
      # not simply using the dir, since filenames may contain paths
      FileUtils.mkdir_p(File.dirname(file_name))
      open(file_name, 'w') { |f| f.write file[1] }
      resulting_filenames << file_name
    end
  end

# creating temp directories recursively
# directories argument is used for recursion
# and is not supposed to be used by the client/user
  def with_tempdirs(filenames = {}, directories = [], &block)

    return block.call(directories) if filenames.empty?

    with_tempdir(filenames.pop) do |dir|
      with_tempdirs(filenames, directories << dir, &block)
    end
  end

# TODO: test this
# creating temp directories recursively
# directories argument is used for recursion
# and is not supposed to be used by the client/user
  def with_tempdirs_and_files(filenames = {}, directories = [], files = [] &block)
    block.call(directories, files) if filenames.empty?

    with_tempdir_and_files(filenames.pop) do |dir, f|
      with_tempdirs_and_files(filenames, directories << dir, files.concat(f), &block)
    end
  end

end