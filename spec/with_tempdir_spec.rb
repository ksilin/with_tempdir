require 'rspec'

describe WithTempdir do

  it 'should create and remove a directory' do

    temp_dir = with_tempdir { |dir|
      expect(File.directory? dir).to be_true
      expect(File.exist? dir).to be_true
      dir
    }
    expect(File.directory? temp_dir).to be_false
    expect(File.exist? temp_dir).to be_false
  end

  it 'should create the temp directory inside the /tmp folder' do
    with_tempdir { |dir|
      expect(dir).to match(/\/tmp\//)
    }
  end

  it 'should create files in the temp dir' do
    with_tempdir('bar', 'foo') { |dir|
      files = Dir.glob("#{dir}/*")
      expect(files.map{|f| File.basename(f)}).to eq(['bar', 'foo'])
    }
  end

  it 'should create files with content in the temp dir' do
    with_tempdir('bar' => 'xxx', 'foo' => 'yyy') { |dir|
      files = Dir.glob("#{dir}/*")
      expect(files.map{|f| File.basename(f)}).to eq(['bar', 'foo'])
    }
  end

  it 'should create file with content and return its name' do
    with_tempdir_and_files('foo' => 'yay, content!') { |dir, files|
      puts "files returned: #{files}"
      files.each { |f| expect(File.read f ).to match(/yay, content/) }
    }
  end

  it 'should create files with content and return their names' do
    with_tempdir_and_files('foo' => 'yay, content!', 'bar' => 'lorem ipsum') { |dir, files|
      puts "files returned: #{files}"
      expect(files.map{|f| File.basename(f)}.sort).to eq(['bar', 'foo'])
    }
  end

  it 'should create files with and without content and return their names' do
    with_tempdir_and_files('foo', 'bar' => 'lorem ipsum') { |dir, files|
      puts "files returned: #{files}"
      expect(files.map{|f| File.basename(f)}.sort).to eq(['bar', 'foo'])
    }
  end

end