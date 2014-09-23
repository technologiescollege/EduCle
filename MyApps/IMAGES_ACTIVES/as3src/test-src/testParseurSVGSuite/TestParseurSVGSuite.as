package testParseurSVGSuite {
	import testParseurSVGSuite.test.TestBitmapsSVG;
	import testParseurSVGSuite.test.TestTextesDetailSVG;
	import testParseurSVGSuite.test.TestTextesSVG;
	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestParseurSVGSuite {
		public var testTextesSVG:TestTextesSVG;
		public var testDetailSVG:TestTextesDetailSVG;
		public var testBitmapSVG:TestBitmapsSVG;
	}
}
