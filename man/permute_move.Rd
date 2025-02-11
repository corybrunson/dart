% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reduction.R
\name{permute_move}
\alias{permute_move}
\title{Reduction <- R6::R6Class("Reduction", list(
  filtration = list(),
  V = Matrix::rsparsematrix(nrow = 0, ncol = 0, density = 0.0), 
  field = "mod2"
))}
\usage{
permute_move(M, i, j, dims = c("both", "rows", "cols"))
}
\description{
Applies a move permutation to a matrix.
}
\details{
# Reduction$set("active", "R", function(value){
# 	if (!missing(value)){ stop("R is a read-only property. ") }
# 	
# })


Reduction$set("public", "pivots", function(R){
	row_pivots <- apply(B1, 2, function(x) {
		idx <- which(as.vector(x) != 0)
		ifelse(length(idx) == 0, 0, tail(idx, 1L))
	})
	
})

Reduction$set("public", "reduce", function(D){
	V <- Matrix::Matrix(diag(ncol(D)), sparse = TRUE)
	J <- seq(ncol(D))
	P <- vector(mode = "integer", length = 0L)
	E <- vector(mode = "integer", length = 0L)
	.pivot_row <- function(x) { idx <- which(as.vector(x) != 0); ifelse(length(idx) == 0, 0, tail(idx, 1L)) }
	.search_p <- function(pivot_j, j){
		if (pivot_j == 0 || j == 1 || length(P) == 0){ return(0) }
		potential_ranks <- which(P < rank_szudsick(matrix(c(pivot_j, j))))
		if (length(potential_ranks) == 0){ return(0) }
		potential_pivots <- unrank_szudsick(P[potential_ranks])
		true_pivots <- which(apply(potential_pivots, 2, function(pivot){ pivot[1] == pivot_j }))
		if (length(true_pivots) == 0){ return(0) }
		return(rank_szudsick(matrix(potential_pivots[,head(true_pivots, 1L)])))
	}
	for (j in J){
		R_j <- D[,j,drop=FALSE]
		pivot_j <- .pivot_row(R_j)
		sk <- .search_p(pivot_j, j)
		while(sk != 0){
			pivot_k <- unrank_szudsick(sk)[1]
			k <- unrank_szudsick(sk)[2]
			R_k <- D %*% V[,k,drop=FALSE]
			lambda <- R_j[pivot_j]/R_k[pivot_k]
			R_j <- R_j - lambda * R_k 
			V[,j,drop=FALSE] <- V[,j,drop=FALSE] - lambda * V[,k,drop=FALSE]
			pivot_j <- .pivot_row(R_j)
			sk <- .search_p(pivot_j, j)
		} 
		if (pivot_j != 0){
			P <- sort(c(P, rank_szudsick(matrix(c(pivot_j, j)))))
		} else { E <- c(E, j) }
	}
})

# restore_l <- function(R, V, I, state = c(FALSE, FALSE, FALSE, FALSE)){
# 	.pivot_row <- function(x) { idx <- which(as.vector(x) != 0); ifelse(length(idx) == 0, 0, tail(idx, 1L)) }
# 	{ d_low <- .pivot_row(R[,I[1]]); d_colR <- R[,I[1],drop=FALSE]; d_colV <- V[,I[1],drop=FALSE] }
# 	if (length(I) == 1){ return(list(R=R, V=V, d_colR=d_colR, d_colV=d_colV)) }
# 	for (k in seq(2, length(I))){
# 		{ new_d_low <- .pivot_row(R[,I[k]]); new_d_colR <- R[,I[k],drop=FALSE]; new_d_colV <- V[,I[k],drop=FALSE] }
# 		if (!state[3]){
# 			R[,I[1]] <- (R[,I[1]] + R[,I[k]]) %% 2
# 			V[,I[1]] <- (V[,I[1]] + V[,I[k]]) %% 2
# 		} else {
# 			R[,I[k]] <- (R[,I[k]] + d_colR) %% 2
# 			V[,I[k]] <- (V[,I[k]] + d_colV) %% 2
# 		}
# 		test <- ifelse(state[2], new_d_low > d_low, d_low > new_d_low)
# 		if (test){ # && new_d_low != 0
# 			{ d_low <- new_d_low; d_colR <- new_d_colR; d_colV <- new_d_colV }
# 		}
# 	}
# 	return(list(R=R, V=V, d_colR=d_colR, d_colV=d_colV))
# }

permute_move

Applies the permutation given by moving column or row 'i' (or both) to column
or row 'j' (or both).
}
