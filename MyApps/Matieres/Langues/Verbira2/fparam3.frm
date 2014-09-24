VERSION 4.00
Begin VB.Form fparam3 
   BackColor       =   &H00C0C0C0&
   Caption         =   "AIDE Paramètres"
   ClientHeight    =   4590
   ClientLeft      =   1245
   ClientTop       =   9960
   ClientWidth     =   7470
   Height          =   5100
   Left            =   1185
   LinkTopic       =   "Form2"
   ScaleHeight     =   4590
   ScaleWidth      =   7470
   Top             =   9510
   Width           =   7590
   Begin VB.CommandButton Command1 
      Caption         =   "Fin"
      Height          =   372
      Left            =   3240
      TabIndex        =   3
      Top             =   3960
      Width           =   972
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Vous pouvez aussi modifier ce nombre à l'aide de la souris, en cliquant sur les touches fléchées"
      Height          =   492
      Left            =   1800
      TabIndex        =   2
      Top             =   3120
      Width           =   3612
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Height          =   612
      Left            =   1080
      TabIndex        =   1
      Top             =   840
      Width           =   5052
   End
   Begin VB.Label Label1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Ce paramètre sert à choisir le nombre de verbes qui seront tirés au sort pendant un exercice"
      Height          =   252
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   6612
   End
   Begin VB.Image Image1 
      Height          =   1365
      Left            =   1560
      Picture         =   "FPARAM3.frx":0000
      Top             =   1680
      Width           =   5025
   End
End
Attribute VB_Name = "fparam3"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    fparam3.Visible = False
End Sub


Private Sub Form_Load()
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
Label2.Caption = "Le nombre de verbes s'incrit ici." & vbCrLf & "Vous pouvez modifier directement ce nombre en cliquant dans le cadre à l'aide de la souris puis rentrer la nouvelle valeur grâce au clavier"
'on place les textes et images, on dimensionne la fenetre
Width = label1.Width + 400
label1.Left = (Width - label1.Width) / 2
Label2.Top = label1.Top + label1.Height + 200
Label2.Left = (Width - Label2.Width) / 2
Image1.Top = Label2.Top + Label2.Height + 200
Label3.Left = (Width - Label3.Width) / 2
Label3.Top = Image1.Top + Image1.Height + 200
Command1.Top = Label3.Top + Label3.Height + 200
Height = Command1.Top + Command1.Height + 500
End Sub


