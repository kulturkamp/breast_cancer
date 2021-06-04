#install.packages("corrplot")
#install.packages("ggplot2")
#install.packages("reshape")
#install.packages("ggbeeswarm")
#install.packages("caret")
library(corrplot)
library(ggplot2)
library(reshape)
library(ggbeeswarm)
library(caret)
df = read.csv('breast_cancer.csv')
str(df)
df[,33] = NULL
df$diagnosis = as.factor(df$diagnosis)
str(df)
summary(df)

# creating correlation matrices and correlation plots for all, mean. se and worst features
corr_mat = cor(df[,3:ncol(df)])
corrplot(corr_mat, order = "hclust", addrect = 8, method='color', addCoef.col='black', 
         number.cex=0.5, tl.col='black',tl.cex = 0.6, tl.srt=40)


features_mean = c('diagnosis', 'radius_mean','texture_mean','perimeter_mean','area_mean','smoothness_mean', 'compactness_mean',
                  'concavity_mean','concave.points_mean', 'symmetry_mean', 'fractal_dimension_mean')
df_mean = df[, features_mean]
df_mean_norm = df_mean
df_mean_norm[,2:ncol(df_mean_norm)] = scale(df_mean_norm[,2:ncol(df_mean_norm)])
df_mean_norm_melted = melt(df_mean_norm, id='diagnosis')

features_worst = c('diagnosis', 'radius_worst','texture_worst','perimeter_worst','area_worst','smoothness_worst', 'compactness_worst',
                   'concavity_worst','concave.points_worst', 'symmetry_worst', 'fractal_dimension_worst')
df_worst = df[, features_worst]
df_worst_norm = df_worst
df_worst_norm[,2:ncol(df_worst_norm)] = scale(df_worst_norm[,2:ncol(df_worst_norm)])
df_worst_norm_melted = melt(df_worst_norm, id='diagnosis')


features_se = c('diagnosis', 'radius_se','texture_se','perimeter_se','area_se','smoothness_se', 'compactness_se',
                'concavity_se','concave.points_se', 'symmetry_se', 'fractal_dimension_se')
df_se = df[, features_se]
df_se_norm = df_se
df_se_norm[,2:ncol(df_se_norm)] = scale(df_se_norm[,2:ncol(df_se_norm)])
df_se_norm_melted = melt(df_se_norm, id='diagnosis')



corr_mat_mean = cor(df_mean[,2:ncol(df_mean)])
corrplot(corr_mat_mean, order = "hclust", method='color', diag=FALSE, type='upper',addCoef.col = "black", 
         number.cex=0.7, tl.col='black', tl.cex=0.7, tl.srt=35)

corr_mat_worst = cor(df_worst[,2:ncol(df_mean)])
corrplot(corr_mat_worst, order = "hclust", method='color', diag=FALSE, type='upper',addCoef.col = "black", 
         number.cex=0.7, tl.col='black', tl.cex=0.7, tl.srt=35)

corr_mat_se = cor(df_se[,2:ncol(df_mean)])
corrplot(corr_mat_se, order = "hclust", method='color', diag=FALSE, type='upper',addCoef.col = "black", 
         number.cex=0.7, tl.col='black', tl.cex=0.7, tl.srt=35)

# creating mean, worst and se features distribution boxplots
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_mean_norm_melted) + geom_boxplot()+ theme(axis.text.x = element_text(angle = 90))
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_worst_norm_melted) + geom_boxplot()+ theme(axis.text.x = element_text(angle = 90))
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_se_norm_melted) + geom_boxplot()+ theme(axis.text.x = element_text(angle = 90))

# creating mean, worst and se features distribution swarmplots
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_mean_norm_melted) + geom_beeswarm(cex=.55, aes(color=diagnosis)) +
  theme(axis.text.x = element_text(angle = 90))
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_worst_norm_melted) + geom_beeswarm(cex=.5, aes(color=diagnosis)) +
  theme(axis.text.x = element_text(angle = 90))
ggplot(aes(x=variable, y=value, fill=diagnosis), data=df_se_norm_melted) + geom_beeswarm(cex=.45, aes(color=diagnosis)) +
  theme(axis.text.x = element_text(angle = 90))


set.seed(1212)
data_index <- createDataPartition(df$diagnosis, p=0.7, list = FALSE)
train_data <- df[data_index, -1]
test_data <- df[-data_index, -1]

# removing multicollinear and inseparable features  
multicoll_free = c('diagnosis', 'radius_mean', 'texture_mean', 'smoothness_mean',
                   'compactness_mean', 'fractal_dimension_worst',
                   'radius_se', 'texture_se', 'compactness_se',
                   )

test_data_mf <- test_data[, multicoll_free]
train_data_mf <- train_data[, multicoll_free]

fitControl <- trainControl(method="cv",
                           number = 10)

# k nearest neighbours model on all features
model_knn <- train(diagnosis~.,
                   train_data,
                   method="knn",
                   preProc = c("center", "scale"),
                   trControl=fitControl)

pred_knn <- predict(model_knn, test_data)
cm_knn <- confusionMatrix(pred_knn, test_data$diagnosis, positive = "B")
cm_knn

# k nearest neighbours model on selected features
model_knn_mf <- train(diagnosis~.,
                      train_data_mf,
                      method="knn",
                      preProc = c("center", "scale"),
                      trControl=fitControl)

pred_knn_mf <- predict(model_knn_mf, test_data_mf)
cm_knn_mf <- confusionMatrix(pred_knn_mf, test_data_mf$diagnosis, positive = "B")
cm_knn_mf

# random forest model on all features
model_rf <- train(diagnosis~.,
                  train_data,
                  method="ranger",
                  preProc = c("center", "scale"),
                  trControl=fitControl)
pred_rf <- predict(model_rf, test_data)
cm_rf <- confusionMatrix(pred_rf, test_data$diagnosis, positive = "B")
cm_rf

# random forest model on selected features
model_rf_mf <- train(diagnosis~.,
                     train_data_mf,
                     method="ranger",
                     preProc = c("center", "scale"),
                     trControl=fitControl)
pred_rf_mf <- predict(model_rf_mf, test_data_mf)
cm_rf_mf <- confusionMatrix(pred_rf_mf, test_data_mf$diagnosis, positive = "B")
cm_rf_mf

# naive bayes model on all features
model_nb <- train(diagnosis~.,
                     train_data,
                     method="nb",
                     preProc = c("center", "scale"),
                     trControl=fitControl)

pred_nb <- predict(model_nb, test_data)
cm_nb <- confusionMatrix(pred_nb, test_data$diagnosis, positive = "B")
cm_nb

# naive bayes model on selected features
model_nb_mf <- train(diagnosis~.,
                     train_data_mf,
                     method="nb",
                     preProc = c("center", "scale"),
                     trControl=fitControl)

pred_nb_mf <- predict(model_nb_mf, test_data_mf)
cm_nb_mf <- confusionMatrix(pred_nb_mf, test_data_mf$diagnosis, positive = "B")
cm_nb_mf

