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
package fr.acversailles.crdp.imagesActives.textes.legendesCouvrantes {
	import fr.acversailles.crdp.utils.functions.centrer;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;

	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAvecDefilement;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionLegendesCouvrantes;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.ZoneTexteAvecDefilement;
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneTexteLegendesCouvrantes extends ZoneTexteAvecDefilement {
		private static const DUREE_APPARITION : Number = 4;
		private var fondBoite : Shape;
		private var padding : Number;
		private var rayon : Number;
		private var tweenAlpha : Tween;
		private var couleurEnTete : uint;
		private var policeTitre : String;
		private var policeTexte : String;

		public function ZoneTexteLegendesCouvrantes(disposition : IDispositionLegendesCouvrantes) {
			super(disposition);
			padding = (_disposition as IDispositionLegendesCouvrantes).getPaddingLegendes();
			rayon = (_disposition as IDispositionLegendesCouvrantes).getRayonLegendes();
			visible = false;
			creerTween();
		}

		override public function construire(nameSpaceComportement : Namespace) : void {
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:					
					super.construire(nameSpaceComportement);
					mettreZoneTexte();
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					
					couleurEnTete = definirCouleurEnTete();					
					super.construire(nameSpaceComportement);
					creerBouton(nameSpaceComportement);
					mettreZoneTexte();
					afficherDescriptionOuConsigne();
					break;
				default:
					assertTrue("ce type d'affichage n'existe pas :" + _disposition.typeAffichage, false);
			}
		}

		private function creerTween() : void {
			tweenAlpha = new Tween(this, "alpha", Regular.easeOut, 0, 1, DUREE_APPARITION);
			tweenAlpha.stop();
		}

		override protected function definirCouleurFleches() : uint {
			return ContenuXML.instance.getParametreCouleur("color_2");
		}

		private function definirCouleurEnTete() : uint {
			return ContenuXML.instance.getParametreCouleur("color_2");
		}

		private function mettreZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTitre = new TextField();
			zoneTexte.multiline = true;
			zoneTitre.multiline = true;
			zoneTitre.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.wordWrap = true;
			zoneTitre.wordWrap = true;
			zoneTexte.selectable = true;
			zoneTitre.selectable = false;
			zoneTexte.antiAliasType = AntiAliasType.ADVANCED;
			zoneTitre.antiAliasType = AntiAliasType.ADVANCED;
			zoneTexte.mouseEnabled = true;
			zoneTexte.mouseWheelEnabled = false;
			zoneTitre.mouseEnabled = false;
			zoneTitre.mouseWheelEnabled = false;
			addChild(zoneTitre);
			addChild(zoneTexte);
		}

		protected function appliquerFormat(descriptionOuConsigne : Boolean) : void {
			var selecteurTexte : String = descriptionOuConsigne ? ".description_text" : ".caption_text";
			var selecteurTitre : String = descriptionOuConsigne ? ".description_title" : ".caption_title";
			 policeTitre  = StylesCSS.instance.styleToTextFormat(selecteurTitre).font;
			zoneTitre.embedFonts = SVGWrapper.instance.policeExiste(policeTitre);
			 policeTexte = StylesCSS.instance.styleToTextFormat(selecteurTexte).font;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(policeTexte);
			zoneTexte.defaultTextFormat = StylesCSS.instance.styleToTextFormat(selecteurTexte);
			zoneTitre.defaultTextFormat = StylesCSS.instance.styleToTextFormat(selecteurTitre);
		}

		private function dessinerFond() : void {
			if (!fondBoite) {
				fondBoite = new Shape();
				addChildAt(fondBoite, 0);
				fondBoite.filters = [new DropShadowFilter(3)];
			}
			fondBoite.graphics.clear();

			var largeur : Number = 2 * padding + zoneTitre.width;

			var hauteur : Number = Math.min(2 * padding + zoneTitre.height + zoneTexte.height, (_disposition as IDispositionLegendesCouvrantes).getHauteurZoneTexte());
			var couleurFond : uint = ContenuXML.instance.getParametreCouleur("color_3");
			var alphaLegendes : Number = (_disposition as IDispositionLegendesCouvrantes).getAlphaLegendes();
			fondBoite.graphics.beginFill(couleurFond, alphaLegendes);
			if (debordement)
				fondBoite.graphics.drawRoundRectComplex(0, 0, largeur, hauteur, rayon, 0, rayon, 0);
			else
				fondBoite.graphics.drawRoundRect(0, 0, largeur, hauteur, rayon);
			fondBoite.graphics.endFill();

			if (debordement) {
				fondBoite.graphics.beginFill(couleurFond, alphaLegendes);
				fondBoite.graphics.drawRoundRectComplex(largeur, 0, (_disposition as IDispositionLegendesCouvrantes).getLargeurScrollbar(), hauteur, 0, rayon, 0, rayon);
				fondBoite.graphics.endFill();
				fondBoite.graphics.beginFill(0x000000, 0.05);
				fondBoite.graphics.drawRoundRectComplex(largeur, 0, (_disposition as IDispositionLegendesCouvrantes).getLargeurScrollbar(), hauteur, 0, rayon, 0, rayon);
				fondBoite.graphics.endFill();
			}
			// on dessine un en-tête
			if (_disposition.typeAffichage == Disposition.AFFICHAGE_QUESTIONS) {
				// TODO pb inexpliqué, l'angle ne recouvre pas bien
				var rayonSpecial : Number = debordement ? rayon : rayon / 2;
				fondBoite.graphics.beginFill(couleurEnTete, 0.5);
				fondBoite.graphics.drawRoundRectComplex(0, 0, largeur + (debordement ? (_disposition as IDispositionLegendesCouvrantes).getLargeurScrollbar() : 0), hauteurFondEnTeteQuestion(), rayonSpecial, rayonSpecial, 0, 0);
				fondBoite.graphics.endFill();
			}
		}

		private function hauteurFondEnTeteQuestion() : Number {
			return padding + zoneTitre.textHeight + zoneTexte.getLineMetrics(0).height / 2;
		}

		override public function afficherLegendeOuQuestion(numero : int) : void {
			super.afficherLegendeOuQuestion(numero);
			actualiserTexte(numero);
			dessinerFond();
			positionnerlegende(numero);
			if (boutonReponse) positionnerBouton();
			tweenAlpha.start();
		}

		private function actualiserTexte(numero : int, avecReponse : Boolean = false) : void {
			appliquerFormat(numero == -1);
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					actualiserTexteAvecLegendes(numero);
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					actualiserTexteAvecQuestionsReponses(numero, avecReponse);
					break;
			}
			//zoneTexte.text = SVGWrapper.instance.enleverCaracteresSansFonts(policeTexte, zoneTexte.text);
			//zoneTitre.text = SVGWrapper.instance.enleverCaracteresSansFonts(policeTitre, zoneTitre.text);
		}

		private function positionnerBouton() : void {
			boutonReponse.y = fondBoite.getBounds(this).bottom + (_disposition as IDispositionAvecDefilement).getMargeSupBoutonreponse();
			boutonReponse.x = fondBoite.x;
		}

		private function positionnerlegende(numero : int, nePasDeplacer : Boolean = false) : void {
			// nePasDeplacer à true si affichage réponse : la boîte doit
			// donner 'limpression de rester immobile
			visible = true;
			parent.setChildIndex(this, parent.numChildren - 1);
			fondBoite.visible = true;
			if (numero == -1) {
				assertFalse("l'affichage de la description générale ou de la consigne n'est jamais un affichage de réponse", nePasDeplacer);
				positionnerBoiteDescription();
			} else if (!nePasDeplacer) {
				positionnerBoiteLegende(numero);
			}

			zoneTitre.x = zoneTexte.x = fondBoite.x + padding;
			zoneTitre.y = fondBoite.y + padding;
			zoneTexte.y = zoneTitre.getBounds(this).bottom;
			flecheBas.visible = flecheHaut.visible = debordement;

			if (debordement) {
				flecheHaut.x = fondBoite.x + 2 * padding + zoneTitre.width + ( (_disposition as IDispositionLegendesCouvrantes).getLargeurScrollbar() - flecheHaut.width) / 2;
				flecheBas.x = flecheHaut.x + flecheBas.width;
				flecheBas.y = zoneTexte.getBounds(this).bottom - flecheBas.height;
				flecheHaut.y = fondBoite.y+hauteurFondEnTeteQuestion();
			}
			gererDebordement();
		}

		private function positionnerBoiteDescription() : void {
			centrer(fondBoite, _disposition.largeurTotale);
			fondBoite.y = _disposition.yFond;
		}

		private function positionnerBoiteLegende(numero : uint) : void {
			var directionLegende : Point = (_disposition as IDispositionLegendesCouvrantes) .getDirectionLegende(numero);
			var departLegende : Point = (_disposition as IDispositionLegendesCouvrantes) .getDepartLegende(numero);

			var posBoite : Point;
			var deplacement : Number = 0;
			var collision : Boolean = true;
			var collisionAvant : Boolean;
			var sortieImage : Boolean;
			var premierEssai : Boolean = true;
			var sortieImageAuDepart : Boolean;
			do {
				posBoite = Point.interpolate(directionLegende, departLegende, deplacement);
				fondBoite.x = posBoite.x - fondBoite.width / 2;
				fondBoite.y = posBoite.y - fondBoite.height / 2;
				deplacement += 0.05;
				collisionAvant = collision;
				collision = (_disposition as IDispositionLegendesCouvrantes).collisionDetail(numero, fondBoite.getBounds(this));
				sortieImage = (_disposition as IDispositionLegendesCouvrantes).sortieImage(fondBoite.getBounds(this));

				if (premierEssai) {
					premierEssai = false;
					sortieImageAuDepart = sortieImage;
				}
			} while (collisionAvant && deplacement < 2 && (!sortieImage || sortieImageAuDepart));
		}

		private function actualiserTexteAvecLegendes(numero : int) : void {
			if (numero == -1) {
				zoneTitre.text = SVGWrapper.instance.titreDescription;
				zoneTexte.text = SVGWrapper.instance.texteDescription;
			} else {
				zoneTitre.text = SVGWrapper.instance.getTitreLegendeDetail(numero);
				zoneTexte.text = SVGWrapper.instance.getTexteLegendeDetail(numero);
			}
			AnalyseurLiens.activerLiens(zoneTexte);
			reconfigurerBoite(numero);
			afficherBoutonReponse(false);
		}

		private function reconfigurerBoite(numero : int) : void {
			var hauteurMaxZoneTexte : Number;
			if (numero >= 0) {
				zoneTitre.width = zoneTexte.width = (_disposition as IDispositionLegendesCouvrantes).getLargeurZoneTexte();
				hauteurMaxZoneTexte = (_disposition as IDispositionLegendesCouvrantes).getHauteurZoneTexte();
			} else {
				zoneTitre.width = zoneTexte.width = _disposition.largeurTotale - ParametresXML.instance.unite * 2;
				hauteurMaxZoneTexte = _disposition.hauteurFond / 2;
			}
			var hauteurZoneTexte : Number = 2 * padding + zoneTitre.height + zoneTexte.textHeight;

			if (hauteurZoneTexte > hauteurMaxZoneTexte) {
				zoneTexte.height = (_disposition as IDispositionLegendesCouvrantes).getHauteurZoneTexte() - (2 * padding + zoneTitre.height);
				debordement = true;
			} else {
				zoneTexte.height = zoneTexte.textHeight + 4;
				debordement = false;
				
			}
			zoneTexte.y = zoneTitre.getBounds(this).bottom;
			zoneTexte.scrollV = 0;
			gererDebordement();
		}

		private function actualiserTexteAvecQuestionsReponses(numero : int, donnerReponse : Boolean) : void {
			// numero -1 signifie affichage de la description générale ou de la consigne
			if (numero == -1) {
				zoneTitre.text = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_title");
				zoneTexte.text = "\n" + ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_text");
			} else {
				zoneTitre.text = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "question_title") + (numero + 1);
				var texteAvecLiens : String = "\n" + SVGWrapper.instance.getTexteQuestionDetail(numero);
				var longueurQuestion : int = texteAvecLiens.length;
				if (donnerReponse) {
					texteAvecLiens += "\n\n";
					texteAvecLiens += SVGWrapper.instance.getReponseQuestionDetail(numero);
				}
				var tableauLiens : Array = AnalyseurLiens.analyserTexte(texteAvecLiens);
				zoneTexte.text = AnalyseurLiens.supprimerLiens(texteAvecLiens);
				zoneTexte.setTextFormat(StylesCSS.instance.styleToTextFormat(".question_text"), 0, longueurQuestion);
				if (donnerReponse) {
					zoneTexte.setTextFormat(StylesCSS.instance.styleToTextFormat(".caption_text"), longueurQuestion, zoneTexte.text.length);
				}
				AnalyseurLiens.implanterLiens(zoneTexte, tableauLiens);
			}

			reconfigurerBoite(numero);
			// on n'affiche le bouton que si on n'affiche pas la réponse et si le numéro n'est pas -1

			afficherBoutonReponse(!donnerReponse && numero >= 0);
		}

		override public function afficherDescriptionOuConsigne() : void {
			afficherLegendeOuQuestion(-1);
		}

		override public function masquerTexte() : void {
			visible = false;
		}

		override protected function gererMouseOver(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OVER_LEGENDE));
		}

		override protected function gererMouseOut(event : MouseEvent) : void {
			super.gererMouseOut(event);
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OUT_LEGENDE));
		}

		override public function afficherReponse(numero : int) : void {
			actualiserTexte(numero, true);
			dessinerFond();
			positionnerlegende(numero, true);
			tweenAlpha.start();
		}
	}
}
