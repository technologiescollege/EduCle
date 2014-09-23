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
package fr.acversailles.crdp.imagesActives.dispositions {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.image.details.IDetail;
	import fr.acversailles.crdp.imagesActives.infos.IZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.infos.ZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;
	import fr.acversailles.crdp.utils.functions.adapterPoliceALaHauteur;
	import fr.acversailles.crdp.utils.functions.centrer;

	import org.flexunit.asserts.assertNotNull;

	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class Disposition implements IDisposition {
		public static const AFFICHAGE_LEGENDES : uint = 1;
		public static const AFFICHAGE_QUESTIONS : uint = 2;
		protected var ns : Namespace;
		protected var _largeurTotale : Number;
		protected var _hauteurTotale : Number;
		protected var largeurMaxImage : Number;
		protected var hauteurMaxImage : Number;
		protected var _xFond : Number;
		protected var _yFond : Number;
		protected var _largeurFond : Number;
		protected var _hauteurFond : Number;
		private var largeurOriginaleFond : Number;
		private var hauteurOriginaleFond : Number;
		protected var posDernierBouton : Number;
		private var _typeAffichage : uint;

		public function Disposition(typeAffichage : uint) {
			assertNotNull("Définissez un espace de nommage xml pour ce layout", ns);
			this._typeAffichage = typeAffichage;
			recupererParametresDimensions();
			posDernierBouton = largeurTotale;
		}

		public function disposerFondImage() : void {
			determinerDimensionsCadre();
			dimensionnerFond();
			positionnerFond();
		}

		private function recupererParametresDimensions() : void {
			_largeurTotale = ContenuXML.instance.getLargeurTotale();
			_hauteurTotale = ContenuXML.instance.getHauteurTotale();
		}

		protected function determinerDimensionsCadre() : void {
			avertirClasseAbstraite();
		}

		private function dimensionnerFond() : void {
			largeurOriginaleFond = SVGWrapper.instance.fond.width;
			hauteurOriginaleFond = SVGWrapper.instance.fond.height;
			var ratioImage : Number = SVGWrapper.instance.fond.width / SVGWrapper.instance.fond.height;
			
			var ratioCadre : Number = largeurMaxImage / hauteurMaxImage;
			
			if (ratioImage > ratioCadre) contraindreParLargeur();
			else contraindreParHauteur();
		}

		public function getMasqueImage() : Shape {
			var masqueImage : Shape = new Shape();
			masqueImage.graphics.beginFill(0x000000);
			masqueImage.graphics.drawRect(SVGWrapper.instance.fond.x, SVGWrapper.instance.fond.y, SVGWrapper.instance.fond.width, SVGWrapper.instance.fond.height);
			masqueImage.graphics.endFill();
			return masqueImage;
		}

		public function getMasqueGlobal() : Shape {
			var masqueFond : Shape = new Shape();
			masqueFond.graphics.beginFill(0x000000);
			masqueFond.graphics.drawRect(0, 0, largeurTotale, hauteurTotale);
			masqueFond.graphics.endFill();
			return masqueFond;
		}

		protected function positionnerFond() : void {
			_xFond = ParametresXML.instance.getParametreDimensions("left_margin", ns);
			if (SVGWrapper.instance.fond.width < largeurMaxImage)
				_xFond += (largeurMaxImage - SVGWrapper.instance.fond.width) / 2;
			_yFond = ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns) + ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
			if (SVGWrapper.instance.fond.height < hauteurMaxImage)
				_yFond += (hauteurMaxImage - SVGWrapper.instance.fond.height) / 2;
			SVGWrapper.instance.fond.x = _xFond;
			SVGWrapper.instance.fond.y = _yFond;
		}

		private function contraindreParLargeur() : void {
			_largeurFond = largeurMaxImage;
			SVGWrapper.instance.fond.width = _largeurFond;
			SVGWrapper.instance.fond.scaleY = SVGWrapper.instance.fond.scaleX;
			_hauteurFond = SVGWrapper.instance.fond.height;
		}

		private function contraindreParHauteur() : void {
			_hauteurFond = hauteurMaxImage;
			SVGWrapper.instance.fond.height = _hauteurFond;
			SVGWrapper.instance.fond.scaleX = SVGWrapper.instance.fond.scaleY;
			_largeurFond = SVGWrapper.instance.fond.width;
		}

		protected function getParametreLayout(cle : String) : Number {
			return ContenuXML.instance.getParametreDispositionSpecifiques(ns, cle);
		}

		public function disposerDetail(detail : IDetail) : void {
			detail.dimensionner(_xFond, _yFond, _largeurFond, _hauteurFond, largeurOriginaleFond, hauteurOriginaleFond);
			if (detail.zoomable)
				configurerZoomDetail(detail);
		}

		public function get xFond() : Number {
			return _xFond;
		}

		public function get yFond() : Number {
			return _yFond;
		}

		public function get largeurFond() : Number {
			return _largeurFond;
		}

		public function get hauteurFond() : Number {
			return _hauteurFond;
		}

		private function configurerZoomDetail(detail : IDetail) : void {
			var rectangleDetail : Rectangle = detail.getRectangle();
			var ratioDetail : Number = rectangleDetail.width / rectangleDetail.height;
			var largeurMaxZoom : Number = _largeurTotale - 2 * ParametresXML.instance.getParametreDimensions("horizontal_zoom_margin", ns);
			var hauteurMaxZoom : Number = _hauteurTotale - 2 * ParametresXML.instance.getParametreDimensions("vertical_zoom_margin", ns);
			var ratioGeneral : Number = largeurMaxZoom / hauteurMaxZoom;
			var largeurObjectif : Number = 0;
			var hauteurObjectif : Number = 0;
			var xObjectif : Number = 0;
			var yObjectif : Number = 0;
			if (ratioDetail > ratioGeneral) {
				largeurObjectif = Math.min(largeurMaxZoom, detail.resolution.width);
				hauteurObjectif = largeurObjectif / rectangleDetail.width * rectangleDetail.height;
			} else {
				hauteurObjectif = Math.min(hauteurMaxZoom, detail.resolution.height);
				largeurObjectif = hauteurObjectif / rectangleDetail.height * rectangleDetail.width;
			}
			xObjectif = (largeurMaxZoom - largeurObjectif) / 2 + ParametresXML.instance.getParametreDimensions("horizontal_zoom_margin", ns);
			yObjectif = (hauteurMaxZoom - hauteurObjectif) / 2 + ParametresXML.instance.getParametreDimensions("vertical_zoom_margin", ns);
			var coeff : Number = largeurObjectif / rectangleDetail.width;
			var ox : Number = xObjectif - rectangleDetail.x * coeff;
			var oy : Number = yObjectif - rectangleDetail.y * coeff;
			var owidth : Number = largeurFond * coeff;
			var oheight : Number = hauteurFond * coeff;
			detail.configurerZoom(new Rectangle(ox, oy, owidth, oheight), new Rectangle(xObjectif, yObjectif, largeurObjectif, hauteurObjectif));
		}

		public function get largeurTotale() : Number {
			return _largeurTotale;
		}

		public function get hauteurTotale() : Number {
			return _hauteurTotale;
		}

		public function dessinerFond(main : Sprite) : void {
			dessinerFondTitre(main);
		}

		private function dessinerFondTitre(main : Sprite) : void {
			var hauteurFond : Number = ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			main.graphics.beginFill(couleurFond);
			main.graphics.lineStyle(2, couleurTrait, 1, true);
			var pta1 : Point = new Point(posDernierBouton, 0);
			pta1.offset(- ParametresXML.instance.getParametreDimensions("toolbar_decoration_witdh", ns), 0);
			var ptd1 : Point = pta1.clone();
			ptd1.offset(-rayonArc * 2, -2);
			var ptf1 : Point = pta1.clone();
			ptf1.offset(rayonArc * 2, rayonArc * 2) ;
			var pta2 : Point = pta1.clone();
			pta2.offset(hauteurFond, hauteurFond);
			var ptd2 : Point = pta2.clone();
			var ptf2 : Point = pta2.clone();
			ptd2.offset(-rayonArc * 2, -rayonArc * 2);
			ptf2.offset(rayonArc * 2, 0);
			main.graphics.moveTo(ptd1.x, ptd1.y);

			main.graphics.curveTo(pta1.x, pta1.y, ptf1.x, ptf1.y);
			main.graphics.lineTo(ptd2.x, ptd2.y);
			main.graphics.curveTo(pta2.x, pta2.y, ptf2.x, ptf2.y);
			main.graphics.lineTo(ContenuXML.instance.getLargeurTotale(), hauteurFond);
			main.graphics.lineStyle();
			main.graphics.lineTo(ContenuXML.instance.getLargeurTotale(), 0);
			main.graphics.lineTo(ptd1.x, ptd1.y);
			main.graphics.endFill();
		}

		public function placerZoneTexte(zoneTexte : IZoneTexte) : void {
			avertirClasseAbstraite();
		}

		public function placerTitre(zoneTitre : TextField) : void {
			zoneTitre.x = Math.min(SVGWrapper.instance.fond.x, ParametresXML.instance.unite * 2);
			zoneTitre.width = posDernierBouton - zoneTitre.x - ParametresXML.instance.getParametreDimensions("toolbar_decoration_witdh", ns);
			zoneTitre.y = 0;
			adapterPoliceALaHauteur(zoneTitre, limiteInferieureTitre() - zoneTitre.y);
			if (zoneTitre.height < ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns))
				centrer(zoneTitre, 0, ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns));
		}

		protected function limiteInferieureTitre() : Number {
			//on peut descendre plus bas que la barre d'outils si l'image n'occupe pas tout son espace vertical
			return _yFond - ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
		}

		public function placerZoneInfosDroits(zoneInfosDroits : TextField) : void {
			zoneInfosDroits.height = zoneInfosDroits.textHeight + 4;
			centrer(zoneInfosDroits, 0, ParametresXML.instance.getParametreDimensions("vertical_footer_area", ns));
			zoneInfosDroits.width = largeurTotale;
			zoneInfosDroits.y += hauteurTotale - ParametresXML.instance.getParametreDimensions("vertical_footer_area", ns);
		}

		public function get couleurFond() : uint {
			return ContenuXML.instance.getParametreCouleur("color_1");
		}

		public function get couleurTrait() : uint {
			return ContenuXML.instance.getParametreCouleur("color_3");
		}

		public function placerBouton(bouton : SimpleButton, superposer : Boolean = false) : void {
			bouton.height = ParametresXML.instance.getParametreDimensions("button_height", ns);
			bouton.scaleX = bouton.scaleY;
			centrer(bouton, 0, ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns));
			bouton.x = posDernierBouton - bouton.width - ParametresXML.instance.getParametreDimensions("button_right_margin", ns);
			if (!superposer) posDernierBouton = bouton.x;
		}

		public function creerZoneInfosDroits() : IZoneInfosDroits {
			var zoneInfosDroits : IZoneInfosDroits = new ZoneInfosDroits(this);
			zoneInfosDroits.yDepart = hauteurTotale;
			zoneInfosDroits.sprite.x = 0;
			return zoneInfosDroits;
		}

		public function hauteurBoutonZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_icon_height", ns);
		}

		public function margeGaucheBoutonZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_icon_left_margin", ns);
		}

		public function hauteurOngletZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
		}

		public function largeurBoutonZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_icon_width", ns);
		}

		public function get rayonArc() : Number {
			return ParametresXML.instance.getParametreDimensions("tabs_corner_radius", ns);
		}

		public function hauteurVisibleZoneInfos() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
		}

		public function largeurOngletZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_tab_width", ns);
		}

		public function margeInfZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_bottom_margin", ns);
		}

		public function getHauteurSoulevementZoneInfosDroits() : Number {
			return ParametresXML.instance.getParametreDimensions("infos_area_lifting", ns);
		}

		public function getDureeEstompageImage() : Number {
			return ParametresXML.instance.getParametreCommun("image_shading_duration");
		}

		public function largeurTootlTips() : Number {
			return ParametresXML.instance.getParametreDimensions("tooltips_width", ns);
		}

		public function getPaddingHBoiteMotDePasse() : Number {
			return ParametresXML.instance.getParametreDimensions("password_box_horizontal_padding", ns);
		}

		public function getPaddingVBoiteMotDePasse() : Number {
			return ParametresXML.instance.getParametreDimensions("password_box_vertical_padding", ns);
		}

		public function getRayonAngleBoiteMotDePasse() : Number {
			return ParametresXML.instance.getParametreDimensions("password_box_corner_radius", ns);
		}

		public function getLargeurZoneInputMotDePasse() : Number {
			return ParametresXML.instance.getParametreDimensions("password_box_input_width", ns);
		}

		public function get typeAffichage() : uint {
			return _typeAffichage;
		}

		public function getPaddingHBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("horizontal_answer_button_padding", ns);
		}

		public function getPaddingVBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("vertical_answer_button_padding", ns);
		}

		public function getMargeSupBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("answer_button_top_margin", ns);
		}

		public function getRayonAngleBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("answer_button_corner_radius", ns);
		}

		public function getDistanceBiseauBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("answer_button_bevel_distance", ns);
		}

		public function getDistanceOmbreBoutonreponse() : Number {
			return ParametresXML.instance.getParametreDimensions("answer_button_dropshadow_distance", ns);
		}

		public function getProportionMaxFenetreCredits() : Number {
			return ParametresXML.instance.getParametreCommun("credits_window_max_proportion");
		}

		public function detailsPucesVisibles() : Boolean {
			avertirClasseAbstraite();
			return false;
		}
	}
}
