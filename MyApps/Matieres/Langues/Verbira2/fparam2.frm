VERSION 4.00
Begin VB.Form fparam2 
   BackColor       =   &H00C0C0C0&
   Caption         =   "AIDE Paramètres"
   ClientHeight    =   5100
   ClientLeft      =   9660
   ClientTop       =   8430
   ClientWidth     =   8115
   Height          =   5610
   Left            =   9600
   LinkTopic       =   "Form2"
   ScaleHeight     =   5100
   ScaleWidth      =   8115
   Top             =   7980
   Width           =   8235
   Begin VB.CommandButton Command1 
      Caption         =   "Suite"
      Height          =   372
      Left            =   3720
      TabIndex        =   2
      Top             =   4440
      Width           =   972
   End
   Begin VB.Label Label2 
      BackColor       =   &H00C0C0C0&
      Height          =   1812
      Left            =   4320
      TabIndex        =   1
      Top             =   1680
      Width           =   2412
   End
   Begin VB.Label Label1 
      BackColor       =   &H00C0C0C0&
      Caption         =   $"FPARAM2.frx":0000
      Height          =   492
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7572
   End
   Begin VB.Image Image1 
      Height          =   2865
      Left            =   120
      Picture         =   "FPARAM2.frx":00D8
      Top             =   1080
      Width           =   4860
   End
End
Attribute VB_Name = "fparam2"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    fparam2.Visible = False
    fparam3.Show 1
End Sub


Private Sub Form_Load()
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
Label2.Caption = "Dans cet exemple, les verbes tirés au sort le seront parmi un groupe de verbes." & vbCrLf & "Ce groupe contient tous les verbes commençant par la lettre A jusqu'a ceux commençant par la lettre D." & vbCrLf & "Ce groupe comprend 32 verbes"
'on place les textes et images, on dimensionne la fenetre
fparam2.Width = label1.Width + 400
label1.Left = (fparam2.Width - label1.Width) / 2
Image1.Top = label1.Top + label1.Height + 200
Label2.Left = Image1.Left + Image1.Width + ((fparam2.Width - Image1.Left - Image1.Width - Label2.Width) / 2)
Label2.Top = Image1.Top + (Image1.Height - Label2.Height) / 2
Command1.Top = Image1.Top + Image1.Height + 200
fparam2.Height = Command1.Top + Command1.Height + 500
End Sub


