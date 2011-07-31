require 'trollop'

opts = Trollop::options do
  opt :template, "DWT file", :short => 't', :type => String
  opt :file, "Target file", :short => 'f', :type => String
end
Trollop::die :template, "must be present" unless opts[:template]
Trollop::die :template, "must exist" unless File.exist?(opts[:template]) if opts[:template]
Trollop::die :file, "must be present" unless opts[:file]
Trollop::die :file, "must exist" unless File.exist?(opts[:template]) if opts[:template]

tpl_end_editable_str = "<!-- TemplateEndEditable -->"
tpl = File.open(opts[:template]).read
tpl_copy = []

begin
  tpl_end = tpl.index("<!-- TemplateBeginEditable")
  tpl_start = tpl.index(tpl_end_editable_str)
  tpl_start = tpl_start + tpl_end_editable_str.length if tpl_start
  tpl_copy << (tpl_end ? tpl[0,tpl_end] : tpl)
  tpl = tpl_start ? tpl[tpl_start,tpl.length] : ''
end while tpl.length > 0

tar_end_editable_str = "<!-- InstanceEndEditable -->"
tar = File.open(opts[:file]).read
tar_copy = []

begin
  tar_start = tar.index("<!-- InstanceBeginEditable")
  tar_end = tar.index(tar_end_editable_str)
  tar_end = tar_end + tar_end_editable_str.length if tar_end
  tar_copy << tar[tar_start,tar_end] if tar_start
  tar = tar_end ? tar[tar_end,tar.length] : ''
end while tar.length > 0

new = ''
(0..(tar_copy.length)).to_a.each do |i|
  new = new += tpl_copy[i]
  new = new += tar_copy[i] if tar_copy[i]
end

puts new
