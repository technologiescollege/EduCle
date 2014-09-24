VERSION 4.00
Begin VB.Form fparam 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "paramétres"
   ClientHeight    =   4350
   ClientLeft      =   6495
   ClientTop       =   4125
   ClientWidth     =   7290
   ControlBox      =   0   'False
   FillColor       =   &H00C0C0C0&
   ForeColor       =   &H00C0C0C0&
   Height          =   4860
   Left            =   6435
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4350
   ScaleWidth      =   7290
   Top             =   3675
   Visible         =   0   'False
   Width           =   7410
   Begin VB.Frame interv 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Verbes"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Times New Roman"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   2292
      Left            =   3240
      TabIndex        =   9
      Top             =   240
      Width           =   3852
      Begin VB.TextBox fing 
         Enabled         =   0   'False
         Height          =   288
         Left            =   2640
         MaxLength       =   1
         TabIndex        =   13
         Top             =   1404
         Width           =   252
      End
      Begin VB.TextBox debutg 
         Enabled         =   0   'False
         Height          =   288
         Left            =   1320
         MaxLength       =   1
         TabIndex        =   12
         Top             =   1404
         Width           =   252
      End
      Begin VB.OptionButton interv_op 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Un groupe de verbes"
         Height          =   492
         Index           =   1
         Left            =   360
         TabIndex        =   11
         Top             =   720
         Width           =   1932
      End
      Begin VB.OptionButton interv_op 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Tous les verbes"
         Height          =   492
         Index           =   0
         Left            =   360
         TabIndex        =   10
         Top             =   360
         Width           =   1932
      End
      Begin VB.Label texteg 
         BackColor       =   &H00C0C0C0&
         Caption         =   "à la lettre"
         Enabled         =   0   'False
         Height          =   252
         Index           =   2
         Left            =   1800
         TabIndex        =   16
         Top             =   1440
         Width           =   852
      End
      Begin VB.Label texteg 
         BackColor       =   &H00C0C0C0&
         Caption         =   "De la lettre"
         Enabled         =   0   'False
         Height          =   252
         Index           =   1
         Left            =   360
         TabIndex        =   15
         Top             =   1440
         Width           =   852
      End
      Begin VB.Label texteg 
         BackColor       =   &H00C0C0C0&
         Enabled         =   0   'False
         Height          =   252
         Index           =   0
         Left            =   360
         TabIndex        =   14
         Top             =   1800
         Width           =   3372
      End
   End
   Begin VB.CommandButton OK_param 
      Caption         =   "OK"
      Height          =   372
      Left            =   3000
      TabIndex        =   1
      Top             =   3840
      Width           =   1332
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Nombre de verbes choisit pour l'exercice"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Times New Roman"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   1092
      Left            =   1560
      TabIndex        =   6
      Top             =   2640
      Width           =   3972
      Begin VB.CommandButton down_btn 
         Caption         =   "<--"
         Height          =   372
         Left            =   840
         TabIndex        =   18
         Top             =   480
         Width           =   612
      End
      Begin VB.CommandButton up_btn 
         Caption         =   "-->"
         Height          =   372
         Left            =   2640
         TabIndex        =   17
         Top             =   480
         Width           =   612
      End
      Begin VB.TextBox saisie_nb 
         Alignment       =   1  'Right Justify
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   1800
         MaxLength       =   3
         TabIndex        =   8
         Top             =   480
         Width           =   492
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Interrogation"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Times New Roman"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   2292
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2892
      Begin VB.OptionButton Option1 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Aléatoire"
         Height          =   372
         Index           =   4
         Left            =   120
         TabIndex        =   7
         Top             =   1800
         Width           =   1932
      End
      Begin VB.OptionButton Option1 
         BackColor       =   &H00C0C0C0&
         Caption         =   "à partir du participe passé"
         Height          =   372
         Index           =   3
         Left            =   120
         TabIndex        =   5
         Top             =   1440
         Width           =   2292
      End
      Begin VB.OptionButton Option1 
         BackColor       =   &H00C0C0C0&
         Caption         =   "à partir du prétérit"
         Height          =   372
         Index           =   2
         Left            =   120
         TabIndex        =   4
         Top             =   1080
         Width           =   1932
      End
      Begin VB.OptionButton Option1 
         BackColor       =   &H00C0C0C0&
         Caption         =   "à partir de l'infinitif anglais"
         Height          =   372
         Index           =   1
         Left            =   120
         TabIndex        =   3
         Top             =   720
         Width           =   2412
      End
      Begin VB.OptionButton Option1 
         BackColor       =   &H00C0C0C0&
         Caption         =   "à partir du français"
         Height          =   372
         Index           =   0
         Left            =   120
         TabIndex        =   2
         Top             =   360
         Width           =   1932
      End
   End
End
Attribute VB_Name = "fparam"
Attribute VB_Creatable = False
Attribute VB_Exposed = False

Sub calcul_intervalle()
Dim dd, ff As Integer
    If debutg.Text = "" Then
        MsgBox "Vous devez indiquer le debut de l'intervalle"
        fing.Text = ""
    ElseIf debutg.Text > fing.Text Then
        MsgBox "La fin de l'intervalle doit être supérieure ou égale au début"
        fing.Text = ""
        debutg.Text = ""
        debutg.SetFocus
    Else
        'calcul de l'intervalle
        debut_interv = Asc(debutg.Text) - 64
        fin_interv = Asc(fing.Text) - 64
        If intervalle(debut_interv, 1) = -1 Then
'lettre non existante : on recherche la prochaine existante
            dd = debut_interv + 1
            While intervalle(dd, 1) = -1 And dd < fin_interv
                dd = dd + 1
                MsgBox "dd= " & dd
            Wend
            debut_interv = dd
        End If
        If intervalle(fin_interv, 2) = -1 Then
'lettre non existante : on recherche la precedente existante
            ff = fin_interv - 1
            While intervalle(ff, 2) = -1 And ff > dd_interv
                ff = ff - 1
            Wend
            fin_interv = ff
        End If
        If intervalle(debut_interv, 1) = -1 Then
'intervalle nul
            MsgBox "Il n'y a aucun verbes dans l'intervalle choisi"
            texteg(0).Caption = "Cet intervalle ne comprend aucun verbe"
            debutg.SetFocus
        Else
'intervalle existant
            maxv = intervalle(fin_interv, 2) - intervalle(debut_interv, 1) + 1
            texteg(0).Caption = "Cet intervalle comprend " & maxv
            If maxv = 1 Then
                texteg(0) = texteg(0) & " verbe"
            Else
                texteg(0) = texteg(0) & " verbes"
            End If
            'saisie_nb.SetFocus ' pour choisir un nb correct
        End If
    End If
End Sub

Private Sub debutg_KeyUp(KeyCode As Integer, Shift As Integer)
    debutg.Text = UCase(debutg.Text) 'passage en majuscules
    If Len(debutg.Text) = 1 Then
        fing.SetFocus ' donne la main a fing
    End If
End Sub

Private Sub debutg_LostFocus()
    If debutg.Text <> "" Then
        If Asc(debutg.Text) < 65 Or Asc(debutg.Text) > 90 Then
            MsgBox "Veuillez entrer une lettre pour le début de l'intervalle"
        ElseIf fing.Text = "" Then ' si la fin de l'intervalle est vide...
            fing.SetFocus ' ...on lui donne la main
        Else
            calcul_intervalle
        End If
    End If
End Sub


Private Sub down_btn_Click()
    If saisie_nb > 1 Then
        saisie_nb = saisie_nb - 1
        nbvex = saisie_nb
    End If
End Sub


Private Sub fing_KeyUp(KeyCode As Integer, Shift As Integer)
    fing.Text = UCase(fing.Text) 'passage en majuscules
    If Len(fing.Text) = 1 Then
        OK_param.SetFocus 'force le lostfocus de fing
    End If
End Sub


Private Sub fing_LostFocus()
    If fing.Text <> "" Then
        If Asc(fing.Text) < 65 Or Asc(fing.Text) > 90 Then
            MsgBox "Veuillez entrer une lettre pour le début de l'intervalle"
        ElseIf debutg.Text = "" Then ' si le debut de l'intervalle est vide...
            debutg.SetFocus ' ...on lui donne la main
        Else
            calcul_intervalle
            If saisie_nb > maxv Then
                saisie_nb = maxv
                nbvex = maxv
            End If
        End If
    End If
End Sub


Private Sub Form_Load()
    'cadrage de l'ecran parametres en fonction de la resolution ecran
    Left = (l - Width) / 2
    Top = (h - Height) / 2
    
'    If ver_enr Then ' si la version est enregistree
'        interv.Enabled = True
'        Frame2.Enabled = True
'        saisie_nb.Enabled = True
'        interv_op(0).Enabled = True
'        interv_op(1).Enabled = True
'    Else
'        interv.Enabled = False
'        Frame2.Enabled = False
'        saisie_nb.Enabled = False
'        interv_op(0).Enabled = False
'        interv_op(1).Enabled = False
'    End If

    
    Option1(fs).Value = True 'coche la forme choisie
    
    saisie_nb.Text = nbvex ' affiche le nb de verbes choisi
    
    'cadre intervalle
    If ts_verbes Then
        'option toutes les lettres choisie
        interv_op(0).Value = True
    Else
        ' option intervalle choisi
        interv_op(1).Value = True
        'on va remplir les cadres lettres de debut et lettre de fin
        debutg.Text = Chr$(debut_interv + 64) 'affiche la lettre de debut en majuscule (+64)
        fing.Text = Chr$(fin_interv + 64) 'affiche la lettre de fin en majuscule (+64)
        maxv = intervalle(fin_interv, 2) - intervalle(debut_interv, 1) + 1
        texteg(0).Caption = "Cet intervalle comprend " + Str$(maxv) + " verbes"
    End If
End Sub

Private Sub interv_op_Click(Index As Integer)
'les textes et cadres de la partie intervalle sont reinitialises
    debutg.Text = ""
    fing.Text = ""
    texteg(0).Caption = "" ' texte indiquant le nb de verbes dans l'intervalle donne

'on rend accessible ou non les textes et cadres suivant l'option choisie
    debutg.Enabled = Index
    fing.Enabled = Index
    For i = 0 To 2
        texteg(i).Enabled = Index
    Next i

    ts_verbes = 1 - Index

    If Index = 0 Then
    ' option toutes les lettres cochee
        debut_interv = 1
        fin_interv = 23
        maxv = 135
    End If
End Sub

Private Sub OK_param_Click()
    If interv_op(1).Value = True And debutg.Text = "" Then
    'si l'option cochee est l'intervalle, on va forcer le calcul
    'dans le cas ou l'utilisateur n'aurait pas rempli les bornes de
    ' l'intervalle apres avoir clique sur l'option
        calcul_intervalle
        Exit Sub
    End If
    If saisie_nb < 1 Or saisie_nb > maxv Then
        If maxv = 1 Then
            MsgBox "Il n'y a qu'un verbe"
            saisie_nb.Text = 1
            nbvex = 1
        Else
            MsgBox "Le nombre doit être compris entre 1 et " & maxv
            saisie_nb.SetFocus
        End If
        Exit Sub
    End If
    fparam.Visible = False
End Sub


Private Sub Option1_Click(Index As Integer)
    fs = Index
    f = Index
End Sub


Private Sub saisie_nb_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then ' si on appuie sur la touche ENTREE
        OK_param.SetFocus ' on donne la main au bouton OK
    End If
End Sub


Private Sub saisie_nb_LostFocus()
    If saisie_nb < 1 Or saisie_nb > maxv Then
        If maxv = 1 Then
            MsgBox "Il n'y a qu'un verbe"
            saisie_nb.Text = 1
        Else
            MsgBox "Le nombre doit être compris entre 1 et " & maxv
            saisie_nb.SetFocus
        End If
        Exit Sub
    End If
    nbvex = saisie_nb
End Sub


Private Sub up_btn_Click()
    If saisie_nb < maxv Then
        saisie_nb = saisie_nb + 1
        nbvex = saisie_nb
    End If
End Sub


