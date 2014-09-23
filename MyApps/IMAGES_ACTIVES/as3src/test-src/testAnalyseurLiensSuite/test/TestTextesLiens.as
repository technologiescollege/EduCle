package testAnalyseurLiensSuite.test {
	import fr.acversailles.crdp.imagesActives.textes.liens.AnalyseurLiens;

	import org.flexunit.Assert;
	import org.flexunit.runners.Parameterized;

	import flash.display.Sprite;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestTextesLiens extends Sprite {
		var foo : Parameterized;
		private var chaineTestee : String;
		private var resultatAttendu : Array;
		private var chaineNettoyee : String;

		[Parameters]
		public static function textes() : Array {
			return [
			//deux liens
			["Le chat {mange@abcd} la {souris@efgh} ", [[8, 13, "abcd"], [17, 23, "efgh"]], "Le chat mange la souris "],
			//un lien en début de chaine
			["{Le musée du Prado@http://www.museePrado.fr} accueille cette expo", [[0, 17, "http://www.museePrado.fr"]], "Le musée du Prado accueille cette expo"],
			//espaces inutiles dans le lien en début de chaine
			["{ Le musée du Prado @ http://www.museePrado.fr } accueille cette expo", [[0, 17, "http://www.museePrado.fr"]], "Le musée du Prado accueille cette expo"],
			//espaces inutiles au début du lien 
			["{ Le musée du Prado@http://www.museePrado.fr} accueille cette expo", [[0, 17, "http://www.museePrado.fr"]], "Le musée du Prado accueille cette expo"],
			//crochet au lieu d'ccolade en début de chaine
			["[Le musée du Prado@http://www.museePrado.fr} accueille cette expo", [], "[Le musée du Prado@http://www.museePrado.fr} accueille cette expo"],
			//pas de texte du lien
			["Le musée du Prado {@http://www.museePrado.fr} accueille cette expo", [], "Le musée du Prado {@http://www.museePrado.fr} accueille cette expo"],
			//texte du lien constitué d'espaces
			["Le musée du Prado {      @http://www.museePrado.fr} accueille cette expo", [], "Le musée du Prado {      @http://www.museePrado.fr} accueille cette expo"],
			//un lien en milieu de chaine
			["Le jeune prince manifeste sa {culture géographique@http://www.insee.fr} devant un globe de grande taille.", [[29, 49, "http://www.insee.fr"]], "Le jeune prince manifeste sa culture géographique devant un globe de grande taille."],
			//un lien numéroté
			["Le jeune prince manifeste {1@http://www.insee.fr} devant un globe de grande taille.", [[26, 27, "http://www.insee.fr"]], "Le jeune prince manifeste 1 devant un globe de grande taille."],
			//un lien numéroté avec espaces
			["Le jeune prince manifeste { 1 @http://www.insee.fr} devant un globe de grande taille.", [[26, 27, "http://www.insee.fr"]], "Le jeune prince manifeste 1 devant un globe de grande taille."],
			//un lien numéroté avec plus d'espaces
			["Le jeune prince manifeste { 1  @ http://www.insee.fr  } devant un globe de grande taille.", [[26, 27, "http://www.insee.fr"]], "Le jeune prince manifeste 1 devant un globe de grande taille."],
			//texte du lien entre crochets
			["Le jeune prince manifeste {[qqc]@ http://www.insee.fr  } devant un globe de grande taille.", [[26, 31, "http://www.insee.fr"]], "Le jeune prince manifeste [qqc] devant un globe de grande taille."],
			//texte du lien entre crochets avec espaces inutiles
			["Le jeune prince manifeste { [qqc] @ http://www.insee.fr  } devant un globe de grande taille.", [[26, 31, "http://www.insee.fr"]], "Le jeune prince manifeste [qqc] devant un globe de grande taille."],
			//texte du lien entre crochets avec espaces utiles
			["Le jeune prince manifeste {[ qqc ]@ http://www.insee.fr  } devant un globe de grande taille.", [[26, 33, "http://www.insee.fr"]], "Le jeune prince manifeste [ qqc ] devant un globe de grande taille."]
			];
		}

		[Before]
		public function setUp() : void {
		}

		[Test]
		public function testTexte() : void {
			var resultatObtenu : Array = AnalyseurLiens.analyserTexte(chaineTestee);
			Assert.assertEquals("On ne trouve pas le même nombre de liens", resultatAttendu.length, resultatObtenu.length);
			for (var i : int = 0; i < resultatAttendu.length; i++) {
				Assert.assertNotNull("Le lien n°" + i + " n'a pas été trouvé", resultatObtenu[i]);
				Assert.assertEquals("Le début du lien n°" + i + " ne correspond pas", resultatAttendu[i][0], resultatObtenu[i][0]);
				Assert.assertEquals("La fin du lien n°" + i + " ne correspond pas", resultatAttendu[i][1], resultatObtenu[i][1]);
				Assert.assertEquals("Le texte lien n°" + i + " ne correspond pas", resultatAttendu[i][2], resultatObtenu[i][2]);
			}
		}

		[Test]
		public function testChaineNettoyee() : void {
			var chaineObtenue : String = AnalyseurLiens.supprimerLiens(chaineTestee);
			Assert.assertEquals("La chaine nettoyée ne correspond pas", chaineNettoyee, chaineObtenue);
		}

		public function TestTextesLiens(chaine : String, resultat : Array, chaineNettoyee : String) {
			this.chaineNettoyee = chaineNettoyee;
			this.resultatAttendu = resultat;
			this.chaineTestee = chaine;
		}
	}
}

