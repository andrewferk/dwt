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
      html_index = copy.index('<html')
      tpl_copy << (html_index ? copy[html_index, copy.length - html_index] : copy)
      tpl = tpl_start ? tpl[tpl_start,tpl.length] : ''
    end while tpl.length > 0

    tar_end_editable_str = "<!-- InstanceEndEditable -->"
    filename = files[0]
    tar = File.open(filename).read
    tar_copy = []

    html_index = tar.index('<html')
    tar_copy << tar[0, html_index]

    begin
      tar_start = tar.index("<!-- InstanceBeginEditable")
      tar_end = tar.index(tar_end_editable_str)
      tar_end = tar_end + tar_end_editable_str.length if tar_end
      tar_copy << tar[tar_start,tar_end-tar_start] if tar_start
      tar = tar_end ? tar[tar_end,tar.length-tar_end] : ''
    end while tar.length > 0

    new = ''
    (0..(tar_copy.length)).to_a.each do |i|
      next if tar_copy[i].nil?
      new = new += tar_copy[i]
      copy = tpl_copy[i]
      copy = apply_link_update(copy,'link','href',filename)
      copy = apply_link_update(copy,'script','src',filename)
      copy = apply_link_update(copy,'form','action',filename)
      copy = apply_link_update(copy,'a','href',filename)
      copy = apply_link_update(copy,'img','src',filename)
      new = new += copy
    end

    return new
  end

  private
    def apply_link_update(html, tag, attribute, filename)
      html.gsub(/<#{tag}(.*)#{attribute}="([^"]*)"([^>]*)>/) do |match|
        tpl_link = $2
        tpl_links = tpl_link.split(File::SEPARATOR)
        tpl_links.delete_at(0)
        filedir = Dir.new(File.dirname(filename))
        back_separators = 0
        begin
          filedir_ls = filedir.each.to_a
          break if filedir_ls.include?('Templates')
          filedir.chdir("..")
          back_separators += 1
        end while filedir.pwd != "/"
        "<#{tag}#{$1}#{attribute}=\"#{("../"*back_separators) + tpl_links.join('/')}\"#{$3}>"
      end
    end
end
