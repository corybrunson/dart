#' PspMatrix 
#' @param dims dimension of matrix to construct
#' @param i row indices of non-zero entries.
#' @param j column indices of non-zero entries.
#' @param x non-zero entries corresponding to positions (\code{i}, \code{j}) in the matrix.
#' @param type storage type for the non-zero entries. Deduced from \code{x} if missing. See details. 
#' @import R6 Matrix
#' @export
PspMatrix <- R6::R6Class("PspMatrix", list(
  matrix = NULL, 
  initialize = function(i=NULL, j=NULL, x=NULL, dims=NULL, type=c("bool", "integer", "numeric")){
  	i_not_supplied <- missing(i) || is.null(i)
  	j_not_supplied <- missing(j) || is.null(j)
		ijx_supplied <- all(!c(i_not_supplied, j_not_supplied, missing(x)|| is.null(x)))
		matrix_supplied <- FALSE
  	if (!missing(x) && !is.null(dim(x)) && i_not_supplied && j_not_supplied){
			nz_idx <- which(x != 0, arr.ind = TRUE)
			dims <- dim(x)
			i <- nz_idx[,1]
			j <- nz_idx[,2]
			x <- x[nz_idx]
			matrix_supplied <- TRUE
  	}
		if (missing(dims) || is.null(dims)){ dims <- dim(x) }
		stopifnot(!is.null(dims), length(dims) == 2)
  	m <- new(dart:::PspBoolMatrix, dims[1], dims[2])
		if (ijx_supplied || matrix_supplied){
			stopifnot(is.vector(i), is.vector(j), is.numeric(x) || is.logical(x))
			m$construct(i-1L,j-1L,x)
		} 
		self$matrix <- m
  }, 
  print = function(){
  	if (self$matrix$nnz == 0){ cat(sprintf("< empty %d x %d PSP matrix >\n", self$matrix$n_rows, self$matrix$n_cols)) }
	  else {
	    cat(sprintf("%d x %d Permutable Sparse Matrix with %d non-zero entries\n", self$matrix$n_rows, self$matrix$n_cols, self$matrix$nnz))
	  	if (self$matrix$n_rows <= 150 && self$matrix$n_cols <= 150){
	  		show(self$as.Matrix())
	  	}
	  }
  }
))

PspMatrix$set("public", "as.Matrix", function(type="CSC", clean=TRUE) {
	if (clean){ self$matrix$clean(0) }
  return(self$matrix$as.Matrix())
})


#' @export
`[.PspMatrix` <- function(x, i=NULL, j=NULL) { 
	if (missing(i) && missing(j)){ return(x$as.Matrix()) }
	if (missing(i) && !missing(j)){
		stopifnot(is.vector(j), is.numeric(j))
		j <- as.integer(j)
		return(x$matrix$submatrix(0L, x$matrix$n_rows-1L, max(j)-1L, max(j)-1L))
	}
	if (!missing(i) && missing(j)){
		stopifnot(is.vector(i), is.numeric(i))
		i <- as.integer(i)
		return(x$matrix$submatrix(min(i)-1L, min(i)-1L, 0L, x$matrix$n_cols-1L))
	}
	stopifnot(is.vector(i), is.numeric(i))
	i <- as.integer(i)
	j <- as.integer(j)
	return(x$matrix$submatrix(min(i)-1L, max(i)-1L, min(j)-1L, max(j)-1L))
}

#' @method dimnames PspMatrix
#' @export
dimnames.PspMatrix <- function(x){
	# if (!missing(value)){ print("tesdting") }
	return(attr(x, "Dimnames"))	
}

#' @method "dimnames<-" PspMatrix
#' @export
`dimnames<-.PspMatrix` <- function(x, value){
	if (!is.list(value) || length(value) != 2L) { stop("invalid 'dimnames' given for PspMatrix") }
	attr(x, "Dimnames") <- value 
	invisible(x)
}



#' psp_matrix 
#' @description User friendly constructed of a Permutable SParse matrix (psp_matrix). \cr
#' \cr
#' A psp_matrix is a sparse matrix representation designed to allow efficient permutation. Like any traditional 
#' sparse matrix representation (CSC, CSR, etc.), the storage complexity of a psp_matrix is proportional to the 
#' number of non-zero entries. However, swapping any two rows or columns takes just constant time. With other 
#' representations, performing a row/column swap in a matrix A can require up to O(nnz(A)) where 
#' nnz(A) = number of non-zero entries in A.
#' @import Matrix 
#' @export
psp_matrix <- function(i=NULL, j=NULL, x=NULL, dims=NULL, type=c("bool", "integer", "numeric")){
	m <- PspMatrix$new(i=i,j=j,x=x,dims=dims,type=type)
	return(m)
}

methods::setAs(from = "PspMatrix", to = "sparseMatrix", def = function(from){
	return(from$as.Matrix())
})
methods::setAs(from = "PspMatrix", to = "dtCMatrix", def = function(from){
	m <- from$as.Matrix()
	tri <- Matrix::sparseMatrix(i=m@i, p = m@p, x = as.integer(m@x), dims = m@Dim, triangular = TRUE, index1 = FALSE)
	return(tri)
})


#' @method dim PspMatrix
#' @export
dim.PspMatrix <- function(x, ...){
	return(c(x$matrix$n_rows, x$matrix$n_cols))
}


# coerce.PspMatrix <- function(from, to){
# 	
# }



# setClass("Rcpp_PspBoolMatrix")
# .print_psp_matrix <- setMethod("show", "Rcpp_PspBoolMatrix", function (object) {
#   if (object$nnz == 0){ cat(sprintf("< empty %d x %d PSP matrix >\n", object$n_rows, object$n_cols)) }
#   else {
#     cat(sprintf("%d x %d Permutable Sparse Matrix with %d non-zero entries", object$n_rows, object$n_cols, object$nnz))
#   }
# })