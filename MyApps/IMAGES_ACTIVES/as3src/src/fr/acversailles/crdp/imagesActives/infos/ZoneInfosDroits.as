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
package fr.acversailles.crdp.imagesActives.infos {
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;

	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.BoutonDroit;
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;
	import fr.acversailles.crdp.utils.functions.chaineVide;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneInfosDroits extends Sprite implements IZoneInfosDroits {
		private static const DUREE : uint = 12;
		private static const VITESSE : Number = 0.5;
		private var zoneInfosDroits : TextField;
		private var bouton : Sprite;
		private var disposition : IDisposition;
		private var tween : Tween;
		private var _yDepart : Number;
		private var _etat : uint;
		private var hauteurTotale : Number;

		public function ZoneInfosDroits(disposition : IDisposition) {
			this.disposition = disposition;
			mettreTexte();
			mesurerHauteur();
			mettreSymbole();
			dessinerFond();
			creerTween();

			addEventListener(MouseEvent.ROLL_OVER, gererActionUtilisateur);
			addEventListener(MouseEvent.ROLL_OUT, gererActionUtilisateur);
			addEventListener(MouseEvent.MOUSE_DOWN, gererActionUtilisateur);
			cacheAsBitmap = true;
			buttonMode = true;
			mouseChildren = true;
		}

		private function mesurerHauteur() : void {
			hauteurTotale = zoneInfosDroits.getBounds(this).bottom + disposition.margeInfZoneInfosDroits();
		}

		private function creerTween() : void {
			tween = new Tween(this, "y", Strong.easeOut, y, y, DUREE);
			tween.stop();
		}

		private function gererActionUtilisateur(event : MouseEvent) : void {
			switch(event.type) {
				case MouseEvent.ROLL_OVER:
					dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OVER_ZONE_INFOS_DROITS));
					break;
				case MouseEvent.ROLL_OUT:
						dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OUT_ZONE_INFOS_DROITS));
					break;
				case MouseEvent.MOUSE_DOWN:
					if (!(event.target is TextField))
						dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_ZONE_INFOS_DROITS));
					break;
			}
		}

		private function mettreTexte() : void {
			zoneInfosDroits = new TextField();
			zoneInfosDroits.multiline = true;
			var police : String=StylesCSS.instance.styleToTextFormat(".infos").font;			
			zoneInfosDroits.embedFonts = SVGWrapper.instance.policeExiste(police);;
			zoneInfosDroits.width = disposition.largeurTotale;
			zoneInfosDroits.autoSize = TextFieldAutoSize.CENTER;
			zoneInfosDroits.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".infos");
			composerTexte();
			zoneInfosDroits.wordWrap = true;
			zoneInfosDroits.selectable = true;
			zoneInfosDroits.antiAliasType = AntiAliasType.ADVANCED;
			zoneInfosDroits.mouseEnabled = true;
			AnalyseurLiens.activerLiens(zoneInfosDroits);
			//TODO d�sactivation sur ce champs
			//zoneInfosDroits.text=SVGWrapper.instance.enleverCaracteresSansFonts(police, zoneInfosDroits.text);
			
			zoneInfosDroits.y = disposition.getHauteurSoulevementZoneInfosDroits();
			addChild(zoneInfosDroits);
			
		}
		private function composerTexte():void {
			if(!chaineVide(SVGWrapper.instance.getTitreImageSource()))
				zoneInfosDroits.appendText(SVGWrapper.instance.getTitreImageSource()+"\n");
			if(!chaineVide(SVGWrapper.instance.getAuteur()))
				zoneInfosDroits.appendText(SVGWrapper.instance.getAuteur()+" - ");
			if(!chaineVide(SVGWrapper.instance.getDate()))
				zoneInfosDroits.appendText(SVGWrapper.instance.getDate()+"\n");
			if(!chaineVide(SVGWrapper.instance.getSource()))
				zoneInfosDroits.appendText(SVGWrapper.instance.getSource()+"\n");
			if(!chaineVide(SVGWrapper.instance.getDroits())) zoneInfosDroits.appendText(SVGWrapper.instance.getDroits() + "\n");
		}

		private function mettreSymbole() : void {
			bouton = new BoutonDroit();
			bouton.height = disposition.hauteurBoutonZoneInfosDroits();
			bouton.width = disposition.largeurBoutonZoneInfosDroits();
			var margeInf : Number = (disposition.hauteurOngletZoneInfosDroits() - bouton.height ) / 2;
			bouton.y = - bouton.height - margeInf;
			bouton.x = disposition.margeGaucheBoutonZoneInfosDroits();
			bouton.mouseEnabled = false;
			addChild(bouton);
		}

		private function dessinerFond() : void {
			var hauteurOnglet : Number = disposition.hauteurOngletZoneInfosDroits();

			var hauteurVisible : Number = disposition.hauteurVisibleZoneInfos();
			graphics.beginFill(ContenuXML.instance.getParametreCouleur("color_1"));
			graphics.lineStyle(2, ContenuXML.instance.getParametreCouleur("color_3"), 1, true);
			var largeurOnglet : Number = disposition.largeurOngletZoneInfosDroits();

			var pt0 : Point = new Point(0, -hauteurOnglet - hauteurVisible);
			var pta1 : Point = pt0.clone();
			pta1.offset(largeurOnglet, 0);
			var ptd1 : Point = pta1.clone();
			ptd1.offset(- disposition.rayonArc * 2, 0);
			var ptf1 : Point = pta1.clone();
			ptf1.offset(disposition.rayonArc * 2, disposition.rayonArc * 2) ;
			var pta2 : Point = pta1.clone();
			pta2.offset(hauteurOnglet, hauteurOnglet);
			var ptd2 : Point = pta2.clone();
			var ptf2 : Point = pta2.clone();
			ptd2.offset(-disposition.rayonArc * 2, -disposition.rayonArc * 2);
			ptf2.offset(disposition.rayonArc * 2, 2);
			graphics.moveTo(pt0.x, pt0.y);
			graphics.lineTo(ptd1.x, ptd1.y);
			graphics.curveTo(pta1.x, pta1.y, ptf1.x, ptf1.y);
			graphics.lineTo(ptd2.x, ptd2.y);
			graphics.curveTo(pta2.x, pta2.y, ptf2.x, ptf2.y);

			graphics.lineTo(ContenuXML.instance.getLargeurTotale(), -hauteurVisible + 2);
			graphics.lineStyle();
			graphics.lineTo(ContenuXML.instance.getLargeurTotale(), hauteurTotale);
			graphics.lineTo(0, hauteurTotale);
			graphics.lineTo(pt0.x, pt0.y);
			graphics.endFill();
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function souleverLegerement() : void {
			if(_etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SOULEVE) return;
			tween.begin = y;
			tween.finish = _yDepart - disposition.getHauteurSoulevementZoneInfosDroits();
			recalculerVitesse();
			tween.start();
			_etat = EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SOULEVE;
		}

		private function recalculerVitesse() : void {
			tween.duration = Math.abs(tween.finish - tween.begin) * VITESSE;
		}

		public function set yDepart(yDepart : Number) : void {
			y = _yDepart = yDepart;
		}

		public function replacer() : void {
			if(_etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_REPOS) return;
			tween.begin = y;
			tween.finish = _yDepart;
			recalculerVitesse();
			tween.start();
			_etat = EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_REPOS;
		}

		public function get etat() : uint {
			return _etat;
		}

		public function sortir() : void {
			if(_etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SORTI) return;
			tween.begin = y;
			tween.finish = _yDepart - hauteurTotale;
			recalculerVitesse();
			tween.start();
			_etat = EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_SORTI;
		}

		public function descendreHorsEcran() : void {
			if(_etat == EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_DESCENDU_HORS_ECRAN) return;
			tween.begin = y;
			tween.finish = _yDepart + disposition.hauteurOngletZoneInfosDroits() + disposition.hauteurVisibleZoneInfos() + 1;
			recalculerVitesse();
			tween.start();
			_etat = EtatsZoneInfosDroits.ETAT_ZONE_INFO_DROITS_DESCENDU_HORS_ECRAN;
		}
	}
}
