require 'nokogiri'
require 'open-uri'
require 'fileutils'

class Integer
  def tries(options={}, &block)
    attempts          = self
    exception_classes = [*options[:on] || StandardError]
 
    begin
      return yield
    rescue *exception_classes => e
	  sleep 2
	  puts "#{e.message}. #{attempts} attempts left"
      retry if (attempts -= 1) > 0
    end
 
    yield
  end
end

ki=ARGV[0]  # channel id
ta=ARGV[1]  # date (eg. 2013-04-15)
sa=ARGV[2]  # time (eg 16)
db=ARGV[3]  # minutes start (eg. 00)
ds=ARGV[4]  # minutes end

(db..ds).each do |da|
  nam="#{ta}_#{sa}#{da}00_#{ki}.flv"
  url="http://s2.tvarsivi.com/cachec/#{nam}"
  puts url
  
  FileUtils.mkdir_p("tv") unless File.directory?("tv")
  
  open("tv/#{nam}","wb") do |file|
		5.tries do
			file << open(url).read
		end
  end
end