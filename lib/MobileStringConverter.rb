require "MobileStringConverter/version"
require "MobileStringConverter/cli"
require 'csv'
module MobileStringConverter
  # Your code goes here...
	
	class Converter
	  	def self.createTemplate()
			outputString = "Renishaw Mobile String template,,\nKey e.g. title_string,Value e.g. Welcome,Comment e.g. This appears on welcome screen\nexample_key,example_value,Comment etc"
			File.open("template.csv", "w") {|file| file.write(outputString) }
	  	end

	  	# Reads strings from CSV and out puts into localized.strings format
		def self.createAppleString(key,value,comment)

			if comment.to_s != ''
				commentString = "/* #{comment} */\n"
			end

			if key.casecmp("section") == 0
				"/* Section: #{value} */\n\n"
			else
				"#{commentString}\"#{key}\" = \"#{value}\";\n\n"
			end

		end

		def self.createAppleFile(stringsArray,fileName,debugOutput) 

			outputString = "/* Generated strings file */\n\n"

			stringsArray.each do |item|
				outputString.concat(item)
			end

			if debugOutput == true
				puts "Apple strings: \n\n" + outputString
			end

			# puts outputString
			# Write changes to the file:
			File.open(fileName, "w") {|file| file.write(outputString) }

			puts "Apple file saved " + fileName
			
		end

		# Reads strings from CSV and out puts into android XML format
		def self.createAndroidString(key,value,comment)
			# <string name="app_name">Trigger Logic\u2122</string>

			if comment.to_s != ''
				commentString = " <!-- "+comment+" -->"
			end

			if key.casecmp("section") == 0
				"\n<!-- * Section: #{value} * * -->\n\n"
			else
				"<string name=\"#{key}\">#{value}</string>#{commentString}\n"
			end

		end

		def self.createAndroidFile(stringsArray,fileName,debugOutput) 

			outputString = "<!-- * Generated strings file * -->\n\n"
			outputString.concat("<resources>\n")
			stringsArray.each do |item|
				outputString.concat(item)
			end
			outputString.concat("</resources>")

			if debugOutput == true
				puts "Android strings: \n\n" + outputString
			end

			# puts outputString
			# Write changes to the file:
			File.open(fileName, "w") {|file| file.write(outputString) }

			puts "Android file saved " + fileName
			
		end

		def self.getContentOfCsv(fileName, debugOutput)

			puts "Converting: #{fileName}"
			if fileName.nil?
				  puts "Filename nil"
				  return
			end

			appleArray = Array.new
			androidArray = Array.new

			CSV.foreach(fileName) do |row|

				# skips empty strings and first 2 lines
				if row[0].to_s != '' &&  $. > 2

					puts $.
					# Get strings from CSV
			  		string_key = row[0]
			  		string_value = row[1]
			  		string_comment = row[2]

			  		# Create strings for each platform and add to array
					appleArray.push(createAppleString(string_key,string_value,string_comment))
					androidArray.push(createAndroidString(string_key,string_value,string_comment))
				else
					puts "Skipping empty row"
				end

			end

			createAppleFile(appleArray,"localized.strings",debugOutput)
			createAndroidFile(androidArray,"strings.xml",debugOutput)

		end

	end

end
