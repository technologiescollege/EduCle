IMAQ Vision for LabVIEW and BridgeVIEW
Advanced Release
Version 4.1.1

Documentation File
(c) Copyright 1997 National Instruments Corporation.
All rights reserved.

Product and company names listed are trademarks
or trade names of their respective companies.

Readme File
======================================================================

This document contains important information about IMAQ Vision for
LabVIEW/BridgeVIEW version 4.1.1 software package.

Please read the following sections carefully.

Installer
=========

Diskette Installation:
  To install IMAQ Vision for LabVIEW/BridgeVIEW,  run "setup.exe" from the 
  installation folder. The installer will install the proper files based on 
  your operating system.

General Information
===================

  By default, if LabVIEW 4.1 is already installed on your machine,
  it will be automatically updated to LabVIEW 4.1.1 before the IMAQ
  Vision files are installed.  For users of IMAQ Vision ver 4.01 and
  earlier, LabVIEW 4.11 contains a tool that will automatically update
  all your applications built using IMAQ Vision 4.01 to conform with
  the new release.
  If you are using IMAQ Vision ver 4.01 and earlier and do not have 
  LabVIEW 4.1 installed on your machine, it is recommended that you
  upgrade to LabVIEW 4.1 before installing IMAQ Vision.

  The installation will install the following new folders or files within 
  the LabVIEW directory:

  vi.lib\Vision: which contains all the IMAQ Vision VIs. This directory will 
	         also contain the following subdirectories:
		 private: which contains the shared libraries used by the IMAQ Vision VIs
		  

  help\imaqg.hlp which is the document containing on-line help for the VIs. 

  examples\Vision: contains files with examples using IMAQ Vision

  menus\Vision: contains the Root.mmu file for the IMAQ Vision palette.


  NOTE: Changes from Ver 4.01 to 4.1.1
	(1) All VI names have been changed from Cvi ... to IMAQ ...
	(2) Addition of LabView error clusters to each VI. This has changed the
	    connector layout of each VI.
	    In order to access the error message dialog that was default in the
	    earlier versions of IMAQ Vision, the following needs to be done:
	    (i) Place the IMAQ Error VI in your diagram
	    (ii) Set the "Error Processing" parameter to "Dialog" and set the
		  "Set Error Condition" input to "True".
	(3) Addition of the "Inspection Tools" set of libraries. In order to use
	    many of these tools, the "Advanced Analysis Library" which is shipped
	    with LabVIEW should be installed on your machine. 

  If you have any questions on IMAQ Vision for LabVIEW/BridgeVIEW, please 
  contact National Instruments technical support at

		1-512-795-8248


 
  
