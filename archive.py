# coding=utf-8
import os
import requests

class Archive:

	def __init__(self, name, floder, identifier, profilesNameAdhoc, profilesNameAppStore, appStore):
		self.name = str(name)
		self.floder = str(floder)
		self.buildfloder = os.path.join(self.floder, 'ARBuild')
		self.identifier = identifier
		self.profilesNameAdhoc = profilesNameAdhoc
		self.profilesNameAppStore = profilesNameAppStore
		self.workspacename = self.name + '.xcworkspace'
		self.schemename = self.name
		self.appStore = appStore

	def error(self, title):
		print('\033[1;37;41m')
		print (title + '\n') * 3
		print('\033[0m')

	def runcmd(self, cmd, step):
		os.chdir(self.floder)
		os.system(cmd)


	def start(self):
		if os.path.isdir(self.floder) == False:
			self.error('工程文件夹不正确')
			return
		if os.path.exists(self.schemename) == False or os.path.exists(self.workspacename) == False:
			self.error('找不到这个工程')
			return

		self.clear()
		archivePath = self.archive()
		ipaPath = self.export(archivePath)
		self.upload(ipaPath)
		self.clear()

	

	def clear(self):
		cmd = 'rm -r ' + self.buildfloder
		self.runcmd(cmd, 'CLEAR')

	def clean(self):
		cmd = 'xcodebuild -workspace %s -scheme %s -configuration Release clean' % (self.workspacename, self.schemename)
		self.runcmd(cmd, 'CLEAR')

	def build(self):
		cmd = 'xcodebuild -workspace %s -scheme %s -configuration Release' % (self.workspacename, self.schemename)
		self.runcmd(cmd, 'BUILD')

	def archive(self):
		archivePath = os.path.join(self.buildfloder, self.name + '.xcarchive')
		cmd = 'xcodebuild -workspace %s -scheme %s -configuration Release -archivePath %s archive' % (self.workspacename, self.schemename, archivePath)
		self.runcmd(cmd, 'ARCHIVE')
		return archivePath

	def export(self, archivePath):
		ipaFloder = self.buildfloder
		ipaPath = os.path.join(self.buildfloder, self.schemename + '.ipa')
		optionsPath = os.path.join(self.buildfloder, 'option.plist')
		optionsfile = open(optionsPath, 'wb')

		if self.appStore == True:
			method = 'app-store'
			optionsText = '''
				<?xml version="1.0" encoding="UTF-8"?>
				<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
				<plist version="1.0">
					<dict>
					<key>method</key>
					<string>%s</string>
					<key>signingStyle</key>
					<string>manual</string>
					<key>stripSwiftSymbols</key>
					<true/>
					<key>uploadSymbols</key>
					<true/>
					<key>provisioningProfiles</key>
					<dict>
						<key>%s</key>
						<string>%s</string>
					</dict>
					</dict>
				</plist>
			''' % (method, self.identifier, self.profilesNameAppStore)
		else:
			method = 'ad-hoc'
			optionsText = '''
				<?xml version="1.0" encoding="UTF-8"?>
				<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
				<plist version="1.0">
				<dict>
					<key>compileBitcode</key>
					<false/>
					<key>method</key>
					<string>%s</string>
					<key>provisioningProfiles</key>
					<dict>
						<key>%s</key>
						<string>%s</string>
					</dict>
				</dict>
				</plist>
			'''  % (method, self.identifier, self.profilesNameAdhoc)
		optionsfile.writelines(optionsText)
		optionsfile.flush()

		cmd = 'xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s' % (archivePath, ipaFloder, optionsPath)
		self.runcmd(cmd, 'EXPORT')
		return ipaPath

	def upload(self, ipaPath):
		url = 'https://qiniu-storage.pgyer.com/apiv1/app/upload'
		headers = {'enctype':'multipart/form-data'}
		files = {'file': open(ipaPath, 'rb')}
		parameter = {
						'uKey':'4e0482ce1d8d72d74e7fcb3c9ebec9fb', 
						'_api_key':'56aa90b54f9513cc127e58a928e74ccc'
					}
		print '上传中...'
		response = requests.post(url, data = parameter, headers = headers, files = files)
		if response.status_code == requests.codes.OK:
			result = response.json()
			code = result['code']
			if code == 0:
				print '上传成功'
				downlodUrl = 'http://www.pgyer.com/' + result['data']['appShortcutUrl']
				print 'Download Url: ' + downlodUrl
			else:
				self.error('发布失败')
		else:
			self.error('HTTPError Code: ' + response.status_code)
		
		
		





if __name__ == '__main__':
	name = 'GMat'
	floder = '/Users/hublot/Desktop/Work/Gmat'
	identifier = 'com.LeiGeGMAT.GMAT'
	profilesNameAdhoc = 'GmatAdhoc'
	profilesNameAppStore = 'GmatAppStore'
	archive = Archive(name, floder, identifier, profilesNameAdhoc, profilesNameAppStore, False)
	archive.start()

