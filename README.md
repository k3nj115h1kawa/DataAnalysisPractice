# DataAnalysisPractice
## kaggleのデータセット"Logistic Regression" に対して, データ分析を行った [1]
### アルゴリズム
1. パッケージの読み込み
2. データの読み込み
3. データ整理
   1. 標準化
   2. 0, 1変換
   3. 学習用データとテスト用データに分類
4. 分析の実行
   1.  ロジスティック回帰
   2.  k近傍法
   3.  決定木分析
   4.  サポートベクトルマシン
   5.  ニューラルネットワーク
5. 誤分類率の結果まとめ
## 行ったこと
* パイプ(%>%)を使ってデータのやり取りを行ってみた [2]
* tidyverseパッケージの読み込みが上手くいかなかったので, 代わりにmagrittrパッケージでパイプ機能を, dplyrパッケージでデータの前処理を行った [2]
* 0, 1変換には, if_else()を利用した [2]
## 参考文献
1. Kaggle, "Logistic Regression", "https://www.kaggle.com/datasets/dragonheir/logistic-regression?resource=download" accessed on 2023/08/23
2. 卒業のためのR入門, "Chapter 8 データ前処理", "https://tomoecon.github.io/R_for_graduate_thesis/DataHandling.html" accessed on 2023/08/23
3. 中嶋 一樹, "R超入門 - Rのインストールから決定木とランダムフォレストによる分析まで", "https://qiita.com/nkjm/items/e751e49c7d2c619cbeab#%E6%B1%BA%E5%AE%9A%E6%9C%A8%E3%81%A7%E4%BA%88%E6%B8%AC%E3%82%92%E3%81%8A%E3%81%93%E3%81%AA%E3%81%86" accessed on 2023/08/23
4. @daifukusan, "機械学習初心者におすすめなkaggleの表形式データセットを調査してみた", "https://qiita.com/daifukusan/items/b98f20a79dbd0b83853e" accessed on 2023/08/23
