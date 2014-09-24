Attribute VB_Name = "Module1"
Option Explicit
' n : nb de questions à poser
' f : forme d'exercice choisit
'       0 : tjs francais
'       1 : tjs infinitif anglais
'       2 : tjs preterit
'       3 : tjs participe passé
'       4 : aléatoire
' maxv : nb de verbes max pour interro
Global n, f, maxv As Integer

Global i, nbvex As Integer ' nbvex : nb de verbes pour l'exo, i pour les boucles for/next

Global vs, fs As Integer ' vs : verbe tiré au sort, fs : forme tirée au sort

Global v(1 To 135, 0 To 3) As String 'tableau contenant les 4 formes de tous les verbes (0 to 3)

Global dc(1 To 135) As Byte ' tableau Deja Choisi : si le verbe a deja été choisi 1 sinon 0

'tableau contenant les statistiques :
' 1ere dimension : les 4 formes
' 2eme dimension :
' 0 : nb de reponses justes
' 1 : nb de reponses fausses
' 2 : nb de non reponses
Global s(0 To 3, 0 To 2) As Integer

Global nom As String ' nom du fichier de parametre

'tableau contenant les indices dans le tableau v des verbes
' de debut et de fin pour chaque lettre
' exemple : la lettre E commence à l'indice 32 =>intervalle(5,1) =32
' si la lettre n'existe pas on trouve -1
' ceci permet de reviser les verbes par intervalle de lettre
' exemple : reviser les verbes de la lettre D à la lettre E comprise
Global intervalle(1 To 26, 1 To 2) As Integer

Global debut_interv, fin_interv As Integer ' debut et fin de l'intervalle

Global h, l As Integer 'hauteur et largeur de l'ecran

Global nbq(0 To 3) As Integer 'compteur du nombre de verbes poses par forme

Global ver_enr As Boolean 'booleen disant si la version est enregistree ou non

Global nb_q_posees As Integer ' nb de questions posees au cours d'un exercice

Global ts_verbes As Boolean ' dit si l'option tous les verbes est choisie

Global compteur As Integer ' compteur pour limiter l'execution à 3 minutes

Global corr As Boolean ' indique si le verbe en cours a été corrigé ou non

'et donc s'il doit etre pris en compte dans les resultats
'(en cas d'arret en cours d'exercice)
Sub etat_fin_exo()
    Form1.b_corr.Visible = False
    Form1.b_suiv.Visible = False
    Form1.b_res.Visible = False
    Form1.drapeau.Visible = True
    
    For i = 0 To 3
        Form1.saisie(i).Text = ""
        Form1.saisie(i).Visible = False
        Form1.aff(i).Visible = False
        Form1.correction(i).Caption = ""
        Form1.correction(i).Visible = False
        Form1.label1(i).Visible = False
    Next i
    
    Form1.param.Enabled = True ' l'exercice terminé, on peut acceder au menu "paramétres"
    Form1.debut.Enabled = True ' l'exercice terminé, on peut acceder au menu "debut de l'exo"
    Form1.fin.Enabled = False ' l'exercice terminé, on ne peut pas acceder au menu "fin de l'exo"
    Form1.arret.Enabled = True ' l'exercice terminé, on peut acceder au menu "Quitter"
    Form1.liste.Enabled = True ' l'exercice terminé, on peut acceder au menu "Liste des verbes"
End Sub

Sub interro()
    If debut_interv = 1 And fin_interv = 1 Then
    'intervalle A-A choisi ne comportant qu'un verbe (si on laisse le RND, 2 nombres peuvent
    'etre tires au sort, c'est pour cela que vs est designe)
        vs = 1
    ElseIf debut_interv = 5 Then
    'intervalle E-E choisi ne comportant qu'un verbe (si on laisse le RND, 2 nombres peuvent
    'etre tires au sort, c'est pour cela que vs est designe)
        vs = 33
    Else
        Do
            ' Int((bornesupérieure - borneinférieure + 1) * Rnd + borneinférieure)
            vs = Int((intervalle(fin_interv, 2) - intervalle(debut_interv, 1) + 1) * Rnd + intervalle(debut_interv, 1)) ' choisit un verbe pour interro
        Loop Until dc(vs) = 0 ' non deja choisit
        dc(vs) = 1 ' le verbe numero vs est choisit
    End If

    ' affichage dans la forme choisie
    If f = 4 Then
        ' forme tirée au sort
        fs = Int(Rnd * 3)
        Form1.saisie(fs).Visible = False
        Form1.aff(fs).Visible = True
        Form1.aff(fs).Caption = v(vs, fs)
    Else
        ' forme imposée
        Form1.saisie(fs).Visible = False
        Form1.aff(fs).Visible = True
        Form1.aff(fs).Caption = v(vs, fs)
    End If
    
    For i = 0 To 3
        If i <> fs Then nbq(i) = nbq(i) + 1 'increment du compteur du nombre de verbes poses par forme
    Next i
    
    nb_q_posees = nb_q_posees + 1
   
   If fs = 0 Then ' si la forme tiree au sort est le francais
       'on donne la main à la 2eme case de saisie
       Form1.saisie(1).SetFocus
   Else
       'sinon on donne la main à la 1ere case
       Form1.saisie(0).SetFocus
   End If
End Sub


