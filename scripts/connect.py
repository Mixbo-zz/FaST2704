#!/usr/bin/python2.7

# ~Mixbo
# https://github.com/Mixbo/FaST2704/
# www.wakowakowako.com
import subprocess,sys

class Target(object):
	def __init__(self, bssid):
		self.bssid = bssid

	def attackWPS(self):
		try:
			subprocess.call('echo "This is where reaver is called"'+bssid,shell=True)
		except:
			return False
		return True


def main():
	target = Target(bssid)
	target.attackWPS()
if __name__ == "__main__":
	if len(sys.argv) == 1:
		print "[-] You must supply the target's BSSID"
	elif len(sys.argv) != 2:
		print "[-] The only accepted argument is the target's BSSID"
	else:
		bssid = sys.argv[1]
		print "[+] Proceding with target "+bssid
		main()
