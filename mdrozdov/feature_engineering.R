library(dplyr)
library(ggplot2)
library(car)
library(ISLR)
library(glmnet)
library(caret)


train = read.csv('data/clean_train.csv')

test = read.csv('data/clean_test.csv')



full_df = train
garage_yrs = c(full_df$GarageYrBlt %>% unique() %>% sort())[-length(unique(full_df$GarageYrBlt))]
full_df$GarageYrBlt[full_df$GarageYrBlt==9999] = full_df$YearBuilt[full_df$GarageYrBlt==9999]

# full_df = cbind(full_df,c(saleprice,rep(NA,nrow(test))))
# colnames(full_df)[81] = 'SalePrice'

numerics= full_df[,!sapply(full_df,is.factor)]


saleprice = train[,ncol(train)]
categoricals = cbind(full_df[,sapply(full_df,is.factor)],saleprice)


# scatterplotMatrix(numerics)

# NUMERICS ####

lm.fit = lm(SalePrice ~.,data=numerics)


vif(lm.fit)


alias(lm.fit)


collinear_cols = c(which(colnames(train)=='X2ndFlrSF'),
                   which(colnames(train)=='LowQualFinSF'),
                   which(colnames(train)=='BsmtFinSF1'),
                   which(colnames(train)=='BsmtFinSF2'),
                   which(colnames(train)=='BsmtUnfSF'),
                   which(colnames(train)=='X1stFlrSF'))


full_df = full_df[,-collinear_cols]

numerics = full_df[,!sapply(full_df,is.factor)]

lm.fit = lm(SalePrice ~.,data=numerics)

vif(lm.fit)[which(vif(lm.fit)>5)]

hi_vif_cols = c('GarageCars')

hi_vif_cols = which(colnames(full_df) %in% hi_vif_cols)

full_df = full_df[,-hi_vif_cols]

numerics= full_df[,!sapply(full_df,is.factor)]

lm.fit = lm(SalePrice ~.,data=numerics)

vif(lm.fit)[which(vif(lm.fit)>5)]

# CATEGORICALS ####

lm.fit.cat = lm(saleprice~.,data=categoricals)

vif(lm.fit.cat)
alias(lm.fit.cat)

collinear_cats = c('GarageFinish','GarageQual')
collinear_cats= which(colnames(full_df) %in% collinear_cats)
full_df = full_df[,-collinear_cats]

categoricals = cbind(full_df[,sapply(full_df,is.factor)],saleprice)

lm.fit.cat = lm(saleprice~.,data=categoricals)
(vif(lm.fit.cat)^2)[,3][which((vif(lm.fit.cat)^2)[,3]>5)]

hi_vif_cats = c('Exterior2nd','BsmtFinType1')
hi_vif_cats = which(colnames(full_df) %in% hi_vif_cats)
hi_vif_cats
full_df = full_df[,-hi_vif_cats]
# NUMS & CATS ####

lm.fit.full = lm(SalePrice~.,data=full_df)
vif(lm.fit.full)
(vif(lm.fit.full)^2)[,3][which((vif(lm.fit.full)^2)[,3]>5)]

full_df = full_df[,-which(colnames(full_df)=='MiscVal')]
lm.fit.full = lm(SalePrice~.,data=full_df)

# OUTLIERS ####

cookd = cooks.distance(lm.fit.full)
sample_size <- nrow(full_df)
plot(cookd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4/sample_size, col="red")  # add cutoff line
text(x=1:length(cookd)+1, y=cookd, labels=ifelse(cookd>4/sample_size, names(cookd),""), col="red")  # add labels

outliers = cookd[cookd>0.05 & !is.na(cookd)]
outliers = as.numeric(outliers %>% names())
full_df = full_df[-outliers,]

# FEATURE ENGINEERING ####


# numerics = numerics[,-1]
# 
# 
# par(mfrow=c(3,3))
# for(i in colnames(numerics)){
#     hist(numerics[,i],main=i)
#     
# }
# 
# hist(log(numerics$SalePrice))
# hist(sqrt(numerics$GarageArea))
# hist(sqrt(numerics$PoolArea))
# hist(sqrt(numerics$WoodDeckSF))
# hist(sqrt(numerics$OpenPorchSF))
# hist(sqrt(numerics$LotArea))
# hist(sqrt(numerics$BsmtUnfSF))
# hist(sqrt(numerics$BsmtFinSF2))
# hist(sqrt(numerics$X1stFlrSF))
# 
# full_df$SalePrice = log(full_df$SalePrice)
# full_df$GarageArea = sqrt(full_df$GarageArea)
# full_df$PoolArea = sqrt(full_df$PoolArea)
# full_df$WoodDeckSF = sqrt(full_df$WoodDeckSF)
# full_df$OpenPorchSF = sqrt(full_df$OpenPorchSF)
# full_df$LotArea = sqrt(full_df$LotArea)
# full_df$BsmtUnfSF = sqrt(full_df$BsmtUnfSF)
# full_df$BsmtFinSF2 = sqrt(full_df$BsmtFinSF2)
# full_df$X1stFlrSF = sqrt(full_df$X1stFlrSF)
# 
# 
# test$GarageArea = sqrt(test$GarageArea)
# test$PoolArea = sqrt(test$PoolArea)
# test$WoodDeckSF = sqrt(test$WoodDeckSF)
# test$OpenPorchSF = sqrt(test$OpenPorchSF)
# test$LotArea = sqrt(test$LotArea)
# test$BsmtUnfSF = sqrt(test$BsmtUnfSF)
# test$BsmtFinSF2 = sqrt(test$BsmtFinSF2)
# test$X1stFlrSF = sqrt(test$X1stFlrSF)
=======
numerics = numerics[,-1]


par(mfrow=c(3,3))
for(i in colnames(numerics)){
    hist(numerics[,i],main=i)
    
}

hist(log(numerics$SalePrice))
hist(sqrt(numerics$GarageArea))
hist(sqrt(numerics$PoolArea))
hist(sqrt(numerics$WoodDeckSF))
hist(sqrt(numerics$OpenPorchSF))
hist(sqrt(numerics$LotArea))
hist(sqrt(numerics$BsmtUnfSF))
hist(sqrt(numerics$BsmtFinSF2))
hist(sqrt(numerics$GrLivArea))



full_df$SalePrice = log(full_df$SalePrice)

full_df$GarageArea = sqrt(full_df$GarageArea)
full_df$PoolArea = sqrt(full_df$PoolArea)
full_df$WoodDeckSF = sqrt(full_df$WoodDeckSF)
full_df$OpenPorchSF = sqrt(full_df$OpenPorchSF)
full_df$LotArea = sqrt(full_df$LotArea)
full_df$BsmtUnfSF = sqrt(full_df$BsmtUnfSF)
full_df$TotalBsmtSF = sqrt(full_df$TotalBsmtSF)
full_df$GrLivArea = sqrt(full_df$GrLivArea)

test$GarageArea = sqrt(test$GarageArea)
test$PoolArea = sqrt(test$PoolArea)
test$WoodDeckSF = sqrt(test$WoodDeckSF)
test$OpenPorchSF = sqrt(test$OpenPorchSF)
test$LotArea = sqrt(test$LotArea)
test$BsmtUnfSF = sqrt(test$BsmtUnfSF)
test$TotalBsmtSF = sqrt(test$TotalBsmtSF)
test$GrLivArea = sqrt(test$GrLivArea)



test = test[,-which((colnames(test) %in% colnames(full_df))==FALSE)]

#test = test[,-which((colnames(test) %in% colnames(full_df))==FALSE)]


dim(full_df)
dim(test)

write.csv(full_df,'data/train_selected_features.csv',row.names = F)
write.csv(test,'data/test_selected_features.csv',row.names = F)

# # LASSO ####
# full_df = full_df[,-1]
# full_df = full_df[,-which(colnames(full_df)=='Utilities')]
# test_id = test$Id
# which((colnames(test) %in% colnames(full_df))==FALSE)
# test = model.matrix(MSSubClass~.,test)
# 
# 
# x = model.matrix(SalePrice~.,train)[,-ncol(train)]
# y = train$SalePrice
# 
# 
# 
# set.seed(0)
# train = sample(1:nrow(x), 7*nrow(x)/10)
# test = (-train)
# y.test = y[test]
# 
# 
# grid = 10^seq(5, -2, length = 100)
# 
# train_control = trainControl(method = 'cv', number=10)
# tune.grid = expand.grid(lambda = grid, alpha=c(1))
# lasso.caret = train(x, y,
#                     method = 'glmnet',
#                     trControl = train_control, tuneGrid = tune.grid)
# 
# 
# 
# 
# pred = predict.train(lasso.caret, newdata = )
# mean((pred - y[test])^2)
# 
# 
# lasso.models.train = glmnet(x, y, alpha = 1, lambda = grid)
# 
# cv.lasso.out = cv.glmnet(x, y,
#                          lambda = grid, alpha = 1, nfolds = 10)
# plot(cv.lasso.out, main = "Lasso Regression\n")
# bestlambda.lasso = cv.lasso.out$lambda.min
# bestlambda.lasso
# 
# bestlambda.lasso
# 
# 
# lasso.bestlambdatrain = predict(lasso.models.train, s = bestlambda.lasso, newx = test)
# mean((lasso.bestlambdatrain - y.test)^2)

# # lasso.bestlambdatrain
# # 
# # test_id %>% length()
# # lasso.bestlambdatrain = as.data.frame(lasso.bestlambdatrain)
# # lasso.bestlambdatrain$'1'
# 
# submission = cbind(test_id,lasso.bestlambdatrain)
