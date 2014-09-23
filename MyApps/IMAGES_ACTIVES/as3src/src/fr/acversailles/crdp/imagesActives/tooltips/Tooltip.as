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
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author Dornbusch
	 */
	internal class Tooltip extends Sprite {
		private static var _instance : Tooltip;
		private static const MARGE : uint = 2;
		private static const NB_COUPS_TIMER : int = 5;
		private static const DELAI_APPARITION : uint = 100;
		private var zoneTexte : TextField;
		private var formatTexte : TextFormat;
		private var pointSouris : Point;
		private var largeurFond : Number;
		private var hauteurFond : Number;
		private var timerApparition : Timer;
		private static var _disposition : IDisposition;

		public function Tooltip(verrou : Verrou) {
			verrou = verrou;
			creerZoneTexte();
			mouseEnabled = false;
			mouseChildren = false;
			filters = [new DropShadowFilter(3, 45, PG.couleurOmbreTooltips)];
			creerTimerApparition();
		}

		private function creerTimerApparition() : void {
			timerApparition = new Timer(DELAI_APPARITION / NB_COUPS_TIMER, NB_COUPS_TIMER);
			timerApparition.addEventListener(TimerEvent.TIMER, actualiserAlpha);
		}

		private function actualiserAlpha(event : TimerEvent) : void {
			alpha = timerApparition.currentCount * (1 / NB_COUPS_TIMER);
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.width = _disposition.largeurTootlTips();
			zoneTexte.selectable = false;
			zoneTexte.wordWrap = true;
			zoneTexte.antiAliasType = AntiAliasType.ADVANCED;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.multiline = true;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(StylesCSS.instance.styleToTextFormat(".tooltips").font);
			formatTexte = StylesCSS.instance.styleToTextFormat(".tooltips");
			;
			zoneTexte.defaultTextFormat = formatTexte;
			addChild(zoneTexte);
		}

		static public function get instance() : Tooltip {
			if (!_instance) _instance = new Tooltip(new Verrou());
			return _instance;
		}

		public function declencher(texte : String) : void {
			zoneTexte.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(formatTexte.font,*/ texte/*)*/;
			zoneTexte.height = zoneTexte.textHeight + 5;
			dessinerFond();
			positionner();
			apparaitre();
		}

		private function apparaitre() : void {
			alpha = 0;
			timerApparition.reset();
			timerApparition.start();
		}

		private function positionner() : void {
			pointSouris = new Point(mouseX, mouseY);
			x = localToGlobal(pointSouris).x - largeurFond / 2;
			y = localToGlobal(pointSouris).y;
			if (stage.stageHeight - y > y) y += 20;
			else {
				y -= hauteurFond;
			}
			while (this.x + largeurFond > stage.stageWidth) x--;
			while (x < 0) x++;
		}

		private function dessinerFond() : void {
			// TODO gérer le problème de l'absence de .tooltips dans feuille de style ou de l'absence des polices

			// par exemple en n'amrquant pas la police

			// ou en revenant sur une des polices existantes

			var rectanglePremierChar : Rectangle = zoneTexte.getCharBoundaries(0);
			largeurFond = zoneTexte.textWidth + 2 * MARGE;
			hauteurFond = zoneTexte.textHeight + 2 * MARGE;
			graphics.clear();
			graphics.beginFill(PG.couleurFondTooltips);
			graphics.lineStyle(0.5, PG.couleurBordTooltips);
			graphics.drawRect(rectanglePremierChar.topLeft.x - MARGE, rectanglePremierChar.topLeft.y - MARGE, largeurFond, hauteurFond);
			graphics.endFill();
		}

		public static function initialiser(disposition : IDisposition) : void {
			_disposition = disposition;
		}
	}
}
class Verrou {
}
