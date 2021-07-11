import sample.module1.ExecutorModule1;

/**
 * Module1を使用するアプリ
 * @author tatsu
 *
 */
public class Application {

	public static void main(String[] args) {
		
		ExecutorModule1 executor = new ExecutorModule1();
		System.out.println(executor.greeting());
		
	}

}
