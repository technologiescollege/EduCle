VERSION 4.00
Begin VB.Form fliste 
   BackColor       =   &H00C0C0C0&
   Caption         =   "Liste des verbes"
   ClientHeight    =   4215
   ClientLeft      =   11985
   ClientTop       =   8040
   ClientWidth     =   7020
   Height          =   4725
   Left            =   11925
   LinkTopic       =   "Form2"
   ScaleHeight     =   4215
   ScaleWidth      =   7020
   Top             =   7590
   Width           =   7140
   Begin VB.CommandButton implist 
      Caption         =   "Imprimer la liste"
      Height          =   492
      Left            =   3960
      TabIndex        =   3
      Top             =   3480
      Width           =   1692
   End
   Begin VB.CommandButton ok_res 
      Caption         =   "OK"
      Height          =   492
      Left            =   1800
      TabIndex        =   2
      Top             =   3480
      Width           =   1092
   End
   Begin VB.Label teteliste 
      BackColor       =   &H00C0C0C0&
      Caption         =   "infinitif anglais     prétérit               participe passé    infinitif français"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   360
      TabIndex        =   1
      Top             =   120
      Width           =   6372
   End
   Begin MSGrid.Grid liste 
      Height          =   2940
      Left            =   360
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   360
      Width           =   6264
      _Version        =   65536
      _ExtentX        =   11049
      _ExtentY        =   5186
      _StockProps     =   77
      BackColor       =   16777215
      BorderStyle     =   0
      Rows            =   1
      Cols            =   4
      FixedRows       =   0
      FixedCols       =   0
      ScrollBars      =   2
      HighLight       =   0   'False
   End
End
Attribute VB_Name = "fliste"
Attribute VB_Creatable = False
Attribute VB_Exposed = False

Private Sub Form_Load()

'cadrage de l'ecran liste en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2

'affichage de la liste de verbes
        For i = 0 To 3
            liste.ColWidth(i) = 1500
        Next i
        ' on remplit la liste AZ
        For i = 1 To 135
            txt = v(i, 1) & Chr(9) & v(i, 2) & Chr(9) & v(i, 3) & Chr(9) & v(i, 0)
            liste.AddItem txt, i
        Next i
End Sub


Private Sub implist_Click()
Dim n As Integer

    If Not ver_enr Then ' si la version n'est pas enregistree
        n = 10
        Printer.Font.bold = True
        Printer.Print
        Printer.Print "VERSION NON ENREGISTREE :"
        Printer.Print "SEULEMENT 10 VERBES SERONT IMPRIMES"
        Printer.Print
        Printer.Print "AVEC LA VERSION ENREGISTREE, LA TOTALITE"
        Printer.Print "DES VERBES (135 VERBES) SERA IMPRIMEE"
        Printer.Font.bold = False
    Else
        n = 135
    End If


    ' a enlever : qualite brouillon
    Printer.PrintQuality = -1

    Printer.Font.Name = "courrier"
    Printer.Font.size = 12
    Printer.PaperSize = vbPRPSA4    ' format A4
    Printer.Orientation = vbPRORPortrait
    Printer.Print   ' saute une ligne
    Printer.Font.underline = True   'titre en-tête souligné
    Printer.Print Tab(5); "Infinitif"; Tab(20); "Prétérit"; Tab(35); "P. passé"; Tab(51); "Français"
    Printer.Print
    Printer.Font.underline = False
    nbp = 1
    For i = 1 To n
        Printer.Print Tab(5); v(i, 1); Tab(20); v(i, 2); Tab(35); v(i, 3); Tab(51); v(i, 0)
        nbp = nbp + 1
        If nbp = 50 Then 'on change de page et on réimprime l'en-tête
            Printer.NewPage
            Printer.Print
            Printer.Font.underline = True
            Printer.Print Tab(5); "Infinitif"; Tab(20); "Prétérit"; Tab(35); "P. passé"; Tab(51); "Français"
            Printer.Print
            Printer.Font.underline = False
            nbp = 1
        End If
    Next i
    Printer.EndDoc ' on envoie l'impression
    ok_res.SetFocus ' on redonne la main au bouton OK
End Sub

Private Sub ok_res_Click()
    Unload fliste
End Sub


