#coding:utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'MeCab'
require 'csv'
require 'json'
require 'pp'
require 'date'
require 'net/https'


#c = CSV.open("gethtml.csv","w", {:force_quotes => true}) do |csv|
while true
#サイト本文抽出
	begin
		uri = "http://www.asahi.com"
		doc = Nokogiri::HTML(open(uri))
		i=0
		urls = Array.new
		#リンクのみを指定
		doc.css('a').each do |node|
			s = node["href"]
			#リンク判定(ローカルかグローバルか)
			if %r{^/.*html$} =~ s
				#文字列連結後配列へ
				str = uri + s.to_s
				#str.slice!(20)
				urls.push(str)		
				i+=1
			end
		
		end
	end
	
	begin
	    response = open(uri)
	rescue Exception
	    puts url
	    puts "retrying"
	    retry
	end

=begin
CSV.open("urls.csv","w", {:force_quotes => true}) do |csv|
	while j<i
		csv << [urls[j]]
		#puts urls[j]
		j+=1
	end

end
=end

	begin
		j=0
		day = Time.now
		daystr = day.strftime("%Y-%m-%d %H:%M")
		csvday = 'articles' + daystr + '.csv'
	
		#記事読み込み、CSVにめかぶ形式で保存
		c = MeCab::Tagger.new(ARGV.join(" "))
		while j<i
			CSV.open(csvday,"a+", {:force_quotes => true}) do |csv|
				arr1 = Nokogiri::HTML(open(urls[j]))
				arr1.css("div.ArticleText").each do |node|
					csv << [c.parse(node.text)]
				end
			end
			j+=1
		end
		#c = MeCab::Tagger.new(ARGV.join(" "))
	end

	sleep(86400)
end

#コマンドライン引数でタグ指定
=begin
doc.css(ARGV[0]).each do |node|
	#この中で形態素解析
	#printf c.parse(node.text)
	puts node.text
end
=end
