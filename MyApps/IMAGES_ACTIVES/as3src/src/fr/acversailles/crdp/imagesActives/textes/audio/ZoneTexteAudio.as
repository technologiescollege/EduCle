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
package fr.acversailles.crdp.imagesActives.textes.audio {
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAudio;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;
	import fr.acversailles.crdp.imagesActives.textes.ZoneTexte;
	import fr.acversailles.crdp.imagesActives.textes.audio.controles.AudioEvent;
	import fr.acversailles.crdp.imagesActives.textes.audio.controles.IZoneControleAudio;
	import fr.acversailles.crdp.imagesActives.textes.audio.controles.ZoneControles;

	import org.flexunit.asserts.assertTrue;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneTexteAudio extends ZoneTexte implements IZoneTexte {
		private static const AUCUN_SON : int = -9999;
		private static const VOLUME_DE_DEPART : int = 5;
		private var canal : SoundChannel;
		private var zoneControles : IZoneControleAudio;
		private var longueurSon : Number;
		private var sonEnCours : Sound;
		private var positionEnCours : Number;
		private var enPause : Boolean;
		private var _volume : int;
		private var memoireVolume : int;
		private var affichageReponse : Boolean;

		public function ZoneTexteAudio(disposition : IDispositionAudio) {
			super(disposition);
			ajouterControles();
			volume = VOLUME_DE_DEPART;
			numeroEnCours = AUCUN_SON;
		}

		override public function construire(nameSpaceComportement : Namespace) : void {
			super.construire(nameSpaceComportement);
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					creerBouton(nameSpaceComportement);
					positionnerBouton();
					afficherBoutonReponse(false);
					break;
				default:
					assertTrue("ce type d'affichage n'existe pas :" + _disposition.typeAffichage, false);
			}
		}

		private function positionnerBouton() : void {
			boutonReponse.y = zoneControles.sprite.y;
			boutonReponse.x = zoneControles.sprite.x - boutonReponse.width - (_disposition as IDispositionAudio).getMargeDroiteBoutonReponse();
		}

		private function ajouterControles() : void {
			zoneControles = new ZoneControles(IDispositionAudio(_disposition));

			addChild(zoneControles.sprite);
			zoneControles.sprite.x = (_disposition as IDispositionAudio).getXZoneControleAudio();
			zoneControles.sprite.y = (_disposition as IDispositionAudio).getYZoneControleAudio();
			zoneControles.sprite.addEventListener(AudioEvent.POSITION, gererChangementPositionSlider);
			zoneControles.sprite.addEventListener(AudioEvent.PAUSE, gererDemandePause);
			zoneControles.sprite.addEventListener(AudioEvent.LECTURE, gererDemandeLecture);
			zoneControles.sprite.addEventListener(AudioEvent.SON_OFF, gererDemandeSonOff);
			zoneControles.sprite.addEventListener(AudioEvent.SON_ON, gererDemandeSonOn);
			zoneControles.sprite.addEventListener(AudioEvent.RESET, gererDemandeReset);
			zoneControles.sprite.addEventListener(AudioEvent.VOLUME, gererChangementVolume);
		}

		private function gererChangementVolume(event : AudioEvent) : void {
			volume = event.position;
			actualiserLectureSon();
		}

		private function gererDemandeReset(event : AudioEvent) : void {
			enPause = false;
			positionEnCours = 0;
			actualiserLectureSon();
		}

		private function gererDemandeSonOn(event : AudioEvent) : void {
			volume = memoireVolume;
			actualiserLectureSon();
		}

		private function gererDemandeSonOff(event : AudioEvent) : void {
			memoireVolume = _volume;
			volume = 0;
			actualiserLectureSon();
		}

		private function gererDemandeLecture(event : AudioEvent) : void {
			enPause = false;
			positionEnCours = event.position * longueurSon;
			actualiserLectureSon();
		}

		private function gererDemandePause(event : AudioEvent) : void {
			enPause = true;
			actualiserLectureSon();
		}

		private function gererChangementPositionSlider(event : AudioEvent) : void {
			enPause = false;
			positionEnCours = event.position * longueurSon;
			actualiserLectureSon();
		}

		private function actualiserLectureSon() : void {
			canal.stop();
			if (canal && canal.hasEventListener(Event.SOUND_COMPLETE)) {
				canal.removeEventListener(Event.SOUND_COMPLETE, lireJingleFin);
				canal.removeEventListener(Event.SOUND_COMPLETE, lireTexte);
			}
			suivreProgression(false);
			if (enPause) {
				return;
			}
			if (sonEnCours) {
				canal = sonEnCours.play(positionEnCours);
				canal.addEventListener(Event.SOUND_COMPLETE, lireJingleFin);
				suivreProgression(true);
			}
			appliquerVolume();
		}

		override public function afficherLegendeOuQuestion(numero : int) : void {
			if (_disposition.typeAffichage == Disposition.AFFICHAGE_LEGENDES && numero == this.numeroEnCours) return;
			super.afficherLegendeOuQuestion(numero);
			affichageReponse = false;
			declencherSon();
		}

		private function declencherSon() : void {
			if (canal) {
				canal.removeEventListener(Event.SOUND_COMPLETE, lireJingleFin);
				canal.removeEventListener(Event.SOUND_COMPLETE, lireTexte);
				canal.stop();
			}
			canal = SVGWrapper.instance.getSon("jingleDebut").play();
			canal.addEventListener(Event.SOUND_COMPLETE, lireTexte);
			appliquerVolume();
		}

		private function appliquerVolume() : void {
			canal.soundTransform = new SoundTransform(_volume / 5);
		}

		private function lireTexte(event : Event) : void {
			zoneControles.afficher();
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					if (numeroEnCours >= 0)
						sonEnCours = SVGWrapper.instance.getSon("detail", numeroEnCours);
					else
						sonEnCours = SVGWrapper.instance.getSon("description");
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					if (numeroEnCours >= 0) {
						sonEnCours = SVGWrapper.instance.getSon((affichageReponse ? "reponse" : "question") , numeroEnCours);
						afficherBoutonReponse(true);
					} else {
						sonEnCours = SVGWrapper.instance.getSon("consigne");
						afficherBoutonReponse(false);
					}
					break;
				default:
					assertTrue("ce type d'affichage n'existe pas :" + _disposition.typeAffichage, false);
			}

			longueurSon = sonEnCours.length;
			positionEnCours = 0;
			enPause = false;
			actualiserLectureSon();
		}

		private function suivreProgression(boolean : Boolean) : void {
			if (boolean) addEventListener(Event.ENTER_FRAME, lireProgression);
			else removeEventListener(Event.ENTER_FRAME, lireProgression);
		}

		private function lireProgression(event : Event) : void {
			positionEnCours = canal.position;
			zoneControles.miseAJourSlider(positionEnCours / longueurSon);
		}

		private function lireJingleFin(event : Event = null) : void {
			if (event) {
				canal.removeEventListener(Event.SOUND_COMPLETE, lireJingleFin);
				suivreProgression(false);
			}
			canal = SVGWrapper.instance.getSon("jingleFin").play();
			appliquerVolume();
		}

		override public function afficherDescriptionOuConsigne() : void {
			afficherLegendeOuQuestion(-1);
		}

		override public function masquerTexte() : void {
			// ne rien faire
		}

		override public function arreterSon() : void {
			if (canal) {
				canal.stop();
				suivreProgression(false);
				if (canal.hasEventListener(Event.SOUND_COMPLETE)) {
					canal.removeEventListener(Event.SOUND_COMPLETE, lireJingleFin);
					canal.removeEventListener(Event.SOUND_COMPLETE, lireTexte);
					lireJingleFin();
				}
			}
			zoneControles.masquer();
			afficherBoutonReponse(false);
			numeroEnCours = AUCUN_SON;
		}

		override protected function gererMouseOver(event : MouseEvent) : void {
		}

		override protected function gererMouseDown(event : MouseEvent) : void {
			super.gererMouseDown(event);
		}

		override protected function gererMouseOut(event : MouseEvent) : void {
		}

		override protected function gererMouseUp(event : MouseEvent) : void {
		}

		public function set volume(volume : int) : void {
			_volume = volume;
			zoneControles.setVolume(_volume);
		}

		override public function afficherReponse(numero : int) : void {
			super.afficherLegendeOuQuestion(numero);
			affichageReponse = true;
			declencherSon();
		}
	}
}
