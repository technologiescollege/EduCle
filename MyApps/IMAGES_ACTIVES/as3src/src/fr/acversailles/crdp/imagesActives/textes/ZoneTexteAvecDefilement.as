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
package fr.acversailles.crdp.imagesActives.textes {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAvecDefilement;
	import fr.acversailles.crdp.imagesActives.icones.FlecheScrollbarLegende;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneTexteAvecDefilement extends ZoneTexte {
		
		private static const DELAI_DEFILEMENT : Number = 100;
		private static const HAUT : int = 0;
		private static const BAS : int = 1;
		protected var flecheHaut : SimpleButton;
		protected var flecheBas : SimpleButton;
		protected var zoneTitre : TextField;
		protected var zoneTexte : TextField;
		private var timerDefilement : Timer;
		private var directionDefilement : int;
		protected var debordement : Boolean;
		private var supportBarre : Sprite;
		private var topBarre : Number;
		private var bottomBarre : Number;
		private var hauteurBarre : Number;
		private var hauteurTotaleBarre : Number;

		

		public function ZoneTexteAvecDefilement(_disposition : IDispositionAvecDefilement) {
			super(_disposition);
		}

		override public function construire(nameSpaceComportement : Namespace) : void {
			super.construire(nameSpaceComportement);
			creerFleches();
			creerTimer();
			supportBarre = new Sprite();
			supportBarre.buttonMode = true;
			addChild(supportBarre);
			gererMoletteSouris();
		}
		
		private function gererMoletteSouris() : void {
			addEventListener(MouseEvent.MOUSE_WHEEL, gererRotationMolette);
		}

		private function gererRotationMolette(event : MouseEvent) : void {
			defilerTexte(null, event.delta > 0 ? HAUT : BAS);
		}

		protected function creerFleches() : void {
			flecheHaut = new FlecheScrollbarLegende();
			flecheBas = new FlecheScrollbarLegende();
			flecheHaut.enabled = flecheBas.enabled = true;
			flecheBas.visible = flecheHaut.visible = false;
			flecheBas.rotation = 180;
			flecheBas.width = flecheHaut.width = (_disposition as IDispositionAvecDefilement).getLargeurFlecheScrollbar();
			flecheBas.scaleY = flecheHaut.scaleY = flecheHaut.scaleX;

			addChild(flecheHaut);
			addChild(flecheBas);
			var coloration : ColorTransform = new ColorTransform();
			coloration.color = definirCouleurFleches();
			flecheBas.transform.colorTransform = coloration;
			flecheHaut.transform.colorTransform = coloration;
		}

		protected function definirCouleurFleches() : uint {
			avertirClasseAbstraite();
			return 0;
		}

		private function creerTimer() : void {
			timerDefilement = new Timer(DELAI_DEFILEMENT);
			timerDefilement.addEventListener(TimerEvent.TIMER, defilerTexte);
		}

		private function defilerTexte(event : TimerEvent = null, direction : int = -1) : void {
			if (!event) {
				this.directionDefilement = direction;
			}
			if (directionDefilement == HAUT) {
				if (zoneTexte.scrollV > 1) zoneTexte.scrollV--;
				else timerDefilement.stop();
			} else if (directionDefilement == BAS) {
				if (zoneTexte.scrollV < zoneTexte.maxScrollV + 1) zoneTexte.scrollV++;
				else timerDefilement.stop();
			}
			actualiserEtatFleches();
			actualiserBarre();
		}

		protected function actualiserEtatFleches() : void {
			if (!debordement) return;
			activerFleche(flecheHaut, zoneTexte.scrollV > 1);
			activerFleche(flecheBas, zoneTexte.scrollV < zoneTexte.maxScrollV);
		}

		private function actualiserBarre() : void {
			if (!debordement) return;

			var posBarre : Number = (hauteurTotaleBarre - hauteurBarre) * ((zoneTexte.scrollV - 1) / (zoneTexte.maxScrollV - 1)) + topBarre;
			supportBarre.y = posBarre;
		}

		protected function delimiterBarreDefilement() : void {
			topBarre = flecheHaut.getBounds(this).bottom + 1;
			bottomBarre = flecheBas.getBounds(this).top - 1;
			hauteurTotaleBarre = bottomBarre - topBarre;
			hauteurBarre = hauteurTotaleBarre * zoneTexte.bottomScrollV / zoneTexte.numLines ;
		}

		private function activerFleche(fleche : SimpleButton, active : Boolean) : void {
			fleche.enabled = active;
			fleche.mouseEnabled = active;
			fleche.alpha = active ? 1 : 0.3;
		}

		override protected function gererMouseDown(event : MouseEvent) : void {
			if (event.target == flecheHaut) {
				defilerTexte(null, HAUT);
				timerDefilement.start();
				arreterDragBarredefilement();
			} else if (event.target == flecheBas) {
				defilerTexte(null, BAS);
				timerDefilement.start();
				arreterDragBarredefilement();
			} else if (event.target == supportBarre) {
				commencerDragBarredefilement();
			} 
			super.gererMouseDown(event);
		}

		private function commencerDragBarredefilement() : void {
			supportBarre.startDrag(false, new Rectangle(0, topBarre, 0, (bottomBarre - topBarre) - hauteurBarre));
			addEventListener(MouseEvent.MOUSE_MOVE, gererDeplacementBarre);
		}

		private function gererDeplacementBarre(event : MouseEvent) : void {
			zoneTexte.scrollV = Math.round(1 + (supportBarre.y - topBarre) / (hauteurTotaleBarre - hauteurBarre) * (zoneTexte.maxScrollV - 1));
		}

		private function arreterDragBarredefilement() : void {
			supportBarre.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, gererDeplacementBarre);
		}

		override protected function gererMouseUp(event : MouseEvent) : void {
			timerDefilement.stop();
			arreterDragBarredefilement();
		}

		override protected function gererMouseOut(event : MouseEvent) : void {
			timerDefilement.stop();
			arreterDragBarredefilement();
		}

		protected function gererDebordement() : void {
			supportBarre.visible = flecheBas.visible = flecheHaut.visible = debordement;
			delimiterBarreDefilement();
			actualiserEtatFleches();
			dessinerBarre();
			actualiserBarre();
		}

		private function dessinerBarre() : void {
			if (!debordement) return;
			supportBarre.graphics.clear();
			//TODO valeur magique
			supportBarre.graphics.beginFill(ContenuXML.instance.getParametreCouleur("color_2"), 0.5);
			supportBarre.graphics.drawRect(flecheHaut.x, 0, flecheHaut.width, hauteurBarre);
			supportBarre.graphics.endFill();
		}
		
		

	}
}
