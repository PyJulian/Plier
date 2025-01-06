on getplist(fol)
	return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleExecutable</key>
    <string>" & (item 2 of fol) & "</string>
    <key>CFBundleIdentifier</key>
    <string>" & (item 3 of fol) & "</string>
    <key>CFBundleName</key>
    <string>" & (item 1 of fol) & "</string>
    <key>CFBundleVersion</key>
    <string>" & (item 4 of fol) & "</string>
</dict>
</plist>"
end getplist

on getbundledata()
	return "#!/bin/bash
cd \"$(dirname \"$(realpath \"$0\")\")\" && python3 engine.py"
end getbundledata

(**
	
	AppDat Buildup:
	
	1 > App Name
	2 > Bundle Executable Name
	3 > Bundle Identifier
	4 > App Version
	5 > Python File Path
	
**)

set appdat to {"MyPlierApp", "PlierBundle", "com.plier.export", "1.0", "?"}

repeat
	display dialog "Select your settings and click export to start
	
App Name: " & (item 1 of appdat) & "
Bundle Name: " & (item 2 of appdat) & "
Bundle Identifier: " & (item 3 of appdat) & "
App Version: " & (item 4 of appdat) & "
Python File: " & (item 5 of appdat) buttons {"Export", "Settings", "Quit"} with icon 1 with title "Plier Export" default button 1
	if the button returned of the result is "Export" then
		try
			do shell script "
cd ~/Documents &&
mkdir -p " & quoted form of (item 1 of appdat) & "/Contents/MacOS
"
			delay 1
			do shell script "cd ~/Documents/" & (item 1 of appdat) & "/Contents &&
echo " & quoted form of (getplist(appdat)) & " > Info.plist
cd MacOS
cp " & (item 5 of appdat) & " engine.py
echo " & quoted form of getbundledata() & " > " & (item 2 of appdat) & "
chmod +x " & (item 2 of appdat) & "
cd ../../../
mv " & (item 1 of appdat) & " " & (item 1 of appdat) & ".app"
			display alert "Succes" message "App made in the Documents Directory"
		on error
			display alert "Fail" message "Export Fail
Reasons may be:
1. Not all values are filled in
2. Invalid values
3. App already exists in the documents folder
4. A value contains Spaces (Which is not allowed)"
		end try
	else if the button returned of the result is "Settings" then
		repeat
			set edit to (choose from list {"App Name", "Bundle Name", "Bundle Identifier", "App Version", "Python File"} with prompt "Select the option to edit:" OK button name "Edit Value" cancel button name "Return" with title "Plier Value Table")
			set the edit to (edit as text)
			if the edit is "App Name" then
				set the item 1 of appdat to the text returned of (display dialog "Edit Value
From: " & (item 1 of appdat) & "
To: ?" default answer (item 1 of appdat) buttons {"Edit"} with title "Plier Edit Value" default button 1)
				display alert "Succes" message "Value Edit Success"
			else if the edit is "Bundle Name" then
				set the item 2 of appdat to the text returned of (display dialog "Edit Value
From: " & (item 2 of appdat) & "
To: ?" default answer (item 2 of appdat) buttons {"Edit"} with title "Plier Edit Value" default button 1)
				display alert "Succes" message "Value Edit Success"
			else if the edit is "Bundle Identifier" then
				set the item 3 of appdat to the text returned of (display dialog "Edit Value
From: " & (item 3 of appdat) & "
To: ?" default answer (item 3 of appdat) buttons {"Edit"} with title "Plier Edit Value" default button 1)
				display alert "Succes" message "Value Edit Success"
			else if the edit is "App Version" then
				set the item 4 of appdat to the text returned of (display dialog "Edit Value
From: " & (item 4 of appdat) & "
To: ?" default answer (item 4 of appdat) buttons {"Edit"} with title "Plier Edit Value" default button 1)
				display alert "Succes" message "Value Edit Success"
			else if the edit is "Python File" then
				try
					set the item 5 of appdat to (POSIX path of (choose file with prompt "Please select a Python file to process:" of type {"public.python-script"})) as string
					display alert "Succes" message "Value Edit Success"
				on error
					set the item 5 of appdat to "?"
				end try
			else
				exit repeat
			end if
		end repeat
	else
		if the button returned of (display alert "Are you sure you want to quit?" message "Values are NOT saved" buttons {"Quit Plier", "No Abort"}) is "Quit Plier" then
			exit repeat
			quit
		end if
	end if
end repeat
