# --------------------------------------------------
#             Fuzzy Naive Bayes Triangular
#
# data: 12.10.2021
# version: 0.1
# author: ..., Ronei Moraes
# adaptado por: Jodavid Ferreira;
# e-mails: ...,jodavid@protonmail.com; ronei@de.ufpb.br
#
# --------------------------------------------------

getParametersTriangular <- function(sample){

  # --------------------------------------------------
  # Estimativa dos parametros a partir do método dado em Werner's Blog
  # https://wernerantweiler.ca/blog.php?item=2019-06-05
  # Verificar uma alternativa mais confiavel e melhor citada na literatura
  # --------------------------------------------------
  qc <- sapply(1:ncol(sample), function(i) stats::quantile(sample[,i],probs = c(0.0625, 0.25, 0.75, 0.9375)))
  uc <- (qc[2,]- qc[1,])^2;
  vc <- (qc[4,]- qc[3,])^2;
  ac <- 2*qc[1,] - qc[2,];
  bc <- 2*qc[4,] - qc[3,];
  mc <- (uc*bc + vc*ac) / (uc+vc);
  # ----------
  names(ac) <- colnames(sample)
  names(bc) <- colnames(sample)
  names(mc) <- colnames(sample)
  # -------------------------
  # Parameters Return
  return(rbind(ac,bc,mc))
}
