## モジュールのサイト生成

### 生成対象外の設定

サイト生成処理は非常に重く時間がかかるため、余分なモジュールは生成しないようにします。

モジュール `sample` とその子モジュールを処理対象外とするため、オプション `-pl` で指定します。
- 除外するには、`!モジュール名` の書式で指定します。

```
rem 処理対象のモジュールの定義
set MVN_SITE_PROJECT_LIST="!sample,!sample/sample-sub-module1,!sample/sample-sub-module2"

rem サイト生成
mvn site -pl %MVN_SITE_PROJECT_LIST%
```

### 各モジュールのサイトの収集

- JaCoCoの集約されたレポートは、`report-aggregate/taget/jacoco-aggregate` に出力されているため、 rootのレポート結果を上書きます。
- サイト生成しても各モジュールのサイトは、`<各モジュールのパス>/target/site/` に格納されたままなので、必要なモジュールのサイトをrootのサイトにコピーします。

```
echo 集約された jacoco-report のコピー
xcopy /Y /E /Q report-aggregate\target\site\jacoco-aggregate target\site\jacoco-aggregate

echo 各モジュールのサイトのコピー
xcopy /S /Y /E /Q /I parent\target\site target\site\parent
xcopy /S /Y /E /Q /I parent\module1\target\site target\site\parent\module1
xcopy /S /Y /E /Q /I parent\module2\target\site target\site\parent\module2
xcopy /S /Y /E /Q /I parent\module2\module2-sub-module1\target\site target\site\parent\module2\module2-sub-module1
xcopy /S /Y /E /Q /I parent\module2\module2-sub-module2\target\site target\site\parent\module2\module2-sub-module2
```

### 各サイトのカスタマイズ

ルートのサイト設定として、デフォルトでは、子モジュールのリンクが出力されるので、直接記載します。

- `<menu ref="modules" />` とすると、`sample` / `report-aggregate` モジュールのリンクが表示されてしまうため、直接記載します。

```
<!-- ルートプロジェクトの site.xml -->
<project name="${project.name}">
	<body>
        <menu name="関連リンク">
			<item name="GitHub" href="https://github.com/mygreen/sample-maven-multi-module/" />
			<item name="JavaDoc" href="apidocs/index.html" />
		</menu>
		<!-- 余分なモジュールは表示しないため直接記述する 
		<menu ref="modules" />
		-->
		<menu name="モジュール">
			<item name="parent" href="parent/index.html" />
		</menu>
		<menu ref="reports" />
	</body>
</project>
```

`site.xml` も親の設定を引き継いでしまうため、`parent` 以下の子モジュールの設定を行います。
- 親モジュールのリンクとして、`<menu ref="parent" iherit="top">` を追加します。
    - 属性 `inherit="top"` で親情報を参照するという意味です。
- 子モジュールのリンクとして、`<menu ref="modules" iherit="bottom">` を追加します。
    - 属性 `inherit="bottom"` で子モジュールにも継承するという意味です。
- レポート情報として、`<menu ref="reports" inherit="bottom" />` を追加します。
    - 属性 `inherit="bottom"` を付与することで、子モジュールにも継承するという意味です。

```
<!-- 子モジュールの site.xml -->
<project name="${project.name}">
	<body>
		<menu ref="parent" inherit="top" />
		<menu name="関連リンク" inherit="bottom">
			<item name="GitHub" href="https://github.com/mygreen/sample-maven-multi-module/" />
			<item name="JavaDoc" href="apidocs/index.html" />
		</menu>
		<menu ref="modules" inherit="bottom" />
		<menu ref="reports" inherit="bottom" />
	</body>
</project>
```


