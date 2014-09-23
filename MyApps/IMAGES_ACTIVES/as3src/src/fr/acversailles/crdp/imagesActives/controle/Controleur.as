 /**
 * Copyright (c) 2011 Centre Régional de Documentation Pédagogique de l'Académie de Versailles 
 * Images Actives is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * at your option) any later version.
 * Images Actives is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Images Actives.  If not, see <http://www.gnu.org/licenses/>.
 **/
package fr.acversailles.crdp.imagesActives.controle {
	import fr.acversailles.crdp.imagesActives.ImageActive;
	import fr.acversailles.crdp.imagesActives.credits.SupportFenetreCredits;
	import fr.acversailles.crdp.imagesActives.image.IZoneImage;
	import fr.acversailles.crdp.imagesActives.infos.EtatsZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.infos.IZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import org.flexunit.asserts.assertNotNull;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class Controleur implements IControleur {
		protected static const ETAT_REPOS : uint = 0;
		protected static const ETAT_EMPHASE_LEGERE : uint = 1;
		protected static const ETAT_EMPHASE_FORTE : uint = 2;
		protected static const ETAT_ZOOM : uint = 3;
		protected static const ETAT_ATTENTE_SYNCHRO : uint = 4;
		protected static const ETAT_EMPHASE_LEGERE_TOUS_DETAIL : uint = 5;
		protected static const ETAT_ATTENTE_MOT_DE_PASSE : uint = 6;
		protected var zoneImage : IZoneImage;
		protected var zoneTexte : IZoneTexte;
		private var curseur : Sprite;
		protected var zoneInfosDroits : IZoneInfosDroits;
		protected var etat : uint;
		protected var numeroDetailEmphase : uint;
		protected var animation : ImageActive;
		private var supportFenetreCredits : SupportFenetreCredits;
		
		protected var _ns : Namespace;

		public function Controleur(zoneImage : IZoneImage, zoneTexte : IZoneTexte, zoneInfosDroits : IZoneInfosDroits, supportFenetreCredits : SupportFenetreCredits, main : ImageActive) {
			assertNotNull("Définissez un espace de nommage xml pour ce behavior", _ns);
			this.supportFenetreCredits = supportFenetreCredits;
			this.animation = main;
			this.zoneInfosDroits = zoneInfosDroits;
			this.zoneTexte = zoneTexte;
			this.zoneImage = zoneImage;

			afficherFenetreCredits(false);

			zoneTexte.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE, gererActionUtilisateur);
			zoneTexte.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION, gererActionUtilisateur);
			zoneTexte.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_OVER_LEGENDE, gererActionUtilisateur);
			zoneTexte.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_OUT_LEGENDE, gererActionUtilisateur);
			zoneTexte.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_REPONSE, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_DETAIL, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_FOND_IMAGE, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_MOVE_DETAIL, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_MOVE_FOND_IMAGE, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(SynchronisationEvent.FIN_DEZOOM, gererEvenementSynchro);
			zoneImage.sprite.addEventListener(SynchronisationEvent.FIN_ZOOM, gererEvenementSynchro);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_DETAIL_PUCE, gererActionUtilisateur);
			zoneImage.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_MOVE_DETAIL_PUCE, gererActionUtilisateur);
			zoneInfosDroits.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_OVER_ZONE_INFOS_DROITS, gererActionZoneInfosDroits);
			zoneInfosDroits.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_OUT_ZONE_INFOS_DROITS, gererActionZoneInfosDroits);
			zoneInfosDroits.sprite.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_ZONE_INFOS_DROITS, gererActionZoneInfosDroits);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_AFFICHER_DETAILS, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_OUT_BOUTON_AFFICHER_DETAILS, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_UP_SCENE, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_OUT_ZONE_IMAGE, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_FOND_SCENE, gererActionUtilisateur);
			main.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_INFOS, gererDemandeAffichageInfos);
			supportFenetreCredits.addEventListener(ActionUtilisateurEvent.MOUSE_DOWN_FENETRE_CREDITS, gererDemandeMasquageInfos);
		}

		private function gererDemandeMasquageInfos(event : ActionUtilisateurEvent) : void {
			afficherFenetreCredits(false);
		}

		private function gererDemandeAffichageInfos(event : ActionUtilisateurEvent) : void {
			afficherFenetreCredits(true);
		}

		private function afficherFenetreCredits(boolean : Boolean) : void {
			supportFenetreCredits.visible = boolean;
			if (boolean)
				supportFenetreCredits.parent.setChildIndex(supportFenetreCredits, supportFenetreCredits.parent.numChildren - 1);
		}

		protected function setEtat(etat : uint, numero : uint = -1) : void {
			this.etat = etat;
			this.numeroDetailEmphase = numero;
			switch(etat) {
				case ETAT_EMPHASE_LEGERE:
					curseurSpecial(Curseur.INFO);
					break;
				case ETAT_EMPHASE_FORTE:
					break;
				case ETAT_REPOS:
					break;
				case ETAT_ATTENTE_MOT_DE_PASSE:
					break;
				case ETAT_ZOOM:
					curseurSpecial(Curseur.DEZOOM);
					break;
			}
		}

		private function gererActionZoneInfosDroits(event : ActionUtilisateurEvent) : void {
			switch(event.type) {
				case ActionUtilisateurEvent.MOUSE_OVER_ZONE_INFOS_DROITS:
					if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_REPOS)
						zoneInfosDroits.souleverLegerement();
					break;
				case ActionUtilisateurEvent.MOUSE_OUT_ZONE_INFOS_DROITS:
					if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SOULEVE)
						zoneInfosDroits.replacer();
					else if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SORTI)
						zoneInfosDroits.replacer();
					break;
				case ActionUtilisateurEvent.MOUSE_DOWN_ZONE_INFOS_DROITS:
					if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SOULEVE)
						zoneInfosDroits.sortir();
					else if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_REPOS)
						zoneInfosDroits.sortir();
					else if (zoneInfosDroits.etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SORTI)
						zoneInfosDroits.replacer();
					break;
			}
		}

		protected function controleEtatZoom(type : String, numero : uint) : void {
			numero = numero;
			if (type == ActionUtilisateurEvent.MOUSE_DOWN_DETAIL || type == ActionUtilisateurEvent.MOUSE_DOWN_FOND_IMAGE) {
				zoneImage.dezoomerDetail(this.numeroDetailEmphase);
				zoneInfosDroits.replacer();
				zoneImage.afficherFondZoom(false);
				curseurNormal();
				setEtat(ETAT_ATTENTE_SYNCHRO, this.numeroDetailEmphase);
			}
		}

		protected function gererEvenementSynchro(event : SynchronisationEvent) : void {
			switch(etat) {
				case ETAT_ATTENTE_SYNCHRO :
					controleEtatAttenteSynchro(event.type, 0);
					break;
			}
		}

		protected function controleEtatAttenteSynchro(type : String, numero : uint) : void {
			numero = numero;
			if (type == SynchronisationEvent.FIN_ZOOM) {
				setEtat(ETAT_ZOOM, this.numeroDetailEmphase);
				curseurSpecial(Curseur.DEZOOM);
			} else if (type == SynchronisationEvent.FIN_DEZOOM) {
				// TODO comportement différent en audio...
				// controleEtatEmphaseLegere(ActionUtilisateurEvent.MOUSE_DOWN_DETAIL, this.numeroDetailEmphase);
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				zoneTexte.arreterSon();
				setEtat(ETAT_REPOS);
				curseurNormal();
			}
		}

		protected function gererActionUtilisateur(event : ActionUtilisateurEvent) : void {
			avertirClasseAbstraite();
		}

		protected function curseurSpecial(type : uint) : void {
			if (this.curseur && ImageActive.supportCurseur.contains(this.curseur))
				ImageActive.supportCurseur.removeChild(this.curseur);
			this.curseur = Curseur.donnerIcone(type);
			ImageActive.supportCurseur.addChild(this.curseur);
			suiviCurseur(true);
			positionnementInitial();
			Mouse.hide();
		}

		private function positionnementInitial() : void {
			curseur.x = zoneImage.sprite.mouseX;
			curseur.y = zoneImage.sprite.mouseY;
		}

		protected function curseurNormal() : void {
			if (this.curseur && ImageActive.supportCurseur.contains(this.curseur))
				ImageActive.supportCurseur.removeChild(this.curseur);
			suiviCurseur(false);
			Mouse.show();
		}

		private function suiviCurseur(boolean : Boolean) : void {
			if (boolean)
				zoneImage.sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, deplacerCurseur);
			else
				zoneImage.sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, deplacerCurseur);
		}

		private function deplacerCurseur(event : MouseEvent) : void {
			curseur.x = event.stageX;
			curseur.y = event.stageY;
		}

		public function get ns() : Namespace {
			return _ns;
		}
	}
}
