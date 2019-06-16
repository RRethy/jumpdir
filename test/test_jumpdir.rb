require_relative '../jumpdir'
require 'test/unit'

class TestJumpdir < Test::Unit::TestCase

  EXPECTED_DATA_DIR = File.expand_path(__dir__);

  def setup
    ENV['XDG_DATA_DIR'] = "#{ENV['HOME']}/.local/share" unless ENV['XDG_DATA_DIR'] && !ENV['XDG_DATA_DIR'].empty?
    @data_dir = "#{ENV['XDG_DATA_DIR']}/jumpdir_test"
    @data_file = "#{@data_dir}/data.txt"
    @marks_file = "#{@data_dir}/marks.txt"
    FileUtils.mkdir_p(@data_dir) unless Dir.exist?(@data_dir)
  end

  def teardown
    FileUtils.rm_rf(@data_dir)
  end

  def test_inc_dir

    def assert_file_contents(fname, expected_lines)
      IO.readlines(fname).each_with_index do |item, index|
        assert_equal(expected_lines[index], item)
      end
    end

    inc_dir 'foo/bar/baz'
    assert_file_contents(@data_file, ['foo/bar/baz 1'])

    inc_dir 'foo/bar/baz'
    assert_file_contents(@data_file, ['foo/bar/baz 2'])

    inc_dir 'not/foo/bar/baz'
    assert_file_contents(@data_file, ['foo/bar/baz 2', 'not/foo/bar/baz 1'])
  end

  def test_jump_dir
  end

  def complete
  end

  def mark_dir
  end

  def jump_mark
  end

  def jump_child
  end

end
