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
package fr.acversailles.crdp.utils.graphiques {
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Dornbusch
	 */
	public class InteractiveSprite extends Sprite {

		protected static const UP : uint = 0;
		protected static const HOVER : uint = 1;
		protected static const DOWN : uint = 2;
		protected static const SELECTED : uint = 3;
		protected static const DISABLED : uint = 4;
		private static const DELAI_CLIGNOTEMENT : uint = 500;

		
		protected var _etat : int;
		private var timer : Timer;

		
		public function InteractiveSprite() {
			_etat = UP;
			actualiserApparence(false);
			ecouterSouris();
		}

		private function ecouterSouris() : void {
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, gererSurvol);
			addEventListener(MouseEvent.ROLL_OUT, gererFinSurvol);
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
		}

		private function neutraliserSouris() : void {
			buttonMode = false;
			removeEventListener(MouseEvent.ROLL_OVER, gererSurvol);
			removeEventListener(MouseEvent.ROLL_OUT, gererFinSurvol);
			removeEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
		}

		
		
		private function gererMouseUp(event : MouseEvent) : void {
			etat = HOVER;
		}

		private function gererMouseDown(event : MouseEvent) : void {
			etat = DOWN;
		}		

		private function gererSurvol(event : MouseEvent) : void {
			etat = HOVER;
		}

		private function gererFinSurvol(event : MouseEvent) : void {
			etat = UP;
		}

		public function activer() : void {
			if (_etat == DISABLED) {
				etat = UP;
				ecouterSouris();
			}
		}

		public function desactiver() : void {
			if (_etat != DISABLED) {
				etat = DISABLED;
				neutraliserSouris();
			}
		}

		public function get desactive() : Boolean {
			return _etat == DISABLED;
		}

		
		public function selectionner() : void {
			if (_etat != SELECTED) {
				etat = SELECTED;
				neutraliserSouris();
			}
		}

		public function deselectionner() : void {			
			if (_etat == SELECTED) {
				etat = UP;
				ecouterSouris();
			}
		}

		public function get selectionne() : Boolean {
			return _etat == SELECTED;
		}

		protected function set etat(nouvelEtat : int) : void {
			if (nouvelEtat == _etat) return;
			_etat = nouvelEtat;
			actualiserApparence(true);
		}

		protected function actualiserApparence(redessiner : Boolean) : void {
			redessiner = redessiner;
			avertirClasseAbstraite();
		}

		public function clignoter() : void {
			if (!timer) creerTimer();
			timer.start();
		}

		public function arreterClignoter() : void {
			if (timer) 
			timer.stop();
			etat = UP;
		}

		public function get clignotante() : Boolean {
			return timer && timer.running;
		}

		private function creerTimer() : void {
			timer = new Timer(DELAI_CLIGNOTEMENT);
			timer.addEventListener(TimerEvent.TIMER, toggleEtat);
		}

		private function toggleEtat(event : TimerEvent) : void {
			if (_etat == HOVER) etat = UP;
			else etat = HOVER;
		}
	}
}
