package sample.module1;

import lombok.extern.slf4j.Slf4j;

/**
 * 処理実行
 * @author tatsu
 *
 */
@Slf4j
public class ExecutorModule1 {

	public String greeting() {
		log.info("exec greeting");
		return "Hello";
	}
	
}
