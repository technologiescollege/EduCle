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
package fr.acversailles.crdp.imagesActives.textes.audio.controles {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ControleVolume extends Sprite implements IControleVolume {
		private static const NB_BARRES : uint = 5;
		private static const ESPACEMENT : Number = 0.5;
		private var largeur : Number;
		private var hauteur : Number;
		private var barres : Vector.<BarreControleVolume>;
		
		public function ControleVolume(largeur : Number, hauteur : Number) {
			this.hauteur = hauteur;
			this.largeur = largeur;
			creerBarres();
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		private function gererMouseDown(event : MouseEvent) : void {
			var barreCliquee : BarreControleVolume = event.target as BarreControleVolume;
			var volume : int = barres.indexOf(barreCliquee)+1;
			parent.dispatchEvent(new AudioEvent(AudioEvent.VOLUME, volume));
		}

		private function creerBarres() : void {
			barres = new Vector.<BarreControleVolume>();
			var largeurBarres : Number = largeur/(NB_BARRES+ESPACEMENT*(NB_BARRES-1));
			for (var i : int = 0; i < NB_BARRES; i++) {
				var xBarre:Number = i*(largeurBarres*(1+ESPACEMENT));
				var hauteurGauche : Number= hauteur/2 *(1+xBarre/largeur);
				var hauteurDroite : Number= hauteur/2 *(1+(xBarre+largeurBarres)/largeur);
				var nouvelleBarre : BarreControleVolume = new BarreControleVolume(largeurBarres, hauteurDroite, hauteurGauche);
				addChild(nouvelleBarre);
				nouvelleBarre.x = xBarre;
				nouvelleBarre.y = hauteur-hauteurDroite;
				barres.push(nouvelleBarre);
			}
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function setVolume(volume : int) : void {
			for (var i : int = 0; i < NB_BARRES; i++) {
				barres[i].activer(i<volume);
			}
		}
	}
}
