package lektionen;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import pages.AppNavigator;
import toni.worker.basis.DefaultWorker;

public class AppNavigatorTest {

	@Test
	public void testSearchStringStringStringStringString() {
		AppNavigator n = (AppNavigator)AppNavigator.getNavigator();
	    String page = n.search("Lektion5","suchen","suchen",DefaultWorker.SUCCESS,"");
	    assertEquals(page,"Lektion5");
	}

}
