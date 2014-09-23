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
package fr.acversailles.crdp.imagesActives.textes.accordeon {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.textes.boutons.BoutonReponse;
	import fr.acversailles.crdp.imagesActives.tooltips.GestionnaireTooltips;

	import flash.display.Shape;
	import flash.filters.DropShadowFilter;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class CorpsCarteBouton extends CorpsCarte {
		private var bouton : BoutonReponse;
		private var reponse : String;
		private var fond : Shape;
		private var fauxfond : Shape;
		private var margeSup : Number;
		private var paddingH : Number;
		private var paddingV : Number;
		private var rayonAngle : Number;
		private var distanceBiseau : Number;
		private var distanceOmbre : Number;
		private var nameSpaceComportement : Namespace;

		public function CorpsCarteBouton(nameSpaceComportement : Namespace, contenu : String, largeur : Number, hauteur : Number, couleur : uint, couleurCurseur : uint, largeurGlissiere : uint, reponse : String, paddingH : Number, paddingV : Number, margeSup : Number, rayonAngle : Number, distanceBiseau : Number, distanceOmbre : Number) {
			this.nameSpaceComportement = nameSpaceComportement;
			this.distanceOmbre = distanceOmbre;
			this.distanceBiseau = distanceBiseau;
			this.rayonAngle = rayonAngle;
			this.paddingV = paddingV;
			this.paddingH = paddingH;
			this.margeSup = margeSup;
			this.reponse = reponse;
			super(contenu, largeur, hauteur, couleur, couleurCurseur, largeurGlissiere);
		}

		private function creerFondQuestion() : void {
			fond = new Shape();
			fauxfond = new Shape();

			fond.cacheAsBitmap = true;
			fauxfond.cacheAsBitmap = true;
			fauxfond.filters = [new DropShadowFilter(distanceOmbre, 45, 0, 0.5)];
		}

		override protected function mettreZoneContenu() : void {
			creerFondQuestion();
			creerBoutonreponse(paddingH, paddingV, margeSup, rayonAngle, distanceBiseau, distanceOmbre);
			super.mettreZoneContenu();
			positionnerBoutonreponse();
			ajouterFondQuestion();
			dessinerFondQuestion();
		}

		private function ajouterFondQuestion() : void {
			supportZoneContenu.addChildAt(fond, 0);
			supportZoneContenu.addChildAt(fauxfond, 0);
			// repasser sous la glissière;
			supportZoneContenu.parent.setChildIndex(supportZoneContenu, 0);
		}

		private function dessinerFondQuestion() : void {
			fond.graphics.clear();
			fauxfond.graphics.clear();
			var largeurFond : Number = largeur - (glissiere != null ? glissiere.width : 0);
			fond.graphics.beginFill(ContenuXML.instance.getParametreCouleur("color_1"), 0.5);
			fauxfond.graphics.beginFill(couleur, 1);
			fond.graphics.drawRect(0, 0, largeurFond, hauteurInitialeTexte + margeSup / 2);
			fauxfond.graphics.drawRect(0, 0, largeurFond, hauteurInitialeTexte + margeSup / 2);
			fond.graphics.endFill();
			fauxfond.graphics.endFill();
		}

		private function creerBoutonreponse(paddingH : Number, paddingV : Number, margeSup : Number, rayonAngle : Number, distanceBiseau : Number, distanceOmbre : Number) : void {
			bouton = new BoutonReponse(nameSpaceComportement, paddingH, paddingV, rayonAngle, distanceBiseau, distanceOmbre);
			supplementZoneContenu = SUPPLEMENT_ZONE_CONTENU_MINI + bouton.height + margeSup;
			GestionnaireTooltips.attacherTooltip(bouton, ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "answer_button_tooltip"));
		}

		private function positionnerBoutonreponse() : void {
			supportZoneContenu.addChild(bouton);
			bouton.y = zoneContenu.getBounds(this).bottom + margeSup;
			bouton.x = zoneContenu.x;
		}

		public function afficherReponse() : void {
			bouton.visible = false;
			supplementZoneContenu = SUPPLEMENT_ZONE_CONTENU_MINI;
			actualiserTexte(zoneContenu.text + "\n\n" + reponse);
			testerDebordementTexte();

		}

		override protected function gererDebordementtexte() : void {
			super.gererDebordementtexte();
			dessinerFondQuestion();
		}
	}
}
