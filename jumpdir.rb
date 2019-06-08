require 'getoptlong'
require 'fileutils'

if ARGV.length == 0
  puts 'Expecting an option but found none.'
  exit 1
end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--incdir', '-i', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--jump', '-j', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--complete', '-c', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--markdir', '-m', GetoptLong::REQUIRED_ARGUMENT ]
)

# TODO these should be handled better
@data_dir = "#{ENV['HOME']}/.local/share/jumpdir"
@data_file = "#{@data_dir}/data.txt"

def print_help
  puts 'TODO: write help'
end

def inc_dir(dir)
  return if dir == ENV['HOME']

  FileUtils.mkdir_p(@data_dir) unless Dir.exist?(@data_dir)

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

def markdir(mark)
end

opts.each do |opt, arg|
  case opt
  when '--help'
    print_help
  when '--incdir'
    if arg.empty?
      inc_dir Dir.pwd
    else
      inc_dir arg
    end
  when '--jump'
    jump_dir arg
  when '--complete'
    complete arg
  when '--markdir'
    markdir arg
  end
end
