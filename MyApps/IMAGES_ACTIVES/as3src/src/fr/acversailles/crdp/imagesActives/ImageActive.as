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
package fr.acversailles.crdp.imagesActives {
	import flash.external.ExternalInterface;

	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.controle.IControleur;
	import fr.acversailles.crdp.imagesActives.credits.SupportFenetreCredits;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.embarque.ChargementEvent;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.BoutonAfficherTous;
	import fr.acversailles.crdp.imagesActives.icones.BoutonAgrandir;
	import fr.acversailles.crdp.imagesActives.icones.BoutonDescriptionGenerale;
	import fr.acversailles.crdp.imagesActives.icones.BoutonInformations;
	import fr.acversailles.crdp.imagesActives.icones.BoutonRetrecir;
	import fr.acversailles.crdp.imagesActives.image.IZoneImage;
	import fr.acversailles.crdp.imagesActives.image.ZoneImage;
	import fr.acversailles.crdp.imagesActives.infos.IZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.pass.BoiteMotDePasse;
	import fr.acversailles.crdp.imagesActives.preload.IPreloader;
	import fr.acversailles.crdp.imagesActives.preload.PreloaderParDefaut;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.imagesActives.tooltips.GestionnaireTooltips;
	import fr.acversailles.crdp.utils.functions.centrer;
	import fr.acversailles.crdp.utils.remplacerSautsDeLigne;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;

	public class ImageActive extends Sprite {
		private var zoneImage : IZoneImage;
		private var zoneTexte : IZoneTexte;
		private var controleur : IControleur;
		public static var supportCurseur : Sprite;
		private var zoneTitre : TextField;
		private var zoneInfosDroits : IZoneInfosDroits;
		private var boutonAgrandir : SimpleButton;
		private var boutonAfficherTousDetails : SimpleButton;
		private var boutonRetrecir : SimpleButton;
		private var boutonInformations : SimpleButton;
		private var boutonAfficherDescription : SimpleButton;
		private var boiteMotDePasse : BoiteMotDePasse;
		private var disposition : IDisposition;
		private var preloader : IPreloader;
		private var fauxFond : Sprite;
		private var masque : Shape;
		private var supportFenetreCredits : Sprite;

		public function ImageActive() {
			dessinerFauxFond();
			mettreMasque();
			CONFIG::preload {
				if (ExternalInterface.available)
					ExternalInterface.call("stopPreload");
			}
			SVGWrapper.initialiser(this.stage);
			if (SVGWrapper.instance.asynchrone)
				gererPreload();
			SVGWrapper.instance.addEventListener(ChargementEvent.CHARGEMENT_TERMINE, construireImage);
			SVGWrapper.instance.chargerRessources();
		}

		private function mettreMasque() : void {
			masque = new Shape();
			masque.graphics.beginFill(0x000000);
			masque.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			masque.graphics.endFill();
			addChild(masque);
			mask = masque;
		}

		private function dessinerFauxFond() : void {
			fauxFond = new Sprite();
			fauxFond.graphics.beginFill(0xFFFFFF, 0.01);
			fauxFond.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			fauxFond.graphics.endFill();
			addChild(fauxFond);
		}

		private function gererPreload() : void {
			SVGWrapper.instance.addEventListener(ChargementEvent.PROGRESSION, gererProgressionChargementRessources);
			SVGWrapper.instance.addEventListener(ChargementEvent.CHARGEMENT_COMMENCE, gererChargementNouvelleRessource);
			SVGWrapper.instance.addEventListener(ChargementEvent.ERREUR, gererErreurChargementRessource);
			afficherPreloader();
		}

		private function gererErreurChargementRessource(event : ChargementEvent) : void {
			preloader.afficherErreur();
		}

		private function gererChargementNouvelleRessource(event : ChargementEvent) : void {
			preloader.afficherNouvelleRessource(event.valeur1, event.valeur2);
		}

		private function afficherPreloader() : void {
			preloader = new PreloaderParDefaut();
			if (preloader.sprite.width > stage.stageWidth)
				preloader.sprite.scaleX = preloader.sprite.scaleY = stage.stageWidth / preloader.sprite.width;
			if (preloader.sprite.height > stage.stageHeight)
				preloader.sprite.scaleX = preloader.sprite.scaleY = stage.stageHeight / preloader.sprite.height;
			addChild(preloader.sprite);
			centrer(preloader.sprite, stage.stageWidth, stage.stageHeight);
		}

		private  function gererProgressionChargementRessources(event : ChargementEvent) : void {
			preloader.afficherProgression(event.valeur1);
		}

		private function construireImage(event : ChargementEvent) : void {
			if (preloader) preloader.sprite.visible = false;
			SVGWrapper.instance.construire();
			var modeleDisposition : String = ContenuXML.instance.modeleDisposition();
			var modeInteractivite : String = ContenuXML.instance.modeInteractivite();

			disposition = ImageActiveFactory.getDisposition(modeleDisposition, ImageActiveFactory.getTypeAffichage(modeInteractivite));

			GestionnaireTooltips.initialiserTooltips(disposition);
			GestionnaireTooltips.activerTooltips(true);
			supportCurseur = new Sprite();
			supportCurseur.mouseEnabled = false;
			zoneImage = new ZoneImage(disposition);

			zoneTexte = ImageActiveFactory.getZoneTexte(disposition);

			disposition.placerZoneTexte(zoneTexte);
			var classeControleur : Class = ImageActiveFactory.getControleur(modeInteractivite);

			creerBoutonsEcran();
			disposition.placerBouton(boutonAgrandir, true);
			disposition.placerBouton(boutonRetrecir);
			creerBoutonInformations();
			disposition.placerBouton(boutonInformations);
			creerBoutonAfficherTousDetails();
			disposition.placerBouton(boutonAfficherTousDetails);
			creerBoutonAfficherDescription();
			disposition.placerBouton(boutonAfficherDescription);

			addChild(zoneTexte.sprite);
			addChild(zoneImage.sprite);
			creerTitre();
			disposition.placerTitre(zoneTitre);
			disposition.dessinerFond(this);
			zoneInfosDroits = disposition.creerZoneInfosDroits();
			addChild(zoneInfosDroits.sprite);
			addChild(supportCurseur);
			mettreFenetreCredits();
			controleur = new classeControleur(zoneImage, zoneTexte, zoneInfosDroits, supportFenetreCredits, this);
			setChildIndex(fauxFond, 0);

			ecouterSouris();
		}

		private function mettreFenetreCredits() : void {
			supportFenetreCredits = new SupportFenetreCredits(disposition);
			addChild(supportFenetreCredits);
		}

		private function ecouterSouris() : void {
			addEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		private function creerBoutonAfficherDescription() : void {
			boutonAfficherDescription = new BoutonDescriptionGenerale();
			addChild(boutonAfficherDescription);
			boutonAfficherDescription.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDownBoutonAfficherDescriptions);
			GestionnaireTooltips.attacherTooltip(boutonAfficherDescription, ContenuXML.instance.getTexteCommun("general_description_tooltip"));
		}

		private function gererMouseDownBoutonAfficherDescriptions(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION));
		}

		private function creerBoutonInformations() : void {
			boutonInformations = new BoutonInformations();
			addChild(boutonInformations);
			boutonInformations.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDownBoutonInformations);
			GestionnaireTooltips.attacherTooltip(boutonInformations, ContenuXML.instance.getTexteCommun("information_tooltip"));
		}

		private function gererMouseDownBoutonInformations(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_INFOS));
		}

		private function creerBoutonAfficherTousDetails() : void {
			boutonAfficherTousDetails = new BoutonAfficherTous();
			addChild(boutonAfficherTousDetails);
			boutonAfficherTousDetails.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDownBoutonAfficherTousDetails);
			boutonAfficherTousDetails.addEventListener(MouseEvent.MOUSE_OUT, gererMouseOutBoutonAfficherTousDetails);
			GestionnaireTooltips.attacherTooltip(boutonAfficherTousDetails, ContenuXML.instance.getTexteCommun("all_details_button_tooltip"));
		}

		private function gererMouseOut(event : MouseEvent) : void {
			if (event.relatedObject == fauxFond) {
				dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OUT_ZONE_IMAGE));
			}
		}

		private function gererMouseDown(event : MouseEvent) : void {
			if (event.target == fauxFond)
				dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_FOND_SCENE));
		}

		private function gererMouseOutBoutonAfficherTousDetails(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_OUT_BOUTON_AFFICHER_DETAILS));
		}

		private function gererMouseUp(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_UP_SCENE));
		}

		private function gererMouseDownBoutonAfficherTousDetails(event : MouseEvent) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_AFFICHER_DETAILS));
		}

		private function creerBoutonsEcran() : void {
			boutonAgrandir = new BoutonAgrandir();
			addChild(boutonAgrandir);
			boutonRetrecir = new BoutonRetrecir();
			addChild(boutonRetrecir);
			actualiserBoutonsEcran();
			boutonAgrandir.addEventListener(MouseEvent.CLICK, changerTailleEcran);
			boutonRetrecir.addEventListener(MouseEvent.CLICK, changerTailleEcran);
			GestionnaireTooltips.attacherTooltip(boutonAgrandir, ContenuXML.instance.getTexteCommun("fullscreen_tooltip"));
			GestionnaireTooltips.attacherTooltip(boutonRetrecir, ContenuXML.instance.getTexteCommun("normal_screen_tooltip"));
		}

		private function changerTailleEcran(event : MouseEvent) : void {
			switch(event.target) {
				case boutonAgrandir:
					stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				case boutonRetrecir:
					stage.displayState = StageDisplayState.NORMAL;
					break;
			}
			actualiserBoutonsEcran();
		}

		private function actualiserBoutonsEcran() : void {
			boutonRetrecir.visible = stage.displayState == StageDisplayState.FULL_SCREEN;
			boutonAgrandir.visible = !boutonRetrecir.visible;
		}

		private function creerTitre() : void {
			zoneTitre = new TextField();
			zoneTitre.multiline = true;
			var police : String = StylesCSS.instance.styleToTextFormat(".title").font;
			zoneTitre.embedFonts = SVGWrapper.instance.policeExiste(police);
			zoneTitre.autoSize = TextFieldAutoSize.LEFT;

			zoneTitre.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(police, */ remplacerSautsDeLigne(SVGWrapper.instance.getTitre())/*)*/;
			zoneTitre.setTextFormat(StylesCSS.instance.styleToTextFormat(".title"));
			zoneTitre.wordWrap = true;
			zoneTitre.selectable = false;
			zoneTitre.antiAliasType = AntiAliasType.ADVANCED;
			zoneTitre.mouseEnabled = false;
			addChildAt(zoneTitre, 0);
		}

		public function afficherDemandeMotDePasse() : void {
			boiteMotDePasse.visible = true;
			boiteMotDePasse.activer();
		}

		public function creerBoiteMotDePasse(ns : Namespace, motDePasse : Number) : BoiteMotDePasse {
			boiteMotDePasse = new BoiteMotDePasse(ns, disposition.getLargeurZoneInputMotDePasse(), disposition.getPaddingHBoiteMotDePasse(), disposition.getPaddingVBoiteMotDePasse(), disposition.getRayonAngleBoiteMotDePasse(), motDePasse);
			addChild(boiteMotDePasse);
			centrer(boiteMotDePasse, disposition.largeurTotale, disposition.hauteurTotale);
			boiteMotDePasse.visible = false;
			return boiteMotDePasse;
		}

		public function masquerDemandeMotDepasse() : void {
			boiteMotDePasse.visible = false;
		}
	}
}
