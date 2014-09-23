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
package fr.acversailles.crdp.imagesActives.image.details {
	import fr.acversailles.crdp.utils.interfaces.IDisplayObject;

	import flash.display.Bitmap;
	import flash.geom.Rectangle;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public interface IDetail extends IDisplayObject {
		function dimensionner(x : Number, y : Number, width : Number, height : Number, largeurOriginaleFond : Number, hauteurOriginaleFond : Number) : void;

		function get idDetail() : uint;

		function emphaseLegere() : void;

		function emphaseForte() : void;

		function aucuneEmphase() : void;

		function get zoomable() : Boolean;

		function get isPuce() : Boolean;

		function configurerZoom(rectangleCadre : Rectangle, rectangleDetail : Rectangle) : void;

		function getRectangle() : Rectangle;

		function zoomer() : void;

		function get resolution() : Rectangle;

		function pixelOpaqueAuPoint(localX : Number, localY : Number) : Boolean;

		function dezoomer() : void;

		function get formeEnCreu() : Bitmap;
	}
}
