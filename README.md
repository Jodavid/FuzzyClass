
# NaiveBayesClassifiers <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version/sentimentBR)](https://cran.r-project.org/package=sentimentBR)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/grand-total/sentimentBR)](https://cran.r-project.org/package=sentimentBR)
<!-- badges: end -->

Última Atualização: 17-10-2021

#### Família de Classificadores utilizando Naive Bayes e Fuzzy Naive Bayes

## Resumo:

Um dos classificadores, foi uma nova abordagem do algoritmo **Naive
Bayes** que junto com meu orientador [**Ronei
Moraes**](mailto:ronei@de.ufpb.br) propusemos no meu TCC de graduação em
Estatística defendido no fim de 2014 na UFPB ([link para a documento do
TCC intitulado como *‘Sistema de avaliação de treinamento baseado em
realidade virtual usando rede de probabilidade fuzzy fundamentada na
distribuição Normal
Fuzzy.’*](http://www.de.ufpb.br/graduacao/tcc/TCC2014p2Jodavid.pdf)), e
publicado em periódico esse ano (2021) com o título [*‘A New Bayesian
Network Based on Gaussian Naive Bayes with Fuzzy Parameters for Training
Assessment in Virtual
Simulators’*](https://link.springer.com/article/10.1007/s40815-020-00936-4)
(publicado na [International Journal of Fuzzy
Systems](https://www.springer.com/journal/40815)).

## Instalação do pacote:

``` r
# Instalando
install.packages("devtools")
devtools::install_github("Jodavid/NaiveBayesClassifiers")

# Chamando o pacote
library(NaiveBayesClassifiers)
```

## Utilização:

### Exemplo 1:

``` r
library(NaiveBayesClassifiers)
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


# --------------------------------------------------
# FuzzyGaussianNaiveBayes com parâmetros Fuzzy

# Splitting into Training and Testing
split <- caTools::sample.split(t(VirtualRealityData[,1]), SplitRatio = 0.7)
Train <- subset(VirtualRealityData, split == "TRUE")
Test <- subset(VirtualRealityData, split == "FALSE")
# ----------------

test = Test[,-4]

fit_FGNB <- FuzzyGaussianNaiveBayes(train =  Train[,-4],
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
#>          1 59  5  1
#>          2  8 42 13
#>          3  0 14 38
#> 
#> Overall Statistics
#>                                           
#>                Accuracy : 0.7722          
#>                  95% CI : (0.7039, 0.8313)
#>     No Information Rate : 0.3722          
#>     P-Value [Acc > NIR] : <2e-16          
#>                                           
#>                   Kappa : 0.6567          
#>                                           
#>  Mcnemar's Test P-Value : 0.6304          
#> 
#> Statistics by Class:
#> 
#>                      Class: 1 Class: 2 Class: 3
#> Sensitivity            0.8806   0.6885   0.7308
#> Specificity            0.9469   0.8235   0.8906
#> Pos Pred Value         0.9077   0.6667   0.7308
#> Neg Pred Value         0.9304   0.8376   0.8906
#> Prevalence             0.3722   0.3389   0.2889
#> Detection Rate         0.3278   0.2333   0.2111
#> Detection Prevalence   0.3611   0.3500   0.2889
#> Balanced Accuracy      0.9137   0.7560   0.8107
saida <- predict(fit_FGNB, test, type = "matrix")
```
