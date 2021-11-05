
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 05-11-2021

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
```

#### Fuzzy Gaussian Naive Bayes com parâmetros Fuzzy

``` r
# --------------------------------------------------
# Fuzzy Gaussian Naive Bayes com parâmetros Fuzzy

# Splitting into Training and Testing
split <- caTools::sample.split(t(VirtualRealityData[,1]), SplitRatio = 0.7)
Train <- subset(VirtualRealityData, split == "TRUE")
Test <- subset(VirtualRealityData, split == "FALSE")
# ----------------

test = Test[,-4]

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
#>          1 57  4  1
#>          2  9 41 10
#>          3  1 11 46
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.8            
#>                  95% CI : (0.734, 0.8558)
#>     No Information Rate : 0.3722         
#>     P-Value [Acc > NIR] : <2e-16         
#>                                          
#>                   Kappa : 0.6997         
#>                                          
#>  Mcnemar's Test P-Value : 0.5785         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8507   0.7321   0.8070
#> Specificity            0.9558   0.8468   0.9024
#> Pos Pred Value         0.9194   0.6833   0.7931
#> Neg Pred Value         0.9153   0.8750   0.9098
#> Prevalence             0.3722   0.3111   0.3167
#> Detection Rate         0.3167   0.2278   0.2556
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9032   0.7895   0.8547
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
#>          1 61  0  1
#>          2  5 46  9
#>          3  0 11 47
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8556          
#>                  95% CI : (0.7956, 0.9034)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7832          
#>                                           
#>  Mcnemar's Test P-Value : 0.1023          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9242   0.8070   0.8246
#> Specificity            0.9912   0.8862   0.9106
#> Pos Pred Value         0.9839   0.7667   0.8103
#> Neg Pred Value         0.9576   0.9083   0.9180
#> Prevalence             0.3667   0.3167   0.3167
#> Detection Rate         0.3389   0.2556   0.2611
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9577   0.8466   0.8676
saida <- predict(fit_FGNB, test, type = "matrix")

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
#>          1 62  0  0
#>          2  6 46  8
#>          3  0 11 47
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8611          
#>                  95% CI : (0.8018, 0.9081)
#>     No Information Rate : 0.3778          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7914          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9118   0.8070   0.8545
#> Specificity            1.0000   0.8862   0.9120
#> Pos Pred Value         1.0000   0.7667   0.8103
#> Neg Pred Value         0.9492   0.9083   0.9344
#> Prevalence             0.3778   0.3167   0.3056
#> Detection Rate         0.3444   0.2556   0.2611
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9559   0.8466   0.8833
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
#>          1 61  1  0
#>          2  5 50  5
#>          3  0 13 45
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7997          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9242   0.7812   0.9000
#> Specificity            0.9912   0.9138   0.9000
#> Pos Pred Value         0.9839   0.8333   0.7759
#> Neg Pred Value         0.9576   0.8833   0.9590
#> Prevalence             0.3667   0.3556   0.2778
#> Detection Rate         0.3389   0.2778   0.2500
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9577   0.8475   0.9000
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
#>          1 62  0  0
#>          2  5 50  5
#>          3  0 14 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7997          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9254   0.7812   0.8980
#> Specificity            1.0000   0.9138   0.8931
#> Pos Pred Value         1.0000   0.8333   0.7586
#> Neg Pred Value         0.9576   0.8833   0.9590
#> Prevalence             0.3722   0.3556   0.2722
#> Detection Rate         0.3444   0.2778   0.2444
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9627   0.8475   0.8955
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
#>          1 58  4  0
#>          2  3 49  8
#>          3  0 12 46
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.85            
#>                  95% CI : (0.7893, 0.8988)
#>     No Information Rate : 0.3611          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7749          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9508   0.7538   0.8519
#> Specificity            0.9664   0.9043   0.9048
#> Pos Pred Value         0.9355   0.8167   0.7931
#> Neg Pred Value         0.9746   0.8667   0.9344
#> Prevalence             0.3389   0.3611   0.3000
#> Detection Rate         0.3222   0.2722   0.2556
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9586   0.8291   0.8783
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
#>          2  2 49  9
#>          3  0 12 46
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8333          
#>                  95% CI : (0.7707, 0.8846)
#>     No Information Rate : 0.3778          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.75            
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9649   0.7206   0.8364
#> Specificity            0.9431   0.9018   0.9040
#> Pos Pred Value         0.8871   0.8167   0.7931
#> Neg Pred Value         0.9831   0.8417   0.9262
#> Prevalence             0.3167   0.3778   0.3056
#> Detection Rate         0.3056   0.2722   0.2556
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9540   0.8112   0.8702
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
#>          1 59  3  0
#>          2  5 45 10
#>          3  0 10 48
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8444          
#>                  95% CI : (0.7831, 0.8941)
#>     No Information Rate : 0.3556          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7665          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9219   0.7759   0.8276
#> Specificity            0.9741   0.8770   0.9180
#> Pos Pred Value         0.9516   0.7500   0.8276
#> Neg Pred Value         0.9576   0.8917   0.9180
#> Prevalence             0.3556   0.3222   0.3222
#> Detection Rate         0.3278   0.2500   0.2667
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.9480   0.8265   0.8728
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>                  1         2         3
#> result.1 -3.070606 -3.163347 -3.350327
#> result.2 -2.859784 -3.078579 -3.331659
#> result.3 -2.706656 -3.043789 -3.326055
#> result.4 -2.827007 -3.094829 -3.327058
#> result.5 -2.651204 -3.037289 -3.326225
#> result.6 -3.063400 -3.092308 -3.331840
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
#>          1 62  0  0
#>          2 30 30  0
#>          3  1 57  0
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.5111          
#>                  95% CI : (0.4357, 0.5862)
#>     No Information Rate : 0.5167          
#>     P-Value [Acc > NIR] : 0.5888          
#>                                           
#>                   Kappa : 0.2603          
#>                                           
#>  Mcnemar's Test P-Value : <2e-16          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.6667   0.3448       NA
#> Specificity            1.0000   0.6774   0.6778
#> Pos Pred Value         1.0000   0.5000       NA
#> Neg Pred Value         0.7373   0.5250       NA
#> Prevalence             0.5167   0.4833   0.0000
#> Detection Rate         0.3444   0.1667   0.0000
#> Detection Prevalence   0.3444   0.3333   0.3222
#> Balanced Accuracy      0.8333   0.5111       NA
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>                     1            2            3
#> result.1 1.132299e-08 3.581647e-12 1.378423e-22
#> result.2 4.406396e-09 3.020695e-13 6.335280e-24
#> result.3 1.181174e-09 7.374546e-15 5.311058e-26
#> result.4 2.289231e-09 7.885329e-19 1.646001e-36
#> result.5 1.390556e-09 1.024705e-15 7.987331e-28
#> result.6 2.878129e-10 2.345254e-13 6.595527e-22
```
