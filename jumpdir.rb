require 'fileutils'

unless File.exist?("#{ENV['HOME']}/.local/share/jr/data.txt")
  puts Dir.pwd
  exit
end

unless ARGV.length == 1
  puts ENV['HOME']
  exit
end

File.open("#{ENV['HOME']}/.local/share/jr/data.txt") do |f|
  f.each_line do |line|
    dir, = line.split
    if /#{ARGV[0].downcase}/ =~ dir.downcase
      puts dir
      exit
    end
  end
end

puts Dir.pwd
