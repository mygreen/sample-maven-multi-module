## レポート情報の集約

Mavenのプラグインは、マルチモジュールに対応して集約機能があるものとないものがあります。

集約機能がないものは、各モジュールのレポートを参照する必要があります。

| プラグイン | 集約対応 | 備考 |
| --- | --- | --- |
| maven-site-plugin | 〇 | 特に設定は不要。 |
| maven-javadoc-plugin | 〇 | モジュール単位のグループ設定する。 |
| maven-jxr-plugin | 〇 | ー |
| maven-surefire-report-plugin | × | ー |
| jacoco-maven-plugin | △ | 専用の集約用モジュールを設定する必要がある。 |
| spotbugs-maven-plugin | × |  |

### maven-javadoc-plugin について

特に設定をしなくても集約はされます。

しかし、グループ設定することでさらに、モジュール単位にタブが追加され使いやすくなります。
ただし、パッケージで分割するので、各モジュールごとにパッケージを明確に設定する必要があります。

```
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-javadoc-plugin</artifactId>
	<configuration>
		<source>${java.version}</source>
		<encoding>${project.build.sourceEncoding}</encoding>
		<charset>UTF-8</charset>
		<docencoding>UTF-8</docencoding>
		<locale>ja_JP</locale>
		<javadocExecutable>${java.home}/bin/javadoc</javadocExecutable>
		<!-- グループ設定 -->
		<groups>
			<group>
				<title>module1</title>
				<packages>sample.module1*</packages>
			</group>
			<group>
				<title>module2-sub1</title>
				<packages>sample.module2.sub1*</packages>
			</group>
			<group>
				<title>module2-sub2</title>
				<packages>sample.module2.sub2*</packages>
			</group>
		</groups>
	</configuration>
</plugin>
```

### maven-jxr-plugin について

集約用のレポート設定を定義する必要があります。

ただし、SpotBugsプラグインが集約に対応していないので、ソースのクロスリファレンスはあまり意味がないです。

```
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-jxr-plugin</artifactId>
	<configuration>
		<inputEncoding>UTF-8</inputEncoding>
		<outputEncoding>UTF-8</outputEncoding>
	</configuration>
	<reportSets>
		<reportSet>
			<id>aggregate</id>
			<reports>
				<report>aggregate</report>
				<report>test-aggregate</report>
			</reports>
		</reportSet>
	</reportSets>
</plugin>
```

### jacoco-maven-plugin について

- 集約用のモジュールに、ゴール `report-aggregate` を設定します。
- 集約したいモジュールを依存関係に追加します。
- JaCoCoのタイトルがデフォルトだとモジュール名になるので、ルートのプロジェクト名に変更します。

```
<!-- JaCoCoの集約用のモジュールのpom.xml -->
<project>
・・・
	<build>
		<plugins>
			<plugin>
				<groupId>org.jacoco</groupId>
				<artifactId>jacoco-maven-plugin</artifactId>
				<executions>
					<execution>
						<id>report-aggregate</id>
						<phase>verify</phase>
						<goals>
							<goal>report-aggregate</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
・・・
	<!-- JaCoCoのレポート集約をするために依存関係に出力するモジュールを追加。 -->
	<dependencies>
		<dependency>
			<groupId>com.github.mygreen.sample</groupId>
			<artifactId>module1</artifactId>
			<version>${revision}</version>
		</dependency>
		<dependency>
			<groupId>com.github.mygreen.sample</groupId>
			<artifactId>module2-sub-module1</artifactId>
			<version>${revision}</version>
		</dependency>
		<dependency>
			<groupId>com.github.mygreen.sample</groupId>
			<artifactId>module2-sub-module2</artifactId>
			<version>${revision}</version>
		</dependency>
	</dependencies>
	
	<reporting>
		<plugins>
			<plugin>
				<groupId>org.jacoco</groupId>
				<artifactId>jacoco-maven-plugin</artifactId>
				<configuration>
					<!-- タイトルをプロジェクト名にします。 -->
					<title>maven-multi-module</title>
				</configuration>
			</plugin>
		</plugins>
	</reporting>
</project>
```

各モジュールの設定では、`prepare-agent` をゴールとした通常JaCoCoの設定を行います。
- 実際には、親の `parent` モジュールに定義を追加しておきます。
- プロパティ `${jacoco.include.package}` を各モジュールで定義し、自身のモジュールのパッケージのみ対象とするようにします。

```
<!-- JaCoCoの各モジュールのpom.xmlの設定 -->
<project>
・・・
	<properties>
		<!-- 自身のモジュールのパッケージのみ対象とする -->
		<jacoco.include.package>sample.module1.*</jacoco.include.package>
	</properties>
・・・
	<build>
		<plugins>
			<plugin>
				<groupId>org.jacoco</groupId>
				<artifactId>jacoco-maven-plugin</artifactId>
				<executions>
					<execution>
						<id>prepage-agent</id>
						<goals>
							<goal>prepare-agent</goal>
						</goals>
						<configuration>
							<propertyName>jacocoArgs</propertyName>
							<includes>
								<include>${jacoco.include.package}</include>
							</includes>
						</configuration>
					</execution>
				</executions>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-surefire-plugin</artifactId>
				<configuration>
					<argLine>${jacocoArgs}</argLine>
				</configuration>
				<dependencies>
					<dependency>
						<groupId>org.junit.platform</groupId>
						<artifactId>junit-platform-surefire-provider</artifactId>
						<version>1.3.2</version>
					</dependency>
				</dependencies>
			</plugin>
		</plugins>
	</build>

	<reporting>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-surefire-report-plugin</artifactId>
				<configuration>
					<aggregate>true</aggregate>
				</configuration>
			</plugin>
			<plugin>
				<groupId>org.jacoco</groupId>
				<artifactId>jacoco-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</reporting>
</project>
```
