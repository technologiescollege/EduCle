# -*- coding: utf8 -*-

#-----------------------------------------
# This is a part of pylote project.
# Name:        utils.py
# Author:      Pascal Peter
# Copyright:   (c) 2009
# Licence:     GNU General Public License
#-----------------------------------------


#importation des modules utiles :
#import sys, os, os.path, random

from PyQt4 import QtCore, QtGui
#from PyQt4 import QtWebKit
#from PyQt4 import QtNetwork 












#quelques variables :
PROGNAME = "pylote"
PROGVERSION = "0.00000000000000001"
PROGAUTHOR = "Pascal Peter"
PROGYEAR = "2009"
PROGMAIL = "pascal.peter at free.fr"
PROGWEB = "http://pascal.peter.free.fr"
LICENCETITLE = "GNU General Public License version 3"





"""
###########################################################
###########################################################

                LA FENÊTRE "À PROPOS" ET SES ONGLETS

###########################################################
###########################################################
"""

class AboutDlg(QtGui.QDialog):
    """
    explications
    """
    def __init__(self, parent = None, lang = "", icon = "./images/icon.png"):
        super(AboutDlg, self).__init__(parent)

        readmefile = do_locale(lang, "README", ".txt")

        logoLabel = QtGui.QLabel()
        logoLabel.setPixmap(QtGui.QPixmap(icon))
        logoLabel.setMaximumWidth (128)
        logoLabel.setAlignment(QtCore.Qt.AlignRight)
        titleLabel = QtGui.QLabel(self.tr("About <B>%1 %2</B> :")
                                                .arg(PROGNAME)
                                                .arg(PROGVERSION))
        titleLabel.setAlignment(QtCore.Qt.AlignLeft)
        titleGroupBox = QtGui.QGroupBox()
        titleLayout = QtGui.QHBoxLayout()
        titleLayout.addWidget(logoLabel)
        titleLayout.addWidget(titleLabel)
        titleGroupBox.setLayout(titleLayout)

        tabWidget = QtGui.QTabWidget()
        tabWidget.addTab(AboutTab(), self.tr("About"))
        tabWidget.addTab(ReadMeTab(readmefile = readmefile), self.tr("ReadMe"))
        tabWidget.addTab(CreditsTab(), self.tr("Credits"))
        tabWidget.addTab(LicenceTab(), self.tr("License"))
        tabWidget.setMinimumSize(600, 300)

        okButton = QtGui.QPushButton(self.tr("&Close"))
        self.connect(okButton, QtCore.SIGNAL("clicked()"), self, QtCore.SLOT("accept()"))
        buttonLayout = QtGui.QHBoxLayout()
        buttonLayout.addStretch(1)
        buttonLayout.addWidget(okButton)

        mainLayout = QtGui.QVBoxLayout()
        mainLayout.addWidget(titleGroupBox)
        mainLayout.addWidget(tabWidget)
        mainLayout.addLayout(buttonLayout)
        self.setLayout(mainLayout)
        self.setWindowTitle(self.tr("About %1").arg(PROGNAME))

class BaseLabelTab(QtGui.QWidget):
    def __init__(self, parent=None):
        super(BaseLabelTab, self).__init__(parent)
        self.bigTruc = QtGui.QLabel()
        mainLayout = QtGui.QHBoxLayout()
        mainLayout.addWidget(self.bigTruc)
        self.setLayout(mainLayout)

class BaseEditorTab(QtGui.QWidget):
    def __init__(self, parent=None):
        super(BaseEditorTab, self).__init__(parent)
        self.bigTruc = QtGui.QTextEdit()
        self.bigTruc.setReadOnly(True)
        mainLayout = QtGui.QHBoxLayout()
        mainLayout.addWidget(self.bigTruc)
        self.setLayout(mainLayout)

class AboutTab(BaseEditorTab):
    def __init__(self, parent=None):
        super(AboutTab, self).__init__(parent)

        copyrightsign = u"\N{COPYRIGHT SIGN}"
        self.bigTruc.setText(
            self.tr("<P><BR></P>"
                    "<P ALIGN=CENTER>Copyright %1 %2 %3</P>"
                    "<P></P>"
                    "<P ALIGN=CENTER><A HREF='%4'>%4</A></P>"
                    "<P ALIGN=CENTER>%5</P>"
                    "<P ALIGN=CENTER>%6</P>")
                        .arg(copyrightsign)
                        .arg(PROGYEAR)
                        .arg(PROGAUTHOR)
                        .arg(PROGWEB)
                        .arg(PROGMAIL)
                        .arg(LICENCETITLE))

class ReadMeTab(BaseEditorTab):
    def __init__(self, parent=None, readmefile = None):
        super(ReadMeTab, self).__init__(parent)
        inFile = QtCore.QFile(QtCore.QString(readmefile))
        if inFile.open(QtCore.QFile.ReadOnly):
            stream = QtCore.QTextStream(inFile)
            stream.setCodec("UTF-8")
            self.bigTruc.setPlainText(stream.readAll())

class CreditsTab(BaseEditorTab):
    def __init__(self, parent=None):
        super(CreditsTab, self).__init__(parent)
        inFile = QtCore.QFile(QtCore.QString("credits.txt"))
        if inFile.open(QtCore.QFile.ReadOnly | QtCore.QFile.Text):
            self.bigTruc.setPlainText(QtCore.QString(inFile.readAll()))

class LicenceTab(BaseEditorTab):
    def __init__(self, parent=None):
        super(LicenceTab, self).__init__(parent)
        inFile = QtCore.QFile(QtCore.QString("gpl.txt"))
        if inFile.open(QtCore.QFile.ReadOnly | QtCore.QFile.Text):
            self.bigTruc.setPlainText(QtCore.QString(inFile.readAll()))















def do_locale(lang, beginfilename, endfilename):
    """
    Teste l'existence d'un fichier localisé.
    Par exemple, insère _fr entre beginfilename et endfilename.
    Renvoie le fichier par défaut sinon.
    """
    localefilename = beginfilename + "_" + lang + endfilename
    localefileFile = QtCore.QFileInfo(localefilename)
    if not(localefileFile.exists()) :
        localefilename = beginfilename + endfilename
    return localefilename






def help_in_browser(lang, basename):
    """
    Ouvre un fichier html dans le navigateur.
    Exemples :
        self.help_in_browser("index")
    """
    thefile = do_locale(lang, "help/" + basename, ".html")
    localefileFile = QtCore.QFileInfo(thefile)
    localefileFile.makeAbsolute()
    thefile = localefileFile.filePath()
    url = QtCore.QUrl.fromLocalFile(unicode(thefile))
    QtGui.QDesktopServices.openUrl(url)



def video_demo(demofile):
    """
    Lance la vidéo avec le logiciel associé
    """
    #demofile = "help/demo.ogv"
    localefileFile = QtCore.QFileInfo(demofile)
    localefileFile.makeAbsolute()
    demofile = localefileFile.filePath()
    url = QtCore.QUrl.fromLocalFile(unicode(demofile))
    QtGui.QDesktopServices.openUrl(url)












