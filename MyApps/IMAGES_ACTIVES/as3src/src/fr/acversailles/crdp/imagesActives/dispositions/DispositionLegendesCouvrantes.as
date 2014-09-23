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
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.image.details.IDetail;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class DispositionLegendesCouvrantes extends DispositionAvecDefilement implements IDispositionLegendesCouvrantes {
		private static const PAS : int = 5;
		private var directionLegendes : Vector.<Point>;
		private var departLegendes : Vector.<Point>;
		private var details : Vector.<IDetail>;

		public function DispositionLegendesCouvrantes(typeAffichage : uint) {
			ns = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives/layouts/covering_captions");
			super(typeAffichage);
			directionLegendes = new Vector.<Point>(SVGWrapper.instance.getNbDetails());
			departLegendes = new Vector.<Point>(SVGWrapper.instance.getNbDetails());
			details = new Vector.<IDetail>(SVGWrapper.instance.getNbDetails());
		}

		override protected function determinerDimensionsCadre() : void {
			var dimensionHZoneImage : Number = _largeurTotale;
			var margesH : Number = ParametresXML.instance.getParametreDimensions("left_margin", ns);
			margesH += ParametresXML.instance.getParametreDimensions("right_margin", ns);
			largeurMaxImage = dimensionHZoneImage - margesH;
			var margesV : Number = ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_image_footer_margin", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
			hauteurMaxImage = _hauteurTotale - margesV;
		}

		override public function placerZoneTexte(zoneTexte : IZoneTexte) : void {
		}

		override public function disposerDetail(detail : IDetail) : void {
			super.disposerDetail(detail);
			creerRectangleLegende(detail);
		}

		private function creerRectangleLegende(detail : IDetail) : void {
			var rectDetail : Rectangle = detail.getRectangle();
			var milieuDetail : Point = Point.interpolate(rectDetail.topLeft, rectDetail.bottomRight, 0.5);
			milieuDetail.offset(-_xFond, - _yFond);
			var rectImage : Rectangle = new Rectangle(_xFond, _yFond, _largeurFond, _hauteurFond);
			var milieuImage : Point = Point.interpolate(rectImage.topLeft, rectImage.bottomRight, 0.5);
			var posRectangle : Point;
			var largeurRectangle : Number;
			var hauteurRectangle : Number;
			if (milieuDetail.x < milieuImage.x / 2 && milieuDetail.y < milieuImage.y / 2) {
				posRectangle = rectDetail.bottomRight;
				largeurRectangle = _largeurFond - rectDetail.right;
				hauteurRectangle = _hauteurFond - rectDetail.bottom;
			} else if (milieuDetail.x < milieuImage.x / 2 && milieuDetail.y > milieuImage.y / 2) {
				posRectangle = new Point(rectDetail.right, 0);
				largeurRectangle = _largeurFond - rectDetail.right;
				hauteurRectangle = rectDetail.top;
			} else if (milieuDetail.x > milieuImage.x / 2 && milieuDetail.y < milieuImage.y / 2) {
				posRectangle = new Point(0, rectDetail.bottom);
				largeurRectangle = rectDetail.left;
				hauteurRectangle = _hauteurFond - rectDetail.bottom;
			} else if (milieuDetail.x > milieuImage.x / 2 && milieuDetail.y > milieuImage.y / 2) {
				posRectangle = new Point(0, 0);
				largeurRectangle = rectDetail.left;
				hauteurRectangle = rectDetail.top;
			}
			posRectangle.offset(_xFond, _yFond);
			var rectLegende : Rectangle = new Rectangle(posRectangle.x, posRectangle.y, largeurRectangle, hauteurRectangle);
			directionLegendes[detail.idDetail] = Point.interpolate(rectLegende.topLeft, rectLegende.bottomRight, 0.5);
			departLegendes[detail.idDetail] = Point.interpolate(rectDetail.topLeft, rectDetail.bottomRight, 0.5);
			departLegendes[detail.idDetail].offset(SVGWrapper.instance.fond.x, SVGWrapper.instance.fond.y);
			details[detail.idDetail] = detail;
		}

		public function getDirectionLegende(numero : uint) : Point {
			return directionLegendes[numero];
		}

		public function getDepartLegende(numero : uint) : Point {
			return departLegendes[numero];
		}

		public function collisionDetail(numeroDetail : uint, espaceLegende : Rectangle) : Boolean {
			var angleSE : Point = espaceLegende.bottomRight;
			var angleNO : Point = espaceLegende.topLeft;
			angleSE.offset(-_xFond, -_yFond);
			angleNO.offset(-_xFond, - _yFond);
			var collision : Boolean = false;
			var deplacementH : int;
			var deplacementV : int;
			var pointTeste : Point;
			for (deplacementH = angleNO.x; deplacementH < angleSE.x; deplacementH += PAS) {
				for (deplacementV = angleNO.y; deplacementV < angleSE.y; deplacementV += PAS) {
					pointTeste = new Point(deplacementH, deplacementV);
					collision = collision || details[numeroDetail].pixelOpaqueAuPoint(pointTeste.x, pointTeste.y);
				}
			}
			return collision;
		}

		public function sortieImage(posLegende : Rectangle) : Boolean {
			return posLegende.x < 0 || posLegende.y < 0 || posLegende.right > largeurTotale || posLegende.bottom > hauteurTotale;
		}

		public function getLargeurZoneTexte() : Number {
			return ParametresXML.instance.getParametreDimensions("captions_width", ns);
		}

		public function getHauteurZoneTexte() : Number {
			return ParametresXML.instance.getParametreDimensions("captions_max_height", ns);
		}

		public function getPaddingLegendes() : Number {
			return ParametresXML.instance.getParametreDimensions("captions_padding", ns);
		}

		public function getRayonLegendes() : Number {
			return ParametresXML.instance.getParametreDimensions("captions_corner_radius", ns);
		}

		public function getLargeurScrollbar() : Number {
			return ParametresXML.instance.getParametreDimensions("caption_scrollbar_width", ns);
		}

		public function getAlphaLegendes() : Number {
			return getParametreLayout("captions_alpha");
		}
		override public function detailsPucesVisibles() : Boolean {
			return true;
		}
	}
}
