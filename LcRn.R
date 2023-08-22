# パッケージの読み込み
library(magrittr)
library(dplyr)
library(class)    # k近傍法に使用
library(rpart)    # 決定木分析に使用
library(partykit) # 決定木分析に使用
library(kernlab)  # svmに使用
library(nnet)     # NNに使用

# データの読み込み
Social_Network_Ads <- read.csv("Social_Network_Ads.csv")

# 目的変数 : Purchased
# 説明変数 : Gender, Age, EstimatedSalary

# データ整理
# 各変数の標準化
Social_Network_Ads.standard_EstimatedSalary <- Social_Network_Ads %>% mutate(Salary_standardized = scale(EstimatedSalary))
Social_Network_Ads.standard <- Social_Network_Ads.standard_EstimatedSalary %>% mutate(Age_standardized = scale(Age))
# Genderの変換 --> 0 or 1
Social_Network_Ads.with_integer <- Social_Network_Ads.standard %>% mutate(Gender_int = if_else(Gender == "Male", 1, 0))
# 変数の整理
Social_Network_Ads.selected <- Social_Network_Ads.with_integer %>% select(Salary_standardized, Age_standardized, Gender_int, Purchased)

# 学習用データとテスト用データに分類
set.seed(50)
Social_Network_Ads.length <- Social_Network_Ads.selected %>% nrow()
train.num <- sample(Social_Network_Ads.length, Social_Network_Ads.length/2) # 学習用データ数 == テスト用データ数
Social_Network_Ads.train <- Social_Network_Ads.selected[train.num, ] # 学習用データ
Social_Network_Ads.test <- Social_Network_Ads.selected[-train.num, ] # テスト用データ


# 1. ロジスティック回帰の実行
# モデルの作成
Social_Network_Ads.glm <- glm(Purchased~., data = Social_Network_Ads.train, family = binomial(link = "logit"))
# 予測の実行
Social_Network_Ads.pred <- predict(Social_Network_Ads.glm, newdata = Social_Network_Ads.test, type = "response")

Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred %>% data.frame()
colnames(Social_Network_Ads.pred_dataframe) <- "pred"
Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred_dataframe %>% mutate(pred_int = if_else(pred >= 0.5, 1, 0))
# 予測値(glm)
Social_Network_Ads.glm_pred <- Social_Network_Ads.pred_dataframe %>% select(pred_int)
colnames(Social_Network_Ads.glm_pred) <- "pred_glm"

# 結果の実行(クロス表と誤分類率)
Social_Network_Ads.glm_table <- table(Social_Network_Ads.test$Purchased, Social_Network_Ads.glm_pred$pred_glm)
### print(Social_Network_Ads.glm_table)
### print(1-sum(diag(Social_Network_Ads.glm_table))/sum(Social_Network_Ads.glm_table))
misclassification_rate.glm <- 1-sum(diag(Social_Network_Ads.glm_table))/sum(Social_Network_Ads.glm_table)

# 2. k近傍法の実行
Social_Network_Ads.knn <- knn(Social_Network_Ads.train[, -4], Social_Network_Ads.test[, -4], Social_Network_Ads.train[, 4], k = 5) # kは仮に5と決定
# 結果の実行(クロス表と誤分類率)
Social_Network_Ads.knn_table <- table(Social_Network_Ads.test[, 4], Social_Network_Ads.knn)
### print(Social_Network_Ads.knn_table)
### print(1-sum(diag(Social_Network_Ads.knn_table))/sum(Social_Network_Ads.knn_table))
misclassification_rate.knn <- 1-sum(diag(Social_Network_Ads.knn_table))/sum(Social_Network_Ads.knn_table)

# 3. 決定木分析の実行
Social_Network_Ads.rpart <- rpart(Purchased~., data = Social_Network_Ads.train)
# partykitによる結果表示
Social_Network_Ads.asparty <- as.party(Social_Network_Ads.rpart)
### print(Social_Network_Ads.asparty)
### plot(Social_Network_Ads.asparty)

# 予測の実行
Social_Network_Ads.pred <- predict(Social_Network_Ads.rpart, newdata = Social_Network_Ads.test)

Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred %>% data.frame()
colnames(Social_Network_Ads.pred_dataframe) <- "pred"
Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred_dataframe %>% mutate(pred_int = if_else(pred >= 0.5, 1, 0))

# 予測値(rpart)
Social_Network_Ads.rpart_pred <- Social_Network_Ads.pred_dataframe %>% select(pred_int)
colnames(Social_Network_Ads.rpart_pred) <- "pred_rpart"

# 結果の実行(クロス表と誤分類率)
Social_Network_Ads.rpart_table <- table(Social_Network_Ads.test$Purchased, Social_Network_Ads.rpart_pred$pred_rpart)
### print(Social_Network_Ads.rpart_table)
### print(1-sum(diag(Social_Network_Ads.rpart_table))/sum(Social_Network_Ads.rpart_table))
misclassification_rate.rpart <- 1-sum(diag(Social_Network_Ads.rpart_table))/sum(Social_Network_Ads.rpart_table)

# 4. SVM(サポートベクトルマシン)の実行
Social_Network_Ads.svm <- ksvm(Purchased~., data = Social_Network_Ads.train)

# 予測の実行
Social_Network_Ads.pred <- predict(Social_Network_Ads.svm, newdata = Social_Network_Ads.test)

Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred %>% data.frame()
colnames(Social_Network_Ads.pred_dataframe) <- "pred"
Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred_dataframe %>% mutate(pred_int = if_else(pred >= 0.5, 1, 0))

# 予測値(svm)
Social_Network_Ads.svm_pred <- Social_Network_Ads.pred_dataframe %>% select(pred_int)
colnames(Social_Network_Ads.svm_pred) <- "pred_svm"

# 結果の実行(クロス表と誤分類率)
Social_Network_Ads.svm_table <- table(Social_Network_Ads.test$Purchased, Social_Network_Ads.svm_pred$pred_svm)
### print(Social_Network_Ads.svm_table)
### print(1-sum(diag(Social_Network_Ads.svm_table))/sum(Social_Network_Ads.svm_table))
misclassification_rate.svm <- 1-sum(diag(Social_Network_Ads.svm_table))/sum(Social_Network_Ads.svm_table)

# 5. NN(ニューラルネットワーク)の実行
# 中間層のニューロン数 : 3, 学習率 : 0.1
Social_Network_Ads.nnet <- nnet(Purchased~., size = 3, decay = 0.1, data = Social_Network_Ads.train)
# 予測の実行
Social_Network_Ads.pred <- predict(Social_Network_Ads.nnet, newdata = Social_Network_Ads.test)

Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred %>% data.frame()
colnames(Social_Network_Ads.pred_dataframe) <- "pred"
Social_Network_Ads.pred_dataframe <- Social_Network_Ads.pred_dataframe %>% mutate(pred_int = if_else(pred >= 0.5, 1, 0))

# 予測値(nnet)
Social_Network_Ads.nnet_pred <- Social_Network_Ads.pred_dataframe %>% select(pred_int)
colnames(Social_Network_Ads.nnet_pred) <- "pred_nnet"

# 結果の実行(クロス表と誤分類率)
Social_Network_Ads.nnet_table <- table(Social_Network_Ads.test$Purchased, Social_Network_Ads.nnet_pred$pred_nnet)
### print(Social_Network_Ads.nnet_table)
### print(1-sum(diag(Social_Network_Ads.nnet_table))/sum(Social_Network_Ads.nnet_table))
misclassification_rate.nnet <- 1-sum(diag(Social_Network_Ads.nnet_table))/sum(Social_Network_Ads.nnet_table)


# ---誤分類率の結果まとめ---
analysis_name <- c("ロジスティック回帰", "k近傍法", "決定木分析", "サポートベクトルマシン", "ニューラルネットワーク")
misclassification_rate <- c(misclassification_rate.glm, misclassification_rate.knn, misclassification_rate.rpart, misclassification_rate.svm, misclassification_rate.nnet)
misclassification_rate.df <- data.frame(analysis_name, misclassification_rate)
colnames(misclassification_rate.df) = c("分析名", "誤分類率")
print(misclassification_rate.df)
