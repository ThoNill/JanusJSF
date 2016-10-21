package lektionen;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import pages.Lektion4Bean;

public class Lektion4 {

	@Test
	public void testSetText1() {
		Lektion4Bean bean = new Lektion4Bean();
		bean.setText1(" X X ");
		bean.setText2("P");
		bean.setOk("0");
		bean.clear();
		bean.perform();
		assertEquals(" P P ",bean.getText3());
	}
	
	@Test
	public void testSetText2() {
		Lektion4Bean bean = new Lektion4Bean();
		bean.setText1(" X X ");
		bean.setText2("P");
		bean.setOk("1");
		bean.clear();
		bean.perform();
		assertEquals("  1   1  ",bean.getText3());
	}



}
