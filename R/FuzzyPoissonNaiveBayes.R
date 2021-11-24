# --------------------------------------------------
#             Fuzzy Poisson Naive Bayes
#
# data: 08.11.2021
# version: 0.1
# author: ..., Ronei Moraes
# adaptado por: Jodavid Ferreira;
# e-mails: ...,jodavid@protonmail.com; ronei@de.ufpb.br
#
# --------------------------------------------------
# Necessary packages
# -------------------
# parallel: to makeCluster function
# doSNOW: to registerDoSnow function
# foreach: to `%dopar%` function
# MASS: to fitdistr
# -------------------

#' Fuzzy Poisson Naive Bayes
#'
#' \code{FuzzyPoissonNaiveBayes} Fuzzy Poisson Naive Bayes
#'
#'
#' @param train matrix or data frame of training set cases.
#' @param cl factor of true classifications of training set
#' @param cores  how many cores of the computer do you want to use (default = 2)
#' @param fuzzy boolean variable to use the membership function
#'
#' @return A vector of classifications
#'
#' @references
#' \insertRef{de2018fuzzy}{FuzzyClass}
#'
#' @examples
#'
#' set.seed(1) # determining a seed
#' data(iris)
#'
#' # Splitting into Training and Testing
#' split <- caTools::sample.split(t(iris[, 1]), SplitRatio = 0.7)
#' Train <- subset(iris, split == "TRUE")
#' Test <- subset(iris, split == "FALSE")
#' # ----------------
#' # matrix or data frame of test set cases.
#' # A vector will be interpreted as a row vector for a single case.
#' test <- Test[, -5]
#' fit_NBT <- FuzzyPoissonNaiveBayes(
#'   train = Train[, -5],
#'   cl = Train[, 5], cores = 2
#' )
#'
#' pred_NBT <- predict(fit_NBT, test)
#'
#' head(pred_NBT)
#' head(Test[, 5])
#' @importFrom stats dpois
#'
#' @export
FuzzyPoissonNaiveBayes <- function(train, cl, cores = 2, fuzzy = T) {
  UseMethod("FuzzyPoissonNaiveBayes")
}

#' @export
FuzzyPoissonNaiveBayes.default <- function(train, cl, cores = 2, fuzzy = T) {

  # --------------------------------------------------------
  # Estimating class parameters
  train <- data.frame(train)
  cols <- ncol(train) # Number of variables
  if(is.null(cols)){
    cols <- 1
  }
  dados <- train # training data matrix
  M <- c(unlist(cl)) # true classes
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Estimating Gamma Parameters
  parametersC <- lapply(1:length(unique(M)), function(i) {
    lapply(1:cols, function(j) {
      SubSet <- dados[M == unique(M)[i], j]
      param <- mean(SubSet, na.rm = TRUE)
      return(param)
    })
  })
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Admitindo que a distribuicao estatistica do vetor de dados, dadas as classes sejam Gamas,
  # pode-se usar a mesma estrutura de maxima verossimilhanca do Classificador Bayesiano.
  # Assim, temos que:
  #
  # ln p(wi\Xk) = ln (p(wi)) + SUM_k [ ln (mu_wi(Xk)) + Xk * ln(lambda_ki) - lambda_ki - ln (Xk !) ]
  #
  # Geracao das funcoes de pertinencias por histograma de frequencias:
  # - Calcular os valores maximo e minimo de cada dimensao
  # - Aplicar a forma de Sturges para gerar os intervalos
  #   Sturges = 1+ 3.3*log10(N)
  # - Encontrar as frequencias para cada combinacao dos dados
  # - Armazenar essas frequencias em uma matriz multimensional
  #
  # --------------------------------------------------------
  # Sturges
  Sturges <- lapply(1:length(unique(M)), function(i) {
    SubSet <- dados[M == unique(M)[i], ]
    return(round(sqrt(nrow(SubSet))))
  })

  # --------------------------------------------------------
  # Comprimento do Intervalo
  Comprim_Intervalo <- lapply(1:length(unique(M)), function(i) {
    SubSet <- dados[M == unique(M)[i], ]
    # (Min - Max) / Sturges -- Por variável
    comp <- (apply(SubSet, 2, max) - apply(SubSet, 2, min)) / Sturges[[i]]
  })
  # --------------------------------------------------------

  # --------------------------------------------------------
  Freq <- lapply(1:length(unique(M)), function(i) {
    ara <- array(0, dim = c(Sturges[[i]], cols))
    return(ara)
  })
  # ---------------
  minimos <- lapply(1:length(unique(M)), function(i) {
    sapply(1:cols, function(j) {
      SubSet <- dados[M == unique(M)[i], ]
      return(min(SubSet[, j]))
    })
  })
  # ---------------
  for (classe in 1:length(unique(M))) {
    # --
    SubSet <- dados[M == unique(M)[classe], ]
    # --
    for (coluna in 1:cols) { # coluna da classe
      for (linhaClasse in 1:nrow(SubSet)) { # linha da classe
        faixa <- minimos[[classe]][coluna] + Comprim_Intervalo[[classe]][coluna] # faixa de frequencia inicial
        for (linhaFreq in 1:Sturges[[classe]]) { # linha da Freq
          if (SubSet[linhaClasse, coluna] < faixa) { # ve se valor da classe pertence aaquela faixa
            Freq[[classe]][linhaFreq, coluna] <- Freq[[classe]][linhaFreq, coluna] + 1 # acumula valor na faixa de frequencia e interrompe este ultimo for
            break
          }
          if (linhaFreq == Sturges[[classe]] && SubSet[linhaClasse, coluna] >= faixa) {
            Freq[[classe]][linhaFreq, coluna] <- Freq[[classe]][linhaFreq, coluna] + 1
            break
          }
          faixa <- faixa + Comprim_Intervalo[[classe]][coluna] # troca de faixa -> proxima
        }
      }
    }
  }
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Cria a funcao de pertinencia para cada classe, a partir das frequencias relativas
  Pertinencia <- lapply(1:length(unique(M)), function(i) {
    Freq[[i]] / nrow(dados[M == unique(M)[i], ])
  })
  # ------
  # Probabilidade a priori das classes - consideradas iguais
  pk <- rep(1 / length(unique(M)), length(unique(M)))
  # -------------------------------------------------------


  # -------------------------------------------------------
  structure(list(
    parametersC = parametersC,
    minimos = minimos,
    cols = cols,
    M = M,
    cores = cores,
    Comprim_Intervalo = Comprim_Intervalo,
    Pertinencia = Pertinencia,
    Sturges = Sturges,
    pk = pk,
    fuzzy = fuzzy
  ),
  class = "FuzzyPoissonNaiveBayes"
  )
}
# -------------------------


#' @export
print.FuzzyPoissonNaiveBayes <- function(x, ...) {
  if (x$fuzzy == T) {
    # -----------------
    cat("\nFuzzy Poisson Naive Bayes Classifier for Discrete Predictors\n\n")
    # -----------------
  } else {
    # -----------------
    cat("\nNaive Poisson  Bayes Classifier for Discrete Predictors\n\n")
    # -----------------
  }
  cat("Class:\n")
  print(levels(x$M))
  # -----------------
}

#' @export
predict.FuzzyPoissonNaiveBayes <- function(object,
                                               newdata,
                                               type = "class",
                                               ...) {
  # --------------------------------------------------------
  # type <- match.arg("class")
  test <- as.data.frame(newdata)
  # --------------------------------------------------------
  parametersC <- object$parametersC
  minimos <- object$minimos
  cols <- object$cols
  M <- object$M
  cores <- object$cores
  Comprim_Intervalo <- object$Comprim_Intervalo
  Pertinencia <- object$Pertinencia
  Sturges <- object$Sturges
  pk <- object$pk
  fuzzy <- object$fuzzy
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Classification
  # --------------
  P <- lapply(1:length(unique(M)), function(i) {
    densidades <- sapply(1:cols, function(j) {
      stats::dpois(test[, j], lambda = parametersC[[i]][[j]][1])
    })
    densidades <- apply(densidades, 1, prod)
    # Calcula a P(w_i) * P(X_k | w_i)
    p <- pk[[i]] * densidades
    # ---
    return(p)
  })

  N_test <- nrow(test)
  # --------------
  # Defining how many CPU cores to use
  core <- parallel::makePSOCKcluster(cores)
  doParallel::registerDoParallel(core)
  # --------------
  # loop start
  R_M_obs <- foreach::foreach(h = 1:N_test, .combine = rbind) %dopar% {

    # ------------
    x <- test[h, ]
    # ------------
    ACHOU_t <- c()
    ACHOU <- 0

    if (fuzzy == T) {
      # ---------------
      for (classe in 1:length(unique(M))) {
        # --
        # --
        for (coluna in 1:cols) { # coluna da classe
          for (linhaF in 1:Sturges[[classe]]) { # linha da classe
            faixa <- minimos[[classe]][coluna] + Comprim_Intervalo[[classe]][coluna] # faixa de frequencia inicial
            if (x[coluna] < faixa) { # ve se valor da classe pertence aaquela faixa
              ACHOU[coluna] <- Pertinencia[[classe]][linhaF, coluna] # acumula valor na faixa de frequencia e interrompe este ultimo for
              break
            }
            if (linhaF == Sturges[[classe]]) {
              ACHOU[coluna] <- Pertinencia[[classe]][linhaF, coluna]
              break
            }
            faixa <- faixa + Comprim_Intervalo[[classe]][coluna] # troca de faixa -> proxima
          }
        }
        # ---
        ACHOU_t <- rbind(ACHOU_t, ACHOU) # Classes são as linhas
        # ---
      }
      # -----
      row.names(ACHOU_t) <- unique(M)
      # --------------------------------------------------------
      ACHOU_t <- apply(ACHOU_t, 1, prod)

      f <- sapply(1:length(unique(M)), function(i) {
        P[[i]][h] * ACHOU_t[i]
      })
    } else {
      f <- sapply(1:length(unique(M)), function(i) {
        P[[i]][h] #* ACHOU_t[i]
      })
    }
    # -------------------------------------------------------

    return(f)
  }
  # ------------
  # -------------------------
  parallel::stopCluster(core)
  # ---------
  if (type == "class") {
    # -------------------------
    R_M_obs <- sapply(1:nrow(R_M_obs), function(i) which.max(R_M_obs[i, ]))
    resultado <- unique(M)[R_M_obs]
    return(as.factor(c(resultado)))
    # -------------------------
  } else {
    # -------------------------
    Infpos <- which(R_M_obs==Inf)
    R_M_obs[Infpos] <- .Machine$integer.max;
    R_M_obs <- R_M_obs/rowSums(R_M_obs)
    # ----------
    colnames(R_M_obs) <- unique(M)
    return(R_M_obs)
    # -------------------------
  }
}
