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
	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class OptionsDisposition {
		
		public static const modelesDispositions:Object={
			accordion:ACCORDION_LAYOUT,
			top_bottom_captions:TOP_BOTTOM_CAPTIONS_LAYOUT,
			covering_captions:COVERING_CAPTIONS_LAYOUT
		};

		public static const ACCORDION_LAYOUT : String="accordion";
		public static const TOP_BOTTOM_CAPTIONS_LAYOUT : String="top_bottom_captions";
		public static const COVERING_CAPTIONS_LAYOUT : String = "covering_captions";
		public static const AUDIO_LAYOUT : String = "audio_captions";
	}
}
