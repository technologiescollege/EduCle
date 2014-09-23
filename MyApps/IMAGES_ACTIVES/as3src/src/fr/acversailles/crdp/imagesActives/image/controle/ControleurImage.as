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
package fr.acversailles.crdp.imagesActives.image.controle {
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.image.IZoneImage;
	import fr.acversailles.crdp.imagesActives.image.details.IGestionDetails;

	import flash.events.MouseEvent;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ControleurImage implements IControleurImage {
		private var zoneImage : IZoneImage;
		private var gestionDetails : IGestionDetails;

		public function ControleurImage(zoneImage : IZoneImage, gestionDetails : IGestionDetails) {
			this.gestionDetails = gestionDetails;
			this.zoneImage = zoneImage;
			this.zoneImage.sprite.mouseChildren = false;
			gererInteractivite();
		}

		private function gererInteractivite() : void {
			this.zoneImage.sprite.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseEvent);
			this.zoneImage.sprite.addEventListener(MouseEvent.MOUSE_MOVE, gererMouseEvent);
		}

		private function gererMouseEvent(event : MouseEvent) : void {
			var idDetail : int = gestionDetails.numeroDetailAuPoint(event.localX, event.localY);
			var evenementDiffuse : ActionUtilisateurEvent;
			if (idDetail >= 0) {
				var typeAction : String;

				if (event.type == MouseEvent.MOUSE_DOWN) {
					if (gestionDetails.detailPuce(idDetail))
						typeAction = ActionUtilisateurEvent.MOUSE_DOWN_DETAIL_PUCE;
					else typeAction = ActionUtilisateurEvent.MOUSE_DOWN_DETAIL;
					evenementDiffuse = new ActionUtilisateurEvent(typeAction, idDetail);
				} else {
					if (gestionDetails.detailPuce(idDetail))
						typeAction = ActionUtilisateurEvent.MOUSE_MOVE_DETAIL_PUCE;
					else typeAction = ActionUtilisateurEvent.MOUSE_MOVE_DETAIL;
					evenementDiffuse = new ActionUtilisateurEvent(typeAction, idDetail);
				}
			} else {
				if (event.type == MouseEvent.MOUSE_DOWN)
					evenementDiffuse = new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_FOND_IMAGE);
				else
					evenementDiffuse = new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_MOVE_FOND_IMAGE);
			}
			this.zoneImage.sprite.dispatchEvent(evenementDiffuse);
		}
	}
}
