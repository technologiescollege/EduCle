package testParseurSVGSuite.test {
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.flexunit.runners.Parameterized;
	import org.fluint.uiImpersonation.UIImpersonator;

	import flash.display.Sprite;
	import flash.events.Event;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestTextesDetailSVG extends Sprite {
		var foo : Parameterized;
		private var elem : Sprite;
		private var svg : Class;
		private var embedClass : Class;
		private var detail : Object;

		[Parameters]
		public static function textes() : Array {
			return [
			[null, 
			 {
			 	numero:2,
			 	titreLegende:"Le bureau",
			 	texteLegende:"Sur son bureau plat à tiroirs reposent la sphère armillaire, un livre de géographie maintenu ouvert par un compas. Le désordre organisé indique le travail d’apprentissage en cours.Sur son bureau plat à tiroirs reposent la sphère armillaire, un livre de géographie maintenu ouvert par un compas. Le désordre organisé indique le travail d’apprentissage en cours.Sur son bureau plat à tiroirs reposent la sphère armillaire, un livre de géographie maintenu ouvert par un compas. Le désordre organisé indique le travail d’apprentissage en cours.Sur son bureau plat à tiroirs reposent la sphère armillaire, un livre de géographie maintenu ouvert par un compas. Le désordre organisé indique le travail d’apprentissage en cours.Sur son bureau plat à tiroirs reposent la sphère armillaire, un livre de géographie maintenu ouvert par un compas. Le désordre organisé indique le travail d’apprentissage en cours."
			 }
			]
		];
		};

		[Before(async, ui)]
		public function setUp() : void {
			elem = new Sprite();
			Async.proceedOnEvent(this, elem, Event.ADDED, 1000);
			UIImpersonator.addChild(elem);
		}

		[Test(order=1, async, ui, description="Récupératon du titre d'un détail")]
		public function testTitreLegende() : void {
			SVGWrapper.initialiser(elem, embedClass);
			SVGWrapper.instance.chargerRessources();
			SVGWrapper.instance.construire();
			Assert.assertEquals("Le titre du detail n°"+detail["numero"]+" ne correspond pas", detail["titreLegende"], SVGWrapper.instance.getTitreLegendeDetail(detail["numero"]));
		}

		[Test(order=2, async, ui, description="Récupération du texte d'un détail")]
		public function testTexteLegende() : void {
			Assert.assertEquals("Le texte du detail n°"+detail["numero"]+" ne correspond pas", detail["texteLegende"], SVGWrapper.instance.getTexteLegendeDetail(detail["numero"]));
		}

		public function TestTextesDetailSVG(embedClass : Class, detail : Object) {
			this.detail = detail;
			this.embedClass = embedClass;
		}
	}
}
