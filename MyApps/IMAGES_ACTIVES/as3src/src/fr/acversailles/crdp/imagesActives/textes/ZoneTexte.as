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
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.textes.boutons.BoutonReponse;
	import fr.acversailles.crdp.imagesActives.tooltips.GestionnaireTooltips;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import org.flexunit.asserts.assertTrue;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneTexte extends Sprite implements IZoneTexte {
		protected var _disposition : IDisposition;
		protected var boutonReponse : BoutonReponse;
		protected var numeroEnCours : int;
		protected var nameSpaceComportement : Namespace;

		public function ZoneTexte(disposition : IDisposition) {
			this._disposition = disposition;
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, gererMouseUp);
			addEventListener(MouseEvent.MOUSE_OVER, gererMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
		}

		protected function gererMouseUp(event : MouseEvent) : void {
			avertirClasseAbstraite();
		}

		protected function gererMouseOut(event : MouseEvent) : void {
			avertirClasseAbstraite();
		}

		protected function gererMouseOver(event : MouseEvent) : void {
			avertirClasseAbstraite();
		}

		protected function gererMouseDown(event : MouseEvent) : void {
			if (event.target is BoutonReponse) {
				avertirClicBoutonReponse(numeroEnCours);
			}
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function afficherLegendeOuQuestion(numero : int) : void {
			this.numeroEnCours = numero;
		}

		public function afficherDescriptionOuConsigne() : void {
			avertirClasseAbstraite();
		}

		public function masquerTexte() : void {
			avertirClasseAbstraite();
		}

		public function arreterSon() : void {
			// ne fait rien la plupart du temps (sauf type audio)
		}

		public function construire(nameSpaceComportement : Namespace) : void {
			this.nameSpaceComportement = nameSpaceComportement;
		}

		public function afficherReponse(numero : int) : void {
			avertirClasseAbstraite();
		}

		protected function avertirClicBoutonReponse(numero : int) : void {
			dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_REPONSE, numero));
		}

		protected function creerBouton(_nameSpaceComportement : Namespace) : void {
			assertTrue("Le bouton n'est créé que dans un affichage de type question", _disposition.typeAffichage == Disposition.AFFICHAGE_QUESTIONS);
			boutonReponse = new BoutonReponse(_nameSpaceComportement, _disposition.getPaddingHBoutonreponse(), _disposition.getPaddingVBoutonreponse(), _disposition.getRayonAngleBoutonreponse(), _disposition.getDistanceBiseauBoutonreponse(), _disposition.getDistanceOmbreBoutonreponse());
			addChild(boutonReponse);
			GestionnaireTooltips.attacherTooltip(boutonReponse, ContenuXML.instance.getTexteSpecifique(_nameSpaceComportement, "answer_button_tooltip"));
		}

		protected function afficherBoutonReponse(visibilite : Boolean) : void {
			if (!boutonReponse) return ;
			boutonReponse.visible = visibilite;
		}
	}
}
