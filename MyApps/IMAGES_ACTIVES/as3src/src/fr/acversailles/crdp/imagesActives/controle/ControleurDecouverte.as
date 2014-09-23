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
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.image.IZoneImage;
	import fr.acversailles.crdp.imagesActives.infos.IZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.utils.functions.assert;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ControleurDecouverte extends Controleur {
		public function ControleurDecouverte(zoneImage : IZoneImage, zoneTexte : IZoneTexte, zoneInfosDroits : IZoneInfosDroits, supportFenetreCredits:SupportFenetreCredits, main : ImageActive) {
			_ns = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives/behavior/discovery");
			super(zoneImage, zoneTexte, zoneInfosDroits, supportFenetreCredits, main);
			etat = ETAT_REPOS;
			zoneTexte.construire(_ns);
		}

		override protected function gererActionUtilisateur(event : ActionUtilisateurEvent) : void {
			switch(etat) {
				case ETAT_REPOS :
					controleEtatRepos(event.type, event.numero);
					break;
				case ETAT_EMPHASE_LEGERE :
					controleEtatEmphaseLegere(event.type, event.numero);
					break;
				case ETAT_EMPHASE_FORTE :
					controleEtatEmphaseForte(event.type, event.numero);
					break;
				case ETAT_ZOOM :
					controleEtatZoom(event.type, event.numero);
					break;
				case ETAT_ATTENTE_SYNCHRO :
					controleEtatAttenteSynchro(event.type, event.numero);
					break;
				case ETAT_EMPHASE_LEGERE_TOUS_DETAIL :
					controleEtatEmphaseLegereTousDetails(event.type, event.numero);
					break;
			}
		}

		private function controleEtatEmphaseForte(type : String, numero : uint) : void {
			if (type == ActionUtilisateurEvent.MOUSE_DOWN_FOND_IMAGE || type==ActionUtilisateurEvent.MOUSE_DOWN_FOND_SCENE ) {
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				zoneTexte.masquerTexte();
				zoneTexte.arreterSon();
				curseurNormal();
				zoneInfosDroits.replacer();
				setEtat(ETAT_REPOS);
			} else if (type == ActionUtilisateurEvent.MOUSE_MOVE_FOND_IMAGE || type==ActionUtilisateurEvent.MOUSE_OUT_ZONE_IMAGE) {
				curseurNormal();
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL || type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL_PUCE) {
				if (numero != numeroDetailEmphase) {
					curseurNormal();
				} else {
					if (zoneImage.detailZoomable(this.numeroDetailEmphase))
						curseurSpecial(Curseur.ZOOM);
					else curseurNormal();
				}
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_DETAIL ) {
				if (numero != numeroDetailEmphase) {
					zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
					zoneTexte.masquerTexte();
					curseurNormal();
					zoneTexte.arreterSon();
					setEtat(ETAT_REPOS);
					controleEtatRepos(ActionUtilisateurEvent.MOUSE_MOVE_DETAIL, numero);
					zoneInfosDroits.replacer();
				} else if (zoneImage.detailZoomable(this.numeroDetailEmphase)) {
					curseurNormal();
					setEtat(ETAT_ATTENTE_SYNCHRO, this.numeroDetailEmphase);
					zoneInfosDroits.descendreHorsEcran();
					zoneTexte.masquerTexte();
					zoneImage.zoomerDetail(this.numeroDetailEmphase);
					zoneImage.afficherFondZoom(true);
				}
				
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE) {
				if (numero != numeroDetailEmphase) {
					curseurNormal();
					zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
					setEtat(ETAT_EMPHASE_LEGERE, numero);
					controleEtatEmphaseLegere(type, numero);
				}
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION) {
				curseurNormal();
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				setEtat(ETAT_REPOS);
				controleEtatRepos(type, numero);
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_OVER_LEGENDE) {
				curseurNormal();
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_AFFICHER_DETAILS) {
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				curseurNormal();
				setEtat(ETAT_REPOS);
				controleEtatRepos(type, numero);
			}
		}

		private function controleEtatEmphaseLegere(type : String, numero : uint) : void {
			if (type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL || type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL_PUCE) {
				assert(numero >= 0, "Un évènement de souris sur un détail doit avoir un numéro positif ou nul.");
				assert(this.numeroDetailEmphase >= 0, "Le numéro de détail emphasé doit être supérieur ou égal à 0.");
				if (this.numeroDetailEmphase != numero) {
					zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
					zoneImage.emphaseLegereDetail(numero);
					curseurSpecial(Curseur.INFO);
					setEtat(ETAT_EMPHASE_LEGERE, numero);
				}
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_MOVE_FOND_IMAGE || type == ActionUtilisateurEvent.MOUSE_OUT_ZONE_IMAGE || type==ActionUtilisateurEvent.MOUSE_DOWN_FOND_SCENE) {
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				curseurNormal();
				setEtat(ETAT_REPOS);
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_DETAIL || type == ActionUtilisateurEvent.MOUSE_DOWN_DETAIL_PUCE) {
				assert(numero >= 0, "Un évènement de souris sur un détail doit avoir un numéro positif ou nul.");
				assert(numero < SVGWrapper.instance.getNbDetails(), "Il n'y a pas de détail numéro " + numero);
				zoneImage.emphaseForteDetail(numero,  type != ActionUtilisateurEvent.MOUSE_DOWN_DETAIL_PUCE);
				zoneTexte.afficherLegendeOuQuestion(numero);
				setEtat(ETAT_EMPHASE_FORTE, numero);
				if (zoneImage.detailZoomable(this.numeroDetailEmphase))
					curseurSpecial(Curseur.ZOOM);
				else curseurNormal();
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE) {
				assert(numero >= 0, "Un évènement de souris sur un détail doit avoir un numéro positif ou nul.");
				assert(numero < SVGWrapper.instance.getNbDetails(), "Il n'y a pas de détail numéro " + numero);
				zoneImage.emphaseForteDetail(numero, !zoneImage.detailPuce(this.numeroDetailEmphase));
				zoneTexte.afficherLegendeOuQuestion(numero);
				curseurNormal();
				setEtat(ETAT_EMPHASE_FORTE, numero);
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION) {
				zoneImage.aucuneEmphaseDetail(this.numeroDetailEmphase);
				curseurNormal();
				setEtat(ETAT_REPOS);
				controleEtatRepos(type, numero);
				
			}
		}

		private function controleEtatRepos(type : String, numero : uint) : void {
			if (type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL || type == ActionUtilisateurEvent.MOUSE_MOVE_DETAIL_PUCE) {
				assert(numero >= 0, "Un évènement de souris sur un détail doit avoir un numéro positif ou nul.");
				zoneImage.emphaseLegereDetail(numero);

				setEtat(ETAT_EMPHASE_LEGERE, numero);
				curseurSpecial(Curseur.INFO);
				zoneInfosDroits.replacer();
				
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_DETAIL) {
				zoneTexte.masquerTexte();
				setEtat(ETAT_EMPHASE_LEGERE, numero);
				curseurSpecial(Curseur.INFO);
				controleEtatEmphaseLegere(type, numero);
				
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE) {
				setEtat(ETAT_EMPHASE_LEGERE, numero);
				curseurNormal();
				controleEtatEmphaseLegere(type, numero);
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION) {
				curseurNormal();
				zoneTexte.afficherDescriptionOuConsigne();
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_FOND_IMAGE || type==ActionUtilisateurEvent.MOUSE_DOWN_FOND_SCENE) {
				zoneTexte.masquerTexte();
				zoneInfosDroits.replacer();
			} else if (type == ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_AFFICHER_DETAILS) {
				zoneTexte.masquerTexte();
				curseurNormal();
				zoneTexte.arreterSon();
				zoneImage.emphaseTousDetails();
				setEtat(ETAT_EMPHASE_LEGERE_TOUS_DETAIL);
				zoneInfosDroits.replacer();
			}
		}

		private function controleEtatEmphaseLegereTousDetails(type : String, numero : uint) : void {
			numero=numero;
			if (type == ActionUtilisateurEvent.MOUSE_OUT_BOUTON_AFFICHER_DETAILS || type == ActionUtilisateurEvent.MOUSE_UP_SCENE) {
				zoneImage.aucuneEmphaseDetail();
				setEtat(ETAT_REPOS);
				curseurNormal();
			}
		}
	}
}
