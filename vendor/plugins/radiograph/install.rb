puts "Copying needed CSS files to your Rails application..."
Radiograph.copy_files

puts IO.read(File.join(File.dirname(__FILE__), 'README'))