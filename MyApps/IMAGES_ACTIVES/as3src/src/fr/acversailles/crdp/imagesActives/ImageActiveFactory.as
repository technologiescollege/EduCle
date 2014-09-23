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
	import fr.acversailles.crdp.imagesActives.controle.ControleurDecouverte;
	import fr.acversailles.crdp.imagesActives.controle.ControleurQuiz;
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.DispositionAudio;
	import fr.acversailles.crdp.imagesActives.dispositions.DispositionAccordeon;
	import fr.acversailles.crdp.imagesActives.dispositions.DispositionLegendesCouvrantes;
	import fr.acversailles.crdp.imagesActives.dispositions.DispositionLegendesHautBas;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAudio;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAccordeon;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionLegendesCouvrantes;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionLegendesHautBas;
	import fr.acversailles.crdp.imagesActives.dispositions.OptionsDisposition;
	import fr.acversailles.crdp.imagesActives.image.controle.OptionsInteractivite;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.imagesActives.textes.accordeon.ZoneTexteAccordeon;
	import fr.acversailles.crdp.imagesActives.textes.audio.ZoneTexteAudio;
	import fr.acversailles.crdp.imagesActives.textes.legendesCouvrantes.ZoneTexteLegendesCouvrantes;
	import fr.acversailles.crdp.imagesActives.textes.legendesHautBas.ZoneTexteLegendesHautBas;

	import flash.errors.IllegalOperationError;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	internal class ImageActiveFactory {

		internal static function getDisposition(modeleDisposition : String, typeAffichage : uint) : IDisposition {
			switch(modeleDisposition) {
				case OptionsDisposition.ACCORDION_LAYOUT:
					return new DispositionAccordeon(typeAffichage);
					break;
				case OptionsDisposition.TOP_BOTTOM_CAPTIONS_LAYOUT:
					return new DispositionLegendesHautBas(typeAffichage);
					break;
				case OptionsDisposition.COVERING_CAPTIONS_LAYOUT:
					return new DispositionLegendesCouvrantes(typeAffichage);
					break;
				case OptionsDisposition.AUDIO_LAYOUT:
					return new DispositionAudio(typeAffichage);
					break;
				default:
					throw new IllegalOperationError("Cette disposition n'existe pas :" + modeleDisposition);
			}
			return null;
		}

		public static function getControleur(modeInteractivite : String) : Class {
			switch(modeInteractivite) {
				case OptionsInteractivite.SIMPLE_DISCOVERY_INTERACTIVITY_MODE:
					return ControleurDecouverte;
					break;
				case OptionsInteractivite.QUIZZ_INTERACTIVITY_MODE:
					return ControleurQuiz;
					break;
				default:
					throw new IllegalOperationError("Cette interactivité n'existe pas :" + modeInteractivite);
			}
			return null;
		}

		public static function getZoneTexte(disposition : IDisposition) : IZoneTexte {
			if (disposition is IDispositionAccordeon)
				return new ZoneTexteAccordeon(IDispositionAccordeon(disposition));
			else if (disposition is IDispositionLegendesCouvrantes)
				return new ZoneTexteLegendesCouvrantes(IDispositionLegendesCouvrantes(disposition));
			else if (disposition is IDispositionLegendesHautBas)
				return new ZoneTexteLegendesHautBas(IDispositionLegendesHautBas(disposition));
			else if (disposition is IDispositionAudio)
				return new ZoneTexteAudio(IDispositionAudio(disposition));
			throw new IllegalOperationError("Ce type de texte n'existe pas :");

			return null;
		}

		public static function getTypeAffichage(modeInteractivite : String) : uint {
			switch(modeInteractivite) {
				case OptionsInteractivite.SIMPLE_DISCOVERY_INTERACTIVITY_MODE:
					return Disposition.AFFICHAGE_LEGENDES;
					break;
				case OptionsInteractivite.QUIZZ_INTERACTIVITY_MODE:
					return Disposition.AFFICHAGE_QUESTIONS;
					break;
				default:
					throw new IllegalOperationError("Cette interactivité n'existe pas :" + modeInteractivite);
			}
			return null;
		}
	}
}
