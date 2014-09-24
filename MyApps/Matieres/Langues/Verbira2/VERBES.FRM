VERSION 4.00
Begin VB.Form Form1 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   4860
   ClientLeft      =   8400
   ClientTop       =   2655
   ClientWidth     =   8760
   FillColor       =   &H00C0C0C0&
   Height          =   5670
   Icon            =   "VERBES.frx":0000
   Left            =   8340
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4860
   ScaleWidth      =   8760
   Top             =   1905
   Width           =   8880
   Begin VB.Timer timer 
      Interval        =   65535
      Left            =   1800
      Top             =   0
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   11
      Left            =   4080
      Picture         =   "VERBES.frx":0442
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   39
      Top             =   3360
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   10
      Left            =   4080
      Picture         =   "VERBES.frx":17BC
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   38
      Top             =   3360
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   9
      Left            =   4080
      Picture         =   "VERBES.frx":2266
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   37
      Top             =   3360
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   8
      Left            =   4080
      Picture         =   "VERBES.frx":35E0
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   36
      Top             =   2520
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   7
      Left            =   4080
      Picture         =   "VERBES.frx":495A
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   35
      Top             =   2520
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   6
      Left            =   4080
      Picture         =   "VERBES.frx":5404
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   34
      Top             =   2520
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   5
      Left            =   4080
      Picture         =   "VERBES.frx":677E
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   33
      Top             =   1680
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   4
      Left            =   4080
      Picture         =   "VERBES.frx":7AF8
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   32
      Top             =   1680
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   3
      Left            =   4080
      Picture         =   "VERBES.frx":85A2
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   31
      Top             =   1680
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   2
      Left            =   4080
      Picture         =   "VERBES.frx":991C
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   23
      Top             =   840
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   1
      Left            =   4080
      Picture         =   "VERBES.frx":AC96
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   22
      Top             =   840
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox visage 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      DrawStyle       =   5  'Transparent
      Enabled         =   0   'False
      ForeColor       =   &H80000008&
      Height          =   615
      Index           =   0
      Left            =   4080
      Picture         =   "VERBES.frx":B740
      ScaleHeight     =   615
      ScaleWidth      =   585
      TabIndex        =   21
      Top             =   840
      Visible         =   0   'False
      Width           =   585
   End
   Begin VB.PictureBox drapeau 
      AutoSize        =   -1  'True
      Height          =   4860
      Left            =   5880
      Picture         =   "VERBES.frx":CABA
      ScaleHeight     =   4800
      ScaleWidth      =   8715
      TabIndex        =   19
      Top             =   3240
      Width           =   8775
   End
   Begin VB.CommandButton b_res 
      Caption         =   "Résultats"
      Height          =   492
      Left            =   2160
      TabIndex        =   15
      TabStop         =   0   'False
      Top             =   4080
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.CommandButton b_suiv 
      Caption         =   "Verbe suivant"
      Height          =   492
      Left            =   2160
      TabIndex        =   14
      TabStop         =   0   'False
      Top             =   4080
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.CommandButton b_corr 
      Caption         =   "Correction"
      Height          =   492
      Left            =   2160
      TabIndex        =   13
      TabStop         =   0   'False
      Top             =   4080
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.TextBox saisie 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Index           =   3
      Left            =   1800
      TabIndex        =   4
      Top             =   3480
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.TextBox saisie 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Index           =   2
      Left            =   1800
      TabIndex        =   3
      Top             =   2640
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.TextBox saisie 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Index           =   1
      Left            =   1800
      TabIndex        =   2
      Top             =   1800
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.TextBox saisie 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   288
      Index           =   0
      Left            =   1800
      TabIndex        =   1
      Top             =   960
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Pas de réponse"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Index           =   4
      Left            =   6840
      TabIndex        =   44
      Top             =   1800
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Pas de réponse"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Index           =   7
      Left            =   6840
      TabIndex        =   43
      Top             =   2640
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Pas de réponse"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Index           =   10
      Left            =   6840
      TabIndex        =   42
      Top             =   3480
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Pas de réponse"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   255
      Index           =   1
      Left            =   6840
      TabIndex        =   41
      Top             =   960
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Faux"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   6840
      TabIndex        =   40
      Top             =   960
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Shape rectangle 
      BackColor       =   &H00C0C0C0&
      BorderColor     =   &H00FF0000&
      Height          =   3975
      Left            =   3960
      Shape           =   4  'Rounded Rectangle
      Top             =   240
      Visible         =   0   'False
      Width           =   4455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Faux"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   11
      Left            =   6840
      TabIndex        =   30
      Top             =   3480
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Juste"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Index           =   9
      Left            =   6840
      TabIndex        =   29
      Top             =   3480
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Faux"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   8
      Left            =   6840
      TabIndex        =   28
      Top             =   2640
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Juste"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Index           =   6
      Left            =   6840
      TabIndex        =   27
      Top             =   2640
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Faux"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   6840
      TabIndex        =   26
      Top             =   1800
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Juste"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Index           =   3
      Left            =   6840
      TabIndex        =   25
      Top             =   1800
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label justefaux 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Juste"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Index           =   0
      Left            =   6840
      TabIndex        =   24
      Top             =   960
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label lbl_corr 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "CORRECTION"
      Height          =   252
      Left            =   3960
      TabIndex        =   20
      Top             =   360
      Visible         =   0   'False
      Width           =   3492
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Participe passé"
      Height          =   252
      Index           =   3
      Left            =   240
      TabIndex        =   18
      Top             =   3480
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Prétérit"
      Height          =   252
      Index           =   2
      Left            =   240
      TabIndex        =   17
      Top             =   2640
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Infinitif anglais"
      Height          =   252
      Index           =   1
      Left            =   240
      TabIndex        =   16
      Top             =   1800
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.Label aff 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Index           =   3
      Left            =   1800
      TabIndex        =   12
      Top             =   3480
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label aff 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Index           =   2
      Left            =   1800
      TabIndex        =   11
      Top             =   2640
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label aff 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Index           =   1
      Left            =   1800
      TabIndex        =   10
      Top             =   1800
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label aff 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Index           =   0
      Left            =   1800
      TabIndex        =   9
      Top             =   960
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label correction 
      BackColor       =   &H00C0C0C0&
      Height          =   252
      Index           =   3
      Left            =   5040
      TabIndex        =   8
      Top             =   3480
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label correction 
      BackColor       =   &H00C0C0C0&
      Height          =   252
      Index           =   2
      Left            =   5040
      TabIndex        =   7
      Top             =   2640
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label correction 
      BackColor       =   &H00C0C0C0&
      Height          =   252
      Index           =   1
      Left            =   5040
      TabIndex        =   6
      Top             =   1800
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label correction 
      BackColor       =   &H00C0C0C0&
      Height          =   252
      Index           =   0
      Left            =   5040
      TabIndex        =   5
      Top             =   960
      Visible         =   0   'False
      Width           =   1932
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Infinitif français"
      Height          =   252
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   960
      Visible         =   0   'False
      Width           =   1212
   End
   Begin VB.Menu general 
      Caption         =   "Général"
      NegotiatePosition=   2  'Middle
      Begin VB.Menu debut 
         Caption         =   "Début de l'exercice"
      End
      Begin VB.Menu fin 
         Caption         =   "Arrêter l'exercice"
         Enabled         =   0   'False
      End
      Begin VB.Menu graphevol 
         Caption         =   "Graphique d'évolution"
      End
      Begin VB.Menu arret 
         Caption         =   "Quitter"
      End
   End
   Begin VB.Menu op 
      Caption         =   "Options"
      Begin VB.Menu param 
         Caption         =   "Paramètres"
      End
      Begin VB.Menu liste 
         Caption         =   "Liste des verbes"
      End
      Begin VB.Menu help 
         Caption         =   "Aide"
         Begin VB.Menu docexo 
            Caption         =   "Comment se déroule un exercice"
         End
         Begin VB.Menu docparam 
            Caption         =   "Paramètres"
         End
      End
   End
   Begin VB.Menu infor 
      Caption         =   "Informations"
      Begin VB.Menu apropos 
         Caption         =   "A propos"
      End
      Begin VB.Menu pb 
         Caption         =   "En cas de problème"
      End
      Begin VB.Menu penreg 
         Caption         =   "Pourquoi s'enregistrer"
         Visible         =   0   'False
      End
      Begin VB.Menu cenreg 
         Caption         =   "Carte postale"
         Visible         =   0   'False
      End
      Begin VB.Menu se 
         Caption         =   "-"
      End
      Begin VB.Menu desinstal 
         Caption         =   "Carte postale"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_Creatable = False
Attribute VB_Exposed = False



Private Sub apropos_Click()
    MsgBox "Ce logiciel m’a servi lorsque j’étais en classe et que je devais apprendre les verbes irréguliers anglais." & Chr(13) & Chr(10) & "Ayant une mémoire visuelle et écrite, ceci m’a permis un apprentissage plus facile et moins rebutant que devant une feuille blanche et un stylo tout en faisant la correction manuellement." & Chr(13) & Chr(10) & Chr(10) & "Aussi, si vous vous êtes servi de ce logiciel, ne serait-ce que quelques minutes, je vous serais infiniment reconnaissant de bien vouloir me faire parvenir toutes vos remarques et suggestions, aussi bien sur le fond que sur la forme." & Chr(13) & Chr(10) & "Je ne vous demande pas une longue analyse en 3 tomes mais juste quelques lignes, voire même une simple carte postale m’indiquant que vous avez utilisé ce logiciel", 0, "Petit mot de l'auteur"
End Sub


Private Sub arret_Click()
Dim num, d1, d2, d3 As Integer
'on enregistre les parametres
    num = FreeFile()
    On Error GoTo non_acces_disk 'permet de masquer les erreurs du a l'ouverture ou creation de fichier incorrectes (par ex à partir d'un CD)
    Open nom For Output As num
    ver_enr = True
    Write #num, ts_verbes, ver_enr, nbvex, f, debut_interv, fin_interv, Form1.Caption
    Close num
non_acces_disk:
     End
End Sub



Private Sub b_corr_Click()
Dim res
    corr = True
    fin.Enabled = True
    lbl_corr.Visible = True
    rectangle.Visible = True
    For i = 0 To 3
        If i <> fs Then ' si la forme n'est pas celle tiree au sort
            ' on affiche la correction
            correction(i).Caption = v(vs, i)
                        
            ' on compte les réponses justes, fausses et non repondu
            res = StrComp(v(vs, i), saisie(i), 1)
            If res = 0 Then
                ' reponse juste
                s(i, 0) = s(i, 0) + 1
                saisie(i).ForeColor = &H8000& ' on met la reponse en vert
                visage(3 * i).Visible = True ' on affiche le visage heureux
                justefaux(3 * i).Visible = True ' on affiche juste
            ElseIf saisie(i) <> "" Then
                ' reponse fausse
                s(i, 1) = s(i, 1) + 1
                saisie(i).ForeColor = &HFF& ' on met la reponse en rouge
                visage(3 * i + 2).Visible = True ' on affiche le visage triste
                justefaux(3 * i + 2).Visible = True ' on affiche faux
            Else
                ' pas de reponse
                s(i, 2) = s(i, 2) + 1
                visage(3 * i + 1).Visible = True ' on affiche le visage neutre
                justefaux(3 * i + 1).Visible = True ' on affiche pas de reponse
            End If
        End If
    Next i
    b_corr.Visible = False
    n = n + 1 ' compteur de verbes deja choisis + 1
    If n = nbvex Then
        'on est arrivé à la fin de l'exercice
        b_res.Visible = True 'on affiche le bouton "resultat"
        b_res.SetFocus ' et on lui "donne la main"
    Else
        b_suiv.Visible = True 'on affiche le bouton "verbe suivant"
        b_suiv.SetFocus ' et on lui "donne la main"
    End If
End Sub


Private Sub b_res_Click()
    lbl_corr.Visible = False
    rectangle.Visible = False
    For i = 0 To 11
        visage(i).Visible = False ' on cache les visages
    Next i
    For i = 0 To 11
        justefaux(i).Visible = False ' on cache les textes juste/faux
    Next i
    
    fres.Show 1 'affiche la feuille fres en mode modal(0) et la charge si ce n'est deja fait
End Sub

Private Sub b_suiv_Click()
    Rem fin.Enabled = False
    corr = False
    For i = 0 To 3 ' initialisation des cadres et textes
        saisie(i).Text = ""
        saisie(i).ForeColor = &H0& ' couleur d'ecriture en noir
        correction(i).Caption = ""
        lbl_corr.Visible = False
        rectangle.Visible = False
    Next i
    For i = 0 To 11
        visage(i).Visible = False ' on cache les visages
    Next i
    For i = 0 To 11
        justefaux(i).Visible = False ' on cache les textes juste/faux
    Next i
        
    Form1.saisie(fs).Visible = True
    Form1.aff(fs).Visible = True
    
    b_corr.Visible = True
    b_suiv.Visible = False
    
    interro
End Sub



Private Sub cenreg_Click()
    MsgBox ("Une petite carte postale de votre région ou de votre ville pour me" & Chr(13) & Chr(10) & "dire que vous avez apprécié VERBIRA 2.0 me ferait très plaisir." & Chr(13) & Chr(13) & Chr(10) & "Mon adresse postale est la suivante :" & Chr(13) & Chr(13) & Chr(10) & "CAZALS Jean-Claude" & Chr(13) & Chr(10) & Chr(10) & "5 impasse des bouvreuils" & Chr(13) & Chr(10) & Chr(10) & "66760 ANGOUSTRINE" & Chr(13) & Chr(10) & Chr(10) & Chr(10) & "Merci.")
    
End Sub

Private Sub desinstal_Click()
    MsgBox ("j'ai passé du temps à écrire ce programme et je vous en fais profiter gratuitement," & Chr(13) & Chr(10) & "aussi, une petite carte postale de votre région ou de votre ville pour me" & Chr(13) & Chr(10) & "dire que vous avez apprécié VERBIRA 2.0 me ferait très plaisir." & Chr(13) & Chr(10) & "(ou à défaut, un petit mot par e-mail à verbira.web@free.fr,mais je préfèrerais" & Chr(13) & Chr(10) & "une carte postale   [ou un don, si vous le souhaitez, pourquoi pas ?])" & Chr(13) & Chr(13) & Chr(10) & "Mon adresse postale est la suivante :" & Chr(13) & Chr(13) & Chr(10) & "CAZALS Jean-Claude" & Chr(13) & Chr(10) & "5 impasse des bouvreuils" & Chr(13) & Chr(10) & "66760 ANGOUSTRINE" & Chr(13) & Chr(10) & Chr(10) & Chr(10) & "Merci.")
End Sub

Private Sub pb_Click()
    MsgBox "Si vous rencontrez des problèmes,ou avez des questions" & Chr(13) & Chr(10) & " ou suggestions à me faire, n'hésitez pas à me contacter" & Chr(13) & Chr(10) & Chr(10) & "CAZALS Jean-Claude" & Chr(13) & Chr(10) & "5 Impasse des bouvreuils" & Chr(13) & Chr(10) & "66760 ANGOUSTRINE" & Chr(13) & Chr(10) & Chr(10) & "e-mail : verbira.web@free.fr", , "En cas de problème ..."
End Sub

Private Sub penreg_Click()
    MsgBox "vous enregistrer, vous permet :" & Chr(13) & Chr(10) & Chr(10) & " - D'avoir une version personnelle et nominative du logiciel" & Chr(13) & Chr(10) & " - Le logiciel n'est plus limité dans le temps à une dizaine de minutes" & Chr(13) & Chr(10) & " - Le logiciel imprime la totalité des verbes irréguliers" & Chr(13) & Chr(10) & " - D'avoir une écoute particulière et attentive de la part de l'auteur", , "Pourquoi s'enregistrer"
End Sub

Private Sub cpenreg_Click()

End Sub

Private Sub debut_Click()
    b_corr.Visible = True
    b_suiv.Visible = False
    b_res.Visible = False
    drapeau.Visible = False
    
    debut.Enabled = False ' on ne peut pas acceder au menu "debut d'exo" pendant l'exercice
    fin.Enabled = True
    Rem fin.Enabled = False ' on ne peut acceder au menu "fin d'exo" qu'apres correction du verbe en cours
    param.Enabled = False ' on ne peut pas acceder au menu "paramétres" pendant l'exercice
    arret.Enabled = False 'on ne peut pas acceder au menu "Quitter" pendant l'exercice
    liste.Enabled = False 'on ne peut pas acceder au menu "Liste des verbes" pendant l'exercice
    
    For i = 0 To 3 ' initialisation des cadres et textes
        saisie(i).Visible = True
        saisie(i).ForeColor = &H0& 'ecriture en noir
        aff(i).Visible = True
        correction(i).Visible = True
        label1(i).Visible = True
        
        nbq(i) = 0 'initialisation des compteurs du nombre de verbes poses par forme
    Next i
        
    n = 0 'compteur de verbe pendant l'exercice
    nb_q_posees = 0
    
    'au départ, aucun verbe n'est choisi
    For i = debut_interv To fin_interv
        dc(i) = 0
    Next i
    
    'initialisation du tableau de statistiques
    For i = 0 To 3
        s(i, 0) = 0
        s(i, 1) = 0
        s(i, 2) = 0
    Next i
    
    Randomize
    interro
End Sub


Private Sub docexo_Click()
    fparam0.Visible = True
End Sub

Private Sub docparam_Click()
    fparam1.Show 1
End Sub

Private Sub fin_Click()
    If Not (corr) Then
        MsgBox "Le verbe en cours n'étant pas corrigé, il ne sera pas pris en compte dans les résultats"
    End If
    fres.Show 1 'affiche la feuille fres en mode modal(0) et la charge si ce n'est deja fait
    etat_fin_exo
            
    lbl_corr.Visible = False
    rectangle.Visible = False
    For i = 0 To 11
        visage(i).Visible = False ' on cache les visages
    Next i
    For i = 0 To 7
        justefaux(i).Visible = False ' on cache les textes juste/faux
    Next i
End Sub


Private Sub Form_Load()
h = Screen.Height ' hauteur de l'ecran
l = Screen.Width  ' largeur de l'ecran
    
'centrage de l'ecran principal en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2
'centrage du drapeau dans la fenetre principale
drapeau.Left = 0 '(Form1.Width - drapeau.Width) / 2
drapeau.Top = 0 '(Form1.Height - drapeau.Height) / 2

' chargement des parametres
' ts_verbes : option "tous les verbes" choisie ou non
' ver_enr : version enregistree ou non
' nbvex : nb de questions à poser
' f : forme d'exercice choisit
'       0 : tjs francais
'       1 : tjs infinitif anglais
'       2 : tjs preterit
'       3 : tjs participe passé
'       4 : aléatoire
' debut_interv et fin_interv : bornes de l'intervalle
' titre : titre de la fenetre principale (version enregistree ou non)
Dim titre As String
Dim num As Integer

nom = CurDir$ & "\graph.jcc"
If Dir$(nom) = "" Then 'si le fichier graph.jcc n'existe pas,
    graphevol.Enabled = False ' la commande du menu "graphique d'évolution" est rendue inaccessible car il n'y a aucun point a afficher
ElseIf FileLen(nom) \ 4 < 2 Then
    graphevol.Enabled = False ' la commande du menu "graphique d'évolution" est rendue inaccessible car il n'y a aucun point a afficher
End If


num = FreeFile()
nom = CurDir$ & "\par.jcc"

If Dir$(nom) = "" Then
    'si le fichier n'existe pas dans le repertoire courant, on le crée
    ver_enr = True
    ts_verbes = False
    nbvex = 5  ' : 5 verbes à poser
    f = 0   ' : tjs francais
    debut_interv = 1 ' : debut de l'intervalle : lettre A
    fin_interv = 3 ' : fin de l'intervalle : lettre C
    Form1.Caption = "VERBIRA 2.0 pensez à envoyer une petite carte postale : menu CARTE POSTALE"
    On Error GoTo non_acces_disk1 'permet de masquer les erreurs du a l'ouverture ou creation de fichier incorrectes (par ex à partir d'un CD)
    Open nom For Output As num
    Write #num, ts_verbes, ver_enr, nbvex, f, debut_interv, fin_interv, Form1.Caption
    Close num
non_acces_disk1:
Else
    'on lit les parametres
    On Error GoTo non_acces_disk 'permet de masquer les erreurs du a l'ouverture ou creation de fichier incorrectes (par ex à partir d'un CD)
    Open nom For Input As num
    Input #num, ts_verbes, ver_enr, nbvex, f, debut_interv, fin_interv, titre
    Close num
non_acces_disk:
    Form1.Caption = "VERBIRA 2.0 pensez à envoyer une petite carte postale : menu CARTE POSTALE"
End If



' on active les menus pourquoi et comment s'enregistrer
    cenreg.Visible = False ' menu comment s'enregistrer devient inutile
    penreg.Visible = False  ' menu pourquoi s'enregistrer devenu inutile
    
' le menu comment desinstaller DEVIENT le menu CARTE POSTALE

    Timer.Enabled = False ' timer de version enregistrée ou non desactivé car version freeware


corr = False
fs = f

intervalle(1, 1) = 1
intervalle(2, 1) = 2
intervalle(3, 1) = 18
intervalle(4, 1) = 26
intervalle(5, 1) = 33
intervalle(6, 1) = 34
intervalle(7, 1) = 45
intervalle(8, 1) = 50
intervalle(9, 1) = -1
intervalle(10, 1) = -1
intervalle(11, 1) = 57
intervalle(12, 1) = 60
intervalle(13, 1) = 69
intervalle(14, 1) = -1
intervalle(15, 1) = -1
intervalle(16, 1) = 72
intervalle(17, 1) = -1
intervalle(18, 1) = 74
intervalle(19, 1) = 79
intervalle(20, 1) = 118
intervalle(21, 1) = 125
intervalle(22, 1) = -1
intervalle(23, 1) = 127
intervalle(24, 1) = -1
intervalle(25, 1) = -1
intervalle(26, 1) = -1

intervalle(1, 2) = 1
intervalle(2, 2) = 17
intervalle(3, 2) = 25
intervalle(4, 2) = 32
intervalle(5, 2) = 33
intervalle(6, 2) = 44
intervalle(7, 2) = 49
intervalle(8, 2) = 56
intervalle(9, 2) = -1
intervalle(10, 2) = -1
intervalle(11, 2) = 59
intervalle(12, 2) = 68
intervalle(13, 2) = 71
intervalle(14, 2) = -1
intervalle(15, 2) = -1
intervalle(16, 2) = 73
intervalle(17, 2) = -1
intervalle(18, 2) = 78
intervalle(19, 2) = 117
intervalle(20, 2) = 124
intervalle(21, 2) = 126
intervalle(22, 2) = -1
intervalle(23, 2) = 135
intervalle(24, 2) = -1
intervalle(25, 2) = -1
intervalle(26, 2) = -1

maxv = intervalle(fin_interv, 2) - intervalle(debut_interv, 1) + 1

compteur = 0 'compteur pour limiter l'execution à 3 minutes

'initialisation du tableau de verbes
' tirés du livre pratique de l'anglais de A à Z
    v(1, 0) = "se lever"
    v(1, 1) = "arise"
    v(1, 2) = "arose"
    v(1, 3) = "arisen"
    v(2, 0) = "être"
    v(2, 1) = "be"
    v(2, 2) = "was"
    v(2, 3) = "been"
    v(3, 0) = "battre"
    v(3, 1) = "beat"
    v(3, 2) = "beat"
    v(3, 3) = "beaten"
    v(4, 0) = "devenir"
    v(4, 1) = "become"
    v(4, 2) = "became"
    v(4, 3) = "become"
    v(5, 0) = "commencer"
    v(5, 1) = "begin"
    v(5, 2) = "began"
    v(5, 3) = "begun"
    v(6, 0) = "plier"
    v(6, 1) = "bend"
    v(6, 2) = "bent"
    v(6, 3) = "bent"
    v(7, 0) = "parier"
    v(7, 1) = "bet"
    v(7, 2) = "bet"
    v(7, 3) = "bet"
    v(8, 0) = "lier"
    v(8, 1) = "bind"
    v(8, 2) = "bound"
    v(8, 3) = "bound"
    v(9, 0) = "mordre"
    v(9, 1) = "bite"
    v(9, 2) = "bit"
    v(9, 3) = "bitten"
    v(10, 0) = "saigner"
    v(10, 1) = "bleed"
    v(10, 2) = "bled"
    v(10, 3) = "bled"
    v(11, 0) = "souffler"
    v(11, 1) = "blow"
    v(11, 2) = "blew"
    v(11, 3) = "blown"
    v(12, 0) = "casser"
    v(12, 1) = "break"
    v(12, 2) = "broke"
    v(12, 3) = "broken"
    v(13, 0) = "amener"
    v(13, 1) = "bring"
    v(13, 2) = "brought"
    v(13, 3) = "brought"
    v(14, 0) = "construire"
    v(14, 1) = "build"
    v(14, 2) = "built"
    v(14, 3) = "built"
    v(15, 0) = "brûler"
    v(15, 1) = "burn"
    v(15, 2) = "burnt"
    v(15, 3) = "burnt"
    v(16, 0) = "éclater"
    v(16, 1) = "burst"
    v(16, 2) = "burst"
    v(16, 3) = "burst"
    v(17, 0) = "acheter"
    v(17, 1) = "buy"
    v(17, 2) = "bought"
    v(17, 3) = "bought"
    v(18, 0) = "jeter"
    v(18, 1) = "cast"
    v(18, 2) = "cast"
    v(18, 3) = "cast"
    v(19, 0) = "attraper"
    v(19, 1) = "catch"
    v(19, 2) = "caught"
    v(19, 3) = "caught"
    v(20, 0) = "choisir"
    v(20, 1) = "choose"
    v(20, 2) = "chose"
    v(20, 3) = "chosen"
    v(21, 0) = "s'accocher"
    v(21, 1) = "cling"
    v(21, 2) = "clung"
    v(21, 3) = "clung"
    v(22, 0) = "venir"
    v(22, 1) = "come"
    v(22, 2) = "came"
    v(22, 3) = "come"
    v(23, 0) = "coûter"
    v(23, 1) = "cost"
    v(23, 2) = "cost"
    v(23, 3) = "cost"
    v(24, 0) = "ramper"
    v(24, 1) = "creep"
    v(24, 2) = "crept"
    v(24, 3) = "crept"
    v(25, 0) = "couper"
    v(25, 1) = "cut"
    v(25, 2) = "cut"
    v(25, 3) = "cut"
    v(26, 0) = "s'occuper de"
    v(26, 1) = "deal"
    v(26, 2) = "dealt"
    v(26, 3) = "dealt"
    v(27, 0) = "creuser"
    v(27, 1) = "dig"
    v(27, 2) = "dug"
    v(27, 3) = "dug"
    v(28, 0) = "faire"
    v(28, 1) = "do"
    v(28, 2) = "did"
    v(28, 3) = "done"
    v(29, 0) = "dessiner"
    v(29, 1) = "draw"
    v(29, 2) = "drew"
    v(29, 3) = "drawn"
    v(30, 0) = "rêver"
    v(30, 1) = "dream"
    v(30, 2) = "dreamt"
    v(30, 3) = "dreamt"
    v(31, 0) = "boire"
    v(31, 1) = "drink"
    v(31, 2) = "drank"
    v(31, 3) = "drunk"
    v(32, 0) = "conduire"
    v(32, 1) = "drive"
    v(32, 2) = "drove"
    v(32, 3) = "driven"
    v(33, 0) = "manger"
    v(33, 1) = "eat"
    v(33, 2) = "ate"
    v(33, 3) = "eaten"
    v(34, 0) = "tomber"
    v(34, 1) = "fall"
    v(34, 2) = "fell"
    v(34, 3) = "fallen"
    v(35, 0) = "nourrir"
    v(35, 1) = "feed"
    v(35, 2) = "fed"
    v(35, 3) = "fed"
    v(36, 0) = "éprouver"
    v(36, 1) = "feel"
    v(36, 2) = "felt"
    v(36, 3) = "felt"
    v(37, 0) = "se battre"
    v(37, 1) = "fight"
    v(37, 2) = "fought"
    v(37, 3) = "fought"
    v(38, 0) = "trouver"
    v(38, 1) = "find"
    v(38, 2) = "found"
    v(38, 3) = "found"
    v(39, 0) = "lancer violemment"
    v(39, 1) = "fling"
    v(39, 2) = "flung"
    v(39, 3) = "flung"
    v(40, 0) = "voler"
    v(40, 1) = "fly"
    v(40, 2) = "flew"
    v(40, 3) = "flown"
    v(41, 0) = "interdire"
    v(41, 1) = "forbid"
    v(41, 2) = "forbade"
    v(41, 3) = "forbidden"
    v(42, 0) = "oublier"
    v(42, 1) = "forget"
    v(42, 2) = "forgot"
    v(42, 3) = "forgotten"
    v(43, 0) = "pardonner"
    v(43, 1) = "forgive"
    v(43, 2) = "forgave"
    v(43, 3) = "forgiven"
    v(44, 0) = "geler"
    v(44, 1) = "freeze"
    v(44, 2) = "froze"
    v(44, 3) = "frozen"
    v(45, 0) = "obtenir"
    v(45, 1) = "get"
    v(45, 2) = "got"
    v(45, 3) = "got"
    v(46, 0) = "donner"
    v(46, 1) = "give"
    v(46, 2) = "gave"
    v(46, 3) = "given"
    v(47, 0) = "aller"
    v(47, 1) = "go"
    v(47, 2) = "went"
    v(47, 3) = "gone"
    v(48, 0) = "moudre"
    v(48, 1) = "grind"
    v(48, 2) = "ground"
    v(48, 3) = "ground"
    v(49, 0) = "grandir"
    v(49, 1) = "grow"
    v(49, 2) = "grew"
    v(49, 3) = "grown"
    v(50, 0) = "suspendre"
    v(50, 1) = "hang"
    v(50, 2) = "hung"
    v(50, 3) = "hung"
    v(51, 0) = "avoir"
    v(51, 1) = "have"
    v(51, 2) = "had"
    v(51, 3) = "had"
    v(52, 0) = "entendre"
    v(52, 1) = "hear"
    v(52, 2) = "heard"
    v(52, 3) = "heard"
    v(53, 0) = "cacher"
    v(53, 1) = "hide"
    v(53, 2) = "hid"
    v(53, 3) = "hidden"
    v(54, 0) = "frapper"
    v(54, 1) = "hit"
    v(54, 2) = "hit"
    v(54, 3) = "hit"
    v(55, 0) = "tenir"
    v(55, 1) = "hold"
    v(55, 2) = "held"
    v(55, 3) = "held"
    v(56, 0) = "blesser"
    v(56, 1) = "hurt"
    v(56, 2) = "hurt"
    v(56, 3) = "hurt"
    v(57, 0) = "garder"
    v(57, 1) = "keep"
    v(57, 2) = "kept"
    v(57, 3) = "kept"
    v(58, 0) = "s'agenouiller"
    v(58, 1) = "kneel"
    v(58, 2) = "knelt"
    v(58, 3) = "knelt"
    v(59, 0) = "savoir"
    v(59, 1) = "know"
    v(59, 2) = "knew"
    v(59, 3) = "known"
    v(60, 0) = "mettre la table"
    v(60, 1) = "lay"
    v(60, 2) = "laid"
    v(60, 3) = "laid"
    v(61, 0) = "mener"
    v(61, 1) = "lead"
    v(61, 2) = "led"
    v(61, 3) = "led"
    v(62, 0) = "apprendre"
    v(62, 1) = "learn"
    v(62, 2) = "learnt"
    v(62, 3) = "learnt"
    v(63, 0) = "quitter"
    v(63, 1) = "leave"
    v(63, 2) = "left"
    v(63, 3) = "left"
    v(64, 0) = "preter"
    v(64, 1) = "lend"
    v(64, 2) = "lent"
    v(64, 3) = "lent"
    v(65, 0) = "permettre"
    v(65, 1) = "let"
    v(65, 2) = "let"
    v(65, 3) = "let"
    v(66, 0) = "être couché"
    v(66, 1) = "lie"
    v(66, 2) = "lay"
    v(66, 3) = "lain"
    v(67, 0) = "allumer"
    v(67, 1) = "light"
    v(67, 2) = "lit"
    v(67, 3) = "lit"
    v(68, 0) = "perdre"
    v(68, 1) = "lose"
    v(68, 2) = "lost"
    v(68, 3) = "lost"
    v(69, 0) = "fabriquer"
    v(69, 1) = "make"
    v(69, 2) = "made"
    v(69, 3) = "made"
    v(70, 0) = "signifier"
    v(70, 1) = "mean"
    v(70, 2) = "meant"
    v(70, 3) = "meant"
    v(71, 0) = "rencontrer"
    v(71, 1) = "meet"
    v(71, 2) = "met"
    v(71, 3) = "met"
    v(72, 0) = "payer"
    v(72, 1) = "pay"
    v(72, 2) = "paid"
    v(72, 3) = "paid"
    v(73, 0) = "poser"
    v(73, 1) = "put"
    v(73, 2) = "put"
    v(73, 3) = "put"
    v(74, 0) = "lire"
    v(74, 1) = "read"
    v(74, 2) = "read"
    v(74, 3) = "read"
    v(75, 0) = "chevaucher"
    v(75, 1) = "ride"
    v(75, 2) = "rode"
    v(75, 3) = "ridden"
    v(76, 0) = "sonner"
    v(76, 1) = "ring"
    v(76, 2) = "rang"
    v(76, 3) = "rung"
    v(77, 0) = "s'élever"
    v(77, 1) = "rise"
    v(77, 2) = "rose"
    v(77, 3) = "risen"
    v(78, 0) = "courir"
    v(78, 1) = "run"
    v(78, 2) = "ran"
    v(78, 3) = "run"
    v(79, 0) = "dire"
    v(79, 1) = "say"
    v(79, 2) = "said"
    v(79, 3) = "said"
    v(80, 0) = "voir"
    v(80, 1) = "see"
    v(80, 2) = "saw"
    v(80, 3) = "seen"
    v(81, 0) = "chercher"
    v(81, 1) = "seek"
    v(81, 2) = "sought"
    v(81, 3) = "sought"
    v(82, 0) = "vendre"
    v(82, 1) = "sell"
    v(82, 2) = "sold"
    v(82, 3) = "sold"
    v(83, 0) = "envoyer"
    v(83, 1) = "send"
    v(83, 2) = "sent"
    v(83, 3) = "sent"
    v(84, 0) = "poser"
    v(84, 1) = "set"
    v(84, 2) = "set"
    v(84, 3) = "set"
    v(85, 0) = "coudre"
    v(85, 1) = "sew"
    v(85, 2) = "sewed"
    v(85, 3) = "sewn"
    v(86, 0) = "secouer"
    v(86, 1) = "shake"
    v(86, 2) = "shook"
    v(86, 3) = "shaken"
    v(87, 0) = "briller"
    v(87, 1) = "shine"
    v(87, 2) = "shone"
    v(87, 3) = "shone"
    v(88, 0) = "tirer au fusil"
    v(88, 1) = "shoot"
    v(88, 2) = "shot"
    v(88, 3) = "shot"
    v(89, 0) = "montrer"
    v(89, 1) = "show"
    v(89, 2) = "showed"
    v(89, 3) = "shown"
    v(90, 0) = "rétrécir"
    v(90, 1) = "shrink"
    v(90, 2) = "shrank"
    v(90, 3) = "shrunk"
    v(91, 0) = "fermer"
    v(91, 1) = "shut"
    v(91, 2) = "shut"
    v(91, 3) = "shut"
    v(92, 0) = "chanter"
    v(92, 1) = "sing"
    v(92, 2) = "sang"
    v(92, 3) = "sung"
    v(93, 0) = "couler"
    v(93, 1) = "sink"
    v(93, 2) = "sank"
    v(93, 3) = "sunk"
    v(94, 0) = "être assis"
    v(94, 1) = "sit"
    v(94, 2) = "sat"
    v(94, 3) = "sat"
    v(95, 0) = "tuer"
    v(95, 1) = "slay"
    v(95, 2) = "slew"
    v(95, 3) = "slain"
    v(96, 0) = "dormir"
    v(96, 1) = "sleep"
    v(96, 2) = "slept"
    v(96, 3) = "slept"
    v(97, 0) = "glisser"
    v(97, 1) = "slide"
    v(97, 2) = "slid"
    v(97, 3) = "slid"
    v(98, 0) = "sentir"
    v(98, 1) = "smell"
    v(98, 2) = "smelt"
    v(98, 3) = "smelt"
    v(99, 0) = "parler"
    v(99, 1) = "speak"
    v(99, 2) = "spoke"
    v(99, 3) = "spoken"
    v(100, 0) = "épeler"
    v(100, 1) = "spell"
    v(100, 2) = "spelt"
    v(100, 3) = "spelt"
    v(101, 0) = "dépenser"
    v(101, 1) = "spend"
    v(101, 2) = "spent"
    v(101, 3) = "spent"
    v(102, 0) = "répandre"
    v(102, 1) = "spill"
    v(102, 2) = "spilt"
    v(102, 3) = "spilt"
    v(103, 0) = "tourner rapidement"
    v(103, 1) = "spin"
    v(103, 2) = "spun"
    v(103, 3) = "spun"
    v(104, 0) = "cracher"
    v(104, 1) = "spit"
    v(104, 2) = "spat"
    v(104, 3) = "spat"
    v(105, 0) = "fendre"
    v(105, 1) = "split"
    v(105, 2) = "split"
    v(105, 3) = "split"
    v(106, 0) = "étaler"
    v(106, 1) = "spread"
    v(106, 2) = "spread"
    v(106, 3) = "spread"
    v(107, 0) = "bondir"
    v(107, 1) = "spring"
    v(107, 2) = "sprang"
    v(107, 3) = "sprung"
    v(108, 0) = "être debout"
    v(108, 1) = "stand"
    v(108, 2) = "stood"
    v(108, 3) = "stood"
    v(109, 0) = "dérober"
    v(109, 1) = "steal"
    v(109, 2) = "stole"
    v(109, 3) = "stolen"
    v(110, 0) = "coller"
    v(110, 1) = "stick"
    v(110, 2) = "stuck"
    v(110, 3) = "stuck"
    v(111, 0) = "piquer"
    v(111, 1) = "sting"
    v(111, 2) = "stung"
    v(111, 3) = "stung"
    v(112, 0) = "puer"
    v(112, 1) = "stink"
    v(112, 2) = "stank"
    v(112, 3) = "stunk"
    v(113, 0) = "frapper"
    v(113, 1) = "strike"
    v(113, 2) = "struck"
    v(113, 3) = "struck"
    v(114, 0) = "jurer"
    v(114, 1) = "swear"
    v(114, 2) = "swore"
    v(114, 3) = "sworn"
    v(115, 0) = "balayer"
    v(115, 1) = "sweep"
    v(115, 2) = "swept"
    v(115, 3) = "swept"
    v(116, 0) = "nager"
    v(116, 1) = "swim"
    v(116, 2) = "swam"
    v(116, 3) = "swum"
    v(117, 0) = "balancer"
    v(117, 1) = "swing"
    v(117, 2) = "swung"
    v(117, 3) = "swung"
    v(118, 0) = "prendre"
    v(118, 1) = "take"
    v(118, 2) = "took"
    v(118, 3) = "taken"
    v(119, 0) = "enseigner"
    v(119, 1) = "teach"
    v(119, 2) = "taught"
    v(119, 3) = "taught"
    v(120, 0) = "déchirer"
    v(120, 1) = "tear"
    v(120, 2) = "tore"
    v(120, 3) = "torn"
    v(121, 0) = "raconter"
    v(121, 1) = "tell"
    v(121, 2) = "told"
    v(121, 3) = "told"
    v(122, 0) = "penser"
    v(122, 1) = "think"
    v(122, 2) = "thought"
    v(122, 3) = "thought"
    v(123, 0) = "lancer"
    v(123, 1) = "throw"
    v(123, 2) = "threw"
    v(123, 3) = "thrown"
    v(124, 0) = "fouler aux pieds"
    v(124, 1) = "tread"
    v(124, 2) = "trod"
    v(124, 3) = "trodden"
    v(125, 0) = "subir"
    v(125, 1) = "undergo"
    v(125, 2) = "underwent"
    v(125, 3) = "undergone"
    v(126, 0) = "comprendre"
    v(126, 1) = "understand"
    v(126, 2) = "understood"
    v(126, 3) = "understood"
    v(127, 0) = "se réveiller"
    v(127, 1) = "wake up"
    v(127, 2) = "woke up"
    v(127, 3) = "woken up"
    v(128, 0) = "porter des vêtements"
    v(128, 1) = "wear"
    v(128, 2) = "wore"
    v(128, 3) = "worn"
    v(129, 0) = "tisser"
    v(129, 1) = "weave"
    v(129, 2) = "wove"
    v(129, 3) = "woven"
    v(130, 0) = "pleurer"
    v(130, 1) = "weep"
    v(130, 2) = "wept"
    v(130, 3) = "wept"
    v(131, 0) = "gagner"
    v(131, 1) = "win"
    v(131, 2) = "won"
    v(131, 3) = "won"
    v(132, 0) = "serpenter"
    v(132, 1) = "wind"
    v(132, 2) = "wound"
    v(132, 3) = "wound"
    v(133, 0) = "se retirer"
    v(133, 1) = "withdraw"
    v(133, 2) = "withdrew"
    v(133, 3) = "withdrawn"
    v(134, 0) = "tordre"
    v(134, 1) = "wring"
    v(134, 2) = "wrung"
    v(134, 3) = "wrung"
    v(135, 0) = "écrire"
    v(135, 1) = "write"
    v(135, 2) = "wrote"
    v(135, 3) = "written"
End Sub

Private Sub graphevol_Click()
    GRAPH.Show 1 'affiche la feuille du graphique en mode modal(0) et la charge si ce n'est deja fait
End Sub

Private Sub liste_Click()
    fliste.Show 1 'affiche la feuille fliste en mode modal(0) et la charge si ce n'est deja fait
End Sub

Private Sub param_Click()
    fparam.Show 1 'affiche la feuille fres en mode modal(0) et la charge si ce n'est deja fait
End Sub




Private Sub saisie_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
If KeyCode = 13 Then 'appui sur la touche ENTREE
    If Index = 3 Or (Index = 2 And (f = 3 Or (f = 4 And fs = 3))) Then
        ' SI la main est sur le dernier cadre
        ' OU la main est à l'avant dernier cadre ET la forme tiree au sort
        ' est la derniere forme (f=3) OU forme tiree au sort(f=4) qui est la derniere(fs=3)
        ' ALORS on passe la main au bouton de correction
        b_corr.SetFocus
    ElseIf Index + 1 = f Or (f = 4 And Index + 1 = fs) Then
        'sinon on est sur l'un des 3 premiers cadres et on doit passer la main
        '2 cadres apres car le suivant est la forme tiree au sort
        saisie(Index + 2).SetFocus
    Else 'on passe la main au cadre suivant qui n'est pas la forme tiree au sort
        saisie(Index + 1).SetFocus
    End If
End If
End Sub

Private Sub Timer1_Timer()

End Sub


Private Sub Timer_Timer()
compteur = compteur + 1
    
End Sub


