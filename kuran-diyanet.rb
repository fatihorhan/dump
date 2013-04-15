=begin
Downloads quran recitations from kuran.diyanet.gov.tr
=end

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

sn=ARGV[0]  # surah number

(ARGV[1]..ARGV[2]).each do |pn|  #pn: part number
  nam=sn+"_"+pn+".mp3"
  url="http://kuran.diyanet.gov.tr/Sound/tr_mehmeteminay/#{nam}"
  puts url
  
  FileUtils.mkdir_p("kur/#{sn}") unless File.directory?("kur/#{sn}")
  
  open("kur/#{sn}/#{nam}","wb") do |file|
		5.tries do
			file << open(url).read
		end
  end
end