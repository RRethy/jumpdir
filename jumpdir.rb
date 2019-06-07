require 'getoptlong'
require 'fileutils'

if ARGV.length == 0
  puts 'Expecting an option but found none.'
  exit 1
end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--mark', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--jump', '-j', GetoptLong::OPTIONAL_ARGUMENT ]
)

# TODO these should be handled better
@data_dir = "#{ENV['HOME']}/.local/share/jumpdir"
@data_file = "#{@data_dir}/data.txt"

def print_help
  puts 'TODO: write help'
end

def mark_pwd
  return if Dir.pwd == ENV['HOME']

  FileUtils.mkdir_p(@data_dir) unless Dir.exist?(@data_dir)

  dirs = []
  matched = false

  if File.exist?(@data_file)
    File.open(@data_file) do |f|
      f.each_line do |line|
        dir, val = line.split
        val = val.to_i
        if Dir.pwd == dir
          val += 1
          matched = true
        end
        dirs.push [dir, val]
      end
    end
  end

  dirs.push([ Dir.pwd, 1 ]) unless matched
  dirs.sort! { |a,b| b[1] <=> a[1] }

  File.open(@data_file, 'w') do |f|
    dirs.each do |pair|
      f.puts "#{pair[0]} #{pair[1]}"
    end
  end
end

def jump_dir(dir)
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

opts.each do |opt, arg|
  case opt
  when '--help'
    print_help
  when '--mark'
    mark_pwd
  when '--jump'
    jump_dir arg
  end
end
