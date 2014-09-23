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
package fr.acversailles.crdp.utils.functions {
	import flash.display.DisplayObject;

	/**
	 * @author Dornbusch
	 */
	public function centrer(objet : DisplayObject, espaceHorizontal : Number = 0, espaceVertical : Number = 0) : void {
		if (espaceHorizontal > 0) objet.x = (espaceHorizontal - objet.width) / 2;
		if (espaceVertical > 0) objet.y = (espaceVertical - objet.height) / 2;
	}
}
