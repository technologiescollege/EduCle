#!/usr/bin/env python
# -*- coding: utf8 -*-

#-----------------------------------------
# Name:        pylote.pyw
# Author:      Pascal Peter
# Copyright:   (c) 2009
# Licence:     GNU General Public Licence
#-----------------------------------------

"""
pylote
Version 0.00000000000000001
Licence:     GNU General Public License

Copyright (C) 2009 Pascal Peter
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


#importation des modules utiles :
import sys, os, os.path

from PyQt4 import QtCore, QtGui

import utils

try:
    import psyco
    psyco.full()
except:
    print "no psyco"
    pass


#quelques variables :
HERE = os.path.dirname(sys.argv[0])
APPDIR = os.path.abspath(HERE)
sys.path.insert(0, APPDIR)
os.chdir(APPDIR)


"""
La variable globale SCREENMODE définit la façon dont le logiciel occupe l'espace.
FULLSCREEN : tout l'écran est occupé, y compris les barres de tâches et autres tableaux de bord.
FULLSPACE : l'espace libre" est utilisé par le logiciel ; on peut toujours utiliser le tableau de bord.
            Il peut y avoir des problèmes de positionnement sur certains systèmes.
TESTS : le logiciel ne s'affiche que dans une petite fenêtre.
            utile juste pour voir les retours de la console en direct.
            à passer en argument.
"""
SCREENMODE = "FULLSPACE"


"""
La variable globale WITHTRAYICON sera mis automatiquement à False 
        si SCREENMODE vaut FULLSCREEN où s'il y a problème.
On peut le changer ici manuellement si on n'en veut pas dans d'autres cas.
KIDICONSCALE définit le coefficient d'agrandissemnt des icônes de la boîte d'outils "Kids".
"""
WITHTRAYICON = True
KIDICONSCALE = 2


"""
Des variables globales manipulées par le programme (à ne pas modifier ici donc) :
maxZValue pour placer l'instrument sélectionné au premier plan
isTracingEnabled pour tracer avec le compas
withFalseCursor pour savoir si le "faux" curseur est actif
"""
maxZValue = 1
isTracingEnabled = False
withFalseCursor = False



"""
###########################################################
###########################################################

                LES INSTRUMENTS DE GÉOMÉTRIE

###########################################################
###########################################################
"""

class Instrument(QtGui.QGraphicsPixmapItem):
    """
    La classe de base pour un instrument de géométrie
    Les vrais instruments en dérivent
    """
    def __init__(self, parent, imageFile):
        QtGui.QGraphicsPixmapItem.__init__(self)
        self.main = parent
        """
        maxZValue sert à faire passer l'instrument au premier plan à la sélection
        imageFile passé en paramètre est l'image de l'instrument à afficher
        isUsed si l'instrument est en cours d'utilisation
                    pour désactiver le tracé du crayon dans ce cas
        leftButtonMode pour le mode TBI (souris un bouton) ou pas
        centralPoint est centre pour les rotations (redéfinit pour chaque instrument)
        tracePoint est le point pour les trace (voir le compas)
        locked si l'instrument est bloqué (pour TBI ; False par défaut)
        """
        self.setFlags(QtGui.QGraphicsItem.ItemIsSelectable|
                        QtGui.QGraphicsItem.ItemIsMovable)
        global maxZValue
        maxZValue = maxZValue + 1
        self.setZValue(maxZValue)

        newimage = QtGui.QImage(imageFile)
        self.setPixmap(QtGui.QPixmap.fromImage(newimage))

        self.centralPoint = self.boundingRect().topLeft()
        self.tracePoint = QtCore.QPointF(0, 0)
        self.scale(0.5, 0.5)
        self.isUsed = False
        self.leftButtonMode = "MOVE"
        self.setCursor(QtCore.Qt.ArrowCursor)
        self.locked = False

    def doLeftButtonMode(self, newMode):
        """
        redéfinition des Flags en fonction du mode sélectionné
        pour le bouton gauche de la souris
        """
        self.leftButtonMode = newMode
        if newMode == "MOVE" :
            self.setFlags(QtGui.QGraphicsItem.ItemIsSelectable|
                            QtGui.QGraphicsItem.ItemIsMovable)
        else :
            self.setFlags(QtGui.QGraphicsItem.ItemIsSelectable)

    def mousePressEvent(self, event):
        """
        on modifie maxZValue pour faire passer l'instrument au premier plan
        on calcule initialLength (distance de la souris au centre) et initialAngle
        isUsed est mis à True
        """
        if self.locked :
            return
        QtGui.QGraphicsItem.mousePressEvent(self, event)
        global maxZValue
        maxZValue = maxZValue + 1
        self.setZValue(maxZValue)

        rayon = QtCore.QLineF(self.centralPoint, event.pos())
        self.initialLength = rayon.length()
        self.initialAngle = rayon.angle()

        if event.button() == QtCore.Qt.LeftButton:
            event.accept()
        self.isUsed = True

    def mouseMoveEvent(self, event):
        """
        on calcule length (distance de la souris au centre) et angle
        Puis suivant le mode (bouton de souris ou leftButtonMode), on fait ce qu'il faut
        """
        #print "Instrument : ", event.pos().x(), event.pos().y()
        if self.locked :
            return
        QtGui.QGraphicsItem.mouseMoveEvent(self, event)
        rayon = QtCore.QLineF(self.centralPoint, event.pos())
        length = rayon.length()
        angle = rayon.angle()

        if event.buttons() == QtCore.Qt.RightButton:
            self.rotate(self.initialAngle - angle)
            event.accept()
        elif event.buttons() == QtCore.Qt.LeftButton:
            if self.leftButtonMode == "MOVE" :
                pass
            elif self.leftButtonMode == "SCALE" :
                coeff = length / self.initialLength
                self.scale(coeff, coeff)
            elif self.leftButtonMode == "ROTATE" :
                self.rotate(self.initialAngle- angle)
                event.accept()
        else :
            coeff = length / self.initialLength
            self.scale(coeff, coeff)

    def mouseReleaseEvent(self, event):
        """
        isUsed est mis à False : on cesse d'utiliser l'instrument
        """
        if self.locked :
            return
        QtGui.QGraphicsItem.mouseReleaseEvent(self, event)
        self.isUsed = False

class Protractor(Instrument):
    """
    Le Rapporteur. L'image doit être décalée pour que le centre du rapporteur soit en (0;0)
    centralPoint est donc redéfini ainsi
    """
    def __init__(self, parent):
        Instrument.__init__(self, parent, "./images/instruments/rapporteur.png")
        centralPoint = QtCore.QPointF(-322, -330)
        self.setOffset(centralPoint)

class Ruler(Instrument):
    """
    La règle. La graduation 0 doit être en (0;0)
    centralPoint est donc redéfini ainsi
    """
    def __init__(self, parent):
        Instrument.__init__(self, parent, "./images/instruments/regle.png")
        centralPoint = QtCore.QPointF(-23, 0)
        self.setOffset(centralPoint)

class SetSquare(Instrument):
    """
    L'équerre.
    """
    def __init__(self, parent):
        Instrument.__init__(self, parent, "./images/instruments/equerre.png")

class Compass(Instrument):
    """
    Le compas doit pouvoir tracer des arcs si la variable globale isTracingEnabled est à True.
    En fait on a besoin de 2 variables :
    
    isTracingEnabled (variable globale) est à True quand la trace du compas est sélectionnée
        (outil sélectionné ou touche control maintenue)
    isTracingPossible est à True quand le compas est autorisé à tracer
        (bon bouton de la souris, etc...)
    isTracing est à True quand le compas est en train de tracer
    
    On redéfinit donc les évènements souris
    centralPoint est redéfini sur la pointe du compas
    tracePoint est sur la mine
    """
    def __init__(self, parent):
        Instrument.__init__(self, parent, "./images/instruments/compas.png")
        centralPoint = QtCore.QPointF(-1, -222)
        self.setOffset(centralPoint)
        self.tracePoint = QtCore.QPointF(458, 0)
        self.isTracingPossible = False
        self.isTracing = False

    def mousePressEvent(self, event):
        """
        On commence un nouvel arc
        """
        if self.locked :
            return
        Instrument.mousePressEvent(self, event)
        self.isTracingPossible = False
        if event.buttons() == QtCore.Qt.RightButton :
            self.isTracingPossible = True
        elif event.buttons() == QtCore.Qt.LeftButton :
            if self.leftButtonMode == "ROTATE" :
                self.isTracingPossible = True
        if self.isTracingPossible and isTracingEnabled :
            self.main.view.last = None
            center = self.mapToScene(QtCore.QPointF(0, 0))
            point = self.mapToScene(self.tracePoint)
            self.main.view.initArc(center, point)
            self.isTracing = True

    def mouseMoveEvent(self, event):
        """
        On affiche l'arc
        """
        if self.locked :
            return
        Instrument.mouseMoveEvent(self, event)
        if self.isTracing :
            self.main.view.last = None
            center = self.mapToScene(QtCore.QPointF(0, 0))
            point = self.mapToScene(self.tracePoint)
            self.main.view.drawArcTo(center, point)
            if not isTracingEnabled :
                self.isTracing = False
        else :
            if self.isTracingPossible and isTracingEnabled :
                self.main.view.last = None
                center = self.mapToScene(QtCore.QPointF(0, 0))
                point = self.mapToScene(self.tracePoint)
                self.main.view.initArc(center, point)
                self.isTracing = True

    def mouseReleaseEvent(self, event):
        """
        On termine l'arc
        """
        if self.locked :
            return
        Instrument.mouseReleaseEvent(self, event)
        if self.isTracing :
            if isTracingEnabled :
                self.main.view.last = None
                center = self.mapToScene(QtCore.QPointF(0, 0))
                point = self.mapToScene(self.tracePoint)
                self.main.view.drawArcTo(center, point)
                self.isTracing = False






"""
###########################################################
###########################################################

                LE FAUX CURSEUR

###########################################################
###########################################################
"""

class MyCursor(QtGui.QGraphicsPixmapItem):
    """
    Le "faux" curseur qui suit la souris (utile pour certains TBI ?).
    Il est dans la liste des instruments, d'où le leftButtonMode 
        pour éviter les erreurs mais qui n'a pas d'utilité.
        (on n'a pas à le redimensionner ou le faire tourner)
    """
    def __init__(self, parent):
        QtGui.QGraphicsPixmapItem.__init__(self)
        self.main = parent

        newimage = QtGui.QImage("./images/cursor.png")
        self.setPixmap(QtGui.QPixmap.fromImage(newimage))
        
        centralPoint = QtCore.QPointF(-8, -8)
        self.setOffset(centralPoint)

        self.isUsed = False
        self.leftButtonMode = "MOVE"

    def doLeftButtonMode(self, newMode):
        """
        juste pour éviter les erreurs
        """
        self.leftButtonMode = newMode










"""
###########################################################
###########################################################

                LES POINTS CRÉÉS PAR L'UTILISATEUR

###########################################################
###########################################################
"""

class PointItem(QtGui.QGraphicsPathItem):
    """
    Un point et son label.
    C'est un QGraphicsPathItem qui contient le dessin du point (path)
        et un label (QGraphicsTextItem)
    """
    def __init__(self, parent, pen, brush, font, text = ""):
        QtGui.QGraphicsPathItem.__init__(self)
        self.main = parent
        self.setFlags(QtGui.QGraphicsItem.ItemIgnoresTransformations)
        self.setPen(pen)
        self.setBrush(brush)
        self.path = QtGui.QPainterPath()
        self.path.moveTo(QtCore.QPointF(-8, -8))
        self.path.lineTo(QtCore.QPointF(8, 8))
        self.path.moveTo(QtCore.QPointF(-8, 8))
        self.path.lineTo(QtCore.QPointF(8, -8))
        self.font = font
        self.text = text
        if text != "" :
            self.setText(pen, brush, font, text)
        self.setPath(self.path)

    def chooseText(self, pen, brush, font):
        """
        pour choisir le texte à la création du point.
        """
        try :
            proposedText = self.main.listPointNames[0]
        except :
            proposedText = ""
        text, ok = QtGui.QInputDialog.getText(self.main, utils.PROGNAME,
                                              self.main.tr("Point Name:"), 
                                              QtGui.QLineEdit.Normal,
                                              proposedText)
        if ok and not text.isEmpty():
            self.text = text
            self.main.listPointNames.remove(text)
            self.textItem = QtGui.QGraphicsTextItem(text, self)
            self.textItem.setFont(font)
            self.textItem.setDefaultTextColor(pen.color())
            self.textItem.setPos(QtCore.QPointF(8, -32))
        return ok

    def setText(self, pen, brush, font, text):
        """
        Pour définir le texte (à l'ouverture d'un fichier par exemple)
        """
        self.text = text
        self.textItem = QtGui.QGraphicsTextItem(text, self)
        self.textItem.setFont(font)
        self.textItem.setDefaultTextColor(pen.color())
        self.textItem.setPos(QtCore.QPointF(8, -32))  









"""
###########################################################
###########################################################

                LA FENÊTRE D'OUTILS

###########################################################
###########################################################
"""

class FlowLayout(QtGui.QLayout):
    """
    Un layout dont la disposition est recalculée lors d'un redimensionnement.
    Les barres d'outils se replacent en fonction de la largeur disponible.
    Pas toujours parfait, mais bon ça marche...
    Repris d'un exemple de Qt.
    """
    def __init__(self, parent=None, margin=0, spacing=-1):
        QtGui.QLayout.__init__(self, parent)

        if parent is not None:
            self.setMargin(margin)
        self.setSpacing(spacing)
        self.itemList = []

    def addItem(self, item):
        self.itemList.append(item)

    def count(self):
        return len(self.itemList)

    def itemAt(self, index):
        if index >= 0 and index < len(self.itemList):
            return self.itemList[index]

    def takeAt(self, index):
        if index >= 0 and index < len(self.itemList):
            return self.itemList.pop(index)

    def expandingDirections(self):
        return QtCore.Qt.Orientations(QtCore.Qt.Orientation(0))

    def hasHeightForWidth(self):
        return True

    def heightForWidth(self, width):
        height = self.doLayout(QtCore.QRect(0, 0, width, 0), True)
        return height

    def setGeometry(self, rect):
        QtGui.QLayout.setGeometry(self, rect)
        self.doLayout(rect, False)

    def sizeHint(self):
        return self.minimumSize()

    def minimumSize(self):
        size = QtCore.QSize()
        width = 0
        for item in self.itemList:
            if item.sizeHint().width() > width :
                 width = item.sizeHint().width()
            if item.geometry().left() == 0 :
                size += QtCore.QSize(0, item.sizeHint().height())
        size += QtCore.QSize(width, 0)
        size += QtCore.QSize(2 * self.margin(), 2 * self.margin())
        return size

    def doLayout(self, rect, testOnly):
        #print "doLayout ", testOnly
        x = rect.x()
        y = rect.y()
        lineHeight = 0
        for item in self.itemList:
            #print item.geometry().left()
            nextX = x + item.sizeHint().width() + self.spacing()
            if nextX - self.spacing() > rect.right() and lineHeight > 0:
                x = rect.x()
                y = y + lineHeight + self.spacing()
                nextX = x + item.sizeHint().width() + self.spacing()
                lineHeight = 0
            if not testOnly:
                item.setGeometry(QtCore.QRect(QtCore.QPoint(x, y), item.sizeHint()))
            x = nextX
            lineHeight = max(lineHeight, item.sizeHint().height())
        return y + lineHeight - rect.y()

class ToolsWindow(QtGui.QWidget):
    """
    La boîte à outils.
    Elle contient les différentes barres d'outils,
        et les actions associées.
    """
    def __init__(self, parent):
        super(ToolsWindow, self).__init__(parent)

        """
        Mise en place. On crée les actions, les barres d'outils, ...
        """
        self.main = parent
        self.setWindowTitle(self.tr("Tools"))
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.Tool)

        self.createActions()
        self.flowLayout = FlowLayout(self)

        self.createToolBars()

        self.setLayout(self.flowLayout)

    def resizeEvent(self, event):
        QtGui.QWidget.resizeEvent(self, event)
        height = self.flowLayout.minimumSize().height()
        self.setMinimumHeight(height)

    def closeEvent(self, event):
        self.main.quit()

    def keyPressEvent(self, event):
        self.main.keyPressEvent(event)

    def createToolBars(self):
        """
        La barre de base (quitter, aide, ...)
        """
        self.toolBarBase = QtGui.QToolBar(self.tr("Base Bar"))
        self.toolBarBase.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarBase)
        self.toolBarBase.addSeparator()
        self.toolBarBase.addAction(self.actionQuit)
        self.toolBarBase.addSeparator()
        self.toolBarBase.addAction(self.actionFileOpen)
        self.toolBarBase.addAction(self.actionFileSaveAs)
        self.toolBarBase.addAction(self.actionFileReload)
        self.toolBarBase.addAction(self.actionFileGoNext)
        self.toolBarBase.addSeparator()
        self.toolBarBase.addAction(self.actionConfigure)
        global WITHTRAYICON
        if not WITHTRAYICON :
            self.toolBarBase.addAction(self.actionMinimize)
        self.toolBarBase.addSeparator()
        self.toolBarBase.addAction(self.actionHelp)
        self.toolBarBase.addAction(self.actionAbout)
        self.toolBarBase.addAction(self.actionVideoDemo)
        self.toolBarBase.addAction(self.actionAboutQt)

        """
        La barre des réglages
        """
        self.toolBarConfig = QtGui.QToolBar(self.tr("Config Bar"))
        self.toolBarConfig.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarConfig)
        self.toolBarConfig.addSeparator()
        self.toolBarConfig.addAction(self.actionMoveInstruments)
        self.toolBarConfig.addAction(self.actionScaleInstruments)
        self.toolBarConfig.addAction(self.actionRotateInstruments)
        self.toolBarConfig.addSeparator()
        self.toolBarConfig.addAction(self.actionTrace)
        self.toolBarConfig.addAction(self.actionLockInstruments)
        self.toolBarConfig.addAction(self.actionShowFalseCursor)

        """
        La barre des screenshots et autres fonds
        """
        self.toolBarBackground = QtGui.QToolBar(self.tr("Background Bar"))
        self.toolBarBackground.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarBackground)
        self.toolBarBackground.addSeparator()
        self.toolBarBackground.addAction(self.actionNewScreenshot)
        self.toolBarBackground.addAction(self.actionWhitePage)
        self.toolBarBackground.addAction(self.actionPointsPage)
        self.toolBarBackground.addAction(self.actionGridPage)
        self.toolBarBackground.addAction(self.actionBackGround)

        """
        La barre des instruments
        """
        self.toolBarInstruments = QtGui.QToolBar(self.tr("Tools Bar"))
        self.toolBarInstruments.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarInstruments)
        self.toolBarInstruments.addSeparator()
        self.toolBarInstruments.addAction(self.actionShowRuler)
        self.toolBarInstruments.addAction(self.actionShowSetSquare)
        self.toolBarInstruments.addAction(self.actionShowProtractor)
        self.toolBarInstruments.addAction(self.actionShowCompass)

        """
        La barre des outils de dessin
        """
        self.toolBarDraw = QtGui.QToolBar(self.tr("Draw Bar"))
        self.toolBarDraw.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarDraw)
        self.toolBarDraw.addSeparator()
        self.toolBarDraw.addAction(self.actionSelect)
        self.toolBarDraw.addSeparator()
        # Le comboboxPens :
        self.comboBoxPens = QtGui.QComboBox()
        self.comboBoxPens.setMaxVisibleItems(5)
        self.comboBoxPens.setIconSize(self.main.iconSize)
        self.comboBoxPens.setObjectName("comboBox")
        for i in range(5) :
            j = i+1
            fileicon = "%s" % (j)
            fileicon = "images/pen" + fileicon + ".png"
            label = ""
            self.comboBoxPens.addItem(QtGui.QIcon(fileicon), label)
        self.connect(self.comboBoxPens, 
                        QtCore.SIGNAL("activated(int)"),
                        self.main.view.comboBoxPensChanged)
        self.toolBarDraw.addWidget(self.comboBoxPens)
        # La suite :
        self.toolBarDraw.addAction(self.actionDrawLine)
        self.toolBarDraw.addAction(self.actionDrawCurve)
        self.toolBarDraw.addAction(self.actionYellowHighlighterPen)
        self.toolBarDraw.addAction(self.actionGreenHighlighterPen)
        self.toolBarDraw.addSeparator()
        self.toolBarDraw.addAction(self.actionAddText)
        self.toolBarDraw.addAction(self.actionAddPoint)
        self.toolBarDraw.addAction(self.actionAddPixmap)

        """
        La barre de réglage des dessins
        """
        self.toolBarDrawConfig = QtGui.QToolBar(self.tr("Draw Config Bar"))
        self.toolBarDrawConfig.setIconSize(self.main.iconSize)
        self.flowLayout.addWidget(self.toolBarDrawConfig)
        self.toolBarDrawConfig.addSeparator()
        self.toolBarDrawConfig.addAction(self.actionPenColor)
        self.toolBarDrawConfig.addAction(self.actionPenWidth)
        self.toolBarDrawConfig.addAction(self.actionPenStyle)
        self.toolBarDrawConfig.addAction(self.actionChooseFont)
        self.toolBarDrawConfig.addSeparator()
        self.toolBarDrawConfig.addAction(self.actionEditText)
        self.toolBarDrawConfig.addAction(self.actionRemoveSelected)
        self.toolBarDrawConfig.addAction(self.actionRemoveLast)
        self.toolBarDrawConfig.addAction(self.actionEraseAll)

    def reloadToolBars(self):
        """
        Si on modifie la taille de icônes, il faut mettre à jour l'affichage
        """
        self.toolBarBase.setIconSize(self.main.iconSize)
        self.toolBarConfig.setIconSize(self.main.iconSize)
        self.toolBarBackground.setIconSize(self.main.iconSize)
        self.toolBarInstruments.setIconSize(self.main.iconSize)
        self.toolBarDraw.setIconSize(self.main.iconSize)
        self.toolBarDrawConfig.setIconSize(self.main.iconSize)

    def createActions(self):
        """
        Les actions de base (quitter, aide, ...)
        """
        self.actionQuit = QtGui.QAction(self.tr("Exit"), self)
        self.actionQuit.setStatusTip(self.tr("Exit"))
        self.actionQuit.setShortcut(self.tr("Ctrl+Q"))
        self.actionQuit.setIcon(QtGui.QIcon("images/application-exit.png"))
        self.connect(self.actionQuit, QtCore.SIGNAL("triggered()"), self.main.quit)

        self.actionFileOpen = QtGui.QAction(self.tr("FileOpen"), self)
        self.actionFileOpen.setIcon(QtGui.QIcon("images/fileopen.png"))
        self.connect(self.actionFileOpen, QtCore.SIGNAL("triggered()"), self.main.fileOpen)

        self.actionFileSaveAs = QtGui.QAction(self.tr("FileSaveAs"), self)
        self.actionFileSaveAs.setIcon(QtGui.QIcon("images/filesaveas.png"))
        self.connect(self.actionFileSaveAs, QtCore.SIGNAL("triggered()"), self.main.fileSaveAs)

        self.actionFileReload = QtGui.QAction(self.tr("FileReload"), self)
        self.actionFileReload.setIcon(QtGui.QIcon("images/view-refresh.png"))
        self.connect(self.actionFileReload, QtCore.SIGNAL("triggered()"), self.main.fileReload)

        self.actionFileGoNext = QtGui.QAction(self.tr("FileGoNext"), self)
        self.actionFileGoNext.setIcon(QtGui.QIcon("images/go-next.png"))
        self.connect(self.actionFileGoNext, QtCore.SIGNAL("triggered()"), self.main.fileGoNext)

        self.actionConfigure = QtGui.QAction(self.tr("Configure"), self)
        self.actionConfigure.setIcon(QtGui.QIcon("images/configure.png"))
        self.connect(self.actionConfigure, QtCore.SIGNAL("triggered()"), self.main.configure)

        self.actionMinimize = QtGui.QAction(self.tr("Minimize"), self)
        self.actionMinimize.setIcon(QtGui.QIcon("images/minimize.png"))
        self.connect(self.actionMinimize, QtCore.SIGNAL("triggered()"), self.main.showMinimized)

        self.actionHelp = QtGui.QAction(self.tr("Help"), self)
        self.actionHelp.setShortcut(self.tr("F1"))
        self.actionHelp.setIcon(QtGui.QIcon("images/help.png"))
        self.connect(self.actionHelp, QtCore.SIGNAL("triggered()"), self.main.help)

        self.actionAbout = QtGui.QAction(self.tr("About"), self)
        self.actionAbout.setIcon(QtGui.QIcon("images/help-about.png"))
        self.connect(self.actionAbout, QtCore.SIGNAL("triggered()"), self.main.about)

        self.actionVideoDemo = QtGui.QAction(self.tr("VideoDemo"), self)
        self.actionVideoDemo.setIcon(QtGui.QIcon("images/video.png"))
        self.connect(self.actionVideoDemo, QtCore.SIGNAL("triggered()"), self.main.video_demo)

        self.actionAboutQt = QtGui.QAction(self.tr("About Qt"), self)
        self.actionAboutQt.setIcon(QtGui.QIcon("images/qt-logo.png"))
        self.connect(self.actionAboutQt, QtCore.SIGNAL("triggered()"), QtGui.qApp, QtCore.SLOT("aboutQt()"))

        """
        Les actions des réglages
        """
        self.actionMoveInstruments = QtGui.QAction(self.tr("MoveInstruments"), self)
        self.actionMoveInstruments.setIcon(QtGui.QIcon("images/move.png"))
        self.actionMoveInstruments.setCheckable(True)
        self.actionMoveInstruments.setChecked(True)
        QtCore.QObject.connect(self.actionMoveInstruments,
                QtCore.SIGNAL("triggered()"), self.moveInstruments)

        self.actionScaleInstruments = QtGui.QAction(self.tr("ScaleInstruments"), self)
        self.actionScaleInstruments.setIcon(QtGui.QIcon("images/scale.png"))
        self.actionScaleInstruments.setCheckable(True)
        self.actionScaleInstruments.setChecked(False)
        QtCore.QObject.connect(self.actionScaleInstruments,
                QtCore.SIGNAL("triggered()"), self.scaleInstruments)

        self.actionRotateInstruments = QtGui.QAction(self.tr("RotateInstruments"), self)
        self.actionRotateInstruments.setIcon(QtGui.QIcon("images/rotate.png"))
        self.actionRotateInstruments.setCheckable(True)
        self.actionRotateInstruments.setChecked(False)
        QtCore.QObject.connect(self.actionRotateInstruments,
                QtCore.SIGNAL("triggered()"), self.rotateInstruments)

        self.actionTrace = QtGui.QAction(self.tr("Trace"), self)
        self.actionTrace.setIcon(QtGui.QIcon("images/trace.png"))
        self.actionTrace.setCheckable(True)
        self.actionTrace.setChecked(False)
        QtCore.QObject.connect(self.actionTrace,
                QtCore.SIGNAL("triggered()"), self.doChangeTrace)

        self.actionLockInstruments = QtGui.QAction(self.tr("LockInstruments"), self)
        self.actionLockInstruments.setIcon(QtGui.QIcon("images/object-locked.png"))
        self.actionLockInstruments.setCheckable(True)
        self.actionLockInstruments.setChecked(False)
        QtCore.QObject.connect(self.actionLockInstruments,
                QtCore.SIGNAL("triggered()"), self.lockInstruments)

        self.actionShowFalseCursor = QtGui.QAction(self.tr("ShowFalseCursor"), self)
        self.actionShowFalseCursor.setIcon(QtGui.QIcon("images/cursor.png"))
        self.actionShowFalseCursor.setCheckable(True)
        self.actionShowFalseCursor.setChecked(False)
        QtCore.QObject.connect(self.actionShowFalseCursor,
                QtCore.SIGNAL("triggered()"), self.showFalseCursor)

        """
        Les actions des screenshots et autres fonds
        """
        self.actionNewScreenshot = QtGui.QAction(self.tr("newScreenshot"), self)
        self.actionNewScreenshot.setIcon(QtGui.QIcon("images/camera-photo.png"))
        QtCore.QObject.connect(self.actionNewScreenshot,
                QtCore.SIGNAL("triggered()"), self.main.newScreenshot)

        self.actionWhitePage = QtGui.QAction(self.tr("WhitePage"), self)
        self.actionWhitePage.setIcon(QtGui.QIcon("images/view_remove.png"))
        QtCore.QObject.connect(self.actionWhitePage,
                QtCore.SIGNAL("triggered()"), self.main.whitePage)

        self.actionPointsPage = QtGui.QAction(self.tr("PointsPage"), self)
        self.actionPointsPage.setIcon(QtGui.QIcon("images/points.png"))
        QtCore.QObject.connect(self.actionPointsPage,
                QtCore.SIGNAL("triggered()"), self.main.pointsPage)

        self.actionGridPage = QtGui.QAction(self.tr("GridPage"), self)
        self.actionGridPage.setIcon(QtGui.QIcon("images/grid.png"))
        QtCore.QObject.connect(self.actionGridPage,
                QtCore.SIGNAL("triggered()"), self.main.gridPage)

        self.actionBackGround = QtGui.QAction(self.tr("ChooseBackGround"), self)
        self.actionBackGround.setIcon(QtGui.QIcon("images/images.png"))
        QtCore.QObject.connect(self.actionBackGround,
                QtCore.SIGNAL("triggered()"), self.main.chooseBackGround)

        """
        Les actions des instruments
        """
        self.actionShowRuler = QtGui.QAction(self.tr("ShowRuler"), self)
        self.actionShowRuler.setIcon(QtGui.QIcon("images/instruments/regle.png"))
        self.actionShowRuler.setCheckable(True)
        self.actionShowRuler.setChecked(False)
        QtCore.QObject.connect(self.actionShowRuler,
                QtCore.SIGNAL("triggered()"), self.showRuler)

        self.actionShowSetSquare = QtGui.QAction(self.tr("ShowSetSquare"), self)
        self.actionShowSetSquare.setIcon(QtGui.QIcon("images/instruments/equerre.png"))
        self.actionShowSetSquare.setCheckable(True)
        self.actionShowSetSquare.setChecked(False)
        QtCore.QObject.connect(self.actionShowSetSquare,
                QtCore.SIGNAL("triggered()"), self.showSetSquare)

        self.actionShowProtractor = QtGui.QAction(self.tr("ShowProtractor"), self)
        self.actionShowProtractor.setIcon(QtGui.QIcon("images/instruments/rapporteur.png"))
        self.actionShowProtractor.setCheckable(True)
        self.actionShowProtractor.setChecked(False)
        QtCore.QObject.connect(self.actionShowProtractor,
                QtCore.SIGNAL("triggered()"), self.showProtractor)

        self.actionShowCompass = QtGui.QAction(self.tr("ShowCompass"), self)
        self.actionShowCompass.setIcon(QtGui.QIcon("images/instruments/compas.png"))
        self.actionShowCompass.setCheckable(True)
        self.actionShowCompass.setChecked(False)
        QtCore.QObject.connect(self.actionShowCompass,
                QtCore.SIGNAL("triggered()"), self.showCompass)

        """
        Les actions des outils de dessin
        """
        self.actionSelect = QtGui.QAction(self.tr("Select"), self)
        self.actionSelect.setIcon(QtGui.QIcon("images/draw_select.png"))
        self.actionSelect.setCheckable(True)
        self.actionSelect.setChecked(False)
        QtCore.QObject.connect(self.actionSelect,
                QtCore.SIGNAL("triggered()"), self.select)

        self.actionDrawLine = QtGui.QAction(self.tr("DrawLine"), self)
        self.actionDrawLine.setIcon(QtGui.QIcon("images/draw-freehand.png"))
        self.actionDrawLine.setCheckable(True)
        self.actionDrawLine.setChecked(False)
        QtCore.QObject.connect(self.actionDrawLine,
                QtCore.SIGNAL("triggered()"), self.drawLine)

        self.actionDrawCurve = QtGui.QAction(self.tr("DrawCurve"), self)
        self.actionDrawCurve.setIcon(QtGui.QIcon("images/draw-brush.png"))
        self.actionDrawCurve.setCheckable(True)
        self.actionDrawCurve.setChecked(False)
        QtCore.QObject.connect(self.actionDrawCurve,
                QtCore.SIGNAL("triggered()"), self.drawCurve)

        self.actionYellowHighlighterPen = QtGui.QAction(self.tr("YellowHighlighterPen"), self)
        self.actionYellowHighlighterPen.setIcon(QtGui.QIcon("images/surligneur_jaune.png"))
        self.actionYellowHighlighterPen.setCheckable(True)
        self.actionYellowHighlighterPen.setChecked(False)
        QtCore.QObject.connect(self.actionYellowHighlighterPen,
                QtCore.SIGNAL("triggered()"), self.yellowHighlighterPen)

        self.actionGreenHighlighterPen = QtGui.QAction(self.tr("GreenHighlighterPen"), self)
        self.actionGreenHighlighterPen.setIcon(QtGui.QIcon("images/surligneur_vert.png"))
        self.actionGreenHighlighterPen.setCheckable(True)
        self.actionGreenHighlighterPen.setChecked(False)
        QtCore.QObject.connect(self.actionGreenHighlighterPen,
                QtCore.SIGNAL("triggered()"), self.greenHighlighterPen)

        self.actionAddText = QtGui.QAction(self.tr("AddText"), self)
        self.actionAddText.setIcon(QtGui.QIcon("images/addtext.png"))
        self.actionAddText.setCheckable(True)
        self.actionAddText.setChecked(False)
        QtCore.QObject.connect(self.actionAddText,
                QtCore.SIGNAL("triggered()"), self.addText)

        self.actionAddPoint = QtGui.QAction(self.tr("AddPoint"), self)
        self.actionAddPoint.setIcon(QtGui.QIcon("images/point.png"))
        self.actionAddPoint.setCheckable(True)
        self.actionAddPoint.setChecked(False)
        QtCore.QObject.connect(self.actionAddPoint,
                QtCore.SIGNAL("triggered()"), self.addPoint)

        self.actionAddPixmap = QtGui.QAction(self.tr("AddPixmap"), self)
        self.actionAddPixmap.setIcon(QtGui.QIcon("images/pixmap.png"))
        self.actionAddPixmap.setCheckable(True)
        self.actionAddPixmap.setChecked(False)
        QtCore.QObject.connect(self.actionAddPixmap,
                QtCore.SIGNAL("triggered()"), self.addPixmap)

        """
        Les actions de réglage des dessins
        """
        self.actionPenColor = QtGui.QAction(self.tr("PenColor"), self)
        self.actionPenColor.setIcon(QtGui.QIcon("images/colorize.png"))
        QtCore.QObject.connect(self.actionPenColor,
                QtCore.SIGNAL("triggered()"), self.main.view.penColor)

        self.actionPenWidth = QtGui.QAction(self.tr("PenWidth"), self)
        self.actionPenWidth.setIcon(QtGui.QIcon("images/line-size.png"))
        QtCore.QObject.connect(self.actionPenWidth,
                QtCore.SIGNAL("triggered()"), self.main.view.penWidth)

        self.actionPenStyle = QtGui.QAction(self.tr("PenStyle"), self)
        self.actionPenStyle.setIcon(QtGui.QIcon("images/line-style.png"))
        QtCore.QObject.connect(self.actionPenStyle,
                QtCore.SIGNAL("triggered()"), self.main.view.penStyle)

        self.actionChooseFont = QtGui.QAction(self.tr("ChooseFont"), self)
        self.actionChooseFont.setIcon(QtGui.QIcon("images/fonts.png"))
        QtCore.QObject.connect(self.actionChooseFont,
                QtCore.SIGNAL("triggered()"), self.chooseFont)

        self.actionEditText = QtGui.QAction(self.tr("EditText"), self)
        self.actionEditText.setIcon(QtGui.QIcon("images/edit.png"))
        QtCore.QObject.connect(self.actionEditText,
                QtCore.SIGNAL("triggered()"), self.main.editText)

        self.actionRemoveSelected = QtGui.QAction(self.tr("RemoveSelected"), self)
        self.actionRemoveSelected.setIcon(QtGui.QIcon("images/edittrash.png"))
        QtCore.QObject.connect(self.actionRemoveSelected,
                QtCore.SIGNAL("triggered()"), self.main.removeSelected)

        self.actionRemoveLast = QtGui.QAction(self.tr("RemoveLast"), self)
        self.actionRemoveLast.setIcon(QtGui.QIcon("images/undo.png"))
        QtCore.QObject.connect(self.actionRemoveLast,
                QtCore.SIGNAL("triggered()"), self.main.removeLast)

        self.actionEraseAll = QtGui.QAction(self.tr("EraseAll"), self)
        self.actionEraseAll.setIcon(QtGui.QIcon("images/draw-eraser.png"))
        QtCore.QObject.connect(self.actionEraseAll,
                QtCore.SIGNAL("triggered()"), self.main.eraseAll)

        """
        Les actions des pinceaux enregistrés
        """

    def showRuler(self):
        """
        affiche ou masque la règle
        """
        WithRuler = self.actionShowRuler.isChecked()
        self.main.ruler.setVisible(WithRuler)

    def showSetSquare(self):
        WithSetSquare = self.actionShowSetSquare.isChecked()
        self.main.setSquare.setVisible(WithSetSquare)

    def showProtractor(self):
        WithProtractor = self.actionShowProtractor.isChecked()
        self.main.protractor.setVisible(WithProtractor)

    def showCompass(self):
        WithCompass = self.actionShowCompass.isChecked()
        self.main.compass.setVisible(WithCompass)

    def doChangeTrace(self):
        """
        On rend possible ou pas la trace du compas.
        La variable globale isTracingEnabled est modifiée.
        """
        global isTracingEnabled
        isTracingEnabled = self.actionTrace.isChecked()

    def changeTrace(self, newMode = False):
        """
        On appelle la fonction précédente depuis le programme.
        """
        self.actionTrace.setChecked(newMode)
        self.doChangeTrace()

    def lockInstruments(self):
        """
        Bloque ou débloque l'utilisation des instruments
        """
        locked = self.actionLockInstruments.isChecked()
        for instrument in self.main.listeInstruments :
            instrument.locked = locked

    def showFalseCursor(self):
        """
        On utilise ou pas le faux curseur.
        """
        global withFalseCursor
        withFalseCursor = self.actionShowFalseCursor.isChecked()
        self.main.myCursor.setVisible(withFalseCursor)
        if withFalseCursor :
            self.disableAll()

    def moveInstruments(self):
        """
        On met les autres boutons à False
        """
        self.actionMoveInstruments.setChecked(True)
        self.actionScaleInstruments.setChecked(False)
        self.actionRotateInstruments.setChecked(False)
        self.main.doInstrumentLeftButtonMode("MOVE")

    def scaleInstruments(self):
        self.actionMoveInstruments.setChecked(False)
        self.actionScaleInstruments.setChecked(True)
        self.actionRotateInstruments.setChecked(False)
        self.main.doInstrumentLeftButtonMode("SCALE")

    def rotateInstruments(self):
        self.actionMoveInstruments.setChecked(False)
        self.actionScaleInstruments.setChecked(False)
        self.actionRotateInstruments.setChecked(True)
        self.main.doInstrumentLeftButtonMode("ROTATE")

    def disableAll(self):
        """
        Met tous les boutons de dessin à False
        Évite de le gérer pour chaque outil
        Il suffit de remettre ensuite celui choisi à True.
        Permet de n'avoir qu'un seul outil de sélectionné.
        """
        self.actionSelect.setChecked(False)
        # on ne doit plus non plus pouvoir sélectionner les items créés :
        for item in self.main.scene.items() :
            if not(item in self.main.listeInstruments) :
                item.setFlags(QtGui.QGraphicsItem.ItemIgnoresTransformations)
        self.actionDrawLine.setChecked(False)
        self.actionDrawCurve.setChecked(False)
        self.actionYellowHighlighterPen.setChecked(False)
        self.actionGreenHighlighterPen.setChecked(False)
        self.actionAddText.setChecked(False)
        self.actionAddPoint.setChecked(False)
        self.actionAddPixmap.setChecked(False)
        # on remet le curseur par défaut :
        self.main.view.actualCursor = QtCore.Qt.ArrowCursor
        self.main.drawingMode = "NO"

    def select(self):
        """
        WithThis pour récupérer l'état du bouton
        On met tous les autres à False
        On met à jour drawingMode.
        Si à True, les items créés deviennent sélectionnables.
        """
        WithThis = self.actionSelect.isChecked()
        self.disableAll()
        self.actionSelect.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "SELECT"
            for item in self.main.scene.items() :
                if not(item in self.main.listeInstruments) :
                    item.setFlags(QtGui.QGraphicsItem.ItemIsSelectable|
                                    QtGui.QGraphicsItem.ItemIsMovable)

    def drawLine(self):
        """
        WithThis pour récupérer l'état du bouton
        On met tous les autres à False
        On met à jour drawingMode.
        Si à True, le curseur prend la forme d'une croix.
        """
        WithThis = self.actionDrawLine.isChecked()
        self.disableAll()
        self.actionDrawLine.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "LINE"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def drawCurve(self):
        WithThis = self.actionDrawCurve.isChecked()
        self.disableAll()
        self.actionDrawCurve.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "CURVE"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def yellowHighlighterPen(self):
        WithThis = self.actionYellowHighlighterPen.isChecked()
        self.disableAll()
        self.actionYellowHighlighterPen.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "YELLOW"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def greenHighlighterPen(self):
        WithThis = self.actionGreenHighlighterPen.isChecked()
        self.disableAll()
        self.actionGreenHighlighterPen.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "GREEN"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def chooseFont(self):
        """
        Dialogue pour choir la police d'écriture
        """
        font, ok = QtGui.QFontDialog.getFont(self.main.view.font, self)
        if ok:
            self.main.view.font = font

    def addText(self):
        WithThis = self.actionAddText.isChecked()
        self.disableAll()
        self.actionAddText.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "TEXT"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def addPoint(self):
        WithThis = self.actionAddPoint.isChecked()
        self.disableAll()
        self.actionAddPoint.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "POINT"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor

    def addPixmap(self):
        WithThis = self.actionAddPixmap.isChecked()
        self.disableAll()
        self.actionAddPixmap.setChecked(WithThis)
        if WithThis :
            self.main.drawingMode = "PIXMAP"
            self.main.view.actualCursor = QtCore.Qt.CrossCursor






class ToolsKidWindow(QtGui.QWidget):
    """
    La boîte à outils.
    Elle contient les différentes barres d'outils,
        et les actions associées.
    """
    def __init__(self, parent):
        super(ToolsKidWindow, self).__init__(parent)

        """
        Mise en place. On crée les actions, les barres d'outils, ...
        """
        self.main = parent
        self.setWindowTitle(self.main.toolsWindow.tr("Tools"))
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.Tool)
        self.mainRequest = False

        self.createActions()
        self.flowLayout = FlowLayout(self)
        self.createToolBars()
        self.setLayout(self.flowLayout)

    def resizeEvent(self, event):
        QtGui.QWidget.resizeEvent(self, event)
        height = self.flowLayout.minimumSize().height()
        self.setMinimumHeight(height)

    def keyPressEvent(self, event):
        self.main.keyPressEvent(event)

    def closeEvent(self, event):
        if self.mainRequest :
            self.mainRequest = False
            event.accept()
        else :
            event.ignore()


    def createToolBars(self):
        """
        La barre de base (quitter, aide, ...)
        """
        self.toolBarBase = QtGui.QToolBar(self.main.toolsWindow.tr("Base Bar"))
        self.toolBarBase.setIconSize(self.main.iconSize * KIDICONSCALE)
        self.flowLayout.addWidget(self.toolBarBase)
        #self.toolBarBase.addSeparator()
        self.toolBarBase.addAction(self.actionFileReload)
        self.toolBarBase.addAction(self.actionFileGoNext)

    def createActions(self):
        """
        Les actions de base (quitter, aide, ...)
        """
        self.actionFileReload = QtGui.QAction(self.main.toolsWindow.tr("FileReload"), self)
        self.actionFileReload.setIcon(QtGui.QIcon("images/view-refresh-kid.png"))
        self.connect(self.actionFileReload, QtCore.SIGNAL("triggered()"), self.main.fileReload)

        self.actionFileGoNext = QtGui.QAction(self.main.toolsWindow.tr("FileGoNext"), self)
        self.actionFileGoNext.setIcon(QtGui.QIcon("images/go-next-kid.png"))
        self.connect(self.actionFileGoNext, QtCore.SIGNAL("triggered()"), self.main.fileGoNext)



"""
###########################################################
###########################################################

                DIALOG DE CRÉATION D'UN TEXTE

###########################################################
###########################################################
"""

class TextItemDlg(QtGui.QDialog):
    """
    La fenêtre de dialogue de création d'un texte.
    Le texte s'affiche dans la police sélectionnée, dans un QTextEdit.
    """
    def __init__(self, parent = None, graphicsTextItem = None):
        super(QtGui.QDialog, self).__init__(parent)

        self.graphicsTextItem = graphicsTextItem
        self.parent = parent

        self.editor = QtGui.QTextEdit()
        self.editor.setAcceptRichText(False)
        self.editor.setTabChangesFocus(True)
        editorLabel = QtGui.QLabel(self.tr("Text:"))
        editorLabel.setBuddy(self.editor)

        self.buttonBox = QtGui.QDialogButtonBox(QtGui.QDialogButtonBox.Ok|
                                          QtGui.QDialogButtonBox.Cancel)
        self.buttonBox.button(QtGui.QDialogButtonBox.Ok).setEnabled(False)

        if self.graphicsTextItem is not None:
            self.font = self.graphicsTextItem.font()
            self.color = self.graphicsTextItem.defaultTextColor()
            self.editor.document().setDefaultFont(self.font)
            self.editor.setTextColor(self.color)
            self.editor.setPlainText(self.graphicsTextItem.toPlainText())
        else :
            self.font = self.parent.font
            self.color = self.parent.drawPen.color()

        layout = QtGui.QGridLayout()
        layout.addWidget(editorLabel, 0, 0)
        layout.addWidget(self.editor, 1, 0, 1, 6)
        layout.addWidget(self.buttonBox, 2, 0, 1, 6)
        self.setLayout(layout)

        self.connect(self.editor, QtCore.SIGNAL("textChanged()"), self.updateUi)
        self.connect(self.buttonBox, QtCore.SIGNAL("accepted()"), self.accept)
        self.connect(self.buttonBox, QtCore.SIGNAL("rejected()"), self.reject)

        self.setWindowTitle(self.tr("InsertText"))
        self.updateUi()

    def updateUi(self):
        self.editor.document().setDefaultFont(self.font)
        self.editor.setTextColor(self.color)
        self.buttonBox.button(QtGui.QDialogButtonBox.Ok).setEnabled(
                not self.editor.toPlainText().isEmpty())

    def accept(self):
        self.graphicsTextItem.setPlainText(self.editor.toPlainText())   
        self.graphicsTextItem.update()
        QtGui.QDialog.accept(self)




"""
###########################################################
###########################################################

                LE GRAPHICSVIEW : ZONE D'AFFICHAGE

###########################################################
###########################################################
"""

class GraphicsView(QtGui.QGraphicsView):
    """
    Le GraphicsView qui affiche l'image de fond et les items.
    """
    def __init__(self, parent):
        QtGui.QGraphicsView.__init__(self, parent)
        
        """
        on récupère main (fenêtre principale)
        pas d'ascenseurs
        """
        self.main = parent

        self.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)

        self.isDrawingEnabled = False
        self.scribbling = False
        self.lastPoint = QtCore.QPointF()
        """
        self.drawPen = QtGui.QPen(QtCore.Qt.black, 1,
                                  QtCore.Qt.SolidLine, QtCore.Qt.RoundCap,
                                  QtCore.Qt.RoundJoin)
        """
        self.pens = []
        for i in range(5) :
            newPen = QtGui.QPen(QtCore.Qt.black, 1,
                                  QtCore.Qt.SolidLine, QtCore.Qt.RoundCap,
                                  QtCore.Qt.RoundJoin)
            self.pens.append(newPen)
        self.drawPen = self.pens[0]
        self.path = QtGui.QPainterPath()
        self.font = QtGui.QFont()
        self.actualCursor = QtCore.Qt.ArrowCursor

    def keyPressEvent(self, event):
        """
        Gestion des touches Control et Delete
        """
        if event.key() == QtCore.Qt.Key_Control :
            self.main.toolsWindow.changeTrace(newMode = True)
        elif event.key() == QtCore.Qt.Key_Delete :
            self.main.removeSelected()
        else :
            self.main.keyPressEvent(event)
            
    def keyReleaseEvent(self, event):
        """
        Gestion de la touche Control
        """
        if event.key() == QtCore.Qt.Key_Control :
            self.main.toolsWindow.changeTrace(newMode = False)

    def mousePressEvent(self, event):
        """
        On veut distinguer le clic du double-clic.
        Ici, on met la variable doubleClick à False,
            et on retarde la gestion du simple clic à la fonction doMouseClick.
        Entre temps, si c'est un double-clic, la variable doubleClick sera
            devenue True.
        """
        QtGui.QGraphicsView.mousePressEvent(self, event)
        self.doubleClick = False
        self.mouseEventButton, self.mouseEventPos = event.button(), self.mapToScene(event.pos())
        self.isDrawingEnabled = False
        # en dessous de 300, ça foire :
        QtCore.QTimer.singleShot(300, self.doMouseClick)

    def mouseDoubleClickEvent(self, event):
        """
        On met la variable doubleClick à True, pour ne pas executer 
            la procédure liée au simple clic.
        Si le double-clic est fait sur un texte ou le label d'un point,
            il permet de l'éditer.
        Sinon, il permet de cacher/afficher la barre d'outils.
        """
        #print "mouseDoubleClickEvent"
        QtGui.QGraphicsView.mouseDoubleClickEvent(self, event)
        self.doubleClick = True
        if self.main.editText() == False :
            if not(self.main.toolsKidMode) :
                if self.main.toolsWindow.isVisible() :
                    self.main.doMinimizeToolsWindow()
                else :
                    self.main.doRestoreToolsWindow()

    def doMouseClick(self):
        """
         Si la variable doubleClick est à False, on fait bien un simple clic.
         Gestion des différents cas possibles 
            (ajout d'un texte, début d'un tracé, ...)
        """
        if self.doubleClick == False :
            #print "doMouseClick"
            #pour ne calculer qu'une seule fois (et pas à nouveau dans mouseMoveEvent) :
            self.isDrawingEnabled = self.main.isDrawingEnabled()
            if self.isDrawingEnabled :
                if self.mouseEventButton == QtCore.Qt.LeftButton and self.main.drawingMode != "NO" :
                    point = self.mouseEventPos
                    if self.main.drawingMode == "TEXT" :
                        textItem = QtGui.QGraphicsTextItem()
                        textItem.setFont(self.font)
                        textItem.setDefaultTextColor(self.drawPen.color())
                        dialog = TextItemDlg(parent = self, graphicsTextItem = textItem)
                        if dialog.exec_() == QtGui.QDialog.Accepted :
                            self.main.scene.addItem(textItem)
                            textItem.setPos(point)                        
                    elif self.main.drawingMode == "POINT" :
                        brush = QtGui.QBrush(self.drawPen.color())
                        exStyle = self.drawPen.style()
                        self.drawPen.setStyle(QtCore.Qt.SolidLine)
                        pointItem = PointItem(self.main, self.drawPen, brush, self.font)
                        self.drawPen.setStyle(exStyle)
                        ok = pointItem.chooseText(self.drawPen, brush, self.font)
                        if ok :
                            self.main.scene.addItem(pointItem)
                            pointItem.setPos(point)                        
                    elif self.main.drawingMode == "PIXMAP" :
                        fileName = QtGui.QFileDialog.getOpenFileName(self.main, 
                                                        self.main.tr("Open Image"),
                                                        self.main.pixmapDir, 
                                                        self.main.tr("Image Files (*.png *.jpg *.jpeg *.xpm)"))
                        if not fileName.isEmpty():
                            self.main.pixmapDir = QtCore.QFileInfo(fileName).absolutePath()
                            image = QtGui.QImage(fileName)
                            pixmap = QtGui.QPixmap.fromImage(image)
                            pixmapItem = QtGui.QGraphicsPixmapItem(pixmap)
                            self.main.scene.addItem(pixmapItem)
                            pixmapItem.setPos(point)                        
                    elif self.main.drawingMode == "LINE" :
                        self.scribbling = True
                        self.last = None
                        self.initLine(point)
                    else : 
                        self.scribbling = True
                        self.last = None
                        self.initCurve(point)

    def mouseMoveEvent(self, event):
        """
        D'une part, si on tace une courbe, on met à jour.
        D'autre part, on vérifie quel curseur est affiché (y compris le "faux")
        """
        QtGui.QGraphicsView.mouseMoveEvent(self, event)
        if self.isDrawingEnabled :
            point = self.mapToScene(event.pos())
            if (event.buttons() & QtCore.Qt.LeftButton) and self.scribbling:
                if self.main.drawingMode == "LINE" :
                    self.drawLineTo(point)
                else :
                    self.drawCurveTo(point)
        if withFalseCursor :
            point = self.mapToScene(event.pos())
            self.main.myCursor.setPos(point.x(), point.y())
            if self.cursor() != QtCore.Qt.BlankCursor :
                self.setCursor(QtCore.Qt.BlankCursor)
        elif self.cursor() != self.actualCursor :
            self.setCursor(self.actualCursor)

    def mouseReleaseEvent(self, event):
        """
        On termine l'éventuel tracé
        """
        QtGui.QGraphicsView.mouseReleaseEvent(self, event)
        if self.isDrawingEnabled :
            if event.button() == QtCore.Qt.LeftButton and self.scribbling:
                point = self.mapToScene(event.pos())
                if self.main.drawingMode == "LINE" :
                    self.drawLineTo(point)
                else :
                    self.drawCurveTo(point, endLine = True)
                self.scribbling = False                

    def initLine(self, startPoint):
        """
        Début d'une ligne (un segment).
        On initialise le path et le pathItem
        """
        self.lastPoint = startPoint
        self.path = QtGui.QPainterPath()
        self.path.moveTo(startPoint)
        pen = self.drawPen
        brush = QtGui.QBrush(QtCore.Qt.green, QtCore.Qt.NoBrush)
        self.pathItem = self.main.scene.addPath(self.path, pen, brush)
        self.pathItem.setFlags(QtGui.QGraphicsItem.ItemIgnoresTransformations)

    def drawLineTo(self, endPoint):
        """
        On supprime systématiquement la ligne précédente
            avant d'ajouter la nouvelle
        """
        self.path.lineTo(endPoint)
        if self.last != None :
            self.main.scene.removeItem(self.last)
        self.last = self.main.scene.addLine(self.lastPoint.x(), self.lastPoint.y(), 
                                            endPoint.x(), endPoint.y(), 
                                            self.drawPen)

    def initCurve(self, startPoint):
        """
        Début d'une courbe.
        On initialise le path et le pathItem. En cours de tracé, on affichera 
            une suite de segments (polyligne).
        Le path sera recalculé à la fin du tracé, pour tracer une courbe.
        On récupèrera donc les points de passage dans une liste (listPoints).
        """
        self.lastPoint = startPoint
        self.path = QtGui.QPainterPath()
        self.path.moveTo(startPoint)
        if self.main.drawingMode == "YELLOW" :
            pen = QtGui.QPen(QtCore.Qt.yellow, 20,
                                    QtCore.Qt.SolidLine, QtCore.Qt.RoundCap,
                                    QtCore.Qt.RoundJoin)
            color = QtGui.QColor(252, 252, 0, 100)
            pen.setColor(color)
        elif self.main.drawingMode == "GREEN" :
            pen = QtGui.QPen(QtCore.Qt.yellow, 20,
                                    QtCore.Qt.SolidLine, QtCore.Qt.RoundCap,
                                    QtCore.Qt.RoundJoin)
            color = QtGui.QColor(0, 252, 0, 100)
            pen.setColor(color)
        else :
            pen = self.drawPen
        brush = QtGui.QBrush(QtCore.Qt.green, QtCore.Qt.NoBrush)
        self.pathItem = self.main.scene.addPath(self.path, pen, brush)
        self.pathItem.setFlags(QtGui.QGraphicsItem.ItemIgnoresTransformations)
        #pour faire la courbe finale :
        self.listPoints = []
        self.listPoints.append(startPoint)

    def drawCurveTo(self, endPoint, endLine = False):
        """
        En cours de tracé, c'est path qui est affiché.
            On récupère le point dans listPoints.
        À la fin (appel avec la variable endLine à True), 
            on calcule la courbe, et on l'affiche.
        """
        self.path.lineTo(endPoint)
        self.lastPoint = endPoint
        self.pathItem.setPath(self.path)
        self.listPoints.append(endPoint)
        if endLine :
            self.lastPoint = endPoint
            self.path = QtGui.QPainterPath()
            self.path.moveTo(self.listPoints[0])
            for i in range(len(self.listPoints) /2) :
                self.path.quadTo(self.listPoints[2*i], self.listPoints[2*i + 1])
            self.pathItem.setPath(self.path)

    def initArc(self, center, startPoint):
        """
        Début d'un arc de compas.
        On initialise les différentes valeurs d'angles utiles.
        On calcule le rectangle d'affichage (carré contenant le cercle complet).
        """
        self.lastPoint = startPoint
        self.path = QtGui.QPainterPath()
        self.path.moveTo(startPoint)
        pen = self.drawPen
        brush = QtGui.QBrush(QtCore.Qt.green, QtCore.Qt.NoBrush)
        self.pathItem = self.main.scene.addPath(self.path, pen, brush)

        self.startPoint = startPoint
        rayon = QtCore.QLineF(center, startPoint)
        self.startAngle = rayon.angle()
        self.minAngle = self.startAngle
        self.maxAngle = self.startAngle
        self.lastAngle = self.startAngle
        length = rayon.length()
        self.rectangle = QtCore.QRectF(center.x() - length, center.y() - length, 
                                    2*length, 2*length)

    def drawArcTo(self, center, endPoint):
        """
        En cours de tracé, on recalcule les différents angles utiles.
            Pas mal de cas à gérer, et la complication du passage brutal de 0 à 360.
        Ensuite on trace l'arc.
        """
        self.lastPoint = QtCore.QPointF(endPoint)

        rayon = QtCore.QLineF(center, endPoint)
        self.path = QtGui.QPainterPath()
        angle = rayon.angle()
        if angle - self.lastAngle > 300 :
            self.minAngle = self.minAngle + 360.0
            self.maxAngle = self.maxAngle + 360.0
        if angle - self.lastAngle < -300 :
            self.minAngle = self.minAngle - 360.0
            self.maxAngle = self.maxAngle - 360.0

        if angle < self.minAngle :
            self.minAngle = angle
            self.startPoint = self.lastPoint
        if angle > self.maxAngle :
            self.maxAngle = angle
        endAngle = self.maxAngle - self.minAngle
        self.path.moveTo(self.startPoint)
        self.path.arcTo(self.rectangle, self.minAngle, endAngle)
        self.pathItem.setPath(self.path)
        self.lastAngle = angle

    def penColor(self):
        """
        Dialog de sélection de couleur
        """
        color = self.drawPen.color()
        choix = QtGui.QColorDialog.getRgba(color.rgba(), self)
        color.setRgba(choix[0])
        newColor = QtGui.QColor(color.red(), color.green(), color.blue(), color.alpha())
        if newColor.isValid():
            self.drawPen.setColor(newColor)

    def penWidth(self):
        """
        Dialog de sélection d'épaisseur du crayon
        """
        newWidth, ok = QtGui.QInputDialog.getInteger(self, utils.PROGNAME,
                                               self.tr("Select pen width:"),
                                               self.drawPen.width(),
                                               1, 50, 1)
        if ok:
            self.drawPen.setWidth(newWidth)

    def penStyle(self):
        """
        Dialog de sélection de style du crayon
        """
        items = QtCore.QStringList()
        items << self.tr("Solid") << self.tr("Dash") << self.tr("Dot") \
                    << self.tr("Dash Dot") << self.tr("Dash Dot Dot")
    
        reponse, ok = QtGui.QInputDialog.getItem(self, utils.PROGNAME,
                                              self.tr("Select pen style:"), items, 0, False)
        if ok and not reponse.isEmpty():
            #print reponse
            if reponse == self.tr("Solid") :
                newStyle = QtCore.Qt.SolidLine
            elif reponse == self.tr("Dash") :
                newStyle = QtCore.Qt.DashLine
            elif reponse == self.tr("Dot") :
                newStyle = QtCore.Qt.DotLine
            elif reponse == self.tr("Dash Dot") :
                newStyle = QtCore.Qt.DashDotLine
            elif reponse == self.tr("Dash Dot Dot") :
                newStyle = QtCore.Qt.DashDotDotLine
            self.drawPen.setStyle(newStyle)


    def comboBoxPensChanged(self):
        """
        On change de stylo
        """
        indexPen = self.main.toolsWindow.comboBoxPens.currentIndex()
        self.drawPen = self.pens[indexPen]




"""
###########################################################
###########################################################

                DIALOG DE CONFIGURATION

###########################################################
###########################################################
"""

class ConfigurationDlg(QtGui.QDialog):
    """
    La fenêtre de configuration.
    """
    def __init__(self, parent = None):
        super(QtGui.QDialog, self).__init__(parent)
        """
        on récupère main (fenêtre principale)
        On affiche 2 textes d'explications.
        Le reste est délégué dans des sous-procédures
        """
        self.main = parent
        self.setWindowTitle(self.tr("Configuration"))
        
        self.buttonBox = QtGui.QDialogButtonBox(QtGui.QDialogButtonBox.Ok|
                                          QtGui.QDialogButtonBox.Cancel)

        bigEditorScreenMode = QtGui.QTextEdit()
        bigEditorScreenMode.setReadOnly(True)
        bigEditorScreenMode.setText(
            self.tr("<P ALIGN=LEFT><B>FullSpace : </B>"
                    "The application use all the free space on desktop.</P>"
                    "<P></P>"
                    "<P ALIGN=LEFT><B>FullScreen : </B>"
                    "Choose this if you ave problems with FullSpace mode.</P>"
                    "<P></P>"
                    "<P ALIGN=CENTER><B>If you change this, you need to restart application.</B></P>"))

        bigEditorIconSize = QtGui.QTextEdit()
        bigEditorIconSize.setReadOnly(True)
        bigEditorIconSize.setText(
            self.tr("<P></P>"
                    "<P ALIGN=LEFT>Here you can change the size of the toolswindow icons.</P>"))

        layout = QtGui.QGridLayout()
        layout.addWidget(self.createScreenModeGroup(), 0, 0)
        layout.addWidget(bigEditorScreenMode, 0, 1)
        layout.addWidget(self.createIconSizeGroup(), 1, 0)
        layout.addWidget(bigEditorIconSize, 1, 1)
        layout.addWidget(self.buttonBox, 2, 0, 1, 6)
        self.setLayout(layout)

        self.connect(self.buttonBox, QtCore.SIGNAL("accepted()"), self.accept)
        self.connect(self.buttonBox, QtCore.SIGNAL("rejected()"), self.reject)

    def createScreenModeGroup(self):
        """
        Configuration de la variable globale SCREENMODE
        radio2 est en "self" pour pouvoir récupérer son état
        """
        groupBox = QtGui.QGroupBox(self.tr("ScreenMode"))
        radio1 = QtGui.QRadioButton(self.tr("FullSpace"))
        self.radio2 = QtGui.QRadioButton(self.tr("FullScreen"))
        global SCREENMODE
        if SCREENMODE == "FULLSCREEN" : 
            self.radio2.setChecked(True)
        else :
            radio1.setChecked(True)
        vbox = QtGui.QVBoxLayout()
        vbox.addWidget(radio1)
        vbox.addWidget(self.radio2)
        vbox.addStretch(1)
        groupBox.setLayout(vbox)
        return groupBox

    def createIconSizeGroup(self):
        """
        Configuration de la variable iconSize
        integerSpinBox est en "self" pour pouvoir récupérer sa valeur
        """
        groupBox = QtGui.QGroupBox(self.tr("IconSize"))

        integerLabel = QtGui.QLabel(self.tr("Enter a value between %1 and %2:").arg(8).arg(128))
        self.integerSpinBox = QtGui.QSpinBox()
        self.integerSpinBox.setRange(8, 128)
        self.integerSpinBox.setSingleStep(1)
        self.integerSpinBox.setValue(self.main.iconSize.width())

        vbox = QtGui.QVBoxLayout()
        vbox.addWidget(integerLabel)
        vbox.addWidget(self.integerSpinBox)
        vbox.addStretch(1)
        groupBox.setLayout(vbox)
        return groupBox

    def accept(self):
        """
        On met à jour les modifications avnt de fermer
        """
        newSize = self.integerSpinBox.value()
        self.main.iconSize = QtCore.QSize(newSize, newSize)
        global SCREENMODE
        if self.radio2.isChecked() :
            SCREENMODE = "FULLSCREEN"
        else :
            SCREENMODE = "FULLSPACE"
        QtGui.QDialog.accept(self)





"""
###########################################################
###########################################################

                LA FENÊTRE PRINCIPALE

###########################################################
###########################################################
"""

class MainWindow(QtGui.QMainWindow):
    def __init__(self, translator, parent = None):
        QtGui.QMainWindow.__init__(self, parent)
        """
        mise en place de l'interface
        plus des variables utiles
        """
        # Un premier Screenshot avant affichage de la fenêtre
        self.backgroundPixmap = QtGui.QPixmap.grabWindow(QtGui.QApplication.desktop().winId())

        # Pour la fenêtre principale, l'i18n et on lit les "Settings"
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.FramelessWindowHint)
        self.setWindowTitle(utils.PROGNAME)
        self.translator = translator
        self.lang = lang
        #self.readSettings()

        # Pour l'affichage de l'image (QGraphicsScene + GraphicsView)
        self.scene = QtGui.QGraphicsScene(self)
        self.view = GraphicsView(self)
        self.scene.setSceneRect(0, 0, 1, 1)
        self.view.setScene(self.scene)
        self.setCentralWidget(self.view)

        # Les instruments, dans une liste (y compris le faux curseur)
        self.listeInstruments = []
        self.ruler = Ruler(self)
        self.listeInstruments.append(self.ruler)
        self.setSquare = SetSquare(self)
        self.listeInstruments.append(self.setSquare)
        self.protractor = Protractor(self)
        self.listeInstruments.append(self.protractor)
        self.compass = Compass(self)
        self.listeInstruments.append(self.compass)
        self.myCursor = MyCursor(self)
        self.listeInstruments.append(self.myCursor)
        for instrument in self.listeInstruments :
            self.scene.addItem(instrument)
            instrument.setVisible(False)

        self.readSettings()

        # La boîte à outils :
        self.toolsWindow = ToolsWindow(self)
        self.toolsWindow.show()
        self.toolsWindow.setGeometry(self.toolsWindowGeometry)

        self.toolsKidMode = False
        self.toolsKidWindow = None


        # Les actions et la TrayIcon
        self.createActions()
        if WITHTRAYICON :
            self.createTrayIcon()
            self.trayIcon.setIcon(QtGui.QIcon("./images/icon.png"))
            self.trayIcon.show()
            QtCore.QObject.connect(self.trayIcon,
                    QtCore.SIGNAL("activated(QSystemTrayIcon::ActivationReason)"),
                    self.iconActivated)

        # divers
        self.brush = QtGui.QBrush()
        self.drawingMode = "NO"
        self.IsMinimized = False

        # Les chemins et autres
        #self.filesDir = QtCore.QDir.homePath()
        self.filesDir = HERE + "/files"
        self.appFiles = self.tr("pylote Files (*.plt)")
        self.appExtension = "plt"
        self.backgroundsDir = HERE + "/images/backgrounds"
        self.pixmapDir = HERE + "/images"
        self.fileName = QtCore.QString()

        # Délai pour le screenshot. 1000 pour 1 seconde ; suffisant ? trop ?
        self.screenShotDelay = 1000
        QtCore.QTimer.singleShot(1, self.firstScreenShot)
        self.toolsWindow.setFocus()

        # La liste des noms pour les points
        self.listPointNames = QtCore.QString(self.tr("ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

    def resizeEvent(self, event):
        """
        gestion du décalage de l'image à afficher
        et affichage d'icelle
        """
        #print "resizeEvent"
        self.calculDecalage()

        brushmatrix = QtGui.QMatrix()
        brushmatrix.translate(-self.decalX, -self.decalY)
        self.brush.setMatrix(brushmatrix)
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)

        # la suite a l'air nécessaire sous windows pour enlever les bordures :
        if sys.platform == 'win32':
            maskedRegion = QtGui.QRegion(0, 0, self.width(), self.height(), 
                                        QtGui.QRegion.Rectangle)
            self.setMask(maskedRegion)

    def calculDecalage(self):
        """
        Calcul du décalage pour positionner la fenêtre
            et l'image à afficher
        Encore quelques bugs sur certains postes (windows !!!)
        """
        global SCREENMODE
        if SCREENMODE == "TESTS" :
            rect = QtGui.QApplication.desktop().availableGeometry()
            self.decalX = rect.x() + (rect.width() - self.width())/2
            self.decalY = rect.y() + (rect.height() - self.height())/2
            self.move(self.decalX, self.decalY)
            self.decalX = self.decalX + self.width()/2 - self.view.getContentsMargins()[0]/2
            self.decalY = self.decalY + self.height()/2 - self.view.getContentsMargins()[1]/2
        elif SCREENMODE == "FULLSPACE" :
            # Position de la fenêtre en fonction de l'os
            rect = QtGui.QApplication.desktop().availableGeometry()
            if sys.platform == 'win32':
                self.decalX = rect.x()
                self.decalY = rect.y()
                # cas windows géré à part :
                self. moveIfWin()
            else :
                self.decalX = rect.x() + (rect.width() - self.width())/2
                self.decalY = rect.y() + (rect.height() - self.height())/2                
                self.move(self.decalX, self.decalY)
            self.decalX = self.decalX + self.width()/2 - self.view.getContentsMargins()[0]/2
            self.decalY = self.decalY + self.height()/2 - self.view.getContentsMargins()[1]/2
        elif SCREENMODE == "FULLSCREEN" :
            self.decalX = self.width()/2
            self.decalY = self.height()/2

    def moveIfWin(self):
        """
        En mode FULLSPACE, je n'arrive pas à placer correctement la fenêtre sous windows.
        Pour ce système, il vaut mieux utiliser le mode FULLSCREEN.
        Cette procédure est donc à améliorer.
        Sous Linux, ça marche du tonnerre...
        """
        if SCREENMODE == "FULLSPACE" :
            origine = self.mapToGlobal(QtCore.QPoint(0, 0))
            #print origine
            rect = QtGui.QApplication.desktop().availableGeometry()
            """
            #print self.view.getContentsMargins()[0]
            marge = (3 * self.view.getContentsMargins()[0],
                     3 * self.view.getContentsMargins()[1])
            #print marge
            self.move(rect.x() - origine.x() - marge[0],
                      rect.y() - origine.y() - marge[1])
            """
            # pourquoi 4 ?  Ça ne marche forcément pas tout le temps.
            a = 4
            self.move(rect.x() - origine.x() - a,
                      rect.y() - origine.y() - a)

    def doMinimize(self):
        """
        Minimise tout le programme.
        """
        self.doMinimizeToolsWindow()
        self.hide()
        self.IsMinimized = True

    def doMinimizeToolsWindow(self):
        """
        Minimise la ToolsWindow.
        Séparé de la procédure précédente car peut être appelé 
            indépendamment (double-clic par exemple).
        """
        self.toolsWindowGeometry = self.toolsWindow.geometry()
        self.toolsWindow.hide()

    def doRestore(self):
        """
        Restaure tout le programme.
        Gestion du cas windows.
        """
        self.show()
        self.doRestoreToolsWindow()
        self.IsMinimized = False
        if sys.platform == 'win32':
            self.moveIfWin()

    def doRestoreToolsWindow(self):
        self.toolsWindow.show()
        self.toolsWindow.setGeometry(self.toolsWindowGeometry)


    def keyPressEvent(self, event):
        if event.key() == QtCore.Qt.Key_K :
            self.switchKidMode()

    def switchKidMode(self):
        self.toolsKidMode = not self.toolsKidMode
        print self.toolsKidMode
        if self.toolsKidMode :
            self.toolsKidWindow = ToolsKidWindow(self)
            self.toolsKidWindow.show()
            self.doMinimizeToolsWindow()
        else :
            self.doRestoreToolsWindow()
            self.toolsKidWindow.mainRequest = True
            self.toolsKidWindow.close()



    def newScreenshot(self):
        """
        On cache le programme, puis on lance le ScreenShot
        """
        self.doMinimize()
        QtCore.QTimer.singleShot(self.screenShotDelay, self.shootScreen)

    def shootScreen(self):
        """
        On fait le ScreenShot
        Puis on place l'image et on réaffiche
        """
        self.backgroundPixmap = QtGui.QPixmap.grabWindow(QtGui.QApplication.desktop().winId())
        brushmatrix = QtGui.QMatrix()
        brushmatrix.translate(-self.decalX, -self.decalY)
        self.brush.setMatrix(brushmatrix)
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)
        self.doRestore()

    def firstScreenShot(self):
        """
        On place l'image du premier ScreenShot
        On profite de cette procédure lancée juste après l'aparition de la fenêtre
            pour retaurer les dimensions de la toolsWindow
            (ça ne fonctionne pas dans la procédure __init__).
        """
        self.calculDecalage()
        brushmatrix = QtGui.QMatrix()
        brushmatrix.translate(-self.decalX, -self.decalY)
        self.brush.setMatrix(brushmatrix)
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)
        self.toolsWindow.setGeometry(self.toolsWindowGeometry)



    def quit(self):
        self.close()

    def closeEvent(self, event):
        """
        On sauvegarde les Settings en quittant.
        """
        self.writeSettings()

    def readSettings(self):
        """
        On récupère la variable iconSize, ainsi que la position de la fenêtre toolsWindow.
        SCREENMODE a déjà été récupérée (avant la création de la fenêtre main).
        On gère juste le cas du mode TESTS.
        """
        settings = QtCore.QSettings(utils.PROGNAME, "config")
        global SCREENMODE
        if SCREENMODE == "TESTS" :
            size = settings.value("size", QtCore.QVariant(QtCore.QSize(400, 400))).toSize()
            self.resize(size)
        # valeurs par défaut en fonction de la taille de l'écran :
        screen = QtGui.QDesktopWidget().screenGeometry()
        if screen.width() < 1000 :
            taille_icones = 12
        else :
            taille_icones = 24            
        self.iconSize = settings.value("iconSize", 
                                QtCore.QVariant(QtCore.QSize(taille_icones, taille_icones))).toSize()
        self.toolsWindowGeometry = settings.value("toolsWindowGeometry", 
                                QtCore.QVariant(QtCore.QRect(20, 80, 295, 227))).toRect()



        for i in range(5) :
            j = i+1
            a = "%s" % (j)
            a = "pen" + a + "/"
            penWidth = settings.value(a + "Width", QtCore.QVariant(1)).toInt()
            self.view.pens[i].setWidth(penWidth[0])
            try :
                penColor = QtGui.QColor(settings.value(a + "Color"))
                self.view.pens[i].setColor(penColor)
            except :
                self.view.pens[i].setColor(QtGui.QColor())
            penStyle = settings.value(a + "Style", QtCore.QVariant(1)).toInt()
            penStyle = penStyle[0]

            if penStyle == 1 :
                penStyle = QtCore.Qt.SolidLine
            elif penStyle == 2 :
                penStyle = QtCore.Qt.DashLine
            elif penStyle == 3 :
                penStyle = QtCore.Qt.DotLine
            elif penStyle == 4 :
                penStyle = QtCore.Qt.DashDotLine
            elif penStyle == 5 :
                penStyle = QtCore.Qt.DashDotDotLine
            else :
                penStyle = QtCore.Qt.SolidLine
            
            self.view.pens[i].setStyle(penStyle)
        self.view.drawPen = self.view.pens[0]


        font = QtGui.QFont(settings.value("font"))
        fontPointSize = settings.value("fontPointSize", QtCore.QVariant(14)).toInt()
        font.setPointSize(fontPointSize[0])

        self.view.font = font

    def writeSettings(self):
        """
        On sauvegarde les variables SCREENMODE et iconSize.
        Ainsi que la position de la fenêtre toolsWindow.
        """
        settings = QtCore.QSettings(utils.PROGNAME, "config")
        global SCREENMODE
        if SCREENMODE != "TESTS" :
            settings.setValue("SCREENMODE", QtCore.QVariant(SCREENMODE))
        settings.setValue("iconSize", QtCore.QVariant(self.iconSize))
        settings.setValue("toolsWindowGeometry", QtCore.QVariant(self.toolsWindow.geometry()))
        
        for i in range(5) :
            j = i+1
            a = "%s" % (j)
            a = "pen" + a + "/"
            settings.setValue(a + "Width", QtCore.QVariant(self.view.pens[i].width()))
            settings.setValue(a + "Color", QtCore.QVariant(self.view.pens[i].color()))
            settings.setValue(a + "Style", QtCore.QVariant(self.view.pens[i].style()))


        settings.setValue("font", QtCore.QVariant(self.view.font))
        settings.setValue("fontPointSize", QtCore.QVariant(self.view.font.pointSize()))




    def configure(self):
        """
        Appel de la fenêtre de configuration du programme.
        """
        dialog = ConfigurationDlg(parent = self)
        if dialog.exec_() == QtGui.QDialog.Accepted :
            self.toolsWindow.reloadToolBars()



    def createActions(self):
        """
        Ces actions sont là car elles sont disponibles depuis la trayicon
        """
        self.actionQuit = QtGui.QAction(self.toolsWindow.tr("Exit"), self)
        self.actionQuit.setShortcut(self.tr("Ctrl+Q"))
        self.actionQuit.setIcon(QtGui.QIcon("images/application-exit.png"))
        self.connect(self.actionQuit, QtCore.SIGNAL("triggered()"), self.quit)

        self.actionHelp = QtGui.QAction(self.toolsWindow.tr("Help"), self)
        self.actionHelp.setShortcut(self.tr("F1"))
        self.actionHelp.setIcon(QtGui.QIcon("images/help.png"))
        self.connect(self.actionHelp, QtCore.SIGNAL("triggered()"), self.help)

        self.actionAbout = QtGui.QAction(self.toolsWindow.tr("About"), self)
        self.actionAbout.setIcon(QtGui.QIcon("images/help-about.png"))
        self.connect(self.actionAbout, QtCore.SIGNAL("triggered()"), self.about)

        self.actionAboutQt = QtGui.QAction(self.toolsWindow.tr("About Qt"), self)
        self.actionAboutQt.setIcon(QtGui.QIcon("images/qt-logo.png"))
        self.connect(self.actionAboutQt, QtCore.SIGNAL("triggered()"), QtGui.qApp, QtCore.SLOT("aboutQt()"))
        
        self.actionNewScreenshot = QtGui.QAction(self.toolsWindow.tr("newScreenshot"), self)
        self.actionNewScreenshot.setIcon(QtGui.QIcon("images/camera-photo.png"))
        QtCore.QObject.connect(self.actionNewScreenshot,
                QtCore.SIGNAL("triggered()"), self.newScreenshot)

        self.minimizeAction = QtGui.QAction(self.toolsWindow.tr("Minimize"), self)
        QtCore.QObject.connect(self.minimizeAction,
                QtCore.SIGNAL("triggered()"), self.doMinimize)

        self.restoreAction = QtGui.QAction(self.tr("Restore"), self)
        QtCore.QObject.connect(self.restoreAction,
                QtCore.SIGNAL("triggered()"), self.doRestore)



    def createTrayIcon(self):
        """
        Création de la trayicon et de son menu (obtenu par clic droit).
        """
        self.trayIconMenu = QtGui.QMenu(self)
        
        self.trayIconMenu.addAction(self.actionHelp)
        self.trayIconMenu.addAction(self.actionAbout)
        self.trayIconMenu.addAction(self.actionAboutQt)
        self.trayIconMenu.addSeparator()

        self.trayIconMenu.addAction(self.actionNewScreenshot)
        self.trayIconMenu.addSeparator()
        self.trayIconMenu.addAction(self.minimizeAction)
        self.trayIconMenu.addAction(self.restoreAction)
        self.trayIconMenu.addSeparator()
        self.trayIconMenu.addAction(self.actionQuit)

        self.trayIcon = QtGui.QSystemTrayIcon(self)
        self.trayIcon.setContextMenu(self.trayIconMenu)

    def iconActivated(self, reason):
        """
        Séparation entre clic et double-clic (grâce à la variable iconDoubleClick).
        Un double-clic relance le screenshot.
        Le simple clic est géré après.
        """
        self.iconDoubleClick = False
        if reason == QtGui.QSystemTrayIcon.DoubleClick:
            self.iconDoubleClick = True
            self.newScreenshot()
        elif reason == QtGui.QSystemTrayIcon.Trigger:
            QtCore.QTimer.singleShot(500, self.iconClick)

    def iconClick(self):
        """
        Si on a bien à faire à un simple clic,
            on minimise ou restaure l'application.
        """
        if self.iconDoubleClick == False :
            if self.IsMinimized :
                self.doRestore()
            else :
                self.doMinimize()



    def doInstrumentLeftButtonMode(self, newMode):
        """
        On modifie l'effet du bouton gauche (mode TBI)
        """
        for instrument in self.listeInstruments :
            instrument.doLeftButtonMode(newMode)

    def isDrawingEnabled(self):
        """
        Teste si on est autorisé à dessiner.
        Par exemple, si on déplace un instrument, la réponse est NON.
        """
        reponse = True
        for instrument in self.listeInstruments :
            if instrument.isUsed :
                reponse = False
        if self.toolsWindow.actionSelect.isChecked() :
            reponse = False
        return reponse

    def eraseAll(self):
        """
        Efface tous les items.
        """
        for item in self.scene.items() :
            if not(item in self.listeInstruments) :
                if item.parentItem() == None :
                    self.scene.removeItem(item)
                    del item

    def removeLast(self):
        """
        Efface le dernier item.
        """
        draws = []
        for item in self.scene.items() :
            if not(item in self.listeInstruments) :
                if item.parentItem() == None :
                    draws.append(item)
        NbItems = len(draws)
        if NbItems > 0 :
            item = draws[NbItems - 1]
            self.scene.removeItem(item)
            del item

    def removeSelected(self):
        """
        Supprime l'item sélectionné, après demande de confirmation.
        """
        items = self.scene.selectedItems()
        if len(items) :
            item = items[0]
            if not(item in self.listeInstruments) :
                if item.parentItem() == None and QtGui.QMessageBox.question(self, utils.PROGNAME,
                            self.tr("Delete this item ?"),
                            QtGui.QMessageBox.Yes|QtGui.QMessageBox.No) == QtGui.QMessageBox.Yes:
                    self.scene.removeItem(item)
                    del item

    def editText(self):
        """
        Édition d'un texte ou du nom d'un point.
        """
        Reponse = False
        items = self.scene.selectedItems()
        if len(items) :
            item = items[0]
            if isinstance(item, QtGui.QGraphicsTextItem):
                Reponse = True
                if item.parentItem() == None :
                    initialText = item.toPlainText()
                    dialog = TextItemDlg(parent = self.view, graphicsTextItem = item)
                    if dialog.exec_() != QtGui.QDialog.Accepted :
                        item.setPlainText(initialText)
                else :
                    initialText = item.toPlainText()
                    text, ok = QtGui.QInputDialog.getText(self, utils.PROGNAME,
                                                        self.tr("Point Name:"), 
                                                        QtGui.QLineEdit.Normal,
                                                        initialText)
                    if ok and not text.isEmpty():
                        item.setPlainText(text)
        return Reponse

    def whitePage(self):
        """
        Affiche une page blanche
        """
        self.backgroundPixmap = QtGui.QPixmap()
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)

    def pointsPage(self):
        """
        Affiche une page de type papier pointé
        """
        image = QtGui.QImage("images/backgrounds/dots.png")
        self.backgroundPixmap = QtGui.QPixmap.fromImage(image)
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)

    def gridPage(self):
        """
        Affiche une grille
        """
        image = QtGui.QImage("images/backgrounds/grid.png")
        self.backgroundPixmap = QtGui.QPixmap.fromImage(image)
        self.brush.setTexture(self.backgroundPixmap)
        self.scene.setBackgroundBrush(self.brush)

    def chooseBackGround(self):
        """
        On sélectionne une image de fond
        """
        fileName = QtGui.QFileDialog.getOpenFileName(self, self.tr("Open Image"),
                                                     self.backgroundsDir, 
                                                     self.tr("Image Files (*.png *.jpg *.jpeg)"))
        if not fileName.isEmpty():
            self.backgroundsDir = QtCore.QFileInfo(fileName).absolutePath()
            image = QtGui.QImage(fileName)
            self.backgroundPixmap = QtGui.QPixmap.fromImage(image)
            brushmatrix = QtGui.QMatrix()
            brushmatrix.translate(-self.decalX, -self.decalY)
            self.brush.setMatrix(brushmatrix)
            self.brush.setTexture(self.backgroundPixmap)
            self.scene.setBackgroundBrush(self.brush)



    def fileSave(self):
        """
        Pas mis en place ; renvoie donc à fileSaveAs.
        """
        self.fileSaveAs()

    def fileSaveAs(self):
        """
        Enregistrement d'un fichier.
        On sauve le titre du programme en entête, 
            le fond et les items (sauf les instruments).
        """
        fileName = QtGui.QFileDialog.getSaveFileName(self, 
                                        self.tr("Save File"),
                                        self.filesDir, 
                                        self.appFiles)
        if not(fileName.isEmpty()):
            self.filesDir = QtCore.QFileInfo(fileName).absolutePath()
            fileName = self.VerifieExtension(fileName, self.appExtension)
            fh = None
            try:
                fh = QtCore.QFile(fileName)
                if not fh.open(QtCore.QIODevice.WriteOnly):
                    raise IOError, unicode(fh.errorString())
                stream = QtCore.QDataStream(fh)
                stream.setVersion(QtCore.QDataStream.Qt_4_2)
                stream << QtCore.QString(utils.PROGNAME)
                stream << self.brush
                for item in self.scene.items() :
                    if not(item in self.listeInstruments) :
                        if item.parentItem() == None :
                            self.writeItemToStream(stream, item)
            except IOError, e:
                QtGui.QMessageBox.warning(self, utils.PROGNAME,
                        self.tr("Failed to save %1: %2").arg(fileName).arg(str(e)))
            finally:
                if fh is not None:
                    fh.close()

    def VerifieExtension(self, FileName, Extension):
        """
        Pour ajouter l'extension au nom du fichier si besoin
        """
        r = FileName.split('.')[0] + '.' + Extension
        return r

    def writeItemToStream(self, stream, item):
        """
        Pour chaque item, on enregistre son type (Point, ...) 
            puis les attributs utiles
        """
        if isinstance(item, PointItem):
            stream << QtCore.QString("Point") << item.pos() << item.matrix() \
                   << item.pen() << item.brush() << item.font << item.text << item.textItem.pos()
        elif isinstance(item, QtGui.QGraphicsTextItem):
            stream << QtCore.QString("Text") << item.pos() << item.matrix() \
                    << item.font()  << item.defaultTextColor() << item.toPlainText()
        elif isinstance(item, QtGui.QGraphicsPixmapItem):
            stream << QtCore.QString("Pixmap") << item.pos() << item.matrix() \
                   << item.pixmap()
        elif isinstance(item, QtGui.QGraphicsPathItem):
            stream << QtCore.QString("Path") << item.pos() << item.matrix() \
                   << item.pen() << item.path()
        elif isinstance(item, QtGui.QGraphicsLineItem):
            stream << QtCore.QString("Line") << item.pos() << item.matrix() \
                    << item.pen() << item.line()

    def fileOpen(self):
        """
        Ouverture d'un fichier.
        On sélectionne puis on délègue à la fonction "fileReload".
        """
        fileName = QtGui.QFileDialog.getOpenFileName(self,
                                        self.tr("Open File"),
                                        self.filesDir,
                                        self.appFiles)
        if not fileName.isEmpty():
            self.fileName = fileName
            self.fileReload()

    def fileReload(self):
        """
        Réouverture du fichier. On commence par effacer tout.
        On vérifie l'entête, puis on récupère le fond et les items.
        """
        fileName = self.fileName
        if not fileName.isEmpty():
            self.filesDir = QtCore.QFileInfo(fileName).absolutePath()
            fh = None
            try:
                fh = QtCore.QFile(fileName)
                if not fh.open(QtCore.QIODevice.ReadOnly):
                    raise IOError, unicode(fh.errorString())
                self.eraseAll()
                stream = QtCore.QDataStream(fh)
                stream.setVersion(QtCore.QDataStream.Qt_4_2)
                
                progName = QtCore.QString()
                stream >> progName
                if progName != utils.PROGNAME :
                    raise IOError, self.tr("not a valid file")

                self.readBackgroundFromStream(stream)
                while not fh.atEnd():
                    self.readItemFromStream(stream)
            except IOError, e:
                QtGui.QMessageBox.warning(self, utils.PROGNAME,
                        self.tr("Failed to open %1: %2").arg(fileName).arg(str(e)))
            finally:
                if fh is not None:
                    fh.close()
        else :
            self.eraseAll()
        if self.toolsWindow.actionSelect.isChecked() :
            self.toolsWindow.select()

    def fileGoNext(self):
        """
        Réouverture du fichier. On commence par effacer tout.
        On vérifie l'entête, puis on récupère le fond et les items.
        """
        if not self.fileName.isEmpty():
            listFiles = QtCore.QStringList()
            dirIterator = QtCore.QDirIterator(self.filesDir, 
                                            QtCore.QStringList("*.plt"), 
                                            QtCore.QDir.Files, 
                                            QtCore.QDirIterator.Subdirectories)
            while dirIterator.hasNext():
                listFiles.append(dirIterator.next())
            i = listFiles.indexOf(self.fileName)
            if i < len(listFiles)-1 :
                self.fileName = listFiles[i+1]
            else :
                self.fileName = listFiles[0]            
            self.fileReload()
            





    def readBackgroundFromStream(self, stream):
        """
        On applique le fond du fichier
        """
        stream >> self.brush
        brushmatrix = QtGui.QMatrix()
        brushmatrix.translate(-self.decalX, -self.decalY)
        self.brush.setMatrix(brushmatrix)
        self.scene.setBackgroundBrush(self.brush)

    def readItemFromStream(self, stream):
        """
        Récupération des items et création
        """
        type = QtCore.QString()
        position = QtCore.QPointF()
        matrix = QtGui.QMatrix()
        stream >> type >> position >> matrix
        if type == "Point":
            #print "Point"
            pen = QtGui.QPen()
            brush = QtGui.QBrush()
            font = QtGui.QFont()
            text = QtCore.QString()
            textPos = QtCore.QPointF()
            stream >> pen >> brush >> font >> text >> textPos
            pointItem = PointItem(self, pen, brush, font, text)
            pointItem.textItem.setPos(textPos)
            self.scene.addItem(pointItem)
            pointItem.setPos(position)
        elif type == "Text":
            #print "Text"
            font = QtGui.QFont()
            color = QtGui.QColor()
            text = QtCore.QString()
            stream >> font >> color >> text
            textItem = QtGui.QGraphicsTextItem()
            textItem.setPlainText(text)
            textItem.setFont(font)
            self.scene.addItem(textItem)
            textItem.setDefaultTextColor(color)
            textItem.setPos(position)
        elif type == "Pixmap":
            #print "Pixmap"
            pixmap = QtGui.QPixmap()
            stream >> pixmap
            pixmapItem = QtGui.QGraphicsPixmapItem(pixmap)
            self.scene.addItem(pixmapItem)
            pixmapItem.setPos(position)
        elif type == "Path":
            #print "Path"
            pen = QtGui.QPen()
            brush = QtGui.QBrush(QtCore.Qt.green, QtCore.Qt.NoBrush)
            path = QtGui.QPainterPath()
            stream >> pen >> path
            self.scene.addPath(path, pen, brush)
        elif type == "Line":
            #print "Line"
            pen = QtGui.QPen()
            line = QtCore.QLineF()
            stream >> pen >> line
            self.scene.addLine(line, pen)



    def about(self):
        #Affiche la fenetre AboutDlg
        aboutdialog = utils.AboutDlg(self, self.lang, icon = "./images/icon.png")
        aboutdialog.exec_()

    def help(self):
        #Ouvre le fichier html dans le navigateur.
        utils.help_in_browser(self.lang, "index")

    def video_demo(self):
        #Lance la vidéo avec le logiciel associé
        utils.video_demo("help/pylote_demo.ogv")






"""
###########################################################
###########################################################

                LANCEMENT DU PROGRAMME

###########################################################
###########################################################
"""

if __name__ == "__main__":
    app = QtGui.QApplication(sys.argv)
    
    ###########################################
    # Installation de l'internationalisation :
    ###########################################
    locale = QtCore.QLocale.system().name()
    lang = locale.split('_')[0]
    #pour faire des tests :
    #locale, lang = "", ""
    QtTranslationsPath = QtCore.QLibraryInfo.location(QtCore.QLibraryInfo.TranslationsPath)
    qtTranslator = QtCore.QTranslator()
    if qtTranslator.load("qt_" + locale, QtTranslationsPath):
        app.installTranslator(qtTranslator)
    trans_dir = QtCore.QDir("./translations")
    localefile = trans_dir.filePath("pylote_" + locale)
    appTranslator = QtCore.QTranslator()
    if appTranslator.load(localefile, ""):
        app.installTranslator(appTranslator)
    
    
    app.setWindowIcon(QtGui.QIcon("./images/icon.png"))
    
    ##################################################
    # Définition de SCREENMODE et de WITHTRAYICON :
    ##################################################
    # on peut passser SCREENMODE en argument (utile pour TESTS)
    if len(sys.argv) > 1 :
        SCREENMODE = sys.argv[1]
        print SCREENMODE
    # valeur par défaut suivant l'os :
    if SCREENMODE != "TESTS" :
        settings = QtCore.QSettings(utils.PROGNAME, "config")
        if sys.platform == 'win32':
            SCREENMODE = settings.value("SCREENMODE", QtCore.QVariant("FULLSCREEN")).toString()
        else :
            SCREENMODE = settings.value("SCREENMODE", QtCore.QVariant("FULLSPACE")).toString()
    # pas de TrayIcon si le système ne le supporte pas :
    if not QtGui.QSystemTrayIcon.isSystemTrayAvailable():
        WITHTRAYICON = False
    # pas besoin de TrayIcon en mode FULLSCREEN :
    if SCREENMODE == "FULLSCREEN" :
        WITHTRAYICON = False

    ##################################################
    # Création et lancement du programme :
    ##################################################
    mainWindow = MainWindow(appTranslator)
    # en fonction de SCREENMODE :
    if SCREENMODE == "TESTS" :
        mainWindow.show()
    elif SCREENMODE == "FULLSPACE" :
        rect = QtGui.QApplication.desktop().availableGeometry()
        mainWindow.resize(int(rect.width()), int(rect.height()))
        mainWindow.showMaximized()
    elif SCREENMODE == "FULLSCREEN" :
        mainWindow.showFullScreen()
    else :
        mainWindow.showFullScreen()
        

    sys.exit(app.exec_())


