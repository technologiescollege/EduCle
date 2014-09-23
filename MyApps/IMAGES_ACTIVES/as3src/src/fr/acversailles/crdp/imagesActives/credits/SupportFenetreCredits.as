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
package fr.acversailles.crdp.imagesActives.credits {
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.icones.FenetreCredits;
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;
	import fr.acversailles.crdp.utils.functions.adapterPoliceALaHauteur;
	import fr.acversailles.crdp.utils.functions.centrer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class SupportFenetreCredits extends Sprite {
		[Embed(source="../../../../../../assets/credits/credits.txt",mimeType="application/octet-stream")]
		public static const TexteCredits : Class;
		private var disposition : IDisposition;
		private var fenetre : Sprite;
		private var proportion : Number;
		private var zoneTexte : TextField;

		public function SupportFenetreCredits(disposition : IDisposition) {
			this.disposition = disposition;
			dessinerFond();
			mettreFenetre();
			ajouterTexte();
			ecouterClic();
		}

		private function ajouterTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.selectable = false;
			zoneTexte.mouseEnabled = true;
			zoneTexte.antiAliasType = AntiAliasType.NORMAL;
			var police : String=StylesCSS.instance.styleToTextFormat(".texte_credits").font;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(police);
			zoneTexte.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".texte_credits");
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			var texte:String=new TexteCredits().toString().replace(/##/g, "\n");

			zoneTexte.height = zoneTexte.textHeight + 4;
			addChild(zoneTexte);
			zoneTexte.y = fenetre.height  * 0.5 + fenetre.y;
			zoneTexte.x = fenetre.width * 0.1 + fenetre.x;
			zoneTexte.width = fenetre.width * 0.8;
			
			zoneTexte.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(police,*/ texte;/*)*/;
			
			
			adapterPoliceALaHauteur(zoneTexte, fenetre.height * 0.40);
			//adapterpolice joue sur setTexteFormat,
			//activer lien utilise defaulttexteFormat
			zoneTexte.defaultTextFormat= zoneTexte.getTextFormat();
			AnalyseurLiens.activerLiens(zoneTexte);
		}

		private function ecouterClic() : void {
			fenetre.addEventListener(MouseEvent.MOUSE_DOWN, gererClicFenetre);
		}

		private function gererClicFenetre(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_FENETRE_CREDITS));
		}

		private function mettreFenetre() : void {
			fenetre = new FenetreCredits();
			addChild(fenetre);
			if (fenetre.width / fenetre.height > disposition.largeurTotale / disposition.hauteurTotale)
				contraindreParLargeur();
			else contraindreParHauteur();
			fenetre.width *= proportion;
			fenetre.height *= proportion;
			centrer(fenetre, disposition.largeurTotale, disposition.hauteurTotale);
			fenetre.buttonMode = true;
		}

		private function contraindreParHauteur() : void {
			proportion = disposition.hauteurTotale * disposition.getProportionMaxFenetreCredits() / fenetre.height;
		}

		private function contraindreParLargeur() : void {
			proportion = disposition.largeurTotale * disposition.getProportionMaxFenetreCredits() / fenetre.width;
		}

		private function dessinerFond() : void {
			graphics.beginFill(0x000000, ParametresXML.instance.getParametreCommun("credits_window_background_alpha"));
			graphics.drawRect(0, 0, disposition.largeurTotale, disposition.hauteurTotale);
			graphics.endFill();
		}
	}
}
