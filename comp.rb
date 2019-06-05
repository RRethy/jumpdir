require 'fileutils'

if !File.exist?("#{ENV['HOME']}/.local/share/jr/data.txt")
  exit
end

keyword = ARGV.length == 0 ? '' : ARGV[0]

dirs = []

File.open("#{ENV['HOME']}/.local/share/jr/data.txt") do |f|
  f.each_line do |line|
    dir, = line.split
    if /#{keyword.downcase}/ =~ dir.downcase
      dirs.push dir
    end
  end
end

puts dirs.join(",")
