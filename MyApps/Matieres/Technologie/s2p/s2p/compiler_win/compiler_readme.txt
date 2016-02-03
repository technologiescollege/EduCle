PICAXE Compilers
(c) Revolution Education Ltd 2006-2014
No distribution without prior written permission.
The latest compiler version is always available online at www.picaxe.co.uk

Each compiler consist of a console application with a filename that 
is the same as the type of chip supported e.g. picaxe20x2

 picaxe08
 picaxe08m
 picaxe08m2
 picaxe14m
 picaxe14m2
 picaxe18
 picaxe18a
 picaxe18m
 picaxe18m2
 picaxe18x
 picaxe20m
 picaxe20m2
 picaxe20x2
 picaxe28
 picaxe28a
 picaxe28x
 picaxe28x1
 picaxe28x2

For the 40X part use the picaxe28x compiler.
For the 40X1 part use the picaxe28x1 compiler.
For the 40X1 part use the picaxe28x2 compiler.

Some very early firmware versions require a separate compiler
(most users will not require these special compiler versions).

 picaxe18x_1 for 18X version 8.0 to 8.1
 picaxe28x_1 for 28X (40X) version 7.0 to 7.3
 picaxe28x1_0 for 28X1 (40X1) version A.0


The compiler is used with the following common command line switches.
Note all text within the command line is cAsE sEnSiTiVe.

 picaxeXXX filename.bas			= download (default port)
 picaxeXXX –cPORT filename.bas		= download (named port)
 picaxeXXX –s filename.bas		= syntax check
 picaxeXXX –cPORT –s filename.bas	= syntax check
 picaxeXXX –cPORT –t filename.bas	= download and terminal
 picaxeXXX –cPORT –d filename.bas	= download and debug
 picaxeXXX –h				= display help

where
	-cPORT		assign serial/USB port for downloading
			(note a #com directive in the program overrules this setting)
	-s		syntax check only (no download)
	-d		leaves the port open for ‘debug’ data after download
	-dh		leaves the port open for ‘debug’ data after download (hex mode)
	-t		leaves the port open for ‘sertxd’ data after download
	-ti		leaves the port open for ‘sertxd’ data after download (int mode)
	-th		leaves the port open for ‘sertxd’ data after download (hex mode)
	-h		displays help
	-p		add pass message to .err log file
	filename.bas	file to be downloaded 

For further information please see the PICAXE manual.