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
package fr.acversailles.crdp.imagesActives.tooltips {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Dornbusch
	 */
	internal class GestionnaireAffichageTooltips {
		private static var timer : Timer;
		private static var _objetElu : Tooltipable;
		private static var scene : DisplayObjectContainer;
		private static var activationGenerale : Boolean;

		internal static function set objetElu(objet : Tooltipable) : void {
			annulerElection(_objetElu);
			_objetElu = objet;
			_objetElu.objet.stage.addEventListener(MouseEvent.MOUSE_MOVE, gererActionSouris);
			_objetElu.objet.stage.addEventListener(MouseEvent.MOUSE_DOWN, gererActionSouris);
			relancerCompteARebours();
		}

		private static function gererActionSouris(event : MouseEvent) : void {
			if (scene && scene.contains(Tooltip.instance))
				scene.removeChild(Tooltip.instance);
			relancerCompteARebours();
		}

		public static function annulerElection(tooltipable : Tooltipable) : void {
			if (_objetElu == tooltipable) {
				if (timer.running)
					timer.stop();
				_objetElu = null;
			}
			if (tooltipable && tooltipable.objet && tooltipable.objet.stage.hasEventListener(MouseEvent.MOUSE_MOVE) ) {
				tooltipable.objet.stage.removeEventListener(MouseEvent.MOUSE_MOVE, gererActionSouris);
				tooltipable.objet.stage.removeEventListener(MouseEvent.MOUSE_DOWN, gererActionSouris);
			}
		}

		private static function relancerCompteARebours() : void {
			timer.reset();
			timer.start();
		}

		public static function initialiser() : void {
			if (!timer) {
				timer = new Timer(PG.delaiApparitionTooltips, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, afficherToolTip);
			}
		}

		private static function afficherToolTip(event : TimerEvent) : void {
			if (!_objetElu.objet.root)
				return;
			if (!activationGenerale)
				return;
			scene = DisplayObjectContainer(_objetElu.objet.root);
			if (!_objetElu.texte)
				return;
			if (!scene.contains(Tooltip.instance))
				scene.addChildAt(Tooltip.instance, scene.numChildren);
			else
				scene.setChildIndex(Tooltip.instance, scene.numChildren - 1);
			Tooltip.instance.declencher(_objetElu.texte);
		}

		public static function activerTooltips(boolean : Boolean) : void {
			activationGenerale = boolean;
		}
	}
}
