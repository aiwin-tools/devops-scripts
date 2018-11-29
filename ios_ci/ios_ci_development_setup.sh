#!/bin/bash

######################################################
#													 #
#	  CI AND DEVELOPMENT TOOLS FOR IOS INSTALLER.    #	
#													 #
######################################################
#
# Usage : sudo ./ios_ci_development_setup.sh
# NOTE THE SUDO COMMAND: Necessary to install most things of this script
#
# To install all the utilities of this script execute the next command:
# yes | sudo ./ios_ci_development_setup.sh
#



#Install xcode command build tools

# See http://apple.stackexchange.com/questions/107307/how-can-i-install-the-command-line-tools-completely-from-the-command-line
read -p "Do you want to install xCode Command Line Tools? [y/n]"  -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Checking Xcode CLI tools"
	echo '------------------------'
	# Only run if the tools are not installed yet
	# To check that try to print the SDK path
	xcode-select -p &> /dev/null
	if [ $? -ne 0 ]; then
  		echo "Xcode CLI tools not found. Installing them..."
  		touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  		PROD=$(softwareupdate -l |
    	grep "\*.*Command Line" |
    	head  | awk -F"*" '{print $2}' |
    	sed -e 's/^ *//' |
    	tr -d '\n')
  		softwareupdate -i "$PROD" -v;
	else
  		echo "Xcode CLI tools OK"
	fi
	echo '------------------------'

  	#Accept xCode license
  	echo "Accept xCode license"
  	echo '------------------------'
  	xcodebuild -license accept
  	echo '------------------------'

fi



read -p "Do you want to install brew? (Necessary for install xcodegen and swiftlint) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#
	# Check if Homebrew is installed
	#
	echo "Checking Brew"
	echo '------------------------'
	which -s brew
	if [[ $? != 0 ]] ; then
    	# Install Homebrew
    	# https://brew.sh/index_es
    	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Updating brew"
    	sudo -u $(logname) brew update
	fi
	echo '------------------------'
fi


read -p "Do you want to install cocoapods? (iOS dependency manager) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install cocoapods
	echo 'INSTALLING COCOAPODS...'
	echo '------------------------'
	which -s pod
	if [[ $? != 0 ]] ; then
		gem install cocoapods
	else
		echo "Cocoapods already installed"
	fi
	echo '------------------------'
fi

read -p "Do you want to install xcodegen? (xCode project file generation tool) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install xcodegen
	echo 'INSTALLING XcodeGen...'
	echo '------------------------'
	which -s xcodegen
	if [[ $? != 0 ]] ; then
		brew tap yonaskolb/XcodeGen https://github.com/yonaskolb/XcodeGen.git
		brew install XcodeGen
	else
		echo "xCodeGen already installed"
	fi
	echo '------------------------'
fi


read -p "Do you want to install lizard? (Cyclomatic Complexity Analyzer, used by Sonar) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install lizard
	echo 'INSTALLING Lizard...'
	echo '------------------------'
	which -s lizard
	if [[ $? != 0 ]] ; then
	 	easy_install lizard
	else
		echo "lizard already installed"
	fi
	echo '------------------------'
fi


read -p "Do you want to install swiftlint? (Swift linter, used by Sonar) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install SwiftLing
	echo 'INSTALLING swiftlint...'
	echo '------------------------'
	which -s swiftlint
	if [[ $? != 0 ]] ; then
		brew install swiftlint
	else
		echo "swiftlint already installed"
	fi
	echo '------------------------'
fi

read -p "Do you want to install JQ? (Json Query, used by custom script to verify sonar status) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install SwiftLing
	echo 'INSTALLING JQ...'
	echo '------------------------'
	which -s jq
	if [[ $? != 0 ]] ; then
		brew install jq
	else
		echo "jq already installed"
	fi
	echo '------------------------'
fi



read -p "Do you want to install sonar-scanner? (Sonar Scanner, used by Sonar) [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install SwiftLing
	echo 'INSTALLING sonar-scanner...'
	echo '------------------------'
	which -s sonar-scanner
	if [[ $? != 0 ]] ; then
		brew install sonar-scanner
	else
		echo "sonar-scanner already installed"
	fi
	echo '------------------------'
fi



read -p "Do you want to install fastlane? [y/n]"  -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install fastlane
	echo 'INSTALLING fastlane...'
	echo '------------------------'
	which -s fastlane
	if [[ $? != 0 ]] ; then
		gem install fastlane -NV
	else
		echo "fastlane already installed"
	fi
	echo '------------------------'
fi


read -p "Do you want to install gitlab runner [y/n]"   -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#Install SwiftLing
	echo 'INSTALLING gitlab runner...'
	echo '------------------------'
	which -s gitlab-runner
	if [[ $? != 0 ]] ; then
		curl --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-darwin-amd64
		chmod +x /usr/local/bin/gitlab-runner
		cd ~
		gitlab-runner install
	else
		echo "gitlab runner already installed"
	fi
	echo '------------------------'
fi

