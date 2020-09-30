require "./propertiesFile"

require 'net/http'
require 'json'
require 'date'

#getXcodeReleasesList
def getXcodeReleasesList()
	url = "https://xcodereleases.com/data.json"
	uri = URI(url)
	response = Net::HTTP.get(uri)
	data = JSON.parse(response)
	return data
end

def getLatestXcodeLists()
	data = getXcodeReleasesList()
	list_data = getDataAfterLastInstalledXcodeVersion(data, latestXcodeVersion)
	return list_data
end

def getDataAfterLastInstalledXcodeVersion(a, b)
	puts "current xcode #{b}"
	data = []
	a.each do |child|
		version = child.dig('version', 'number')
		data.push(child)
		if b == version
			data.pop
			break
		end
	end
	return data
end

def getLatestXcodeListsData()
	a = []
	data = Hash.new
	b = getLatestXcodeLists()
	data["available_xcodes"] = b.count
	b.each do |child|
		version = child['version']
		release = version['release']
		gm = release["gm"]
		if !gm.nil?
			a.push(child)
		end
	end
	if !a.empty?
		data["available_xcodes_gm"] =  a.count
		data["Xcode_data"] = a
	else
		data["available_xcodes_gm"] =  a.count
	end
	return data
end

def getFormattedLatestXcodeData(a)
	data = []
	a.each do |child|
		data.push(getFormattedXcodedata(child))
	end
	# c = data max value by days ago getting the latest one and than returns
	# puts "getProperXcodedata #{c} \n "

	return data.first
end

def getFormattedXcodedata(a)
	data = Hash.new
	swift_versions = []
	version = a.dig('version')
	data["version-number"] = version.dig('number')
	data["build-version"] = version.dig('build')
	data["date"] = getFormattedDate(a.dig('date'))
	links = a.dig('links')
	data["notes_url"] = links.dig('notes', 'url')
	data["download_url"] = links.dig('download', 'url')
	data["requireOSVersion"] = a.dig('requires')
	b = a.dig('compilers', 'swift')
	b.each do |ver|
		swift_versions.push(ver['number'])
	end
	data["requireSwiftVersion"] = swift_versions
	return data
end

def getFormattedDate(a)
	data = Hash.new
	release_year_xcode = a['year']
	release_month_xcode = a['month']
	release_day_xcode = a['day']
	release_date = Date.parse("#{release_year_xcode}-#{release_month_xcode}-#{release_day_xcode}")
	data["release_date"] = release_date.strftime("%a, %e %b %Y")
	data["days_ago"] = (Date.today - release_date).to_i
	return data
end

def checkLatestXcode()
	x = getLatestXcodeListsData()
	y = x['available_xcodes_gm']
	data = Hash.new
	data['available_xcodes'] = x['available_xcodes']
	data['available_xcodes'] = x['available_xcodes']
	data["available_xcodes_gm"] = y
	if y > 0
		data["xcode_data"] = getFormattedLatestXcodeData(x['Xcode_data'])
	end
	return data
end
