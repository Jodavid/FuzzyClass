
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 29-11-2021

#### Família de Classificadores utilizando probabilidades Fuzzy e Não Fuzzy

<!--
## Resumo:


Um dos classificadores, foi uma nova abordagem do algoritmo **Naive Bayes** que junto com meu orientador [**Ronei Moraes**](mailto:ronei@de.ufpb.br) propusemos no meu TCC de graduação em Estatística defendido no fim de 2014 na UFPB ([link para a documento do TCC intitulado como *'Sistema de avaliação de treinamento baseado em realidade virtual usando rede de probabilidade fuzzy fundamentada na distribuição Normal Fuzzy.'*](http://www.de.ufpb.br/graduacao/tcc/TCC2014p2Jodavid.pdf)), e publicado em periódico esse ano (2021) com o título [*'A New Bayesian Network Based on Gaussian Naive Bayes with Fuzzy Parameters for Training Assessment in Virtual Simulators'*](https://link.springer.com/article/10.1007/s40815-020-00936-4) (publicado na [International Journal of Fuzzy Systems](https://www.springer.com/journal/40815)).
-->

## Instalação do pacote:

``` r
# Instalando
install.packages("devtools")
devtools::install_github("Jodavid/FuzzyClass")

# Chamando o pacote
library(FuzzyClass)
```

## Utilização:

### Exemplo 1:

``` r
library(FuzzyClass)
library(caret)
#> Carregando pacotes exigidos: lattice
#> Carregando pacotes exigidos: ggplot2
#' ---------------------------------------------
#' Abaixo seguem como são utilizadas as funções:
#' --------------
#' Lendo uma base de dados:
#'
#' Dados de treinamento real:
data(VirtualRealityData)

VirtualRealityData <- as.data.frame(VirtualRealityData)

# Splitting into Training and Testing
split <- caTools::sample.split(t(VirtualRealityData[,1]), SplitRatio = 0.7)
Train <- subset(VirtualRealityData, split == "TRUE")
Test <- subset(VirtualRealityData, split == "FALSE")
# ----------------

test = Test[,-4]
```

#### Fuzzy Gaussian Naive Bayes com parâmetros Fuzzy

``` r
# --------------------------------------------------
# Fuzzy Gaussian Naive Bayes com parâmetros Fuzzy


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
#>          1 58  6  0
#>          2 10 40 16
#>          3  1  9 40
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.7667         
#>                  95% CI : (0.698, 0.8264)
#>     No Information Rate : 0.3833         
#>     P-Value [Acc > NIR] : <2e-16         
#>                                          
#>                   Kappa : 0.6493         
#>                                          
#>  Mcnemar's Test P-Value : 0.2658         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8406   0.7273   0.7143
#> Specificity            0.9459   0.7920   0.9194
#> Pos Pred Value         0.9062   0.6061   0.8000
#> Neg Pred Value         0.9052   0.8684   0.8769
#> Prevalence             0.3833   0.3056   0.3111
#> Detection Rate         0.3222   0.2222   0.2222
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.8933   0.7596   0.8168
saida <- predict(fit_FGNB, test, type = "matrix")
```

#### Fuzzy Gaussian Naive Bayes baseado em Zadeh

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
#>          1 62  2  0
#>          2  8 48 10
#>          3  0  9 41
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8389          
#>                  95% CI : (0.7769, 0.8894)
#>     No Information Rate : 0.3889          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7569          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8857   0.8136   0.8039
#> Specificity            0.9818   0.8512   0.9302
#> Pos Pred Value         0.9688   0.7273   0.8200
#> Neg Pred Value         0.9310   0.9035   0.9231
#> Prevalence             0.3889   0.3278   0.2833
#> Detection Rate         0.3444   0.2667   0.2278
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9338   0.8324   0.8671
#saida <- predict(fit_FGNB, test, type = "matrix")

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
#>          1 61  3  0
#>          2  8 49  9
#>          3  0  9 41
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8389          
#>                  95% CI : (0.7769, 0.8894)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7567          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8841   0.8033   0.8200
#> Specificity            0.9730   0.8571   0.9308
#> Pos Pred Value         0.9531   0.7424   0.8200
#> Neg Pred Value         0.9310   0.8947   0.9308
#> Prevalence             0.3833   0.3389   0.2778
#> Detection Rate         0.3389   0.2722   0.2278
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9285   0.8302   0.8754
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
#>          1 53 11  0
#>          2  3 60  3
#>          3  0 12 38
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8389          
#>                  95% CI : (0.7769, 0.8894)
#>     No Information Rate : 0.4611          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7548          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9464   0.7229   0.9268
#> Specificity            0.9113   0.9381   0.9137
#> Pos Pred Value         0.8281   0.9091   0.7600
#> Neg Pred Value         0.9741   0.7982   0.9769
#> Prevalence             0.3111   0.4611   0.2278
#> Detection Rate         0.2944   0.3333   0.2111
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9289   0.8305   0.9202
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
#>          1 62  2  0
#>          2  7 55  4
#>          3  0 11 39
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7976          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8986   0.8088   0.9070
#> Specificity            0.9820   0.9018   0.9197
#> Pos Pred Value         0.9688   0.8333   0.7800
#> Neg Pred Value         0.9397   0.8860   0.9692
#> Prevalence             0.3833   0.3778   0.2389
#> Detection Rate         0.3444   0.3056   0.2167
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9403   0.8553   0.9133
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
#>          1 59  5  0
#>          2  6 44 16
#>          3  1  5 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.7252          
#>                                           
#>  Mcnemar's Test P-Value : 0.07674         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8939   0.8148   0.7333
#> Specificity            0.9561   0.8254   0.9500
#> Pos Pred Value         0.9219   0.6667   0.8800
#> Neg Pred Value         0.9397   0.9123   0.8769
#> Prevalence             0.3667   0.3000   0.3333
#> Detection Rate         0.3278   0.2444   0.2444
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9250   0.8201   0.8417
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
#>          1 57  7  0
#>          2  6 44 16
#>          3  1  5 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8056          
#>                  95% CI : (0.7401, 0.8607)
#>     No Information Rate : 0.3556          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.7084          
#>                                           
#>  Mcnemar's Test P-Value : 0.07722         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8906   0.7857   0.7333
#> Specificity            0.9397   0.8226   0.9500
#> Pos Pred Value         0.8906   0.6667   0.8800
#> Neg Pred Value         0.9397   0.8947   0.8769
#> Prevalence             0.3556   0.3111   0.3333
#> Detection Rate         0.3167   0.2444   0.2444
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9151   0.8041   0.8417
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
#>          1 55  9  0
#>          2  4 48 14
#>          3  0  6 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.35            
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7246          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9322   0.7619   0.7586
#> Specificity            0.9256   0.8462   0.9508
#> Pos Pred Value         0.8594   0.7273   0.8800
#> Neg Pred Value         0.9655   0.8684   0.8923
#> Prevalence             0.3278   0.3500   0.3222
#> Detection Rate         0.3056   0.2667   0.2444
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.9289   0.8040   0.8547
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>              1         2         3
#> [1,] 0.2976836 0.3359634 0.3663530
#> [2,] 0.3169548 0.3314227 0.3516225
#> [3,] 0.2938003 0.3374377 0.3687620
#> [4,] 0.2900517 0.3389213 0.3710270
#> [5,] 0.3342487 0.3217799 0.3439714
#> [6,] 0.3232457 0.3262905 0.3504638
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
#>          1 64  0  0
#>          2 22 44  0
#>          3  0 50  0
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.6             
#>                  95% CI : (0.5245, 0.6722)
#>     No Information Rate : 0.5222          
#>     P-Value [Acc > NIR] : 0.02165         
#>                                           
#>                   Kappa : 0.3737          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.7442   0.4681       NA
#> Specificity            1.0000   0.7442   0.7222
#> Pos Pred Value         1.0000   0.6667       NA
#> Neg Pred Value         0.8103   0.5614       NA
#> Prevalence             0.4778   0.5222   0.0000
#> Detection Rate         0.3556   0.2444   0.0000
#> Detection Prevalence   0.3556   0.3667   0.2778
#> Balanced Accuracy      0.8721   0.6061       NA
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999988 1.232397e-06 5.207023e-15
#> [2,] 0.9997229 2.770746e-04 2.259131e-11
#> [3,] 0.9999997 2.932041e-07 7.819028e-17
#> [4,] 1.0000000 2.006375e-09 9.135465e-21
#> [5,] 0.9974416 2.558361e-03 4.262871e-09
#> [6,] 0.9990408 9.592427e-04 5.079659e-10
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
#>          1  5 56  3
#>          2  0 60  6
#>          3  0 28 22
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.4833          
#>                  95% CI : (0.4084, 0.5589)
#>     No Information Rate : 0.8             
#>     P-Value [Acc > NIR] : 1               
#>                                           
#>                   Kappa : 0.2038          
#>                                           
#>  Mcnemar's Test P-Value : 8.655e-16       
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity           1.00000   0.4167   0.7097
#> Specificity           0.66286   0.8333   0.8121
#> Pos Pred Value        0.07812   0.9091   0.4400
#> Neg Pred Value        1.00000   0.2632   0.9308
#> Prevalence            0.02778   0.8000   0.1722
#> Detection Rate        0.02778   0.3333   0.1222
#> Detection Prevalence  0.35556   0.3667   0.2778
#> Balanced Accuracy     0.83143   0.6250   0.7609
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>              1            2            3
#> [1,] 0.9999988 1.232397e-06 5.207023e-15
#> [2,] 0.9997229 2.770746e-04 2.259131e-11
#> [3,] 0.9999997 2.932041e-07 7.819028e-17
#> [4,] 1.0000000 2.006375e-09 9.135465e-21
#> [5,] 0.9974416 2.558361e-03 4.262871e-09
#> [6,] 0.9990408 9.592427e-04 5.079659e-10
```
