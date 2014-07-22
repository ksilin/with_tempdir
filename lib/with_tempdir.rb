require_relative 'with_tempdir/version'

module WithTempdir

  def with_tempdir(*filenames)
    Dir.mktmpdir do |dir|
      make_tempfiles(dir, filenames)
      yield dir
    end
  end

  def with_tempdir_and_files(*filenames)
    Dir.mktmpdir do |dir|
      files = make_tempfiles(dir, filenames)
      yield(dir, files)
    end
  end

  def make_tempfiles(dir, filenames)

    merged = filenames.each_with_object({}) { |f, result|
      result.merge!(should_be_hashed(f) ? { f => '' } : f)
    }
    names_and_content = merged.each_with_object({}) { |(key, value), result|
      result[key.to_s] = value
    }

    names_and_content.reduce([]) do |resulting_filenames, (name, content)|
      file_name = File.join(dir, name)
      # p "writing #{content} to #{name}"
      # not simply using the dir, since filenames may contain paths
      FileUtils.mkdir_p(File.dirname(file_name))
      open(file_name, 'w') { |f| f.write content }
      resulting_filenames << file_name
    end
  end

  def should_be_hashed(f)
    f.is_a?(String) || f.is_a?(Symbol)
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