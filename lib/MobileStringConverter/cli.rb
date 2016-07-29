require 'thor'
require "thor/runner"

module MobileStringConverter
  class CLI < Thor

    desc "convert FILE", "This is the file to convert into strings"
    def convert(file)
      Converter.getContentOfCsv(file,false)
      # Converter.print()
      puts "#{file} converted to strings files"
    end
    
    desc "create_template", "This creates a blank strings template"
    def create_template()
      Converter.createTemplate()
      # Converter.print()
      puts "template.csv created"
    end
    
  end
  $thor_runner = true

end
