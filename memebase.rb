=begin
Downloads memebase pictures
=end

require 'nokogiri'
require 'open-uri'

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

(ARGV[0]..ARGV[1]).each do |pn|
  puts "---- Page #{pn} ----"
  doc = Nokogiri::HTML(open("http://memebase.com/page/#{pn}/"))
  imgn=1
  doc.xpath('//img[contains(@src,\'wordpress\')]/@src').each do |img|
    if img.value.include? "stats.wordpress.com" or img.value.include? "?"
      #puts "---" + img.value
    else
      puts img.value
	  
	  fold=pn.to_s[0..-3]
	  FileUtils.mkdir_p("img/#{fold}") unless File.directory?("img/#{fold}")
      nam=img.value.rpartition("/")[2]
      open("img/#{fold}/#{pn}-#{imgn}-#{nam}","wb") do |file|
		5.tries do
			file << open(img.value).read
		end
      end
    imgn=imgn+1
    end
  end
end


