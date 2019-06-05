require 'fileutils'

if /^\.{1,2}$/ =~ Dir.pwd || Dir.pwd == ENV['HOME']
  exit
end

puts Dir.pwd

unless Dir.exist?("#{ENV['HOME']}/.local/share/jr")
  FileUtils.mkdir_p "#{ENV['HOME']}/.local/share/jr"
end

dirs = []
matched = false

if File.exist?("#{ENV['HOME']}/.local/share/jr/data.txt")
  File.open("#{ENV['HOME']}/.local/share/jr/data.txt") do |f|
    f.each_line do |line|
      dir, val = line.split
      val = val.to_i
      if /^#{Dir.pwd}$/ =~ dir
        val += 1
        matched = true
      end
      dirs.push [dir, val]
    end
  end
end

unless matched
  dirs.push [Dir.pwd, 1]
end

dirs.sort! { |a,b| b[1] <=> a[1] }

File.open("#{ENV['HOME']}/.local/share/jr/data.txt", 'w') do |f|
  dirs.each do |pair|
    f.puts "#{pair[0]} #{pair[1]}"
  end
end
