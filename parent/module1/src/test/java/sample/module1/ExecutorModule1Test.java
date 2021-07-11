package sample.module1;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

/**
 * {@link ExecutorModule1}のテスタ
 * 
 * @author tatsu
 *
 */
public class ExecutorModule1Test {

	@Test
	void test() {
		ExecutorModule1 executor = new ExecutorModule1();
		
		assertEquals("Hello", executor.greeting());
	}

}
