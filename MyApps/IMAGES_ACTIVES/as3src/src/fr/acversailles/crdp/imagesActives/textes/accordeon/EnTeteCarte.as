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
/*
 **   Images Actives ©2010-2011 CRDP de l'Académie de Versailles
 ** This file is part of Images Actives.
 **
 **    Images Actives is free software: you can redistribute it and/or modify
 **    it under the terms of the GNU General Public License as published by
 **    the Free Software Foundation, either version 3 of the License, or
 **    (at your option) any later version.
 **
 **    Images Actives is distributed in the hope that it will be useful,
 **    but WITHOUT ANY WARRANTY; without even the implied warranty of
 **    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 **    GNU General Public License for more details.
 **
 **    You should have received a copy of the GNU General Public License
 **    along with Images Actives.  If not, see <http://www.gnu.org/licenses/>
 **
 ** 	@author joachim.dornbusch@crdp.ac-versailles.fr
 */
package fr.acversailles.crdp.imagesActives.textes.accordeon {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.IconeTitreLegendeAccordeon;
	import fr.acversailles.crdp.imagesActives.icones.InterrogationQuiz;
	import fr.acversailles.crdp.utils.functions.adapterPoliceALaHauteur;
	import fr.acversailles.crdp.utils.functions.tronquerTexte;

	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	internal class EnTeteCarte extends Sprite {
		private static const MARGES_LATERALES : Number = 5;
		private static const MARGE_GAUCHE_ICONES : Number = 10;
		private static const MARGES_INF_SUP_ICONES : Number = 0.35;
		private static const MARGE_GAUCHE_TEXTE : Number = 5;
		private static const MARGES_INF_SUP_ICONE_TITRE : Number = 0.2;
		private var titre : String;
		private var largeur : Number;
		private var hauteur : Number;
		private var zoneTexte : TextField;
		private var _couleurFond : uint;
		private var formatTexte : TextFormat;
		private var type : String;
		private var icone : Sprite;
		private static const ARRONDI : Number = 0.2;
		private static const EPAISSEUR_PROLONGEMENT_BARRE_DESCRIPTION : Number = 0.15;
		private var supportFond : Shape;
		private static var colorationIcones : ColorTransform;

		public function EnTeteCarte(titre : String, largeur : Number, hauteur : Number, type : String) {
			this.type = type;
			this.formatTexte = StylesCSS.instance.styleToTextFormat(".caption_title");
			this.hauteur = hauteur;
			this.largeur = largeur;
			this.titre = titre;
			supportFond = new Shape();
			addChild(supportFond);
			buttonMode = true;
			mouseChildren = false;
			determinerCouleurs();
			if (type != TypesCartes.DESCRIPTION)
				mettreIcone();
			creerZoneTexte();
			dessinerFond();

			supportFond.filters = [new BevelFilter(2, 45, 0xFFFFFF, 1, 0x000000, 1, 6)];
		}

		private function determinerCouleurs() : void {
			switch(type) {
				case TypesCartes.DETAIL:
				case TypesCartes.QUESTION:
					formatTexte.color = StylesCSS.instance.styleToTextFormat(".caption_title").color;
					_couleurFond = ContenuXML.instance.getParametreCouleur("color_1");
					break;
				case TypesCartes.DESCRIPTION:
				case TypesCartes.CONSIGNE_QUIZZ:
					formatTexte.color = StylesCSS.instance.styleToTextFormat(".description_title").color;
					_couleurFond = ContenuXML.instance.getParametreCouleur("color_2");
					break;
			}
		}

		private function mettreIcone() : void {
			var marge : Number = 0;
			switch(type) {
				case TypesCartes.DETAIL:
				case TypesCartes.QUESTION:
					icone = new IconeTitreLegendeAccordeon();
					marge = MARGES_INF_SUP_ICONES;
					break;
				case TypesCartes.CONSIGNE_QUIZZ:
					icone = new InterrogationQuiz();
					marge = MARGES_INF_SUP_ICONE_TITRE;
					break;
				case TypesCartes.DESCRIPTION:
					icone = null;
			}
			if (!icone)
				return;
			var hauteurIcone : Number = hauteur - marge * hauteur * 2;
			icone . scaleX = icone.scaleY = hauteurIcone / icone.height ;
			icone.y = marge * hauteur ;
			icone.x = MARGE_GAUCHE_ICONES;
			if (!colorationIcones) {
				colorationIcones = new ColorTransform();
				colorationIcones.color = uint(formatTexte.color);
			}
			icone.transform.colorTransform = colorationIcones;
			addChild(icone);
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = false;
			zoneTexte.selectable = false;
			zoneTexte.mouseEnabled = false;
			zoneTexte.antiAliasType = AntiAliasType.ADVANCED;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(formatTexte.font);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(formatTexte.font,*/ titre/*)*/;
			// TODO valeur magique
			adapterPoliceALaHauteur(zoneTexte, hauteur * 0.8);
			zoneTexte.height = zoneTexte.textHeight + 4;
			addChild(zoneTexte);
			zoneTexte.y = (hauteur - zoneTexte.height) / 2;
			zoneTexte.x = icone ? icone.getBounds(this).right : 0;
			zoneTexte.x += MARGE_GAUCHE_TEXTE;
			zoneTexte.width = largeur - MARGES_LATERALES;
			//� cause du retrait plus important
			var margeDroiteSupplementaire:Number=0;
			switch(type) {
				case TypesCartes.DETAIL:
				case TypesCartes.QUESTION:
					margeDroiteSupplementaire=0;
					break;
				case TypesCartes.DESCRIPTION:
				case TypesCartes.CONSIGNE_QUIZZ:
					margeDroiteSupplementaire=hauteur;
					break;
			}
			tronquerTexte(zoneTexte, largeur - MARGES_LATERALES - zoneTexte.x - hauteur/2-margeDroiteSupplementaire);
		}

		private function dessinerFond() : void {
			if (type == TypesCartes.DESCRIPTION || type == TypesCartes.CONSIGNE_QUIZZ) {
				supportFond.graphics.beginFill(_couleurFond);
				supportFond.graphics.lineStyle(1, _couleurFond, 1, true);
				supportFond.graphics.moveTo(0, 0);
				var pta1 : Point = new Point(largeur - 2 * hauteur, 0);
				var ptd1 : Point = pta1.clone();
				ptd1.offset(-ARRONDI * hauteur, 0);
				var ptf1 : Point = pta1.clone();
				ptf1.offset(ARRONDI * hauteur, ARRONDI * hauteur);
				var pta2 : Point = new Point(largeur - hauteur, hauteur * (1 - EPAISSEUR_PROLONGEMENT_BARRE_DESCRIPTION));
				var ptd2 : Point = pta2.clone();
				ptd2.offset(-ARRONDI * hauteur, - ARRONDI * hauteur);
				var ptf2 : Point = pta2.clone();
				ptf2.offset(ARRONDI * hauteur, 0);
				supportFond.graphics.lineTo(ptd1.x, ptd1.y);
				supportFond.graphics.curveTo(pta1.x, pta1.y, ptf1.x, ptf1.y);
				supportFond.graphics.lineTo(ptd2.x, ptd2.y);
				supportFond.graphics.curveTo(pta2.x, pta2.y, ptf2.x, ptf2.y);
				supportFond.graphics.lineTo(largeur, hauteur * (1 - EPAISSEUR_PROLONGEMENT_BARRE_DESCRIPTION));
				supportFond.graphics.lineTo(largeur, hauteur);
				supportFond.graphics.lineTo(0, hauteur);
				supportFond.graphics.lineTo(0, 0);
				supportFond.graphics.endFill();
			} else {
				graphics.beginFill(ContenuXML.instance.getParametreCouleur("color_4"));
				graphics.drawRect(0, 0, largeur, hauteur);
				graphics.endFill();
				supportFond.graphics.beginFill(_couleurFond);
				supportFond.graphics.lineStyle(2, _couleurFond, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND);
				supportFond.graphics.moveTo(0, 0);
				var pta3 : Point = new Point(largeur - hauteur, 0);
				var ptd3 : Point = pta3.clone();
				ptd3.offset(-ARRONDI * hauteur, 0);
				var ptf3 : Point = pta3.clone();
				ptf3.offset(ARRONDI * hauteur, ARRONDI * hauteur);
				supportFond.graphics.lineTo(ptd3.x, ptd3.y);
				supportFond.graphics.curveTo(pta3.x, pta3.y, ptf3.x, ptf3.y);
				supportFond.graphics.lineTo(largeur, hauteur - 2);
				supportFond.graphics.lineTo(largeur, hauteur);
				supportFond.graphics.lineTo(0, hauteur);
				supportFond.graphics.lineTo(0, 0);
				supportFond.graphics.endFill();
			}
		}

		internal function get couleurFond() : uint {
			return _couleurFond;
		}
	}
	// end class
} // end package
