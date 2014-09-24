VERSION 4.00
Begin VB.Form fparam1 
   BackColor       =   &H00C0C0C0&
   Caption         =   "AIDE Paramètres"
   ClientHeight    =   4950
   ClientLeft      =   11325
   ClientTop       =   7005
   ClientWidth     =   7485
   Height          =   5460
   Left            =   11265
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4950
   ScaleWidth      =   7485
   Top             =   6555
   Width           =   7605
   Begin VB.CommandButton Command1 
      Caption         =   "Suite"
      Height          =   372
      Left            =   3240
      TabIndex        =   3
      Top             =   4320
      Width           =   972
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Le paramètre ""Interrogation"" vous permet de choisir à partir de quelle forme vous allez être interrogé."
      Height          =   492
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   5172
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   $"FPARAM1.frx":0000
      Height          =   492
      Left            =   360
      TabIndex        =   1
      Top             =   3120
      Width           =   6732
   End
   Begin VB.Label Label2 
      BackColor       =   &H00C0C0C0&
      Caption         =   $"FPARAM1.frx":00A0
      Height          =   1092
      Left            =   3600
      TabIndex        =   0
      Top             =   1080
      Width           =   3132
   End
   Begin VB.Image Image1 
      Height          =   2850
      Left            =   120
      Picture         =   "FPARAM1.frx":0151
      Top             =   720
      Width           =   3660
   End
End
Attribute VB_Name = "fparam1"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    fparam1.Visible = False
    fparam2.Show 1
End Sub


Private Sub Form_Load()
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
'on place les textes et images, on dimensionne la fenetre
fparam1.Width = Label3.Width + 400
label1.Left = (fparam1.Width - label1.Width) / 2
Image1.Top = label1.Top + label1.Height + 200
Label2.Left = Image1.Left + Image1.Width + ((fparam1.Width - Image1.Left - Image1.Width - Label2.Width) / 2)
Label2.Top = Image1.Top + (Image1.Height - Label2.Height) / 2
Label3.Left = (fparam1.Width - Label3.Width) / 2
Label3.Top = Image1.Top + Image1.Height + 300
Command1.Top = Label3.Top + Label3.Height + 200
fparam1.Height = Command1.Top + Command1.Height + 500
End Sub


