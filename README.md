
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 26-10-2021

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
#>          1 44  7  0
#>          2 10 41 12
#>          3  3 13 50
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.75            
#>                  95% CI : (0.6801, 0.8114)
#>     No Information Rate : 0.3444          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.6243          
#>                                           
#>  Mcnemar's Test P-Value : 0.3119          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.7719   0.6721   0.8065
#> Specificity            0.9431   0.8151   0.8644
#> Pos Pred Value         0.8627   0.6508   0.7576
#> Neg Pred Value         0.8992   0.8291   0.8947
#> Prevalence             0.3167   0.3389   0.3444
#> Detection Rate         0.2444   0.2278   0.2778
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.8575   0.7436   0.8354
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
#>          1 49  2  0
#>          2  6 48  9
#>          3  0  8 58
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8611          
#>                  95% CI : (0.8018, 0.9081)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7909          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8909   0.8276   0.8657
#> Specificity            0.9840   0.8770   0.9292
#> Pos Pred Value         0.9608   0.7619   0.8788
#> Neg Pred Value         0.9535   0.9145   0.9211
#> Prevalence             0.3056   0.3222   0.3722
#> Detection Rate         0.2722   0.2667   0.3222
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.9375   0.8523   0.8974
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
#>          1 48  3  0
#>          2  7 48  8
#>          3  0  8 58
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8556          
#>                  95% CI : (0.7956, 0.9034)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7825          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8727   0.8136   0.8788
#> Specificity            0.9760   0.8760   0.9298
#> Pos Pred Value         0.9412   0.7619   0.8788
#> Neg Pred Value         0.9457   0.9060   0.9298
#> Prevalence             0.3056   0.3278   0.3667
#> Detection Rate         0.2667   0.2667   0.3222
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.9244   0.8448   0.9043
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
#>          1 48  3  0
#>          2  5 46 12
#>          3  5  6 55
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.7411          
#>                                           
#>  Mcnemar's Test P-Value : 0.05756         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8276   0.8364   0.8209
#> Specificity            0.9754   0.8640   0.9027
#> Pos Pred Value         0.9412   0.7302   0.8333
#> Neg Pred Value         0.9225   0.9231   0.8947
#> Prevalence             0.3222   0.3056   0.3722
#> Detection Rate         0.2667   0.2556   0.3056
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.9015   0.8502   0.8618
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
#>          1 48  3  0
#>          2  5 52  6
#>          3  5  7 54
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8556          
#>                  95% CI : (0.7956, 0.9034)
#>     No Information Rate : 0.3444          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7831          
#>                                           
#>  Mcnemar's Test P-Value : 0.1341          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8276   0.8387   0.9000
#> Specificity            0.9754   0.9068   0.9000
#> Pos Pred Value         0.9412   0.8254   0.8182
#> Neg Pred Value         0.9225   0.9145   0.9474
#> Prevalence             0.3222   0.3444   0.3333
#> Detection Rate         0.2667   0.2889   0.3000
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.9015   0.8727   0.9000
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
#>          1 43  8  0
#>          2  5 48 10
#>          3  4  6 56
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.3667          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7235          
#>                                           
#>  Mcnemar's Test P-Value : 0.1276          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8269   0.7742   0.8485
#> Specificity            0.9375   0.8729   0.9123
#> Pos Pred Value         0.8431   0.7619   0.8485
#> Neg Pred Value         0.9302   0.8803   0.9123
#> Prevalence             0.2889   0.3444   0.3667
#> Detection Rate         0.2389   0.2667   0.3111
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.8822   0.8235   0.8804
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
#>          1 41 10  0
#>          2  5 43 15
#>          3  4  6 56
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7778          
#>                  95% CI : (0.7099, 0.8362)
#>     No Information Rate : 0.3944          
#>     P-Value [Acc > NIR] : < 2e-16         
#>                                           
#>                   Kappa : 0.6643          
#>                                           
#>  Mcnemar's Test P-Value : 0.02308         
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8200   0.7288   0.7887
#> Specificity            0.9231   0.8347   0.9083
#> Pos Pred Value         0.8039   0.6825   0.8485
#> Neg Pred Value         0.9302   0.8632   0.8684
#> Prevalence             0.2778   0.3278   0.3944
#> Detection Rate         0.2278   0.2389   0.3111
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.8715   0.7818   0.8485
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
#>          1 41 10  0
#>          2  4 47 12
#>          3  0  5 61
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.4056          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.739           
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9111   0.7581   0.8356
#> Specificity            0.9259   0.8644   0.9533
#> Pos Pred Value         0.8039   0.7460   0.9242
#> Neg Pred Value         0.9690   0.8718   0.8947
#> Prevalence             0.2500   0.3444   0.4056
#> Detection Rate         0.2278   0.2611   0.3389
#> Detection Prevalence   0.2833   0.3500   0.3667
#> Balanced Accuracy      0.9185   0.8112   0.8944
saida <- predict(fit_FENB, test, type = "matrix")
head(saida)
#>                  1         2         3
#> result.1 -2.671542 -3.038441 -3.310101
#> result.2 -3.056237 -3.234012 -3.352569
#> result.3 -2.949310 -3.090004 -3.319175
#> result.4 -3.275632 -3.121498 -3.327061
#> result.5 -2.802769 -3.071225 -3.314861
#> result.6 -2.647904 -3.043645 -3.309953
```
