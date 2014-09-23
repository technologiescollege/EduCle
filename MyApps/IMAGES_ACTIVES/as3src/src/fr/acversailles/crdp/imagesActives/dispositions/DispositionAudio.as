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
package fr.acversailles.crdp.imagesActives.dispositions {
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.image.details.IDetail;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class DispositionAudio extends Disposition implements IDispositionAudio {
		public function DispositionAudio(typeAffichage : uint) {
			ns = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives/layouts/audio");
			super(typeAffichage);
		}

		override protected function determinerDimensionsCadre() : void {
			var dimensionHZoneImage : Number = _largeurTotale;
			var margesH : Number = ParametresXML.instance.getParametreDimensions("left_margin", ns);
			margesH += ParametresXML.instance.getParametreDimensions("right_margin", ns);
			largeurMaxImage = dimensionHZoneImage - margesH;
			var margesV : Number = ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_image_footer_margin", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
			hauteurMaxImage = _hauteurTotale - margesV;
		}

		override public function placerZoneTexte(zoneTexte : IZoneTexte) : void {
		}

		override public function disposerDetail(detail : IDetail) : void {
			super.disposerDetail(detail);
		}

		public function getXZoneControleAudio() : Number {
			return largeurTotale - getLargeurZoneControleAudio() - ParametresXML.instance.getParametreDimensions("right_margin", ns);
		}

		public function getYZoneControleAudio() : Number {
			return _hauteurTotale - ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns) - ParametresXML.instance.getParametreDimensions("audio_controls_area_bottom_margin", ns) - ParametresXML.instance.getParametreDimensions("audio_controls_area_height", ns);
		}

		public function getLargeurZoneControleAudio() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_area_width", ns);
		}

		public function getHauteurZoneControleAudio() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_area_height", ns);
		}

		public function getLargeurBoutonsControle() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_button_width", ns);
		}

		public function getMargeEntreBoutonsControle() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_button_horizontal_margin", ns);
		}

		public function getHauteurPignonSlider() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_slider_button_height", ns);
		}

		public function getLargeurZoneControleVolume() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_volume_area_width", ns);
		}

		public function getHauteurZoneControleVolume() : Number {
			return ParametresXML.instance.getParametreDimensions("audio_controls_volume_area_height", ns);
		}

		public function getMargeDroiteBoutonReponse() : Number {
			return ParametresXML.instance.getParametreDimensions("answer_button_right_margin", ns);
		}
		override public function detailsPucesVisibles() : Boolean {
			return true;
		}
	}
}
