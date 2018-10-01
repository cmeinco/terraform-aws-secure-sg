


#import urllib.request
# import
# contents = urllib.request.urlopen("http://checkip.amazonaws.com/").read()
#
#
# print(contents)
import os
import urllib2
response = urllib2.urlopen('http://checkip.amazonaws.com/')
ip = response.read().strip()
#print ip

from templite import Templite

template = "templates/main.tf"

t = Templite("").from_file(template)

dirName = "temp"
if not os.path.exists(dirName):
    os.mkdir(dirName)

f = open("temp/main.tf", "w")
f.write(t(x = 8,homeip = ip))
