require 'getoptlong'
require 'fileutils'
require 'find'

if ARGV.length == 0
  puts 'Expecting an option but found none.'
  exit 1
end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--incdir', '-i', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--jumpdir', '-j', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--complete', '-c', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--markdir', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--jumpmark', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--jumpchild', GetoptLong::REQUIRED_ARGUMENT ]
)

# TODO these should be handled better
@data_dir = "#{ENV['HOME']}/.local/share/jumpdir"
@data_file = "#{@data_dir}/data.txt"
@marks_file = "#{@data_dir}/marks.txt"

def print_help
  puts 'TODO: write help'
end

def inc_dir(dir)
  return if dir == ENV['HOME']

  paths = []
  matched = false

  if File.exist?(@data_file)
    File.open(@data_file) do |f|
      f.each_line do |line|
        path, val = line.split
        val = val.to_i
        if dir == path
          val += 1
          matched = true
        end
        paths.push [path, val]
      end
    end
  end

  paths.push([ dir, 1 ]) unless matched
  paths.sort! { |a,b| b[1] <=> a[1] }

  File.open(@data_file, 'w') do |f|
    paths.each do |pair|
      f.puts "#{pair[0]} #{pair[1]}"
    end
  end
end

def jump_dir(dir)
  return ENV['HOME'] if dir.empty?

  unless File.exist?(@data_file)
    puts Dir.pwd
    return
  end

  File.open(@data_file) do |f|
    f.each_line do |line|
      path, = line.split
      if /#{dir.downcase}/ =~ path.downcase
        puts path
        return
      end
    end
  end

  puts Dir.pwd
end

def complete(str)
  return unless File.exists?(@data_file)

  results = []

  File.open(@data_file) do |f|
    f.each_line do |line|
      dir, = line.split
      if dir.downcase =~ /#{str.downcase}/
        results.push dir
      end
    end
  end

  puts results.join(' ')
end

def mark_dir(mark)
  return unless mark =~ /\w/

  marks_data = []
  matched = false

  File.open(@marks_file) do |f|
    f.each_line do |line|
      path, tag = line.split
      if tag == mark
        path = Dir.pwd
        matched = true
      end
      marks_data.push [path, tag]
    end
  end if File.exist?(@marks_file)

  marks_data.push([ Dir.pwd, mark ]) unless matched

  File.open(@marks_file, 'w') do |f|
    marks_data.each do |pair|
      f.puts "#{pair[0]} #{pair[1]}"
    end
  end
end

def jump_mark(mark)
  unless mark =~ /\w/ && File.exist?(@marks_file)
    puts Dir.pwd
    return
  end

  File.open(@marks_file) do |f|
    f.each_line do |line|
      path, tag = line.split
      if tag == mark
        puts path
        return
      end
    end
  end

  puts Dir.pwd
end

def jump_child(child)
  Find.find(Dir.pwd) do |path|
    if File.directory?(path)
      if path.downcase =~ /#{child.downcase}/
        puts path
        return
      end
    end
  end
end

opts.each do |opt, arg|
  FileUtils.mkdir_p(@data_dir) unless Dir.exist?(@data_dir)

  case opt
  when '--help'
    print_help
  when '--incdir'
    if arg.empty?
      inc_dir Dir.pwd
    else
      inc_dir arg
    end
  when '--jumpdir'
    jump_dir arg
  when '--complete'
    complete arg
  when '--markdir'
    mark_dir arg
  when '--jumpmark'
    jump_mark arg
  when '--jumpchild'
    jump_child arg
  end
end
