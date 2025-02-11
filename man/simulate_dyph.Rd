% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/moves.R
\name{simulate_dyph}
\alias{simulate_dyph}
\title{Simulate Dynamic Persistent Homology}
\usage{
simulate_dyph(f, FUN = NULL)
}
\arguments{
\item{f}{function that takes no arguments and yields a filtration on invocation.}

\item{FUN}{optional function to inspect persistence-related information for each filtration. See details.}
}
\description{
Simulates persistent homology (PH) in dynamic settings
}
\details{
This function enables the efficient computation of persistence over dynamic or time-varying settings.
Given a nullary function which returns a filtration upon each invocation, this function computes the 
persistent homology of each filtration in sequence, applying the user-supplied \code{FUN} to the resulting 
persistence diagram. The user may specify the type interpolation process to use between adjacent filtrations. 
Thus, conceptually this acts as an alternative to collecting all of the filtrations into a list \code{L} and executing 
\code{lapply(L, function(filtration){ FUN(ph(filtration)) }) }. \cr
\cr     
Unlike the simplistic \code{lapply} strategy discussed above, this function requires at most 2 filtrations be 
in memory at any given time. Moreover, when adjacent persistence diagrams are relatively "close", it can be more efficient 
to update the underlying R=DV decomposition over time instead of simply recomputing the decomposition independently for 
each filtration. Optionally, the user may also simulate persistence at intermediate or "interpolated" points as well---the 
so-called vineyards approach.
}
