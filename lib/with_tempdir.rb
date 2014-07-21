require_relative 'with_tempdir/version'

module WithTempdir

  def with_tempdir(filenames = {})
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
    filenames.reduce([]) do |fn, name, content|

      file_name = File.join(dir, name.to_s)
      # not simply usign the dir, since filenames may contain paths
      FileUtils.mkdir_p(File.dirname(file_name))

      p "writing #{content} to #{file_name}"
      open(file_name, 'w') { |f| f.write content }
      fn << file_name
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
  def with_tempdirs_and_files(filenames = {}, directories = [], files = [] & block)
    block.call(directories, files) if filenames.empty?

    with_tempdir_and_files(filenames.pop) do |dir, f|
      with_tempdirs_and_files(filenames, directories << dir, files.concat(f), &block)
    end
  end

  def to_filelist(*names)
    names.reduce({}) do |h, name|
      h[name] = nil
      h
    end
  end

end