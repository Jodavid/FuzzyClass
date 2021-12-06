
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Last update: 06-12-2021

## A family of probabilities-based classifiers Fuzzy and Non-Fuzzy

### Installation

``` r
# Installation
install.packages("devtools")
devtools::install_github("Jodavid/FuzzyClass")
```

### Usage

``` r
# package import
library(FuzzyClass)
```

### Data reading and preparation for use

``` r
library(FuzzyClass)
library(caret)
#> Carregando pacotes exigidos: lattice
#> Carregando pacotes exigidos: ggplot2
#' ---------------------------------------------
#' The following shows how the functions are used:
#' --------------
#' Reading a database:
#'
#' Actual training data:
data(VirtualRealityData)

VirtualRealityData <- as.data.frame(VirtualRealityData)

# Splitting into Training and Testing
split <- caTools::sample.split(t(VirtualRealityData[,1]), SplitRatio = 0.7)
Train <- subset(VirtualRealityData, split == "TRUE")
Test <- subset(VirtualRealityData, split == "FALSE")
# ----------------

test = Test[,-4]
```

#### Fuzzy Gaussian Naive Bayes with Fuzzy Parameters

``` r
# --------------------------------------------------
# Fuzzy Gaussian Naive Bayes with Fuzzy Parameters


fit_FGNB <- GauNBFuzzyParam(train =  Train[,-4],
                                    cl = Train[,4], metd = 1, cores = 1)


print(fit_FGNB)
#> 
#> Fuzzy Gaussian Naive Bayes Classifier for Discrete Predictors
#> 
#> Variables:
#> [1] "V1" "V2" "V3"
#> Class:
#> NULL
saida <- predict(fit_FGNB, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 54  3  0
#>          2 11 48 11
#>          3  0 14 39
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7833          
#>                  95% CI : (0.7159, 0.8412)
#>     No Information Rate : 0.3611          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.6734          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8308   0.7385   0.7800
#> Specificity            0.9739   0.8087   0.8923
#> Pos Pred Value         0.9474   0.6857   0.7358
#> Neg Pred Value         0.9106   0.8455   0.9134
#> Prevalence             0.3611   0.3611   0.2778
#> Detection Rate         0.3000   0.2667   0.2167
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9023   0.7736   0.8362
saida <- predict(fit_FGNB, test, type = "matrix")
```

#### Fuzzy Gaussian Naive Bayes based in Zadeh

``` r
fit_FGNB <- FuzzyGaussianNaiveBayes(train =  Train[,-4],
                                    cl = Train[,4], cores = 1,
                                    fuzzy = T)
print(fit_FGNB)
#> 
#> Fuzzy Gaussian Naive Bayes Classifier for Discrete Predictors Zadeh-based
#> 
#> Variables:
#> [1] "V1" "V2" "V3"
#> Class:
#> NULL
saida <- predict(fit_FGNB, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 55  2  0
#>          2  4 58  8
#>          3  0  9 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8722          
#>                  95% CI : (0.8145, 0.9172)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.807           
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9322   0.8406   0.8462
#> Specificity            0.9835   0.8919   0.9297
#> Pos Pred Value         0.9649   0.8286   0.8302
#> Neg Pred Value         0.9675   0.9000   0.9370
#> Prevalence             0.3278   0.3833   0.2889
#> Detection Rate         0.3056   0.3222   0.2444
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9578   0.8662   0.8879
# -----
fit_GNB <- FuzzyGaussianNaiveBayes(train =  Train[,-4],
                               cl = Train[,4], cores = 2,
                               fuzzy = F)
print(fit_GNB)
#> 
#> Gaussian Naive Bayes Classifier for Discrete Predictors
#> 
#> Variables:
#> [1] "V1" "V2" "V3"
#> Class:
#> NULL
saida <- predict(fit_GNB, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 55  2  0
#>          2  6 56  8
#>          3  0  8 45
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.799           
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9016   0.8485   0.8491
#> Specificity            0.9832   0.8772   0.9370
#> Pos Pred Value         0.9649   0.8000   0.8491
#> Neg Pred Value         0.9512   0.9091   0.9370
#> Prevalence             0.3389   0.3667   0.2944
#> Detection Rate         0.3056   0.3111   0.2500
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9424   0.8628   0.8930
saida <- predict(fit_GNB, test, type = "matrix")
```

#### Fuzzy Naive Bayes Triangular

``` r
fit_FNBT <- FuzzyTriangularNaiveBayes(train =  Train[,-4],
                                  cl = Train[,4], cores = 2,
                                  fuzzy = T)

print(fit_FNBT)
#> 
#> Fuzzy Naive Bayes Triangular Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_FNBT, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 49  8  0
#>          2  0 67  3
#>          3  0 12 41
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8722          
#>                  95% CI : (0.8145, 0.9172)
#>     No Information Rate : 0.4833          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.8046          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            1.0000   0.7701   0.9318
#> Specificity            0.9389   0.9677   0.9118
#> Pos Pred Value         0.8596   0.9571   0.7736
#> Neg Pred Value         1.0000   0.8182   0.9764
#> Prevalence             0.2722   0.4833   0.2444
#> Detection Rate         0.2722   0.3722   0.2278
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9695   0.8689   0.9218
saida <- predict(fit_FNBT, test, type = "matrix")

# ----------------

fit_NBT <- FuzzyTriangularNaiveBayes(train =  Train[,-4],
                                 cl = Train[,4], cores = 2,
                                 fuzzy = F)
print(fit_NBT)
#> 
#> Naive Bayes Triangular Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_NBT, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 54  3  0
#>          2  5 61  4
#>          3  0 11 42
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8722          
#>                  95% CI : (0.8145, 0.9172)
#>     No Information Rate : 0.4167          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.8061          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9153   0.8133   0.9130
#> Specificity            0.9752   0.9143   0.9179
#> Pos Pred Value         0.9474   0.8714   0.7925
#> Neg Pred Value         0.9593   0.8727   0.9685
#> Prevalence             0.3278   0.4167   0.2556
#> Detection Rate         0.3000   0.3389   0.2333
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9452   0.8638   0.9155
saida <- predict(fit_NBT, test, type = "matrix")
```

#### Fuzzy Naive Bayes Trapezoidal

``` r
fit_FNBT <- FuzzyTrapezoidalNaiveBayes(train =  Train[,-4],
                                    cl = Train[,4], cores = 4,
                                  fuzzy = T)
print(fit_FNBT)
#> 
#> Fuzzy Naive Bayes Trapezoidal Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_FNBT, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 50  7  0
#>          2  1 55 14
#>          3  1  7 45
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8333          
#>                  95% CI : (0.7707, 0.8846)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.7486          
#>                                           
#>  Mcnemar's Test P-Value : 0.04958         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9615   0.7971   0.7627
#> Specificity            0.9453   0.8649   0.9339
#> Pos Pred Value         0.8772   0.7857   0.8491
#> Neg Pred Value         0.9837   0.8727   0.8898
#> Prevalence             0.2889   0.3833   0.3278
#> Detection Rate         0.2778   0.3056   0.2500
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9534   0.8310   0.8483
saida <- predict(fit_FNBT, test, type = "matrix")

# ----------------

fit_NBT <- FuzzyTrapezoidalNaiveBayes(train =  Train[,-4],
                                  cl = Train[,4], cores = 2,
                                  fuzzy = F)
print(fit_NBT)
#> 
#> Naive Bayes Trapezoidal Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_NBT, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 50  7  0
#>          2  1 55 14
#>          3  1  6 46
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8389          
#>                  95% CI : (0.7769, 0.8894)
#>     No Information Rate : 0.3778          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.7572          
#>                                           
#>  Mcnemar's Test P-Value : 0.03356         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9615   0.8088   0.7667
#> Specificity            0.9453   0.8661   0.9417
#> Pos Pred Value         0.8772   0.7857   0.8679
#> Neg Pred Value         0.9837   0.8818   0.8898
#> Prevalence             0.2889   0.3778   0.3333
#> Detection Rate         0.2778   0.3056   0.2556
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9534   0.8374   0.8542
saida <- predict(fit_NBT, test, type = "matrix")
```

#### Fuzzy Exponential Naive Bayes Classifier

``` r
fit_FENB <- ExpNBFuzzyParam(train =  Train[,-4],
                                    cl = Train[,4], metd = 1, cores = 2)
                              
print(fit_FENB)
#> 
#> Fuzzy Exponential Naive Bayes Classifier for Discrete Predictors
#> 
#> Variables:
#> [1] "V1" "V2" "V3"
#> Class:
#> NULL
saida <- predict(fit_FENB, test)
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 52  5  0
#>          2  4 53 13
#>          3  0  5 48
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.85            
#>                  95% CI : (0.7893, 0.8988)
#>     No Information Rate : 0.35            
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7746          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9286   0.8413   0.7869
#> Specificity            0.9597   0.8547   0.9580
#> Pos Pred Value         0.9123   0.7571   0.9057
#> Neg Pred Value         0.9675   0.9091   0.8976
#> Prevalence             0.3111   0.3500   0.3389
#> Detection Rate         0.2889   0.2944   0.2667
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9441   0.8480   0.8724
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>              1         2         3
#> [1,] 0.2961453 0.3365267 0.3673280
#> [2,] 0.3157359 0.3359077 0.3483564
#> [3,] 0.3052298 0.3358075 0.3589627
#> [4,] 0.2958981 0.3371857 0.3669162
#> [5,] 0.3176593 0.3313850 0.3509557
#> [6,] 0.3306028 0.3232660 0.3461311
```

#### Fuzzy Gamma Naive Bayes Classifier

``` r
fit_NBT <- FuzzyGammaNaiveBayes(train =  Train[,-4],
                                    cl = Train[,4], cores = 2)
                              
print(fit_NBT)
#> 
#> Fuzzy Gamma Naive Bayes Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_NBT, test)
saida <- factor(saida,levels = unique(Test[,4]))
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1 56  1  0
#>          2 13 57  0
#>          3  0 53  0
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.6278          
#>                  95% CI : (0.5527, 0.6985)
#>     No Information Rate : 0.6167          
#>     P-Value [Acc > NIR] : 0.4113          
#>                                           
#>                   Kappa : 0.4173          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8116   0.5135       NA
#> Specificity            0.9910   0.8116   0.7056
#> Pos Pred Value         0.9825   0.8143       NA
#> Neg Pred Value         0.8943   0.5091       NA
#> Prevalence             0.3833   0.6167   0.0000
#> Detection Rate         0.3111   0.3167   0.0000
#> Detection Prevalence   0.3167   0.3889   0.2944
#> Balanced Accuracy      0.9013   0.6626       NA
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999081 9.188013e-05 3.572063e-13
#> [2,] 0.9994942 5.058356e-04 6.868808e-13
#> [3,] 1.0000000 3.735844e-10 1.435324e-24
#> [4,] 0.9999998 2.040093e-07 1.799137e-18
#> [5,] 0.9974631 2.536878e-03 5.907486e-11
#> [6,] 0.9279839 7.201598e-02 1.114937e-07
```

#### Fuzzy Exponential Naive Bayes Classifier

``` r
fit_NBE <- FuzzyExponentialNaiveBayes(train =  Train[,-4],
                                    cl = Train[,4], cores = 2)
                              
print(fit_NBE)
#> 
#> Fuzzy Exponential Naive Bayes Classifier for Discrete Predictors
#> 
#> Class:
#> NULL
saida <- predict(fit_NBE, test)
saida <- factor(saida,levels = unique(Test[,4]))
confusionMatrix(factor(Test[,4]), saida)
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  1  2  3
#>          1  3 37 17
#>          2  0 54 16
#>          3  0 50  3
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.3333         
#>                  95% CI : (0.265, 0.4073)
#>     No Information Rate : 0.7833         
#>     P-Value [Acc > NIR] : 1              
#>                                          
#>                   Kappa : -0.0562        
#>                                          
#>  Mcnemar's Test P-Value : 2.022e-15      
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity           1.00000   0.3830  0.08333
#> Specificity           0.69492   0.5897  0.65278
#> Pos Pred Value        0.05263   0.7714  0.05660
#> Neg Pred Value        1.00000   0.2091  0.74016
#> Prevalence            0.01667   0.7833  0.20000
#> Detection Rate        0.01667   0.3000  0.01667
#> Detection Prevalence  0.31667   0.3889  0.29444
#> Balanced Accuracy     0.84746   0.4864  0.36806
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999081 9.188013e-05 3.572063e-13
#> [2,] 0.9994942 5.058356e-04 6.868808e-13
#> [3,] 1.0000000 3.735844e-10 1.435324e-24
#> [4,] 0.9999998 2.040093e-07 1.799137e-18
#> [5,] 0.9974631 2.536878e-03 5.907486e-11
#> [6,] 0.9279839 7.201598e-02 1.114937e-07
```
