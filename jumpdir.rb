require 'fileutils'

if !File.exist?("#{ENV['HOME']}/.local/share/jr/data.txt")\
    || ARGV.length != 1
  puts Dir.pwd
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
