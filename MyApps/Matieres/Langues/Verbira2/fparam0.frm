VERSION 4.00
Begin VB.Form fparam0 
   BackColor       =   &H00C0C0C0&
   Caption         =   "AIDE"
   ClientHeight    =   2040
   ClientLeft      =   465
   ClientTop       =   8610
   ClientWidth     =   3225
   Height          =   2550
   Left            =   405
   LinkTopic       =   "fparam0"
   ScaleHeight     =   2040
   ScaleWidth      =   3225
   Top             =   8160
   Width           =   3345
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   372
      Left            =   600
      TabIndex        =   1
      Top             =   840
      Width           =   852
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "Label1"
      Height          =   192
      Left            =   600
      TabIndex        =   0
      Top             =   240
      Width           =   516
   End
End
Attribute VB_Name = "fparam0"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Private Sub Command1_Click()
    fparam0.Visible = False
End Sub

Private Sub Form_Load()
label1.Caption = "Après avoir défini les paramêtres à votre convenance," & vbCrLf & "choisissez l'option 'début de l'exercice' dans le menu général." & vbCrLf & vbCrLf & "Un verbe est alors tiré au sort et c'est à vous de jouer :" & vbCrLf & "vous devez alors remplir les 3 autres formes." & vbCrLf & vbCrLf & "Vous pouvez passer d'une case à la suivante grâce à la souris," & vbCrLf & "la touche Entrée ou Tabulation." & vbCrLf & vbCrLf & "A tout moment vous pouvez interrompre l'exercice en cours" & vbCrLf & "en choisissant l'option 'fin de l'exercice' dans le menu général." & vbCrLf & vbCrLf & "A la fin de l'exercice, un tableau récapitule vos performances" & vbCrLf & "afin de repérer vos points faibles et vous permettre de progresser"
label1.Left = 500
Command1.Top = label1.Top + label1.Height + 200
fparam0.Height = Command1.Top + Command1.Height + 500
fparam0.Width = label1.Width + 1000
Command1.Left = (fparam0.Width - Command1.Width) / 2
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
End Sub


