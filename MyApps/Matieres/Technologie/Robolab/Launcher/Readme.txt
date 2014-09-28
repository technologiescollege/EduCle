----------------------------------------------------------
                 LEGO EDUCATIONAL DIVISION 
                 LEGO Mindstorms for Schools
                    ROBOLAB(tm) Software
                       Version 2.5.4
-----------------------------------------------------------

-----------------------------------------------------------

-----------------------------------------------------------

Disclaimer
The software is provided as-is without any warranty of any kind. The entire risk 
arising out the use or performance of the software remains with you. To the 
maximum extent permitted by applicable law, in no event shall the LEGO Group of 
Companies (including LEGO Systems A/S) and its suppliers and licensors, be 
liable for any damages arising out of the use or inability to use the software.
To install and use the software, you must agree to the terms of the ROBOLAB(tm) 
Software Version 2.5.4 License Agreement included with the software. Please be 
sure to read the License Agreement before installing ROBOLAB(tm) Software 
Version 2.5.4 on your system.
 
 
 
Table of Contents:
  1 - System requirements for this version 
  2 - Installing ROBOLAB
  3 - Launching ROBOLAB
  4 - FAQ and known issues for ROBOLAB
  5 - Other hardware or driver specific issues 
  6 - General troubleshooting for ROBOLAB
  7 - Un-installing ROBOLAB
  8 - Technical support 
  9 - Version history 
  10 - Legal 

1) SYSTEM REQUIREMENTS FOR THIS VERSION
MACINTOSH®
System 9.0 or OSX
166MHz PowerPC Processor
128Mb RAM
300 Mb Hard Drive Space
1 Free Serial Port
or
1 Free USB Port

PC
Windows 95, 98, ME, 2000, XP
133 MHz Processor
128Mb RAM
250 Mb Hard Drive Space
1 Free Serial Port
or
1 Free USB Port
Sound Card Required
  
  
Software
OS: Windows 98, 98SE, ME, 2000 and XP (Windows 95 and NT are NOT supported). 

2) INSTALLING ROBOLAB
Please note:
Before installing on Windows 2000 or Windows XP you will need to have 
administrative user privileges to install ROBOLAB application.

Also, you might need to turn off any resident programs like antivirus programs 
or Norton SystemWorks that monitor file installations.

TO INSTALL ON PC
1. Insert the CD-ROM into any available CD-ROM drive. 
2. If Auto Insert Notification is enabled for your CD-ROM drive the installer 
should start automatically. If it does not you can start it by either: 
Doubleclicking the CD-ROM icon in My Computer or running the "PC-Installer.exe"
file on the CD-ROM in Explorer.
3. Follow the installation steps throughout the installer.

PLEASE NOTE: ROBOLAB 2.5.4 does NOT uninstall or upgrade previous versions of
ROBOLAB. Please uninstall your existing version before you install ROBOLAB 2.5.4.

TO INSTALL ON MACINTOSH
1. Insert the CD-ROM into any available CD-ROM drive.
2. Doubleclick the CD-icon that appears on your desktop.
3. Run the "Robolab" ViseWise-Installer to start installation
4. Follow the installation steps throughout the installer.

NOTE! Please see section 4 "Known Issues" if installing on Windows 98/ME/2000.

Follow the on-screen installation instructions. 
3) LAUNCHING ROBOLAB
TO RUN ON PC
Locate the Robolab folder in the start menu and click the short-cut there to 
start Robolab OR doubleclick the Robolab short-cut on your desktop.

TO RUN ON MACINTOSH
Doubleclick the Robolab short-cut on your desktop to start Robolab.

4) FAQ AND KNOWN ISSUES FOR ROBOLAB

4A. UNINSTALLING ROBOLAB DOES NOT REMOVE SAVED MODELS AND SNAPSHOTS
When uninstalling the ROBOLAB software, all your saved programs will be retained 
on the hard drive. Should you choose to reinstall ROBOLAB the data will still be 
available. As the saved data is rather compact it will take up only a tiny 
portion of your hard drive space. However should you wish to clear out the 
space, you will be required to do so manually using the windows explorer. 
The models and snapshots will be located in your "My documents" folder on a PC 
installation and in "Documents" on a MAC installation.

4B. IR TRANSMITTER COMMUNICATION PROBLEMS
Set the Transmitter on Short Range  

Note: ROBOLAB does not support Long Range for the IR Transmitter for Macintosh 
computers with Legacy Serial Ports. 

Check Com Port Settings, Cable Connections to computer and Transmitter, 9V 
battery in the IR Transmitter. 

Note: The USB Transmitter does not use a battery. 

Ensure the RCX communication cones are appearing on the RCX.

Be sure the RCX is on, facing the right direction, has new AA batteries or the 
AC adapter plugged in, and is close enough (4" (10cm)) to the IR Transmitter. 

Check that there is not fluorescent lighting or excessive sunlight in the area. 
If there is excessive lighting, cover the RCX and IR tower with a box or dark 
paper to prevent light from interfering with the transmission. 

4C. PROBLEMS GETTING THE CAMERA TO WORK
The Camera functions of ROBOLAB are designed to be used primarily with the USB 
LEGO Cam.  However, this camera is designed specifically for the PC. A group of 
open source developers have created macam (http://webcam-osx.sourceforge.net/) 
which provides support for USB web cameras in Mac OS X.  This allows the LEGO 
USB camera can now be used in ROBOLAB 2.5 and higher on the MAC platform (OS 10 
and higher). This option is not officially supported but has been used by many 
users with great success. Users of Panther with QT 6.5 should be sure to have at
least the 0.9 version to work. To install the driver simply copy it from the
installation CD (ROBOLAB MAC:RL254 OSX Installer:macam:macam.component) to your
components directory (Macintosh HD:Library:Components:) and start ROBOLAB.
LEGO does not provide any support for this driver or assume any responsibility
in regards to its application. This driver is provided "as is".

On the windows platform we do not install drivers for use with ROBOLAB. We assume
that most users will already have a driver installed from their camera vendor. If
you do not have have such a driver you can try to install the generic driver we 
provide on the CD. It can be found in ROBOLAB254_PC_CD\Install\Camera\win98 for
the Windows 98/ME platform and \ROBOLAB254_PC_CD\Install\Camera\win2000 for
Windows 2000. Launch QDRVINS.EXE to install the driver.
 
4D. MAKE INSTALLATION FASTER ON A WINDOWS INSTALL
You can remove the tick boxes for testing the WinVDIG and QUICKTIME components.
This will speed up the installation process a bit.

4E. INSTALLING ROBOLAB ON WINDOWS 98/ME/2000
Installation of ROBOLAB on a "clean" install of Windows 98/ME/2000 has revealed
issues. As the Labview component we install with ROBOLAB requires that Microsoft
Installer 2.0 (MSI2.0) is present on the system, you might be prompted to reboot
your computer in the middle of installtion. If you see one or more dialog boxes
asking for a reboot, choose to NOT reboot. If a reboot is done during the install,
ROBOLAB might not work as all components have not been installed.

Do NOT reboot the computer until you see a dialog with the following text:
"ROBOLAB 2.5.4 has finished installation. A reboot is needed for ROBOLAB to work."
Also, Do not start ROBOLAB right after the reboot. Please allow the background
installation of the Labview component to finish (wait a few minutes, until task
scheduler, next to the clock in the status bar, stops switching on/off). If it has
not finished you will see the following error message "File not found: MSVCP60.DLL"
when trying to start ROBOLAB. Wait a few minutes and try again.

Optionally you can install MSI2.0 (and reboot) BEFORE trying to install ROBOLAB.
You must STILL choose NO to reboot if asked this by the WinVDIG component installer.
The MSI2.0 installer is located at \ROBOLAB254_PC_CD\Install\LabVIEW\suppfiles\
Run the InstMSI.exe file to install MSI2.0. This should negate the problem. 

Windows 98A problems
The first version of Windows 98 does not contain two components needed by ROBOLAB.
They are DCOM98 and MSI2.0. If you are going to install ROBOLAB in Windows 98A,
please make sure your Windows is updated with the available Mircosoft updates
(Windows 98A service pack 1, Internet Explorer 6.0 SP1 etc.) or install DCOM98 and
MSI 2.0 from the ROBOLAB CD. MSI 2.0 can be installed from \ROBOLAB254_PC_CD\Install
\LabVIEW\suppfiles\ and DCOM98 from \ROBOLAB254_PC_CD\Install\Support. I you are
seeing the error message: "File not found: MSCVP60.DLL", uninstall ROBOLAB, install
the Microsoft updates and then reinstall ROBOLAB.
 
4F. UNINSTALLING ROBOLAB ON A WINDOWS PLATFORM SHOWS A BLANK DIALOG BOX
If you see a blank dialog box when uninstall with "YES" and "NO" buttons, it is
a reboot dialog asking you to reboot the pc. You do not have to do this, but doing
so should not cause problems to your system.

Windows ME and 2000 problems
During the install of ROBOLAB you might see this pop-up dialog box: "The following
applications should be closed before continuing the install."  In the dialog box
Robolab 2.5.4 setup is shown and there are buttons to Cancel / Retry / Ignore. You
must click the ignore button or the ROBOLAB installer will shut down. Not having
completed the install process, ROBOLAB will most likely not work if you do not
click ignore. If this has already happened to you, simply uninstall and reinstall
ROBOLAB.
 
5) OTHER HARDWARE OR DRIVER SPECIFIC ISSUES

6) GENERAL TROUBLESHOOTING FOR ROBOLAB
General troubleshooting can resolve many issues experienced with running a 
program. If the issue you are experiencing is not specifically addressed, please 
read the following General Troubleshooting section before contacting Technical 
Support.

Please remember, when making changes to your system it is a good practice to 
take notes and backup along the way to enable you to reverse your changes.
 
6A. DISABLING ANTI-VIRUS TO INCREASE PERFORMANCE
If you experience ROBOLAB to run too slow, you could try disabling your anti 
virus software, however this is NOT recommended as it leaves your system un-
protected to harmful viruses
Please consult your anti-virus software's users manual or online help for 
instructions on how to turn it off.

6B. UPDATING DRIVERS 
In general if you are experiencing performance issues, lock ups, blue/black 
screen, error messages, etc. it is advisable to check with the machine 
manufacturer to ensure that you are using the most current drivers available. 
Sound, Video and CD-ROM manufacturers often release a number of new driver 
versions in a year to enable the user to get the best performance from their 
hardware. These drivers often contain improvements and sometimes include fixes 
for known issues with the hardware. If you are unfamiliar with updating your 
drivers or have any questions about your system drivers, please contact your 
computer manufacturer or supplier for assistance.

7) UN-INSTALLING ROBOLAB

TO UN-INSTALL ON PC
There are two ways to un-install ROBOLAB:
Click Start from the task bar, go to Settings, Control Panel, Add/Remove 
Programs, and select ROBOLAB from the menu. Follow the uninstall wizard. 
Click Start from the task bar, go to programs, LEGO Software, ROBOLAB, and click 
Uninstall. You can then select to remove or reinstall ROBOLAB. Follow the Wizard 
to complete your selection.
 
TO UN-INSTALL ON MACINTOSH
There is no uninstaller provided for MAC, but you can simply drag the Robolab 
folder from the Applications directory to the trashcan and then delete the 
desktop short-cut.

8) TECHNICAL SUPPORT
Thank you for using ROBOLAB, known issues are listed above in this readme. If 
you are experiencing problems not listed above, you can send your feedback to us 
on following address: 

http://www.lego.com/education/Mindstorms


9) VERSION HISTORY 

2.5.4 ROBOLAB Version 2.5.4
Native MAC OS X Version
Upload RCX Code 
Labview 7 Base

2.5.2 ROBOLAB Version 2.5.2
Inclusion of ROBOLAB Training Missions
Improved ROBOLAB Internet Server
Improved Vision Capabilities 

2.5.1 ROBOLAB Version 2.5.1
Revised Vision Capabilities
LEGO Camera Support for Windows 2000
Improved Executable

2.5.0 ROBOLAB Version 2.5.0
Addition of USB Transmitter Support and Multimedia Capacity
Utilization of updated LabVIEW engine

2.0.1 ROBOLAB Version 2.0.1
Improved Internet Capabilities

2.0 ROBOLAB Version 2.0  
Addition of ROBOLAB Investigator portion of ROBOLAB

1.5 ROBOLAB Version 1.5
Additional programming themes (C &Transportation, Starter Set) with included 
sample programs added
The [OK] and [Cancel] buttons replaced with graphical OK / Cancel buttons
Corrections and refinements to the TimerFork, and the Jump and Land structures

1.0 ROBOLAB Version 1.0
Initial Version


10) LEGAL
ROBOLAB is Developed by Tufts University.
Distributed by the LEGO Group, DK-7190 Billund, Denmark. © 2003 The LEGO Group 
and its licensors.

(C) 2004 The LEGO Group.
