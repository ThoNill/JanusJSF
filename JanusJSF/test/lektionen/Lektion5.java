package lektionen;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import pages.Lektion5Bean;

public class Lektion5 {

	@Test
	public void testSetText1() {
		Lektion5Bean bean = new Lektion5Bean();
		bean.setText1(" X X ");
		bean.muster();
		bean.perform();
		assertEquals(" X X 1",bean.getText2());
	}



}
