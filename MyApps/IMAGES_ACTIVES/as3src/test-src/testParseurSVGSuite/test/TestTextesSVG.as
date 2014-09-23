package testParseurSVGSuite.test {
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.flexunit.runners.Parameterized;
	import org.fluint.uiImpersonation.UIImpersonator;

	import flash.display.Sprite;
	import flash.events.Event;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestTextesSVG extends Sprite {
		var foo : Parameterized;
		private var elem : Sprite;
		private var svg : Class;
		private var embedClass : Class;
		private var textes : Object;

		[Parameters]
		public static function textes() : Array {
			return [[null,
			 {
			 	titre:"Louis de France, Dauphin, fils de Louis XV",
			 	infos:"Atelier de Louis Tocque.",
			 	droits:"RMN ({Château de Versailles@http://www.chateauversailles.fr}) / Franck Raux",
			 	titreDescription:"Le prince géographe",
			 	texteDescription:"Ce tableau d’apparat (qui vante un",
			 	nbDetails:5
			 }
			 	]
			];
		}

		[Before(async, ui)]
		public function setUp() : void {
			elem = new Sprite();
			Async.proceedOnEvent(this, elem, Event.ADDED, 1000);
			UIImpersonator.addChild(elem);
		}


		[Test(order=1, async, ui, description="Récupération des textes SVGWrapper")]
		public function testTitre() : void {
			SVGWrapper.initialiser(elem, embedClass);
			SVGWrapper.instance.chargerRessources();
			SVGWrapper.instance.construire();
			Assert.assertNotNull(SVGWrapper.instance);
			Assert.assertEquals("Le titre de l'image ne correspond pas",SVGWrapper.instance.getTitre().indexOf(textes["titre"]), 0);
		}

		[Test(order=2, async, ui, description="Récupération du titre description SVGWrapper")]
		public function testTitreDescription() : void {
			Assert.assertEquals("Le titre de la description l'image ne correspond pas",SVGWrapper.instance.titreDescription.indexOf(textes["titreDescription"]), 0);
		}

		[Test(order=3, async, ui, description="Récupération du texte de la description SVGWrapper")]
		public function testTexteDescription() : void {
			Assert.assertEquals("Le texte de la description l'image ne correspond pas",SVGWrapper.instance.texteDescription.indexOf(textes["texteDescription"]), 0);
		}

		[Test(order=4, async, ui, description="Récupération des infos de l'image SVGWrapper")]
		public function testInfos() : void {
			//Assert.assertEquals("Le textes d'infos de l'image ne correspond pas",SVGWrapper.instance.getInfos().indexOf(textes["infos"]), 0);
		}

		[Test(order=5, async, ui, description="Récupération des droits de l'image SVGWrapper")]
		public function testDroits() : void {
			Assert.assertEquals("Les droits de l'image ne correspondent pas : on attendait"+textes["droits"],SVGWrapper.instance.getDroits().indexOf(textes["droits"]), 0);
		}

		[Test(order=6, async, ui, description="Récupération du nb de détails SVGWrapper")]
		public function testNbDetails() : void {
			Assert.assertEquals("Le nombre de détails ne correspond pas", textes["nbDetails"], SVGWrapper.instance.getNbDetails());
		}

		public function TestTextesSVG(embedClass : Class, textes : Object) {
			this.textes = textes;
			this.embedClass = embedClass;
		}
	}
}
