class DWT
  attr_accessor :template, :files

  def apply
    files = [@files] if @files.is_a? String

    tpl_end_editable_str = "<!-- TemplateEndEditable -->"
    tpl = File.open(@template).read
    tpl_copy = []

    begin
      tpl_src = @template.index('Templates/').nil? ? '/Templates/' + @template.gsub(/^.*\/([^\/]*)/,'\1') : @template.gsub(/^.*Templates\/(.*)$/, '/Templates/\1')
      tpl_end = tpl.index("<!-- TemplateBeginEditable")
      tpl_start = tpl.index(tpl_end_editable_str)
      tpl_start = tpl_start + tpl_end_editable_str.length if tpl_start
      copy = (tpl_end ? tpl[0,tpl_end] : tpl)
      copy.gsub!(/<html([^>]*)>/, '<html\1><!-- InstanceBegin template="'+tpl_src+'" codeOutsideHTMLIsLocked="false" -->')
      copy.gsub!(/<\/html>/,'<!-- InstanceEnd --></html>')
      tpl_copy << copy
      tpl = tpl_start ? tpl[tpl_start,tpl.length] : ''
    end while tpl.length > 0

    tar_end_editable_str = "<!-- InstanceEndEditable -->"
    tar = File.open(files[0]).read
    tar_copy = []

    begin
      tar_start = tar.index("<!-- InstanceBeginEditable")
      tar_end = tar.index(tar_end_editable_str)
      tar_end = tar_end + tar_end_editable_str.length if tar_end
      tar_copy << tar[tar_start,tar_end-tar_start] if tar_start
      tar = tar_end ? tar[tar_end,tar.length-tar_end] : ''
    end while tar.length > 0

    new = ''
    (0..(tar_copy.length)).to_a.each do |i|
      new = new += tpl_copy[i]
      new = new += tar_copy[i] if tar_copy[i]
    end

    return new
  end
end
