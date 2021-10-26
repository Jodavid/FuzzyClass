
# FuzzyClass <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/FuzzyClass)](https://cran.r-project.org/package=sFuzzyClass)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/FuzzyClass)](https://cran.r-project.org/package=FuzzyClass)
<!-- badges: end -->

Última Atualização: 25-10-2021

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
#>          1 66  7  0
#>          2  6 38  8
#>          3  0 12 43
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.4             
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7221          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9167   0.6667   0.8431
#> Specificity            0.9352   0.8862   0.9070
#> Pos Pred Value         0.9041   0.7308   0.7818
#> Neg Pred Value         0.9439   0.8516   0.9360
#> Prevalence             0.4000   0.3167   0.2833
#> Detection Rate         0.3667   0.2111   0.2389
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9259   0.7764   0.8751
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
#>          1 69  4  0
#>          2  8 39  5
#>          3  0 14 41
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8278          
#>                  95% CI : (0.7645, 0.8799)
#>     No Information Rate : 0.4278          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7378          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8961   0.6842   0.8913
#> Specificity            0.9612   0.8943   0.8955
#> Pos Pred Value         0.9452   0.7500   0.7455
#> Neg Pred Value         0.9252   0.8594   0.9600
#> Prevalence             0.4278   0.3167   0.2556
#> Detection Rate         0.3833   0.2167   0.2278
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9286   0.7893   0.8934
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
#>          1 68  5  0
#>          2  8 40  4
#>          3  0 13 42
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8333          
#>                  95% CI : (0.7707, 0.8846)
#>     No Information Rate : 0.4222          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7466          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8947   0.6897   0.9130
#> Specificity            0.9519   0.9016   0.9030
#> Pos Pred Value         0.9315   0.7692   0.7636
#> Neg Pred Value         0.9252   0.8594   0.9680
#> Prevalence             0.4222   0.3222   0.2556
#> Detection Rate         0.3778   0.2222   0.2333
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9233   0.7956   0.9080
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
#>          1 66  7  0
#>          2  3 49  0
#>          3  0 23 32
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8167          
#>                  95% CI : (0.7523, 0.8703)
#>     No Information Rate : 0.4389          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.7237          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9565   0.6203   1.0000
#> Specificity            0.9369   0.9703   0.8446
#> Pos Pred Value         0.9041   0.9423   0.5818
#> Neg Pred Value         0.9720   0.7656   1.0000
#> Prevalence             0.3833   0.4389   0.1778
#> Detection Rate         0.3667   0.2722   0.1778
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9467   0.7953   0.9223
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
#>          1 70  3  0
#>          2  7 44  1
#>          3  0 12 43
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8722          
#>                  95% CI : (0.8145, 0.9172)
#>     No Information Rate : 0.4278          
#>     P-Value [Acc > NIR] : < 2.2e-16       
#>                                           
#>                   Kappa : 0.8056          
#>                                           
#>  Mcnemar's Test P-Value : NA              
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9091   0.7458   0.9773
#> Specificity            0.9709   0.9339   0.9118
#> Pos Pred Value         0.9589   0.8462   0.7818
#> Neg Pred Value         0.9346   0.8828   0.9920
#> Prevalence             0.4278   0.3278   0.2444
#> Detection Rate         0.3889   0.2444   0.2389
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9400   0.8398   0.9445
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
#>          1 63 10  0
#>          2  5 42  5
#>          3  2 10 43
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8222          
#>                  95% CI : (0.7584, 0.8751)
#>     No Information Rate : 0.3889          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7312          
#>                                           
#>  Mcnemar's Test P-Value : 0.149           
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.9000   0.6774   0.8958
#> Specificity            0.9091   0.9153   0.9091
#> Pos Pred Value         0.8630   0.8077   0.7818
#> Neg Pred Value         0.9346   0.8437   0.9600
#> Prevalence             0.3889   0.3444   0.2667
#> Detection Rate         0.3500   0.2333   0.2389
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.9045   0.7963   0.9025
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
#>          1 62 11  0
#>          2  5 42  5
#>          3  2  9 44
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.8222          
#>                  95% CI : (0.7584, 0.8751)
#>     No Information Rate : 0.3833          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.7314          
#>                                           
#>  Mcnemar's Test P-Value : 0.1452          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8986   0.6774   0.8980
#> Specificity            0.9009   0.9153   0.9160
#> Pos Pred Value         0.8493   0.8077   0.8000
#> Neg Pred Value         0.9346   0.8437   0.9600
#> Prevalence             0.3833   0.3444   0.2722
#> Detection Rate         0.3444   0.2333   0.2444
#> Detection Prevalence   0.4056   0.2889   0.3056
#> Balanced Accuracy      0.8997   0.7963   0.9070
saida <- predict(fit_NBT, test, type = "matrix")
```
