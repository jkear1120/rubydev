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
#while true
#サイト本文抽出
begin
	uri = "http://www.mainichi.jp/select"
	doc = Nokogiri::HTML(open(uri))
	i=0
	urls = Array.new
	#リンクのみを指定
	doc.css('a').each do |node|
		s = node["href"]
		リンク判定(ローカルかグローバルか)
		if %r{^/.*} =~ s
			#文字列連結後配列へ
			str = uri + s.to_s
			#str.slice!(20)
			urls.push(str)		
			i+=1
		end
	end
end

begin
	j=0
	day = Time.now
	daystr = day.strftime("%Y-%m-%d_%H:%M")
	csvday = 'artcl-YomiuriTop' + daystr + '.csv'

	#記事読み込み、CSVにめかぶ形式で保存
	m = MeCab::Tagger.new(ARGV.join(" "))
	while j<i
		CSV.open(csvday,"a+", {:force_quotes => true}) do |csv|
			arr1 = Nokogiri::HTML(open(urls[j]))
			arr1.xpath('p').each do |node|
				p node.text
				if /(.+?)）+$/u =~ node.text
					csv << [m.parse(node.text)]
					#puts node.text
					#deb = node.text
					#puts deb
					break
				end
			end
		end
	j+=1
	end
	#c = MeCab::Tagger.new(ARGV.join(" "))
end
