
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 01-11-2021

#### Família de Classificadores utilizando Naive Bayes e Fuzzy Naive Bayes

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
#>          1 47  5  0
#>          2  9 43  9
#>          3  0 17 50
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7778          
#>                  95% CI : (0.7099, 0.8362)
#>     No Information Rate : 0.3611          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.6662          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8393   0.6615   0.8475
#> Specificity            0.9597   0.8435   0.8595
#> Pos Pred Value         0.9038   0.7049   0.7463
#> Neg Pred Value         0.9297   0.8151   0.9204
#> Prevalence             0.3111   0.3611   0.3278
#> Detection Rate         0.2611   0.2389   0.2778
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.8995   0.7525   0.8535
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
#>          1 49  2  1
#>          2  5 50  6
#>          3  0 14 53
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8444          
#>                  95% CI : (0.7831, 0.8941)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7661          
#>                                           
#>  Mcnemar's Test P-Value : 0.1395          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9074   0.7576   0.8833
#> Specificity            0.9762   0.9035   0.8833
#> Pos Pred Value         0.9423   0.8197   0.7910
#> Neg Pred Value         0.9609   0.8655   0.9381
#> Prevalence             0.3000   0.3667   0.3333
#> Detection Rate         0.2722   0.2778   0.2944
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.9418   0.8305   0.8833
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
#>          1 50  2  0
#>          2  5 50  6
#>          3  0 14 53
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.85            
#>                  95% CI : (0.7893, 0.8988)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7746          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9091   0.7576   0.8983
#> Specificity            0.9840   0.9035   0.8843
#> Pos Pred Value         0.9615   0.8197   0.7910
#> Neg Pred Value         0.9609   0.8655   0.9469
#> Prevalence             0.3056   0.3667   0.3278
#> Detection Rate         0.2778   0.2778   0.2944
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.9465   0.8305   0.8913
saida <- predict(fit_GNB, test, type = "matrix")
```

#### Fuzzy Naive Bayes Triangular

``` r
fit_FNBT <- FuzzyTriangNaiveBayes(train =  Train[,-4],
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
#>          1 41 11  0
#>          2  2 56  3
#>          3  0 18 49
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8111          
#>                  95% CI : (0.7462, 0.8655)
#>     No Information Rate : 0.4722          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7153          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9535   0.6588   0.9423
#> Specificity            0.9197   0.9474   0.8594
#> Pos Pred Value         0.7885   0.9180   0.7313
#> Neg Pred Value         0.9844   0.7563   0.9735
#> Prevalence             0.2389   0.4722   0.2889
#> Detection Rate         0.2278   0.3111   0.2722
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.9366   0.8031   0.9008
saida <- predict(fit_FNBT, test, type = "matrix")

# ----------------

fit_NBT <- FuzzyTriangNaiveBayes(train =  Train[,-4],
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
#>          1 49  3  0
#>          2  4 54  3
#>          3  0 16 51
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8556          
#>                  95% CI : (0.7956, 0.9034)
#>     No Information Rate : 0.4056          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7831          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9245   0.7397   0.9444
#> Specificity            0.9764   0.9346   0.8730
#> Pos Pred Value         0.9423   0.8852   0.7612
#> Neg Pred Value         0.9688   0.8403   0.9735
#> Prevalence             0.2944   0.4056   0.3000
#> Detection Rate         0.2722   0.3000   0.2833
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.9505   0.8372   0.9087
saida <- predict(fit_NBT, test, type = "matrix")
```

#### Fuzzy Naive Bayes Trapezoidal

``` r
fit_FNBT <- FuzzyTrapeNaiveBayes(train =  Train[,-4],
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
#>          1 40 12  0
#>          2  6 45 10
#>          3  2 10 55
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7778          
#>                  95% CI : (0.7099, 0.8362)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.6645          
#>                                           
#>  Mcnemar's Test P-Value : 0.2615          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8333   0.6716   0.8462
#> Specificity            0.9091   0.8584   0.8957
#> Pos Pred Value         0.7692   0.7377   0.8209
#> Neg Pred Value         0.9375   0.8151   0.9115
#> Prevalence             0.2667   0.3722   0.3611
#> Detection Rate         0.2222   0.2500   0.3056
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.8712   0.7650   0.8709
saida <- predict(fit_FNBT, test, type = "matrix")

# ----------------

fit_NBT <- FuzzyTrapeNaiveBayes(train =  Train[,-4],
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
#>          1 39 13  0
#>          2  6 44 11
#>          3  2  9 56
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7722          
#>                  95% CI : (0.7039, 0.8313)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.6558          
#>                                           
#>  Mcnemar's Test P-Value : 0.1887          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8298   0.6667   0.8358
#> Specificity            0.9023   0.8509   0.9027
#> Pos Pred Value         0.7500   0.7213   0.8358
#> Neg Pred Value         0.9375   0.8151   0.9027
#> Prevalence             0.2611   0.3667   0.3722
#> Detection Rate         0.2167   0.2444   0.3111
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.8660   0.7588   0.8692
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
#>          1 47  5  0
#>          2  3 47 11
#>          3  0  9 58
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8444          
#>                  95% CI : (0.7831, 0.8941)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7651          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9400   0.7705   0.8406
#> Specificity            0.9615   0.8824   0.9189
#> Pos Pred Value         0.9038   0.7705   0.8657
#> Neg Pred Value         0.9766   0.8824   0.9027
#> Prevalence             0.2778   0.3389   0.3833
#> Detection Rate         0.2611   0.2611   0.3222
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.9508   0.8264   0.8797
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>                  1         2         3
#> result.1 -2.692359 -3.047178 -3.326748
#> result.2 -3.052309 -3.218101 -3.353889
#> result.3 -2.960359 -3.107734 -3.340212
#> result.4 -2.947487 -3.090266 -3.334070
#> result.5 -3.266477 -3.122288 -3.341154
#> result.6 -3.118455 -3.130048 -3.345382
```

#### Fuzzy Gamma Naive Bayes Classifier

``` r
fit_NBT <- FGamNB(train =  Train[,-4],
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
#>          1 52  0  0
#>          2 27 34  0
#>          3  1 66  0
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.4778          
#>                  95% CI : (0.4029, 0.5534)
#>     No Information Rate : 0.5556          
#>     P-Value [Acc > NIR] : 0.9849          
#>                                           
#>                   Kappa : 0.2358          
#>                                           
#>  Mcnemar's Test P-Value : <2e-16          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.6500   0.3400       NA
#> Specificity            1.0000   0.6625   0.6278
#> Pos Pred Value         1.0000   0.5574       NA
#> Neg Pred Value         0.7812   0.4454       NA
#> Prevalence             0.4444   0.5556   0.0000
#> Detection Rate         0.2889   0.1889   0.0000
#> Detection Prevalence   0.2889   0.3389   0.3722
#> Balanced Accuracy      0.8250   0.5012       NA
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>                     1            2            3
#> result.1 2.213513e-09 1.584578e-15 9.009252e-26
#> result.2 6.190082e-10 9.848134e-14 2.250009e-22
#> result.3 7.905877e-09 2.788048e-13 9.416160e-23
#> result.4 2.483214e-09 9.358737e-14 2.031418e-22
#> result.5 2.952595e-10 2.411385e-13 6.533858e-20
#> result.6 1.823305e-09 4.365288e-12 3.197783e-20
```
