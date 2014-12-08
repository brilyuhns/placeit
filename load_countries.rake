@resultHash = {}
a.get(url) do |page|
parsedPage = page.parser
@resultHash[:landmarks] = parsedPage.at_xpath("div:nth-child(8).imagelist > div.catbox > h3:nth-child(1) > a:nth-child(1) > img:nth-child(1).landscape.thumbnail")
end

//*[@id="content"]/div[1]/h2[1]
//*[@id="content"]/div[1]/div[1]
//*[@id="content"]/div[1]/h2[2]
//*[@id="content"]/div[1]/div[2]

a = Mechanize.new { |agent|
agent.user_agent_alias = 'Mac Safari'
}
url = "http://famouswonders.com/asia/india/"
response = RestClient.get url
@page = Nokogiri::HTML(response)
heading_parts = @page.xpath("//*[@id='content']/div[1]/h2[1]").text.split(" ")
@page.xpath("//*[@id='content']/div[1]/div[1]/div").each{|a| puts "name " + a.text; puts a.xpath("h3/a/img")[0].attributes["src"]; puts "---"}

x = @page.xpath("//*[@id='content']/div[1]/div[1]")

country_urls = RestClient.get 'https://www.kimonolabs.com/api/e9qa41ce?apikey=BurxkWv91mNJOoZNjd33mgvdzHgKNBVy'
country_urls = Oj.load(country_urls)
country_name = @page.xpath("//*[@id='content']/h1)


country_urls = ["http://famouswonders.com/asia/india/"]
country_urls.each do |url|
puts url
response = RestClient.get url
page = Nokogiri::HTML(response)
name = page.xpath("//*[@id='content']/h1").text
puts name
next if is_blank? name 
cntry_sym = name.parameterize.underscore.to_sym
country = @countries[cntry_sym] || {}
puts country
for i in 1..3 do
puts i
heading_parts = page.xpath("//*[@id='content']/div[1]/h2[#{i}]").text.split(" ")
puts heading_parts
cat = heading_parts.map(&:camelize) & ["Cities", "Landmarks", "Facts"]
puts cat
if(cat.size > 0)
temp = []
cat_name = cat.join(" ").parameterize.underscore.to_sym
puts cat_name
page.xpath("//*[@id='content']/div[1]/div[#{i}]/div").each do |a|
entry = {}
entry[:name] = a.text
entry[:img_src] = a.xpath("h3/a/img")[0].attributes["src"] if !a.xpath("h3/a/img")[0].nil?
ap entry
temp << entry
end
country[cat_name] = temp	
@countries[cntry_sym] = country
end
end
end

def non_blank var, val
(is_blank? var) ? val : var
end

def is_blank? var
!(!var.nil? && !var.blank?)
end


def sanitize_image hash
img_src = hash["img_src"]
i = img_src.rindex(/\./)
ext = img_src[i..img_src.length]
file_name = img_src[0..i-1]
file_name = file_name.split("-180")[0]
img_src = file_name + ext
puts img_src
if try_image img_src
hash["img_src"] = img_src
puts img_src
return hash
else
if try_image hash["img_src"]
puts hash["img_src"]
return hash
end
end
puts "--"
return nil
end

def try_image src
img = RestClient.get src
img.code == 200
end
