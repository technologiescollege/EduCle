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
package fr.acversailles.crdp.imagesActives.textes.legendesHautBas {
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.DispositionLegendesHautBas;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionLegendesHautBas;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.ZoneTexteAvecDefilement;
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneTexteLegendesHautBas extends ZoneTexteAvecDefilement {
		private var selecteurs : Vector.<ISelecteurLegende> = new Vector.<ISelecteurLegende>();
		private var formatTitre : TextFormat;
		private var formatTexte : TextFormat;
		private var reponseAffichee : Boolean;
		private var hauteurZoneTexteSansBouton : Number;
		private var hauteurZoneTexteAvecBouton : Number;
		private var bordDroitTexteSansGlissiere : Number;

		public function ZoneTexteLegendesHautBas(disposition : IDispositionLegendesHautBas) {
			super(disposition);
			placerSelecteurs();
		}

		override public function construire(nameSpaceComportement : Namespace) : void {
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					creerZoneTexte();
					super.construire(nameSpaceComportement);
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					reponseAffichee = false;
					creerBouton(nameSpaceComportement);
					creerZoneTexte();
					super.construire(nameSpaceComportement);
					
					positionnerBouton();
					break;
				default:
					assertTrue("ce type d'affichage n'existe pas :" + _disposition.typeAffichage, false);
			}
			afficherDescriptionOuConsigne();
		}

		private function positionnerBouton() : void {
			if (!boutonReponse) return;
			boutonReponse.y = zoneTexte.getBounds(this).bottom;
			boutonReponse.x = _disposition.largeurFond - boutonReponse.width;
		}

		override protected function definirCouleurFleches() : uint {
			return ContenuXML.instance.getParametreCouleur("color_3");
		}

		override protected function creerFleches() : void {
			super.creerFleches();
			bordDroitTexteSansGlissiere = zoneTexte.getBounds(this).right;
		}

		override protected function delimiterBarreDefilement() : void {			
			flecheHaut.x = flecheBas.x = bordDroitTexteSansGlissiere - flecheHaut.width;
			flecheBas.y = zoneTexte.getBounds(this).bottom - flecheBas.height;
			flecheHaut.y = zoneTexte.getBounds(this).top;
			flecheBas.x += flecheBas.width;
			flecheBas.y += flecheBas.height;
			super.delimiterBarreDefilement();
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = true;
			zoneTexte.multiline = true;
			zoneTexte.mouseWheelEnabled = false;
			zoneTexte.mouseEnabled = true;
			zoneTexte.wordWrap = true;
			zoneTexte.x = _disposition.xFond;
			zoneTexte.y = selecteurs[0].sprite.getBounds(this).bottom + (_disposition as IDispositionLegendesHautBas).getMargeInfSelecteurs();
			zoneTexte.width = _disposition.largeurFond;
			if ((_disposition as IDispositionLegendesHautBas).getPosition() == DispositionLegendesHautBas.TOP)
				hauteurZoneTexteSansBouton = _disposition.yFond - zoneTexte.y - (_disposition as IDispositionLegendesHautBas).getMargeInfLegende();
			else if ((_disposition as IDispositionLegendesHautBas).getPosition() == DispositionLegendesHautBas.BOTTOM)
				hauteurZoneTexteSansBouton = _disposition.hauteurTotale - zoneTexte.y - (_disposition as IDispositionLegendesHautBas).getMargeInfLegende() - _disposition.hauteurOngletZoneInfosDroits() - _disposition.hauteurVisibleZoneInfos();
			hauteurZoneTexteAvecBouton = hauteurZoneTexteSansBouton - (boutonReponse ? boutonReponse.height : 0);
			appliquerHauteur();
			addChild(zoneTexte);
		}

		private function placerSelecteurs() : void {
			var nbSelecteurs : uint = SVGWrapper.instance.getNbDetails();
			var largeurSelecteur : Number = (_disposition as IDispositionLegendesHautBas).getLargeurSelecteurs();
			var selecteur : ISelecteurLegende;
			var position : Point;
			for (var i : int = 0; i < nbSelecteurs; i++) {
				selecteur = new SelecteurLegende(largeurSelecteur, i + 1);
				position = (_disposition as IDispositionLegendesHautBas).getPositionSelecteur(i);
				selecteur.sprite.x = position.x;
				selecteur.sprite.y = position.y;
				selecteurs.push(selecteur);
				addChild(selecteur.sprite);
			}
		}

		override protected function gererMouseOver(event : MouseEvent) : void {
		}

		override protected function gererMouseDown(event : MouseEvent) : void {
			if (event.target is SelecteurLegende) {
				var numeroLegende : uint = (event.target as SelecteurLegende).numero - 1;
				dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE, numeroLegende));
			}
			super.gererMouseDown(event);
		}

		override protected function gererMouseOut(event : MouseEvent) : void {
		}

		override public function afficherLegendeOuQuestion(numero : int) : void {
			super.afficherLegendeOuQuestion(numero);
			for each (var selecteur : ISelecteurLegende in selecteurs) {
				selecteur.selectionner(numero == selecteur.numero - 1);
			}
			appliquerFormat(false);
			var titre : String = "";
			var texte : String = "";
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					titre = SVGWrapper.instance.getTitreLegendeDetail(numero);
					texte = SVGWrapper.instance.getTexteLegendeDetail(numero);
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					titre = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "question_title") + (numero + 1) + " - " + SVGWrapper.instance.getTexteQuestionDetail(numero);
					if (reponseAffichee)
						texte = SVGWrapper.instance.getReponseQuestionDetail(numero);
					afficherBoutonReponse(!reponseAffichee);
					break;
				default:
					assertFalse("On est soit en affichage de légendes soit en affichage de questions", true);
			}
			afficherTexte(titre, texte);
			reponseAffichee = false;
			// on le remet à faux
		}

		override public function afficherReponse(numero : int) : void {
			reponseAffichee = true;
			afficherLegendeOuQuestion(numero);
		}

		private function appliquerFormat(descriptionOuConsigne : Boolean) : void {
			var selecteurCSSTexte : String = descriptionOuConsigne ? ".description_text" : ".caption_text";
			var selecteurCSSTitre : String = descriptionOuConsigne ? ".description_title" : ".caption_title";

			formatTexte = StylesCSS.instance.styleToTextFormat(selecteurCSSTexte);
			formatTitre = StylesCSS.instance.styleToTextFormat(selecteurCSSTitre);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(formatTexte.font) && SVGWrapper.instance.policeExiste(formatTitre.font);
		}

		override public function afficherDescriptionOuConsigne() : void {
			appliquerFormat(false);
			for each (var selecteur : ISelecteurLegende in selecteurs) {
				selecteur.selectionner(false);
			}
			var titre : String;
			var texte : String;
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					titre = SVGWrapper.instance.titreDescription;
					texte = SVGWrapper.instance.texteDescription;
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					titre = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_title");
					texte = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_text");
					afficherBoutonReponse(false);
					break;
				default:
					assertFalse("On est soit en affichage de légendes soit en affichage de questions", true);
			}
			afficherTexte(titre, texte);
		}

		private function afficherTexte(titre : String, texte : String) : void {
			zoneTexte.scrollV = 0;
			var texteComplet : String = titre + "\n" + texte;
			
			var tableauLiens : Array = AnalyseurLiens.analyserTexte(texteComplet);
			zoneTexte.text = AnalyseurLiens.supprimerLiens(texteComplet);

			if (titre.length>0 && texte.length > 0)
				zoneTexte.setTextFormat(formatTexte, titre.length + 1, zoneTexte.text.length);
			AnalyseurLiens.implanterLiens(zoneTexte, tableauLiens);
			if (titre.length > 0)
				zoneTexte.setTextFormat(formatTitre, 0, titre.length);
			//TODO pas terrible
			//zoneTexte.text = SVGWrapper.instance.enleverCaracteresSansFonts(formatTexte.font, zoneTexte.text);
			//zoneTexte.text = SVGWrapper.instance.enleverCaracteresSansFonts(formatTitre.font, zoneTexte.text);
			appliquerHauteur();
			debordement = zoneTexte.textHeight +4 > zoneTexte.height;
			zoneTexte.width = _disposition.largeurFond - (debordement ? flecheHaut.width : 0);
			gererDebordement();
			positionnerBouton();
		}

		private function appliquerHauteur() : void {
			if ((_disposition as IDispositionLegendesHautBas).getPosition() == DispositionLegendesHautBas.TOP && _disposition.typeAffichage == Disposition.AFFICHAGE_QUESTIONS && boutonReponse.visible)
				zoneTexte.height = hauteurZoneTexteAvecBouton;
			else zoneTexte.height = hauteurZoneTexteSansBouton;
		}

		override public function masquerTexte() : void {
			// ne rien faire
		}
	}
}
