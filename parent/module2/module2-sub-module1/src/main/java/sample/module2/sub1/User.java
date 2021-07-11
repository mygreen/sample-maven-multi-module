package sample.module2.sub1;

import lombok.Data;

/**
 * ユーザエンティティ
 * @author tatsu
 *
 */
@Data
public class User {
	
	/**
	 * ID
	 */
	private long id;
	
	/**
	 * 名前
	 */
	private String name;

}