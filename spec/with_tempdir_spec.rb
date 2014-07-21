require 'rspec'

describe WithTempdir do

  it 'should create and remove a directory' do

    temp_dir = with_tempdir{|dir|
      expect(File.directory? dir).to be_true
      expect(File.exist? dir).to be_true
      dir
    }
    expect(File.directory? temp_dir).to be_false
    expect(File.exist? temp_dir).to be_false
  end

  it 'should create the temp directory inside the /tmp folder' do
    with_tempdir{|dir|
      expect(dir).to match(/\/tmp\//)
    }
  end

end