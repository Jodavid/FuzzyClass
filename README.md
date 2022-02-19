
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Last update: 19-02-2022

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
#>          1 55  6  1
#>          2  6 41 12
#>          3  2 17 40
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7556          
#>                  95% CI : (0.6861, 0.8164)
#>     No Information Rate : 0.3556          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.6332          
#>                                           
#>  Mcnemar's Test P-Value : 0.7541          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8730   0.6406   0.7547
#> Specificity            0.9402   0.8448   0.8504
#> Pos Pred Value         0.8871   0.6949   0.6780
#> Neg Pred Value         0.9322   0.8099   0.8926
#> Prevalence             0.3500   0.3556   0.2944
#> Detection Rate         0.3056   0.2278   0.2222
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9066   0.7427   0.8026

saida <- predict(fit_FGNB, test, type = "matrix")
```

<!--

#### Fuzzy Gaussian Naive Bayes based in Zadeh


```r
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
#>          1 58  3  1
#>          2  6 42 11
#>          3  0 10 49
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.3556          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7415          
#>                                           
#>  Mcnemar's Test P-Value : 0.5626          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9062   0.7636   0.8033
#> Specificity            0.9655   0.8640   0.9160
#> Pos Pred Value         0.9355   0.7119   0.8305
#> Neg Pred Value         0.9492   0.8926   0.9008
#> Prevalence             0.3556   0.3056   0.3389
#> Detection Rate         0.3222   0.2333   0.2722
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9359   0.8138   0.8596

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
#>          1 59  3  0
#>          2  7 42 10
#>          3  0 11 48
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7415          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8939   0.7500   0.8276
#> Specificity            0.9737   0.8629   0.9098
#> Pos Pred Value         0.9516   0.7119   0.8136
#> Neg Pred Value         0.9407   0.8843   0.9174
#> Prevalence             0.3667   0.3111   0.3222
#> Detection Rate         0.3278   0.2333   0.2667
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9338   0.8065   0.8687

saida <- predict(fit_GNB, test, type = "matrix")
```

#### Fuzzy Naive Bayes Triangular


```r
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
#>          1 53  9  0
#>          2  1 57  1
#>          3  1 23 35
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8056          
#>                  95% CI : (0.7401, 0.8607)
#>     No Information Rate : 0.4944          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7085          
#>                                           
#>  Mcnemar's Test P-Value : 4.478e-06       
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9636   0.6404   0.9722
#> Specificity            0.9280   0.9780   0.8333
#> Pos Pred Value         0.8548   0.9661   0.5932
#> Neg Pred Value         0.9831   0.7355   0.9917
#> Prevalence             0.3056   0.4944   0.2000
#> Detection Rate         0.2944   0.3167   0.1944
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9458   0.8092   0.9028

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
#>          1 59  3  0
#>          2  5 47  7
#>          3  1 12 46
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8444          
#>                  95% CI : (0.7831, 0.8941)
#>     No Information Rate : 0.3611          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7665          
#>                                           
#>  Mcnemar's Test P-Value : 0.4209          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9077   0.7581   0.8679
#> Specificity            0.9739   0.8983   0.8976
#> Pos Pred Value         0.9516   0.7966   0.7797
#> Neg Pred Value         0.9492   0.8760   0.9421
#> Prevalence             0.3611   0.3444   0.2944
#> Detection Rate         0.3278   0.2611   0.2556
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9408   0.8282   0.8828

saida <- predict(fit_NBT, test, type = "matrix")
```

#### Fuzzy Naive Bayes Trapezoidal


```r

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
#>          1 56  6  0
#>          2  4 46  9
#>          3  1 11 47
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.35            
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7416          
#>                                           
#>  Mcnemar's Test P-Value : 0.6594          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9180   0.7302   0.8393
#> Specificity            0.9496   0.8889   0.9032
#> Pos Pred Value         0.9032   0.7797   0.7966
#> Neg Pred Value         0.9576   0.8595   0.9256
#> Prevalence             0.3389   0.3500   0.3111
#> Detection Rate         0.3111   0.2556   0.2611
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9338   0.8095   0.8713

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
#>          1 55  7  0
#>          2  4 47  8
#>          3  1 11 47
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.3611          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7417          
#>                                           
#>  Mcnemar's Test P-Value : 0.5141          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9167   0.7231   0.8545
#> Specificity            0.9417   0.8957   0.9040
#> Pos Pred Value         0.8871   0.7966   0.7966
#> Neg Pred Value         0.9576   0.8512   0.9339
#> Prevalence             0.3333   0.3611   0.3056
#> Detection Rate         0.3056   0.2611   0.2611
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9292   0.8094   0.8793

saida <- predict(fit_NBT, test, type = "matrix")
```

#### Fuzzy Exponential Naive Bayes Classifier


```r

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
#>          1 53  9  0
#>          2  4 43 12
#>          3  0  8 51
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.35            
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7251          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9298   0.7167   0.8095
#> Specificity            0.9268   0.8667   0.9316
#> Pos Pred Value         0.8548   0.7288   0.8644
#> Neg Pred Value         0.9661   0.8595   0.9008
#> Prevalence             0.3167   0.3333   0.3500
#> Detection Rate         0.2944   0.2389   0.2833
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.9283   0.7917   0.8706

saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>              1         2         3
#> [1,] 0.3081521 0.3321311 0.3597168
#> [2,] 0.3135802 0.3359677 0.3504521
#> [3,] 0.2893301 0.3387083 0.3719616
#> [4,] 0.3165405 0.3340471 0.3494124
#> [5,] 0.3147480 0.3300611 0.3551909
#> [6,] 0.3143975 0.3295745 0.3560280
```

#### Fuzzy Gamma Naive Bayes Classifier


```r

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
#>          1 62  0  0
#>          2 18 41  0
#>          3  0 59  0
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.5722          
#>                  95% CI : (0.4965, 0.6455)
#>     No Information Rate : 0.5556          
#>     P-Value [Acc > NIR] : 0.3548          
#>                                           
#>                   Kappa : 0.3565          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.7750   0.4100       NA
#> Specificity            1.0000   0.7750   0.6722
#> Pos Pred Value         1.0000   0.6949       NA
#> Neg Pred Value         0.8475   0.5124       NA
#> Prevalence             0.4444   0.5556   0.0000
#> Detection Rate         0.3444   0.2278   0.0000
#> Detection Prevalence   0.3444   0.3278   0.3278
#> Balanced Accuracy      0.8875   0.5925       NA

saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999867 1.331780e-05 1.723133e-14
#> [2,] 0.9999757 2.428439e-05 2.672388e-14
#> [3,] 1.0000000 2.360821e-10 2.518640e-21
#> [4,] 0.9998490 1.509711e-04 1.077752e-12
#> [5,] 0.9999808 1.924925e-05 6.174013e-14
#> [6,] 0.9999667 3.330026e-05 1.561842e-12
```

#### Fuzzy Exponential Naive Bayes Classifier


```r

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
#>          1  1 61  0
#>          2  0 50  9
#>          3  0 58  1
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.2889         
#>                  95% CI : (0.2239, 0.361)
#>     No Information Rate : 0.9389         
#>     P-Value [Acc > NIR] : 1              
#>                                          
#>                   Kappa : -0.058         
#>                                          
#>  Mcnemar's Test P-Value : NA             
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity          1.000000  0.29586 0.100000
#> Specificity          0.659218  0.18182 0.658824
#> Pos Pred Value       0.016129  0.84746 0.016949
#> Neg Pred Value       1.000000  0.01653 0.925620
#> Prevalence           0.005556  0.93889 0.055556
#> Detection Rate       0.005556  0.27778 0.005556
#> Detection Prevalence 0.344444  0.32778 0.327778
#> Balanced Accuracy    0.829609  0.23884 0.379412

saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999867 1.331780e-05 1.723133e-14
#> [2,] 0.9999757 2.428439e-05 2.672388e-14
#> [3,] 1.0000000 2.360821e-10 2.518640e-21
#> [4,] 0.9998490 1.509711e-04 1.077752e-12
#> [5,] 0.9999808 1.924925e-05 6.174013e-14
#> [6,] 0.9999667 3.330026e-05 1.561842e-12
```
-->
