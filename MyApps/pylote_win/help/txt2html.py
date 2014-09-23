#!/usr/bin/env python
# -*- coding: utf8 -*-

#-----------------------------------------
# Name:        txt2html.py
# Author:      Pascal Peter
# Copyright:   (c) 2008
# Licence:     GNU General Public Licence
#-----------------------------------------

"""
pdf2jpg
Licence:     GNU General Public License

Copyright (C) 2008 Pascal Peter
http://pascal.peter.free.fr/
pascal.peter at free.fr


-------------------------------------------------------------------------------
Ce programme est un logiciel libre ; vous pouvez le redistribuer et/ou le
modifier conformément aux dispositions de la Licence Publique Générale GNU,
telle que publiée par la Free Software Foundation ; version 3 de la licence,
ou encore toute version ultérieure.

Ce programme est distribué dans l'espoir qu'il sera utile,
mais SANS AUCUNE GARANTIE ; sans même la garantie implicite de COMMERCIALISATION
ou D'ADAPTATION A UN OBJET PARTICULIER. Pour plus de détail,
voir la Licence Publique Générale GNU.

Vous devez avoir reçu un exemplaire de la Licence Publique Générale GNU en même
temps que ce programme ; si ce n'est pas le cas, voir <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""




import os, os.path, sys, glob

HERE = os.path.dirname(sys.argv[0])
APPDIR = os.path.abspath(HERE)
sys.path.insert(0, APPDIR)
os.chdir(APPDIR)
print "HERE :", HERE
print "APPDIR :", APPDIR


ligne_commande = "cd " + HERE
os.system(ligne_commande)


#récupération de la liste des fichiers pdf à traiter :
list_txt = glob.glob(HERE + '*.txt')
list_txt = glob.glob('*.txt')
print "list_txt :", list_txt


from PyQt4 import QtCore, QtGui
app = QtGui.QApplication(sys.argv)
MessageBox = QtGui.QMessageBox()

texte = "Conversion des fichiers : "
for file_txt in list_txt :
    texte = texte + file_txt + " "
MessageBox.information(MessageBox, "txt2html", texte)



for file_txt in list_txt :    
    #print "file_pdf :", file_pdf
    basename = file_txt.split(".")[0]
    #print "basename :", basename

    #transformation du pdf en ppm (1 par page) :
    ligne_commande = "pandoc -s -S -c pandoc.css " + file_txt + " -o " + basename + ".html"
    print "ligne_commande :", ligne_commande
    os.system(ligne_commande)

    print "ppmtojpg OK"
    
MessageBox.information(MessageBox, "txt2html", u"Conversion terminée")

