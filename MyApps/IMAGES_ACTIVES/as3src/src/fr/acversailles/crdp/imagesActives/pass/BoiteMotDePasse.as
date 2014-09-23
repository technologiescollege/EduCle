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
package fr.acversailles.crdp.imagesActives.pass {
	import flash.display.DisplayObject;
	import fr.acversailles.crdp.imagesActives.icones.BoutonEffacer;
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.Bouton0;
	import fr.acversailles.crdp.imagesActives.icones.Bouton1;
	import fr.acversailles.crdp.imagesActives.icones.Bouton2;
	import fr.acversailles.crdp.imagesActives.icones.Bouton3;
	import fr.acversailles.crdp.imagesActives.icones.Bouton4;
	import fr.acversailles.crdp.imagesActives.icones.Bouton5;
	import fr.acversailles.crdp.imagesActives.icones.Bouton6;
	import fr.acversailles.crdp.imagesActives.icones.Bouton7;
	import fr.acversailles.crdp.imagesActives.icones.Bouton8;
	import fr.acversailles.crdp.imagesActives.icones.Bouton9;
	import fr.acversailles.crdp.imagesActives.icones.BoutonFermer;
	import fr.acversailles.crdp.imagesActives.icones.BoutonValider;
	import fr.acversailles.crdp.utils.graphiques.InteractiveSprite;

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class BoiteMotDePasse extends Sprite {
		private var zoneInput : TextField;
		private var etiquette : TextField;
		private var paddingH : Number;
		private var paddingV : Number;
		private var rayonAngle : Number;
		private var motDePasse : Number;
		private var largeurInput : Number;
		private var boutonValider : BoutonBoiteMotDePasse;
		private var boutonAnnuler : BoutonBoiteMotDePasse;
		private var nameSpaceComportement : Namespace;
		private var iconesBoutonsChiffres : Vector.<Sprite>;
		private var boutonsChiffres : Vector.<BoutonBoiteMotDePasse>;
		private var boutonEffacer : BoutonBoiteMotDePasse;

		public function BoiteMotDePasse(nameSpaceComportement : Namespace, largeurInput : Number, paddingH : Number, paddingV : Number, rayonAngle : Number, motDePasse : Number) {
			this.nameSpaceComportement = nameSpaceComportement;
			this.largeurInput = largeurInput;
			this.motDePasse = motDePasse;
			this.rayonAngle = rayonAngle;
			this.paddingV = paddingV;
			this.paddingH = paddingH;
			this.iconesBoutonsChiffres = Vector.<Sprite>([new Bouton0(), new Bouton1(), new Bouton2(), new Bouton3(), new Bouton4, new Bouton5, new Bouton6, new Bouton7, new Bouton8, new Bouton9]);
			creerEtiquette();
			creerZoneInput();
			mettreBoutons();
			dessinerFond();
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.beginFill(ParametresXML.instance.getParametreCouleur("password_box_background_color"), 0.4);
			var bordGauche:Number=Math.min(0, this.getBounds(this).left-paddingH);
			graphics.drawRoundRect(bordGauche, 0, width + 2 * paddingH, height + 2 * paddingV, rayonAngle, rayonAngle);
			graphics.endFill();
		}

		private function mettreBoutons() : void {
			var marge : Number = ParametresXML.instance.unite * 0.3;
			this.boutonsChiffres = new Vector.<BoutonBoiteMotDePasse>();
			var nouveauBouton : BoutonBoiteMotDePasse;
			for (var i : int = 0; i < iconesBoutonsChiffres.length; i++) {
				nouveauBouton = new BoutonBoiteMotDePasse(iconesBoutonsChiffres[i], ParametresXML.instance.getParametreCouleur("password_box_number_button_up_color"), ParametresXML.instance.getParametreCouleur("password_box_number_button_hover_color"), ParametresXML.instance.getParametreCouleur("password_box_number_button_down_color"));
				boutonsChiffres.push(nouveauBouton);
				nouveauBouton.addEventListener(MouseEvent.CLICK, gererClicBoutonChiffre);
				addChild(nouveauBouton);
			}
			boutonEffacer = new BoutonBoiteMotDePasse(new BoutonEffacer(), ParametresXML.instance.getParametreCouleur("password_box_delete_button_up_color"), ParametresXML.instance.getParametreCouleur("password_box_delete_button_hover_color"), ParametresXML.instance.getParametreCouleur("password_box_delete_button_down_color"));
			boutonValider = new BoutonBoiteMotDePasse(new BoutonValider(), ParametresXML.instance.getParametreCouleur("password_box_validation_button_up_color"), ParametresXML.instance.getParametreCouleur("password_box_validation_button_hover_color"), ParametresXML.instance.getParametreCouleur("password_box_validation_button_down_color"));
			boutonAnnuler = new BoutonBoiteMotDePasse(new BoutonFermer(), ParametresXML.instance.getParametreCouleur("password_box_cancel_button_up_color"), ParametresXML.instance.getParametreCouleur("password_box_cancel_button_hover_color"), ParametresXML.instance.getParametreCouleur("password_box_cancel_button_down_color"));
			addChild(boutonEffacer);
			addChild(boutonValider);
			addChild(boutonAnnuler);

			boutonAnnuler.y = boutonEffacer.y = etiquette.getBounds(this).bottom + marge;
			boutonValider.y = boutonEffacer.getBounds(this).bottom + marge;
			boutonAnnuler.x = zoneInput.getBounds(this).right - boutonEffacer.width;
			boutonValider.x = boutonEffacer.x = boutonAnnuler.x - boutonValider.width - marge;

			boutonValider.addEventListener(MouseEvent.CLICK, gererClicBoutonValider);
			boutonAnnuler.addEventListener(MouseEvent.CLICK, gererClicBoutonAnnuler);
			boutonEffacer.addEventListener(MouseEvent.CLICK, gererClicBoutonEffacer);
			var curseurX : Number = boutonValider.x;
			var curseurY : Number = boutonValider.y;
			var compteur : int;
			for (i = boutonsChiffres.length - 1; i >= 0; i--) {
				compteur = 9 - i;
				nouveauBouton = boutonsChiffres[i];

				if (i == 4) {
					curseurX = boutonValider.x;
					curseurY = boutonEffacer.y;
				}
				curseurX -= boutonsChiffres[9].width + marge;
				nouveauBouton.x = curseurX;
				nouveauBouton.y = curseurY;
			}
		}

		private function gererClicBoutonChiffre(event : MouseEvent) : void {
			var cible : DisplayObject = DisplayObject(event.target);
			while(!(cible is BoutonBoiteMotDePasse) )
				{
					if(cible.parent) cible=cible.parent;
					else return;
				}
			var bouton : BoutonBoiteMotDePasse = cible as BoutonBoiteMotDePasse;
			var chiffre : String = boutonsChiffres.indexOf(bouton).toString();
			//TODO dans fichier de paramètres
			if(zoneInput.text.length>=6)
				zoneInput.text=zoneInput.text.substring(1);
			zoneInput.appendText(chiffre);
		}

		private function gererClicBoutonAnnuler(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.ABANDON_DEVERROUILLAGE_ANIMATION));
		}

		private function gererClicBoutonValider(event : MouseEvent) : void {
			if (zoneInput.text == motDePasse.toString()) {
				dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.DEVERROUILLAGE_ANIMATION));
			} else {
				zoneInput.text = "";
			}
		}
		private function gererClicBoutonEffacer(event : MouseEvent) : void {
			if (zoneInput.text.length==0) return;
			zoneInput.text = zoneInput.text.substr(0, -1);
			
		}

		private function creerZoneInput() : void {
			zoneInput = new TextField();
			zoneInput.background = true;
			zoneInput.backgroundColor = ParametresXML.instance.getParametreCouleur("password_box_input_color");
			zoneInput.displayAsPassword = true;
			zoneInput.multiline = false;
			zoneInput.wordWrap = false;
			var police : String = StylesCSS.instance.styleToTextFormat(".password_box_input").font;
			zoneInput.embedFonts = SVGWrapper.instance.policeExiste(police);
			zoneInput.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".password_box_input");
			zoneInput.width = largeurInput;
			zoneInput.height = etiquette.height;
			zoneInput.border = true;
			zoneInput.borderColor = ParametresXML.instance.getParametreCouleur("password_box_input_border_color");
			addChild(zoneInput);
			zoneInput.x = etiquette.getBounds(this).right;
			zoneInput.y = paddingV;
		}

		private function creerEtiquette() : void {
			etiquette = new TextField();
			etiquette.background = true;
			etiquette.backgroundColor = ParametresXML.instance.getParametreCouleur("password_box_label_color");
			etiquette.mouseEnabled = false;
			etiquette.selectable = false;
			etiquette.multiline = false;
			etiquette.wordWrap = false;
			var police : String = StylesCSS.instance.styleToTextFormat(".password_box_label").font;
			etiquette.embedFonts = SVGWrapper.instance.policeExiste(police);
			etiquette.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".password_box_label");
			etiquette.autoSize = TextFieldAutoSize.CENTER;
			etiquette.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(police,*/ ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "password_box_label") + " "/*)*/;
			addChild(etiquette);
			etiquette.x = paddingH;
			etiquette.y = paddingV;
		}

		public function activer() : void {
			zoneInput.text = "";
			parent.setChildIndex(this, parent.numChildren - 1);
		}
	}
}
