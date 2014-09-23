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
package fr.acversailles.crdp.imagesActives.textes.accordeon {
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	internal class CorpsCarte extends Sprite {
		private static const RETRAIT_FOND_H : Number = 0;
		private static const MARGE_V_TEXTE : Number = 5;
		private static const DUREE_OUVERTURE : Number = 12;
		protected static const SUPPLEMENT_ZONE_CONTENU_MINI : Number = 10;
		protected var supplementZoneContenu : Number;
		protected var couleur : uint;
		protected var hauteur : Number;
		protected var largeur : Number;
		private var contenu : String;
		protected var zoneContenu : TextField;
		private var masque : Shape;
		private var tweenMasque : Tween;
		private var _ouvert : Boolean;
		protected var rectangleDrag : Rectangle;
		protected var supportZoneContenu : Sprite;
		protected var gestionDebordementTexte : Boolean;
		protected var glissiere : GlissiereCarte;
		private var couleurCurseur : uint;
		protected var hauteurInitialeTexte : Number;
		private var largeurGlissiere : uint;

		// pour inclure le bouton dans le scroll
		public function CorpsCarte(contenu : String, largeur : Number, hauteur : Number, couleur : uint, couleurCurseur : uint, largeurGlissiere : uint) {
			this.largeurGlissiere = largeurGlissiere;
			this.couleurCurseur = couleurCurseur;
			this.contenu = contenu;
			this.largeur = largeur;
			this.hauteur = hauteur;
			this.couleur = couleur;
			supplementZoneContenu = SUPPLEMENT_ZONE_CONTENU_MINI;
			dessinerFond();
			mettreZoneContenu();
			determinerRectangleDrag();
			mettreMasque();
			creerTweenMasque();
		}

		private function determinerRectangleDrag() : void {
			var hauteurRectangleDrag : Number = MARGE_V_TEXTE + zoneContenu.height + supplementZoneContenu - hauteur ;
			rectangleDrag = new Rectangle(0, -hauteurRectangleDrag, 0, hauteurRectangleDrag);
		}

		private function mettreMasque() : void {
			masque = new Shape();
			masque.graphics.beginFill(0x000000);
			masque.graphics.drawRect(RETRAIT_FOND_H, 0, largeur - 2 * RETRAIT_FOND_H, hauteur);
			masque.graphics.endFill();
			addChild(masque);
			mask = masque;
			masque.height = 0;
			// on masque au départ
			_ouvert = false;
		}

		private function creerTweenMasque() : void {
			tweenMasque = new Tween(masque, "height", Regular.easeOut, 0, hauteur, DUREE_OUVERTURE);
			tweenMasque.stop();
		}

		private function dessinerFond() : void {
			graphics.beginFill(couleur);
			graphics.drawRect(RETRAIT_FOND_H, 0, largeur - 2 * RETRAIT_FOND_H, hauteur);
			graphics.endFill();
		}

		protected function mettreZoneContenu() : void {
			supportZoneContenu = new Sprite();
			zoneContenu = new TextField();
			zoneContenu.multiline = true;
			zoneContenu.embedFonts = SVGWrapper.instance.policeExiste(StylesCSS.instance.styleToTextFormat(".caption_text").font);
			zoneContenu.width = largeur - 2 * RETRAIT_FOND_H - ParametresXML.instance.unite;

			zoneContenu.x = RETRAIT_FOND_H + ParametresXML.instance.unite * 0.5;
			zoneContenu.y = MARGE_V_TEXTE;
			zoneContenu.autoSize = TextFieldAutoSize.LEFT;

			zoneContenu.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".caption_text");

			zoneContenu.wordWrap = true;
			zoneContenu.selectable = true;
			zoneContenu.mouseWheelEnabled = false;
			zoneContenu.antiAliasType = AntiAliasType.NORMAL;

			zoneContenu.mouseEnabled = true;

			actualiserTexte(contenu);

			hauteurInitialeTexte = zoneContenu.getBounds(this).bottom;
			testerDebordementTexte();
			addChild(supportZoneContenu);
			supportZoneContenu.addChild(zoneContenu);
			
		}

		protected function testerDebordementTexte() : void {
			// hauteur moins une ligne
			if (zoneContenu.textHeight > hauteur - int(zoneContenu.getTextFormat().size))
				gererDebordementtexte();
		}

		protected function actualiserTexte(contenu : String) : void {
			zoneContenu.text = contenu;
			
			//zoneContenu.text = SVGWrapper.instance.enleverCaracteresSansFonts(zoneContenu.getTextFormat().font,contenu);
			ajouterLiens();
		}

		private function ajouterLiens() : void {
			AnalyseurLiens.activerLiens(zoneContenu);
		}

		protected function gererDebordementtexte() : void {
			if (!gestionDebordementTexte) {
				zoneContenu.width -= largeurGlissiere;
				mettreGlissiere();
			} else redimensionnerGlissiere();
			gestionDebordementTexte = true;
			supportZoneContenu.buttonMode = gestionDebordementTexte;
			determinerRectangleDrag();
		}

		private function redimensionnerGlissiere() : void {
			glissiere.redimensionner(MARGE_V_TEXTE + zoneContenu.height + supplementZoneContenu);
		}

		private function mettreGlissiere() : void {
			glissiere = new GlissiereCarte(hauteur, MARGE_V_TEXTE + zoneContenu.height + supplementZoneContenu, largeurGlissiere, couleurCurseur);
			addChild(glissiere);
			glissiere.x = largeur - largeurGlissiere;
			glissiere.addEventListener(CurseurEvent.DEPLACEMENT, actualiserPositiontexte);
		}

		private function actualiserPositiontexte(event : CurseurEvent) : void {
			var posCurseur : Number = event.posY;
			supportZoneContenu.y = -posCurseur * (MARGE_V_TEXTE + zoneContenu.height + supplementZoneContenu) / hauteur;
		}

		private function gererDragDrop(boolean : Boolean) : void {
			if (!gestionDebordementTexte)
				return;
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, commencerDrag);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, signalerDeplacement);
			}
			if (boolean)
				addEventListener(MouseEvent.MOUSE_DOWN, commencerDrag);
			else
				removeEventListener(MouseEvent.MOUSE_DOWN, commencerDrag);
		}

		protected function signalerDeplacement(event : MouseEvent) : void {
			var posCurseur : Number = -supportZoneContenu.y * hauteur / (zoneContenu.height + supplementZoneContenu);
			glissiere.ajusterCurseur(posCurseur);
		}

		private function commencerDrag(event : MouseEvent) : void {
			if (!gestionDebordementTexte)
				return;
			if (glissiere.contains(event.target as DisplayObject))
				return;
			removeEventListener(MouseEvent.MOUSE_DOWN, commencerDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, arreterDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, signalerDeplacement);
			supportZoneContenu.startDrag(false, rectangleDrag);
		}

		private function arreterDrag(event : MouseEvent) : void {
			if (!gestionDebordementTexte)
				return;
			supportZoneContenu.stopDrag();
			gererDragDrop(true);
		}

		public function afficher(boolean : Boolean) : void {
			if (_ouvert == boolean)
				return;
			tweenMasque.begin = boolean ? 0 : hauteur;
			tweenMasque.finish = boolean ? hauteur : 0;
			tweenMasque.start();
			_ouvert = boolean;
			if (gestionDebordementTexte) {
				gererDragDrop(boolean);
				gererMoletteSouris();
			}
		}

		private function gererMoletteSouris() : void {
			addEventListener(MouseEvent.MOUSE_WHEEL, gererRotationMolette);
		}

		private function gererRotationMolette(event : MouseEvent) : void {
			supportZoneContenu.y += event.delta * int(StylesCSS.instance.styleToTextFormat(".caption_text").size);
			supportZoneContenu.y = Math.min(0, supportZoneContenu.y);
			supportZoneContenu.y = Math.max(rectangleDrag.top, supportZoneContenu.y);
			signalerDeplacement(null);
		}

		public function get ouvert() : Boolean {
			return _ouvert;
		}
	}
} 
