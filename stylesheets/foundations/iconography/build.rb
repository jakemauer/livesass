input = File.open('_variables.scss', 'r')
flag_reached = false
results = []

input.each_line do |line|
    results << line if flag_reached
    flag_reached = true if line =~ /\/\/ START ICONS/
end

input.close

results = results.keep_if { |value| value != "\n"}

class_prefix = ".icon-"
pseudo = ":before"
r = /\$(.*)\:/
output = File.open('_icons.scss', 'w')
# clear the file
output.truncate(0)
# write the warning
output.write("// Please don't edit this file by hand, see build.rb\n")

results.each do |icon|
    class_base = r.match(icon)
    output.write("#{class_prefix}#{class_base[1]}#{pseudo} { content: #{class_base[0].gsub(/\:/, "")}; }\n")
end

output.close