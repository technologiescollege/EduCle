VERSION 4.00
Begin VB.Form GRAPH 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Graphique d'évolution"
   ClientHeight    =   6390
   ClientLeft      =   8940
   ClientTop       =   7155
   ClientWidth     =   9480
   Height          =   6900
   Left            =   8880
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6390
   ScaleWidth      =   9480
   Top             =   6705
   Width           =   9600
   Begin VB.CommandButton OK 
      Caption         =   "OK"
      Height          =   480
      Left            =   4440
      TabIndex        =   0
      Top             =   5760
      Width           =   996
   End
End
Attribute VB_Name = "GRAPH"
Attribute VB_Creatable = False
Attribute VB_Exposed = False

Private Sub Form_Load()
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
    
    Dim nomfic As String
    Dim numfic, nbpt As Integer
    Dim tabpt() As Byte
    numfic = FreeFile()
    nomfic = CurDir$ & "\graph.jcc"
'lecture des points
    Open nomfic For Binary As numfic
    nbpt = LOF(numfic) \ 4
    ReDim tabpt(0 To nbpt - 1, 0 To 3)
    For i = 0 To nbpt - 1
        For j = 0 To 3
            Get numfic, 4 * i + j + 1, tabpt(i, j)
        Next j
    Next i
    Close numfic
    
' GRAPHIQUE
    Cls
    Dim margex, margey As Byte
    Dim decalage, unitex As Integer
    margex = 25
    margey = 25
    unitex = Fix(300 / (nbpt - 1)) 'calcule l'unité des x en fonction du nombre de données
    ForeColor = vbBlack
    FontBold = True
    Scale (0, 160)-(335, 0) ' 30 points espacés de 10 + marge de 35 = 335
    CurrentX = 1
    CurrentY = 20
    Print "pourcentage de bonnes réponses"
    CurrentY = 130 + margey
    CurrentX = 95
    Print "évolution sur les"; nbpt; "derniers exercices"
        ' dessine les graduations
    Line (23, margey)-(23, 100 + margey)
    Line (23, margey - 1)-(330, margey - 1)
    For i = 0 To 100 Step 10
        Line (22, i + margey)-(24, i + margey), vbBlack
        CurrentX = 0
        CurrentY = CurrentY + 3
        Print i; " %"
    Next i
        'trace des 4 courbes l'une aprés l'autre
    Dim couleur, k As Integer ' nbpts sert a compter le nb reel de pts a afficher car il peut varier (forme aleatoire)
    Dim texte As String
    For j = 0 To 3
        decalage = j / 1.5 'pour decaler les courbes afin qu'elles ne soient pas confondues
            'affiche la legende
        couleur = Choose(j + 1, RGB(233, 140, 44), vbRed, vbBlue, RGB(0, 146, 64)) 'choisi la couleur en fonction de j
        ForeColor = couleur 'couleur du texte et graphique
        FillColor = couleur ' couleur de remplissage
        FillStyle = 0 'remplissage plein
        CurrentX = j * 70 + margex
        CurrentY = 115 + margey
        texte = Choose(j + 1, "Français", "Infinitif", "Prétérit", "Participe passé")
        Print texte
    '    nbpts = 0
            ' on detecte le cas dans lequel on se trouve : 0pt, 1 pt, +ieurs pts à tracer
'        For i = 0 To nbpt - 1
'            If tabpt(i, j) <> 255 Then
'                nbpts = nbpts + 1
'            End If
'        Next i
 '       Select Case nbpts
 '           Case 0  ' 0 pt a afficher
 '           Case 1  ' 1 pt a afficher
 '               For i = 0 To nbpt - 1
 '                   If tabpt(i, j) <> 255 Then ' on a trouvé le pt
 '                       Circle (unitex * i + margex + decalage, tabpt(i, j) + margey + decalage), 0.5
 '                       Exit For 'on sort du for...next car on a trouvé le pt
 '                   End If
 '               Next i
  '          Case Else 'dans les autres cas, c-a-d, +ieurs pts a afficher
                For i = 0 To nbpt - 1
                    If tabpt(i, j) <> 255 Then ' on a trouvé un pt
                        Circle (unitex * i + margex + decalage, tabpt(i, j) + margey + decalage), 1
                        For k = i To nbpt - 1 'on cherche les autres pts
                            If tabpt(k, j) <> 255 Then 'quand on en trouve 1
                                Line -(unitex * k + margex + decalage, tabpt(k, j) + margey + decalage), couleur 'on le relie au pt precedent
                                Circle (unitex * k + margex + decalage, tabpt(k, j) + margey + decalage), 1
                            End If
                        Next k
                        Exit For ' on sort car on a traité tous les pts
                    End If
                Next i
   '     End Select
    Next j
End Sub


Private Sub OK_Click()
    Unload GRAPH
End Sub


