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
  puts "---- Sayfa #{pn} ----"
  doc = Nokogiri::HTML(open("http://www.smbc-comics.com/index.php?db=comics&id=#{pn}"))
  doc.xpath('//img[contains(@src,\'http://www.smbc-comics.com/comics/\')]/@src').each do |img|
    puts img.value
	  fold=pn.to_s[0..-3]
	  FileUtils.mkdir_p("img/#{fold}") unless File.directory?("img/#{fold}")
    nam=img.value.rpartition("/")[2]
    open("img/#{fold}/#{pn}-#{nam}","wb") do |file|
		5.tries do
			file << open(img.value).read
		end
    end
  end
end