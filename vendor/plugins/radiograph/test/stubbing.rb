class Radiograph
  def Radiograph.copy_files
  end
end

module StubHelper
  def stylesheet_link_tag(file)
    '<link href="/stylesheets/' + file + '" media="screen" rel="Stylesheet" type="text/css" />'
  end
end