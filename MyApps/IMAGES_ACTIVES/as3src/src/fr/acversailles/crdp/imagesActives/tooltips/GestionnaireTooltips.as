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
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import flash.display.InteractiveObject;

	/**
	 * @author Dornbusch
	 */
	public class GestionnaireTooltips {
		private static var tooltipables : Vector.<Tooltipable>;

		public static function attacherTooltip(objet : InteractiveObject, texte : String) : void {
			if (!tooltipables)
				reinitialiser();
			if (dejaEnregistre(objet))
				modifierTexte(objet, texte);
			else
				ajouterToolTipable(objet, texte);
		}

		public static function reinitialiser() : void {
			tooltipables = new Vector.<Tooltipable>();
			GestionnaireAffichageTooltips.initialiser();
		}

		private static function dejaEnregistre(objet : InteractiveObject) : Boolean {
			return getTooltipable(objet) != null;
		}

		private static function modifierTexte(objet : InteractiveObject, texte : String) : void {
			getTooltipable(objet).texte = texte;
		}

		private static function ajouterToolTipable(objet : InteractiveObject, texte : String) : void {
			var tooltipable : Tooltipable = new Tooltipable(objet, texte);
			tooltipable.activer();
			tooltipables.push(tooltipable);
		}

		public static function desactiverTooltip(objet : InteractiveObject) : void {
			if (dejaEnregistre(objet) && getTooltipable(objet).active)
				getTooltipable(objet).desactiver();
		}

		public static function activerTooltip(objet : InteractiveObject) : void {
			if (dejaEnregistre(objet) && !getTooltipable(objet).active)
				getTooltipable(objet).activer();
		}

		private static function getTooltipable(objet : InteractiveObject) : Tooltipable {
			for each (var tooltipable : Tooltipable in tooltipables) {
				if (tooltipable.objet == objet)
					return tooltipable;
			}
			return null;
		}

		public static function activerTooltips(boolean : Boolean) : void {
			GestionnaireAffichageTooltips.activerTooltips(boolean);
		}

		public static function initialiserTooltips(disposition : IDisposition) : void {
			Tooltip.initialiser(disposition);
		}
	}
}
