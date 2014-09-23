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
	import flash.geom.ColorTransform;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAudio;
	import fr.acversailles.crdp.imagesActives.icones.BoutonLecture;
	import fr.acversailles.crdp.imagesActives.icones.BoutonPause;
	import fr.acversailles.crdp.imagesActives.icones.BoutonReset;
	import fr.acversailles.crdp.imagesActives.icones.BoutonSonOff;
	import fr.acversailles.crdp.imagesActives.icones.BoutonSonOn;
	import fr.acversailles.crdp.imagesActives.icones.PignonLecture;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneControles extends Sprite implements IZoneControleAudio {
		private var largeur : Number;
		private var hauteur : Number;
		private var disposition : IDispositionAudio;
		private var boutonLecture : SimpleButton;
		private var boutonReset : SimpleButton;
		private var boutonSonOn : SimpleButton;
		private var boutonSonOff : SimpleButton;
		private var boutonPause : SimpleButton;
		private var pignon : PignonLecture;
		private var posDepartSlider : Number;
		private var posArriveeSlider : Number;
		private var rectSlider : Rectangle;
		private var controleVolume : IControleVolume;

		public function ZoneControles(disposition : IDispositionAudio) {
			this.disposition = disposition;
			largeur = disposition.getLargeurZoneControleAudio();
			hauteur = disposition.getHauteurZoneControleAudio();
			dessinerFond();
			ajouterBoutons();
			ajouterControleVolume();
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		private function ajouterControleVolume() : void {
			controleVolume = new ControleVolume(disposition.getLargeurZoneControleVolume(), disposition.getHauteurZoneControleVolume());
			addChild(controleVolume.sprite);
			controleVolume.sprite.x = largeur / 2 + (largeur / 2 - controleVolume.sprite.width) / 2;
		}

		private function gererMouseDown(event : MouseEvent) : void {
			if (event.target == pignon) {
				commencerDragPignon();
			} else if (event.target == boutonPause) {
				gererMouseDownBoutonPause();
			} else if (event.target == boutonLecture) {
				gererMouseDownBoutonLecture();
			} else if (event.target == boutonSonOff) {
				gererMouseDownBoutonSonOff();
			} else if (event.target == boutonSonOn) {
				gererMouseDownBoutonSonOn();
			} else if (event.target == boutonReset) {
				gererMouseDownBoutonReset();
			}
		}

		private function gererMouseDownBoutonReset() : void {
			dispatchEvent(new AudioEvent(AudioEvent.RESET));
			boutonPause.visible = true;
			boutonLecture.visible = false;
		}

		private function gererMouseDownBoutonSonOn() : void {
			dispatchEvent(new AudioEvent(AudioEvent.SON_ON));
			boutonSonOn.visible = false;
			boutonSonOff.visible = true;
		}

		private function gererMouseDownBoutonSonOff() : void {
			dispatchEvent(new AudioEvent(AudioEvent.SON_OFF));
			boutonSonOn.visible = true;
			boutonSonOff.visible = false;
		}

		private function gererMouseDownBoutonLecture() : void {
			repriseLecture();
			boutonPause.visible = true;
			boutonLecture.visible = false;
		}

		private function gererMouseDownBoutonPause() : void {
			pauseSon();
			boutonPause.visible = false;
			boutonLecture.visible = true;
		}

		private function commencerDragPignon() : void {
			addEventListener(MouseEvent.MOUSE_MOVE, gererMouseMove);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
			pauseSon();
		}

		private function gererMouseUp(event : MouseEvent) : void {
			if (event.target == pignon) gererMouseOut(event);
		}

		private function repriseLecture() : void {
			dispatchEvent(new AudioEvent(AudioEvent.LECTURE, valeurPignon()));
		}

		private function pauseSon() : void {
			dispatchEvent(new AudioEvent(AudioEvent.PAUSE));
		}

		private function gererMouseOut(event : MouseEvent) : void {
			if (event.target == pignon) {
				arreterDragPignon();
				transmettrePosition();
			}
		}

		private function transmettrePosition() : void {
			dispatchEvent(new AudioEvent(AudioEvent.POSITION, valeurPignon()));
			boutonPause.visible = true;
			boutonLecture.visible = false;
		}

		private function valeurPignon() : Number {
			return (pignon.x - posDepartSlider) / (posArriveeSlider - posDepartSlider);
		}

		private function arreterDragPignon() : void {
			removeEventListener(MouseEvent.MOUSE_MOVE, gererMouseMove);
			removeEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP, gererMouseOut);
		}

		private function gererMouseMove(event : MouseEvent) : void {
			pignon.x = Math.min(Math.max(event.stageX - x, rectSlider.left), rectSlider.right);
		}

		private function ajouterBoutons() : void {
			boutonLecture = new BoutonLecture();
			boutonPause = new BoutonPause();
			addChild(boutonLecture);
			addChild(boutonPause);
			boutonPause.width = boutonLecture.width = disposition.getLargeurBoutonsControle();
			boutonLecture.scaleY = boutonLecture.scaleX;
			boutonPause.height = boutonLecture.height;
			boutonPause.y = boutonLecture.y = hauteur - boutonLecture.height;
			boutonSonOn = new BoutonSonOn();
			boutonSonOff = new BoutonSonOff();
			boutonReset = new BoutonReset();
			addChild(boutonSonOff);
			addChild(boutonSonOn);
			boutonSonOff.width = boutonSonOn.width = boutonLecture.width;
			boutonSonOff.height = boutonSonOn.height = boutonLecture.height;
			boutonSonOff.x = boutonSonOn.x = boutonLecture.getBounds(this).right + disposition.getMargeEntreBoutonsControle();
			boutonReset.y = boutonSonOff.y = boutonSonOn.y = boutonLecture.y;
			boutonReset.x = boutonSonOn.getBounds(this).right + disposition.getMargeEntreBoutonsControle();
			boutonReset.height = boutonLecture.height;
			boutonReset.width = boutonLecture.width;
			addChild(boutonReset);
			recolorier(boutonReset);
			recolorier(boutonPause);
			recolorier(boutonLecture);
			recolorier(boutonSonOff);
			recolorier(boutonSonOn);

			pignon = new PignonLecture();
			pignon.height = disposition.getHauteurPignonSlider();
			pignon.scaleX = pignon.scaleY;
			pignon.y = hauteur - pignon.height / 2;
			posArriveeSlider = largeur - pignon.width;
			addChild(pignon);
			rectSlider = new Rectangle(posDepartSlider, pignon.y, posArriveeSlider - posDepartSlider, 0);
			visible = false;
		}

		private function recolorier(bouton : SimpleButton) : void {
			var coloration : ColorTransform = new ColorTransform();
			coloration.color = ContenuXML.instance.getParametreCouleur("color_3");
			bouton.transform.colorTransform = coloration;
		}

		private function dessinerFond() : void {
			graphics.lineStyle(2, ContenuXML.instance.getParametreCouleur("color_3"), 1, true, LineScaleMode.VERTICAL, CapsStyle.ROUND, JointStyle.ROUND);
			var pt0 : Point = new Point(largeur, hauteur);
			var pta1 : Point = new Point(largeur / 2, hauteur);
			var ptd1 : Point = pta1.clone();
			ptd1.offset(hauteur / 2, 0);
			var ptf1 : Point = pta1.clone();
			ptf1.offset(0, -hauteur / 2);
			var pta2 : Point = pta1.clone();
			pta2.offset(0, -hauteur);
			var ptf2 : Point = pta2.clone();
			ptf2.offset(-hauteur / 2, 0);
			var pt3 : Point = new Point(0, 0);

			graphics.moveTo(pt0.x, pt0.y);
			graphics.lineTo(ptd1.x, ptd1.y);
			graphics.curveTo(pta1.x, pta1.y, ptf1.x, ptf1.y);
			graphics.curveTo(pta2.x, pta2.y, ptf2.x, ptf2.y);
			graphics.lineTo(pt3.x, pt3.y);
			posDepartSlider = ptd1.x;			
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function miseAJourSlider(posLecture : Number) : void {
			pignon.x = posDepartSlider + (posArriveeSlider - posDepartSlider) * posLecture;
		}

		public function afficher() : void {
			visible = true;
			boutonPause.visible = true;
			boutonLecture.visible = false;
			boutonSonOn.visible = false;
			boutonSonOff.visible = true;
			miseAJourSlider(0);
		}

		public function masquer() : void {
			visible = false;
			arreterDragPignon();
		}

		public function setVolume(volume : int) : void {
			controleVolume.setVolume(volume);
		}
	}
}
