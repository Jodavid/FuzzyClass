# --------------------------------------------------
#             Fuzzy Gaussian Naive Bayes
#                       Zadeh
#
# data: 18.09.2021
# version: 0.1
# author: Jodavid Ferreira; Ronei Moraes
# e-mails: jodavid@protonmail.com; ronei@de.ufpb.br
#
# --------------------------------------------------
# Necessary packages
# -------------------
# parallel: to makeCluster function
# doSNOW: to registerDoSnow function
# foreach: to `%dopar%` function
# -------------------

# -----------------------------------------------
#      Fuzzy Gaussian Naive Bayes Classifier
# -----------------------------------------------

#' Fuzzy Gaussian Naive Bayes Classifier
#'
#' \code{FuzzyGaussianNaiveBayesZadeh} Fuzzy Gaussian Naive Bayes Classifier Zadeh-based
#'
#'
#' @param train matrix or data frame of training set cases.
#' @param cl factor of true classifications of training set
#' @param metd Method of transforming the triangle into scalar, It is the type of data entry for the test sample, use metd 1 if you want to use the Baricentro technique and use metd 2 if you want to use the Q technique of the uniformity test (article: Directional Statistics and Shape analysis).
#' @param cores  how many cores of the computer do you want to use (default = 2)
#'
#' @return A vector of classifications
#'
#' @references
#' \insertRef{marcos2012online}{FuzzyNaiveBayes}
#'
#' @examples
#'
#' set.seed(1) # determining a seed
#' data(iris)
#'
#' # Splitting into Training and Testing
#' split <- caTools::sample.split(t(iris[,1]), SplitRatio = 0.7)
#' Train <- subset(iris, split == "TRUE")
#' Test <- subset(iris, split == "FALSE")
#' # ----------------
#' # matrix or data frame of test set cases.
#' # A vector will be interpreted as a row vector for a single case.
#' test = Test[,-5]
#' fit_FGNB <- FuzzyGaussianNaiveBayesZadeh(train =  Train[,-5],
#'                                     cl = Train[,5], metd = 1, cores = 2)
#'
#' pred_FGNB <- predict(fit_FGNB, test)
#'
#' head(pred_FGNB)
#' head(Test[,5])
#'
#' @importFrom stats cov dnorm qchisq qnorm
#' @importFrom foreach '%dopar%'
#' @importFrom Rdpack reprompt
#'
#' @export
FuzzyGaussianNaiveBayesZadeh <- function( train, cl, metd = 1, cores = 2)
  UseMethod("FuzzyGaussianNaiveBayesZadeh")

#' @export
FuzzyGaussianNaiveBayesZadeh.default <- function( train, cl, metd = 1, cores = 2){

  # --------------------------------------------------------
  # Estimating class parameters
  cols <- ncol(train) # Number of variables
  dados <- train; # training data matrix
  M <- cl; # true classes
  # -------------------------------
  N <- nrow(dados) # Number of observations
  # -------------------------------
  # --------------------------------------------------------
  # RETIRADO DO CODIGO DO MATLAB
  # -----------------------------
  # % Admitindo que a distribuicao estatistica do vetor de dados, dadas as classes sejam normais,
  # % pode-se usar a mesma estrutura de maxima verossimilhanca do Classificador Bayesiano.
  # % Assim, temos que:
  #   % ln p(k\X) = ln (mu_k(X)) + ln (p_k(X)) - 0.5*ln(det(covariancia_k)) - 0.5*(X-media(X))*inversa_covar_k*(X(1:d,j)-media(1:d,1))
  # %
  # % Geracao das funcoes de pertinencias por histograma de frequencias:
  #   % - Calcular os valores maximo e minimo de cada dimensao
  # % - Aplicar a forma de Sturges para gerar os intervalos
  # %   Sturges = 1+ 3.3*log10(N)
  # % - Encontrar as frequencias para cada combinacao dos dados
  # % - Armazenar essas frequencias em uma matriz multimensional
  # -----------------------------
  class <- length(unique(M))
  names_class <- unique(M)
  sizes <- table(factor(M))#sapply(1:class, function(x) sum(M==x)) # Quantas observações em cada classe
  Sturges <- round(1+ 3.3*log10(sizes)) # Sturges
  # -----------------------------
  # Minimo de cada classe para cada variável
  # Linhas classes, colunas variáveis
  minimo <- lapply(1:class, function(j){
    sapply(1:cols, function(i){
      min(dados[M==names_class[j],i])
    })
  })
  # -----------------------------
  # Máximo de cada classe para cada variável
  # Linhas classes, colunas variáveis
  maximo <- lapply(1:class, function(j){
    sapply(1:cols, function(i){
      max(dados[M==names_class[j],i])
    })
  })
  # -----------------------------
  AT_classe <- lapply(1:class, function(i) maximo[[i]]-minimo[[i]])
  # -----------------------------
  Comprim_Intervalo = lapply(1:class, function(i) AT_classe[[i]]/Sturges[i])
  # --------------------------------------------------------
  # Lista dentro Lista, dimensões
  Freq <- lapply(1:class, function(i){

    array(0,dim = Sturges)

  })
  # ----------------------

  # Loop nos dados por classe [CRIAR]

  Pertinencias <- lapply(1:length(unique(M)), function(i){

    dados2 <- dados[M==names_class[i],]
    # laco nas observações de cada grupo
    for(t in 1:nrow(dados2)){
      x <- dados2[t,] # Observacao

      saida <- floor((x-minimo[[i]])/Comprim_Intervalo[[i]]) + 1
      # ---
      aux <- (saida > Sturges[i])
      aux <- which(aux==T)
      if(length(aux)>0) saida[aux] <- saida[aux]-1
      # ---
      # Encontrando posição de aumentar uma frequencia
      res <- 0;
      tamanho_saida <- length(saida)
      if(tamanho_saida > 1 ){
        for(j in tamanho_saida:2) res <- res + (saida[j]-1)*(Sturges[i]^(j-1))
      }
      res <- res + saida[1]
      # ---
      # ---
      Freq[[i]][as.numeric(res)] = Freq[[i]][as.numeric(res)] +1
      # ---
      Freq[[i]][is.na(Freq[[i]])] <- 0
    }
    # Fim do for


    Pertinencia <- Freq[[i]]/sizes[i]

    return(Pertinencia)

  })
  # --------------------------------------------------------
  # Finding Mu and Sigma for each class
  medias <- lapply(1:length(unique(M)), function(i) colMeans( subset( dados, M == unique(M)[i] ) ) )
  varian <- lapply(1:length(unique(M)), function(i) diag( diag( cov( subset( dados, M==unique(M)[i] ) ) ), (cols), (cols) ) )
  # --------------------------------------------------------
  # Probabilidade a priori das classes - consideradas iguais
  pk <- rep(1/class,class)
  # -----------------------
  logaritmo <-  log(pk);
  log_determinante <- lapply(1:length(unique(M)), function(i) 0.5*log(det(varian[[i]])))
  inversa_covar <- lapply(1:length(unique(M)), function(i) MASS::ginv(varian[[i]]))
  # -----------------------

 # -------------------------------------------------------
  structure(list( minimo = minimo,
                  maximo = maximo,
                  Comprim_Intervalo = Comprim_Intervalo,
                  Sturges = Sturges,
                  Pertinencias = Pertinencias,
                  log_determinante = log_determinante,
                  logaritmo = logaritmo,
                  inversa_covar = inversa_covar,
                   medias = medias,
                   cols = cols,
                   M = M,
                   metd = metd,
                   cores = cores
                 ),
            class = "FuzzyGaussianNaiveBayesZadeh")

}
# -------------------------


#' @export
print.FuzzyGaussianNaiveBayesZadeh <- function(x, ...){
  # -----------------
  cat("\nFuzzy Gaussian Naive Bayes Classifier for Discrete Predictors Zadeh-based\n\n")
  # -----------------
  cat("Variables:\n")
  print(names(x$medias[[1]]))
  cat("Class:\n")
  print(levels(x$M))
  # -----------------
}

#' @export
predict.FuzzyGaussianNaiveBayesZadeh <- function(object,
                                            newdata,
                                            ...){
  # --------------------------------------------------------
  #type <- match.arg("class")
  test <- as.data.frame(newdata)
  # --------------------------------------------------------
  minimo = object$minimo
  maximo = object$maximo
  Comprim_Intervalo = object$Comprim_Intervalo
  Sturges = object$Sturges
  log_determinante = object$log_determinante
  logaritmo = object$logaritmo
  Pertinencias = object$Pertinencias
  inversa_covar = object$inversa_covar
  medias = object$medias
  cols = object$cols
  M = object$M
  metd = object$metd
  cores = object$cores
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Calculation of triangles for each test observation
  # sum of Logs and calculation of Barycenter
  # --------------
  N_test <- nrow(test)
  # --------------
  # Defining how many CPU cores to use
  core <- parallel::makeCluster(cores)
  doSNOW::registerDoSNOW(core)
  # --------------
  # loop start
  R_M_obs <- foreach::foreach(h=1:N_test,.combine = rbind) %dopar% {
    # ------------
    x <- test[h,]
    # ------------
    R_M <- lapply(1:length(unique(M)), function(i){

      saida <- abs( floor((x - minimo[[i]])/Comprim_Intervalo[[i]]) + 1)
      # ---
      aux1 <- x < minimo[[i]]
      aux2 <- x > maximo[[i]]
      # ---
      log_Pertinencia = ifelse((T %in% aux1) | (T %in% aux2), -50, 0 )
      # ---
      # ---
      # Encontrando posição de aumentar uma frequencia
      res <- 0;
      tamanho_saida <- length(saida)
      if(tamanho_saida > 1 ){
        for(j in tamanho_saida:2) res <- res + (saida[j]-1)*(Sturges[i]^(j-1))
      }
      res <- abs(res + saida[1])
      # ---
      # ---
      if(log_Pertinencia == -50){
        pert <- ifelse(is.na(Pertinencias[[i]][as.numeric(res)])==T, 0,  Pertinencias[[i]][as.numeric(res)] )
        log_Pertinencia = ifelse(pert <= 0, -50, log(Pertinencias[[i]][as.numeric(res)]) )
      }

      f <- log_Pertinencia + logaritmo[i] - log_determinante[[i]] - 0.5*as.numeric(x - medias[[i]] )%*%inversa_covar[[i]]%*%as.numeric(x - medias[[i]] )

      return(f)
    })
    # --------------------------------------------------------
    R_M_class <- which.max(R_M)
    # -------------------------
    return(R_M_class)
  }

  # -------------------------
  parallel::stopCluster(core)
  # -------------------------
  resultado <- unique(M)[R_M_obs]
  # ---------
  return(as.factor(c(resultado)))

}
