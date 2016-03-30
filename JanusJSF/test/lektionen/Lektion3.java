package lektionen;

import static org.junit.Assert.*;


import org.junit.Test;

import pages.Lektion3Bean;

public class Lektion3 {

	@Test
	public void testSetText1() {
		Lektion3Bean bean = new Lektion3Bean();
		bean.setText1(" X X ");
		bean.setText2("1");
		bean.perform();
		assertEquals(" 1 1 ",bean.getText3());
	}



}
