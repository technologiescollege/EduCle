VERSION 4.00
Begin VB.Form fres 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Résultats"
   ClientHeight    =   5325
   ClientLeft      =   2955
   ClientTop       =   1995
   ClientWidth     =   6375
   ControlBox      =   0   'False
   FillColor       =   &H000000FF&
   ForeColor       =   &H000000FF&
   Height          =   5835
   Left            =   2895
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5328
   ScaleMode       =   0  'User
   ScaleWidth      =   6245.365
   Top             =   1545
   Width           =   6495
   Begin VB.CommandButton ok_res 
      Caption         =   "OK"
      Height          =   492
      Left            =   2760
      TabIndex        =   0
      Top             =   4680
      Width           =   1092
   End
   Begin VB.Label nb_q_tot 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   2
      Left            =   5400
      TabIndex        =   43
      Top             =   3000
      Width           =   492
   End
   Begin VB.Label nb_q_tot 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   1
      Left            =   4080
      TabIndex        =   42
      Top             =   3000
      Width           =   492
   End
   Begin VB.Label nb_q_tot 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   0
      Left            =   2760
      TabIndex        =   41
      Top             =   3000
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   11
      Left            =   5400
      TabIndex        =   40
      Top             =   2280
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   10
      Left            =   5400
      TabIndex        =   39
      Top             =   1800
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   9
      Left            =   5400
      TabIndex        =   38
      Top             =   1320
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   8
      Left            =   5400
      TabIndex        =   37
      Top             =   840
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   7
      Left            =   4080
      TabIndex        =   36
      Top             =   2280
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   6
      Left            =   4080
      TabIndex        =   35
      Top             =   1800
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   5
      Left            =   4080
      TabIndex        =   34
      Top             =   1320
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   4
      Left            =   4080
      TabIndex        =   33
      Top             =   840
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   3
      Left            =   2760
      TabIndex        =   32
      Top             =   2280
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   2
      Left            =   2760
      TabIndex        =   31
      Top             =   1800
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   1
      Left            =   2760
      TabIndex        =   30
      Top             =   1320
      Width           =   492
   End
   Begin VB.Label nb_q 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   252
      Index           =   0
      Left            =   2760
      TabIndex        =   29
      Top             =   840
      Width           =   492
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00C0C0C0&
      BorderColor     =   &H00FF0000&
      Height          =   3012
      Left            =   240
      Shape           =   4  'Rounded Rectangle
      Top             =   360
      Width           =   5892
   End
   Begin VB.Label forme_txt 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   2400
      TabIndex        =   28
      Top             =   3720
      Width           =   3492
   End
   Begin VB.Label label1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "La forme choisie est : "
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   10
      Left            =   240
      TabIndex        =   27
      Top             =   3720
      Width           =   2172
   End
   Begin VB.Label moyenne_txt 
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   252
      Left            =   1560
      TabIndex        =   26
      Top             =   4200
      Width           =   2172
   End
   Begin VB.Label label1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "MOYENNE :"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   9
      Left            =   240
      TabIndex        =   25
      Top             =   4200
      Width           =   1332
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808000&
      Height          =   252
      Index           =   11
      Left            =   4800
      TabIndex        =   24
      Top             =   2280
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808000&
      Height          =   252
      Index           =   10
      Left            =   4800
      TabIndex        =   23
      Top             =   1800
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808000&
      Height          =   252
      Index           =   9
      Left            =   4800
      TabIndex        =   22
      Top             =   1320
      Width           =   612
   End
   Begin VB.Label tot 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808000&
      Height          =   252
      Index           =   2
      Left            =   4800
      TabIndex        =   21
      Top             =   3000
      Width           =   612
   End
   Begin VB.Label tot 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   252
      Index           =   1
      Left            =   3480
      TabIndex        =   20
      Top             =   3000
      Width           =   612
   End
   Begin VB.Label tot 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   252
      Index           =   0
      Left            =   2160
      TabIndex        =   19
      Top             =   3000
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808000&
      Height          =   252
      Index           =   8
      Left            =   4800
      TabIndex        =   18
      Top             =   840
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   252
      Index           =   7
      Left            =   3480
      TabIndex        =   17
      Top             =   2280
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   252
      Index           =   6
      Left            =   3480
      TabIndex        =   16
      Top             =   1800
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   252
      Index           =   5
      Left            =   3480
      TabIndex        =   15
      Top             =   1320
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   252
      Index           =   4
      Left            =   3480
      TabIndex        =   14
      Top             =   840
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   252
      Index           =   3
      Left            =   2160
      TabIndex        =   13
      Top             =   2280
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   252
      Index           =   2
      Left            =   2160
      TabIndex        =   12
      Top             =   1800
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   252
      Index           =   1
      Left            =   2160
      TabIndex        =   11
      Top             =   1320
      Width           =   612
   End
   Begin VB.Label res 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   252
      Index           =   0
      Left            =   2160
      TabIndex        =   10
      Top             =   840
      Width           =   612
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Nombre de réponses :"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   8
      Left            =   240
      TabIndex        =   9
      Top             =   0
      Width           =   5892
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Manquantes"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   7
      Left            =   4800
      TabIndex        =   8
      Top             =   360
      Width           =   1212
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Incorrectes"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   6
      Left            =   3480
      TabIndex        =   7
      Top             =   360
      Width           =   1212
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Correctes"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   5
      Left            =   2160
      TabIndex        =   6
      Top             =   360
      Width           =   1212
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "TOTAL"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   4
      Left            =   240
      TabIndex        =   5
      Top             =   3000
      Width           =   1452
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Participe passé"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   3
      Left            =   240
      TabIndex        =   4
      Top             =   2280
      Width           =   1452
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Prétérit"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   2
      Left            =   240
      TabIndex        =   3
      Top             =   1800
      Width           =   1452
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Infinitif anglais"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   1
      Left            =   240
      TabIndex        =   2
      Top             =   1320
      Width           =   1452
   End
   Begin VB.Label label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0C0C0&
      Caption         =   "Infinitif français"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   0
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   1452
   End
End
Attribute VB_Name = "fres"
Attribute VB_Creatable = False
Attribute VB_Exposed = False

Dim p100(0 To 3) As Byte    'tableau de pourcentage de reponses justes --> graphique

Private Sub Form_Load()

'centrage de l'ecran resultats en fonction de la resolution ecran
Left = (l - Width) / 2
Top = (h - Height) / 2

nb_q_posees = nb_q_posees + Not (corr) ' si on arrete en cours d'exo sur un verbe non corrige,
'il faut retrancher 1 au nb de questions posees

Dim txt, textaff As String
    ' affichage des resultats
    Dim t(0 To 2), k, j As Integer
        k = 0
        For i = 0 To 2
            t(i) = 0
            For j = 0 To 3
                If nbq(j) <> 0 Then
                    'nb de reponses justes, fausses, non repondues par forme
                    res(k).Caption = s(j, i) ' ex : 2 (/ 6)
                    ' nb de questions posees par forme
                    textaff = " / " & nbq(j) + Not (corr) ' ex : (2) / 6
                    If i = 0 Then ' si on compte les reponses justes
                        p100(j) = Int(s(j, i) * 100 / (nbq(j) + Not (corr)))
                    End If
                Else
                    res(k).Caption = ""
                    textaff = ""
                    If i = 0 Then ' si on compte les reponses justes
                        p100(j) = 255 ' forme fixe
                    End If
                End If
                nb_q(k).Caption = textaff 'affichage du nb de questions posees par forme
                k = k + 1
                t(i) = t(i) + s(j, i)
            Next j
            tot(i) = t(i)
        Next i
    'si la forme tiree au sort est fixe, on rend invisible la ligne de zeros
    If f <> 4 Then
        res(f).Caption = ""
        res(f + 4).Caption = ""
        res(f + 8).Caption = ""
    End If
    'affichage du nombre total de questions
    For i = 0 To 2
        nb_q_tot(i) = " / " & nb_q_posees * 3
    Next i
    'affichage de la moyenne
    Dim moy As Single
    If nb_q_posees = 0 Then
        moy = 0
    Else
        moy = Int((20 * t(0) / (nb_q_posees * 3)) * 100) / 100
    End If
    If moy >= 10 Then
        moyenne_txt.ForeColor = &H8000& ' on ecrit en vert
    Else
        moyenne_txt.ForeColor = &HFF& ' on ecrit en rouge
    End If
    moyenne_txt.Caption = moy & " / 20"
    
    'affichage de la forme choisie
    Select Case f
    Case 0
        forme_txt.Caption = " à partir de l'infinitif français"
    Case 1
        forme_txt.Caption = " à partir de l'infinitif anglais"
    Case 2
        forme_txt.Caption = " à partir du prétérit"
    Case 3
        forme_txt.Caption = " à partir du participe passé"
    Case 4
        forme_txt.Caption = " aléatoire"
    End Select
End Sub


Private Sub ok_res_Click()
' on sauvegarde les pourcentages de reponses justes pour le graphique
    Dim nomfic As String
    Dim numfic, longfic, i As Integer
    numfic = FreeFile()
    nomfic = CurDir$ & "\graph.jcc"
    On Error GoTo non_acces_disk 'permet de masquer les erreurs du a l'ouverture ou creation de fichier incorrectes (par ex à partir d'un CD)
    Open nomfic For Binary As numfic
    longfic = LOF(numfic)
    If longfic \ 4 = 15 Then 'si il y a deja 15 enregistrements
        Dim a As Byte
        For i = 5 To 60 ' on decale les 14 derniers enregistrements
            Get numfic, i, a
            Put numfic, i - 4, a
        Next i
        For i = 0 To 3 ' on met les 30ieme enregistrement a la fin du fichier
            Put numfic, 57 + i, p100(i)
        Next i
    Else
        For i = 0 To 3 ' sinon on met l'enregistrement a la fin du fichier
            Put numfic, longfic + 1 + i, p100(i)
        Next i
    End If
    
    ' si il y a 2 points ou plus dans le fichier, on peut avoir acces au graphique
    If longfic >= 2 Then
        Form1.graphevol.Enabled = True
    End If
    
    Close numfic
non_acces_disk:
    
    Unload fres
    etat_fin_exo
End Sub



