---
layout: post
title:  Using a network-diagram to facilitate eliminating predictor variables
---
In ecological niche modelling, we always faced the problem of variable 
selection and colinearity (Dormann et al. 2013). Because highly correlated predictor variables may lead to model overfitting, so we introduced a method to facilitate eliminating predictor variables when the aim is to avoid colinearity (see more details in our paper Feng et al. 2015). We used network-diagram which is straight forward in showing the complex colinearity structure of all predictor variables.

The general steps:  
* (1) Build a Pearson correlation matrix for the all predictor variables with raster library in R (Hijmans 2014). Here we used 19 bioclimatic variables as an example (worldclim.org).  

* (2) Draw a network diagram using igraph library in R (Csardi and Nepusz 2006). In the network diagram, highly correlated (\|r\|>0.7) variables are linked by lines, and the group of variables with colinearity would clustere together (Figure 1).  

* (3) With this network diagram, there are multiply ways to select variables depending on your needs. One way is to pick one variable out of a group of clusted variables; another way is to choose a starting node and jumping across a nod to select a second node. However, the variable selection should be ecologically justified. For example, we prioritized extreme variables instead of average variables among the clustered variables (e.g., we selected maximum temperature of the warmest month instead of annual mean temperature), assuming that extreme variables are more likely to be limiting factors for the species.


<img src="{{ site.url }}/figure/old_post/fig.1.jpg" alt="network1" style="width: 300px;" align="middle"/>  

*Figure 1. Network diagram of 19 bioclimatic variables. The yellow circles represent temperature variables and the green circles represent precipitation variables. Two circles are linked if the two represented variables have a high correlation (\|r\|≥ 0.7). The selected variables are marked with red boundaries.*  

*The network diagram is implemented in R, with raster and igraph libraries.
~~~
#include igraph and raster libraries
library(igraph)
library(raster)

#load predictor variables
#bioFiles <- list.files(path = "path for variable", pattern = ".asc$", recursive = FALSE, full.names=TRUE)
bioFiles <- list.files(path = "D:/projects/2012.IOZ.pheasant/2012.11-ioz-modify/9.rejected/layer4/prjArea_china_10m_asc/", pattern = ".asc$", recursive = FALSE, full.names=TRUE)
bioRaster<- stack(bioFiles)

# Build correlation matrix
m <- layerStats(bioRaster,'pearson',na.rm=TRUE)[[1]]

# Set threshold for "high" correlation, here we used 0.7
m <- abs(m)
m[m<0.7] <- 0

#
#m<-m*10

# Link variables
net <- graph.adjacency(m,mode="undirected",weighted=TRUE,diag=FALSE)

for (i in 1:11){
    tt<-paste("bio",i,sep="")
	for(j in 1:length(V(net)$name)){
		if ( V(net)$name[j]==tt){
			# set up color for the first 11 variables
			V(net)$color[[j]] <- "yellow"
			# set up node size for the first 11 variables
			V(net)$size[[j]] <- 18
			break
			}
	}
}
for (i in 12:19){
    tt<-paste("bio",i,sep="")
	for(j in 1:length(V(net)$name)){
		if ( V(net)$name[j]==tt){
			V(net)$color[[j]]<-"green"
			V(net)$size[[j]]<-18
		}
	}
}
# Draw the network diagram
tkplot(net)
~~~


## References:
* Csardi G, Nepusz T (2006) The igraph software package for complex network research. InterJournal Complex Systems:1695
* Dormann CF, Elith J, Bacher S, Buchmann Cand others (2013) Collinearity: a review of methods to deal with it and a simulation study evaluating their performance. Ecography 36:27-46
* Feng, X., C. Lin, H. Qiao, and L. Ji. Assessment of Climatically Suitable Area for Syrmaticus reevesii under Climate Change. Endangered Species Research 28:19-31. doi:10.3354/esr00668
* Hijmans RJ (2014) Raster: geographic data analysis and modeling.cran.r-project.org/web/packages/raster/ (accessed 1 Nov 2014)
