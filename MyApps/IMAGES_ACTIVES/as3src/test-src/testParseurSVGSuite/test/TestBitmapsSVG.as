package testParseurSVGSuite.test {
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.flexunit.runners.Parameterized;
	import org.fluint.uiImpersonation.UIImpersonator;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestBitmapsSVG extends Sprite {
		var foo : Parameterized;
		private var elem : Sprite;
		private var svg : Class;
		private var embedClass : Class;
		private var caracteristiques : Object;
		private var bitmap : Bitmap;
		private var cleDetail : String;
		private var zoomabilite : Boolean;

		[Parameters]
		public static function caracteristiques() : Array {
			return [
			[null, {numero:3, largeur:800, hauteur:1047}]
			];
		}

		[Before(async, ui)]
		public function setUp() : void {
			elem = new Sprite();

			UIImpersonator.addChild(elem);
			SVGWrapper.initialiser(elem, embedClass);
			SVGWrapper.instance.chargerRessources();
			SVGWrapper.instance.construire();
			zoomabilite = SVGWrapper.instance.isDetailZoomable(caracteristiques["numero"]);
			bitmap = SVGWrapper.instance.getDetail(caracteristiques["numero"]);
			Async.proceedOnEvent(this, bitmap, Event.FRAME_CONSTRUCTED, 2000);
			elem.addChild(bitmap);
			// rect = mesurerZoneOpaque(bitmap.bitmapData);
		}

		[Test(order=1, async, ui, description="Largeur globale du bitmap (égale à celle du fond)")]
		public function testExistence() : void {
			Assert.assertNotNull("Le bitmap est nul" + cleDetail, bitmap);
		}

		[Test(order=2, async, ui, description="Largeur globale du bitmap (égale à celle du fond)")]
		public function testLargeur() : void {
			Assert.assertEquals("La largeur du détail n°" + caracteristiques["numero"] + " ne correspond pas", caracteristiques["largeur"], bitmap.width);
		}

		[Test(order=3, async, ui, description="Hauteur globale du bitmap (égale à celle du fond)")]
		public function testHauteur() : void {
			Assert.assertEquals("La hauteur du détail n°" + caracteristiques["numero"] + " ne correspond pas", caracteristiques["hauteur"], bitmap.height);
		}

		public function TestBitmapsSVG(embedClass : Class, caracteristiques : Object) {
			this.caracteristiques = caracteristiques;
			this.embedClass = embedClass;
		}
	}
}
