
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 08-11-2021

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
#>          1 52  8  1
#>          2  9 33  8
#>          3  1 16 52
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.7611         
#>                  95% CI : (0.692, 0.8214)
#>     No Information Rate : 0.3444         
#>     P-Value [Acc > NIR] : <2e-16         
#>                                          
#>                   Kappa : 0.641          
#>                                          
#>  Mcnemar's Test P-Value : 0.4359         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8387   0.5789   0.8525
#> Specificity            0.9237   0.8618   0.8571
#> Pos Pred Value         0.8525   0.6600   0.7536
#> Neg Pred Value         0.9160   0.8154   0.9189
#> Prevalence             0.3444   0.3167   0.3389
#> Detection Rate         0.2889   0.1833   0.2889
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.8812   0.7204   0.8548
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
#>          1 57  4  0
#>          2  4 39  7
#>          3  0  9 60
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7987          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9344   0.7500   0.8955
#> Specificity            0.9664   0.9141   0.9204
#> Pos Pred Value         0.9344   0.7800   0.8696
#> Neg Pred Value         0.9664   0.9000   0.9369
#> Prevalence             0.3389   0.2889   0.3722
#> Detection Rate         0.3167   0.2167   0.3333
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9504   0.8320   0.9079
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
#>          1 57  4  0
#>          2  5 38  7
#>          3  0 10 59
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8556          
#>                  95% CI : (0.7956, 0.9034)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.782           
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9194   0.7308   0.8939
#> Specificity            0.9661   0.9062   0.9123
#> Pos Pred Value         0.9344   0.7600   0.8551
#> Neg Pred Value         0.9580   0.8923   0.9369
#> Prevalence             0.3444   0.2889   0.3667
#> Detection Rate         0.3167   0.2111   0.3278
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9427   0.8185   0.9031
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
#>          1 54  7  0
#>          2  2 25 23
#>          3  0  1 68
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.5056          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7179          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9643   0.7576   0.7473
#> Specificity            0.9435   0.8299   0.9888
#> Pos Pred Value         0.8852   0.5000   0.9855
#> Neg Pred Value         0.9832   0.9385   0.7928
#> Prevalence             0.3111   0.1833   0.5056
#> Detection Rate         0.3000   0.1389   0.3778
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9539   0.7938   0.8680
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
#>          1 57  4  0
#>          2  4 42  4
#>          3  0 12 57
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8667          
#>                  95% CI : (0.8081, 0.9127)
#>     No Information Rate : 0.3389          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7997          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9344   0.7241   0.9344
#> Specificity            0.9664   0.9344   0.8992
#> Pos Pred Value         0.9344   0.8400   0.8261
#> Neg Pred Value         0.9664   0.8769   0.9640
#> Prevalence             0.3389   0.3222   0.3389
#> Detection Rate         0.3167   0.2333   0.3167
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9504   0.8293   0.9168
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
#>          1 53  8  0
#>          2  3 37 10
#>          3  2  8 59
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7399          
#>                                           
#>  Mcnemar's Test P-Value : 0.2127          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9138   0.6981   0.8551
#> Specificity            0.9344   0.8976   0.9099
#> Pos Pred Value         0.8689   0.7400   0.8551
#> Neg Pred Value         0.9580   0.8769   0.9099
#> Prevalence             0.3222   0.2944   0.3833
#> Detection Rate         0.2944   0.2056   0.3278
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9241   0.7979   0.8825
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
#>          1 53  8  0
#>          2  3 32 15
#>          3  2  8 59
#> 
#> Overall Statistics
#>                                          
#>                Accuracy : 0.8            
#>                  95% CI : (0.734, 0.8558)
#>     No Information Rate : 0.4111         
#>     P-Value [Acc > NIR] : < 2e-16        
#>                                          
#>                   Kappa : 0.6966         
#>                                          
#>  Mcnemar's Test P-Value : 0.09356        
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9138   0.6667   0.7973
#> Specificity            0.9344   0.8636   0.9057
#> Pos Pred Value         0.8689   0.6400   0.8551
#> Neg Pred Value         0.9580   0.8769   0.8649
#> Prevalence             0.3222   0.2667   0.4111
#> Detection Rate         0.2944   0.1778   0.3278
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9241   0.7652   0.8515
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
#>          1 52  9  0
#>          2  4 39  7
#>          3  0  8 61
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8444          
#>                  95% CI : (0.7831, 0.8941)
#>     No Information Rate : 0.3778          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7655          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9286   0.6964   0.8971
#> Specificity            0.9274   0.9113   0.9286
#> Pos Pred Value         0.8525   0.7800   0.8841
#> Neg Pred Value         0.9664   0.8692   0.9369
#> Prevalence             0.3111   0.3111   0.3778
#> Detection Rate         0.2889   0.2167   0.3389
#> Detection Prevalence   0.3389   0.2778   0.3833
#> Balanced Accuracy      0.9280   0.8039   0.9128
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>                  1         2         3
#> result.1 -3.070158 -3.170582 -3.341755
#> result.2 -3.062776 -3.274319 -3.404448
#> result.3 -2.582074 -3.037449 -3.315749
#> result.4 -2.967027 -3.109698 -3.330948
#> result.5 -2.947663 -3.092281 -3.324113
#> result.6 -3.117808 -3.125445 -3.334274
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
#>          1 61  0  0
#>          2 22 28  0
#>          3  1 65  3
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.5111          
#>                  95% CI : (0.4357, 0.5862)
#>     No Information Rate : 0.5167          
#>     P-Value [Acc > NIR] : 0.5888          
#>                                           
#>                   Kappa : 0.2935          
#>                                           
#>  Mcnemar's Test P-Value : <2e-16          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.7262   0.3011  1.00000
#> Specificity            1.0000   0.7471  0.62712
#> Pos Pred Value         1.0000   0.5600  0.04348
#> Neg Pred Value         0.8067   0.5000  1.00000
#> Prevalence             0.4667   0.5167  0.01667
#> Detection Rate         0.3389   0.1556  0.01667
#> Detection Prevalence   0.3389   0.2778  0.38333
#> Balanced Accuracy      0.8631   0.5241  0.81356
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>                     1            2            3
#> result.1 5.523584e-09 6.534319e-14 6.807468e-21
#> result.2 2.325655e-09 1.137082e-14 2.202915e-22
#> result.3 2.463579e-09 4.906552e-20 1.848882e-30
#> result.4 4.607821e-09 1.979129e-14 1.706810e-21
#> result.5 1.052613e-09 6.400612e-15 2.334398e-21
#> result.6 7.892581e-10 6.726475e-14 2.351434e-19
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
#>          1  1 19 41
#>          2  1 13 36
#>          3  1 11 57
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.3944          
#>                  95% CI : (0.3225, 0.4699)
#>     No Information Rate : 0.7444          
#>     P-Value [Acc > NIR] : 1               
#>                                           
#>                   Kappa : 0.0577          
#>                                           
#>  Mcnemar's Test P-Value : 1.398e-14       
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity          0.333333  0.30233   0.4254
#> Specificity          0.661017  0.72993   0.7391
#> Pos Pred Value       0.016393  0.26000   0.8261
#> Neg Pred Value       0.983193  0.76923   0.3063
#> Prevalence           0.016667  0.23889   0.7444
#> Detection Rate       0.005556  0.07222   0.3167
#> Detection Prevalence 0.338889  0.27778   0.3833
#> Balanced Accuracy    0.497175  0.51613   0.5823
saida <- predict(fit_NBT, test, type = "matrix")
head(saida)
#>                     1            2            3
#> result.1 5.523584e-09 6.534319e-14 6.807468e-21
#> result.2 2.325655e-09 1.137082e-14 2.202915e-22
#> result.3 2.463579e-09 4.906552e-20 1.848882e-30
#> result.4 4.607821e-09 1.979129e-14 1.706810e-21
#> result.5 1.052613e-09 6.400612e-15 2.334398e-21
#> result.6 7.892581e-10 6.726475e-14 2.351434e-19
```
