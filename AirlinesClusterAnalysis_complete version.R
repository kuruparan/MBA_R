#-----------------------------------------------------------------------------
## Step 1 To Step 3 are common for both Hierachical & K-means cluster analysis
#-----------------------------------------------------------------------------

## Hierachical Cluster Analysis of Airlines problem>>>

## STEP 1: SET Working directory Ctrl + Shift + H and  ensure 'airlines.csv' file is available

## Step 2: Exploring the data 

  airlines <- read.csv("airlines.csv", stringsAsFactors = TRUE)
  str(airlines)
  head(airlines, 3)
  summary(airlines)

  #Observed much smaller [Bonustrans (11.6) & Flighttrans (1.374)]  and much larger
  #[Balance (73601) & Bonusmiles (17145)] range of values for different columns.        

## Step 3: Normalize  the data to avoid undue influence of  features with larger ranges.

  #using 'caret' package's preProcess() and predict() functions for normalization
  if(require("caret") == FALSE) {install.packages("caret")};{library(caret)}

  preproc = preProcess(airlines)
  airlinesNorm = predict(preproc, airlines)

  #Observe the normalized data loaded in 'airlinesNorm' data frame
  summary(airlinesNorm)


## STEP 4: Computing distances & performing hierarchical clustering

  #using euclidean distances between data points to create the clusters
  distances = dist(airlinesNorm, method = "euclidean")

  #using the hclust() function with 'ward distance' to  generate and merge clusters in    
  #bottom-up (agglomerative hierarchical ) approach
  hierClust = hclust(distances, method = "ward")

  #Generate dendrogram to visualize the hierarchical clusters
  dend <- as.dendrogram(hierClust)
  plot(dend, main = "Market Segmentation For Airlines - Cluster Dendrogram")


## STEP 5: Observe the Dendrogram and with the input of marketing department
#decide the right number of clusters (segments). 

  #Here, we decided to go with 5 segments, so using cutree() with k=5
  clusterGroups = cutree(hierClust, k = 5)

  #Observe cluster membership
  table(clusterGroups)

#-----------------------------
#Try this to obtain a colored dendrograms with the 5 clusters in different colors
#For colored dendrogram visualisation
if(require("dendextend") == FALSE) {install.packages("dendextend")};{library(dendextend)}
dend1 <- color_branches(dend, k = 5)
par(mfrow = c(1,2))
plot(dend1, main = "Market Segmentation For Airlines - Cluster Dendrogram")
#-----------------------------


## STEP 6: Compare Cluster column (variable) averages for profiling each segment

  airVec <- c(tapply(airlines$Balance, clusterGroups, mean),
              tapply(airlines$Qualmiles,clusterGroups, mean),
              tapply(airlines$Bonusmiles,clusterGroups, mean), 
              tapply(airlines$Bonustrans,clusterGroups, mean),
              tapply(airlines$Flightmiles,clusterGroups, mean),
              tapply(airlines$Flighttrans, clusterGroups, mean), 
              tapply(airlines$Dayssinceenroll, clusterGroups, mean))

  dim(airVec) = c(5, 7)

  colnames(airVec) = c("Balance", "QualMiles", "BonusMiles", "BonusTrans",   
                     "FlightMiles12mo", "FlightTrans12", "DaysSinceEnroll")

  #Interpret the results and create the segment profiles
  airVec


  #Instead of the above code you can also try this:
  lapply(split(airlines, clusterGroups), colMeans)


#-------------------------------------------------------------------------------------
## K-means Cluster Analysis of Airlines problem>>>

## Assuming Step 1 To Step 3 already carried out and both and the data frames airlines
# & airlinesNorm are available in memory
#-------------------------------------------------------------------------------------

## STEP 4: For k-means clustering, unlike hierarchical clustering here we need to specify k at the outset

  # Since our marketing department wants to segment customers in to 5 groups
  k = 5
  set.seed(88)
  KMC.airlines = kmeans(airlinesNorm, centers = k, iter.max = 1000)


  ## STEP 5: Compare cluster column (variable) averages for profiling each segment

  KMC.airlines$centers

  airVec2 <- c(tapply(airlines$Balance, KMC.airlines$cluster, mean),
               tapply(airlines$Qualmiles,KMC.airlines$cluster, mean),
               tapply(airlines$Bonusmiles,KMC.airlines$cluster, mean), 
               tapply(airlines$Bonustrans,KMC.airlines$cluster, mean),
               tapply(airlines$Flightmiles,KMC.airlines$cluster, mean),
               tapply(airlines$Flighttrans, KMC.airlines$cluster, mean), 
               tapply(airlines$Dayssinceenroll, KMC.airlines$cluster, mean))
  
  dim(airVec2) = c(5, 7)
  
  colnames(airVec2) = c("Balance", "QualMiles", "BonusMiles", "BonusTrans",  
                        "FlightMiles12mo", "FlightTrans12", "DaysSinceEnroll")
  
  airVec2


## STEP 6: Visualising the k-means clusters with 'factoextra' package fviz_cluster()

  if(require("factoextra")== FALSE) {install.packages("factoextra")};{library(factoextra)}

  fviz_cluster(KMC.airlines, data = airlines)


#-------------------------------------------------------------
## Algorithmically determining the right number of clusters>>>
#-------------------------------------------------------------

# For hierarchical clustering:to obatin a recommendation based on multiple indices
  
  if(require("NbClust") == FALSE) {install.packages("NbClust")};{library(NbClust)}

  NbClust(data = airlinesNorm, diss = NULL, distance = "euclidean", min.nc = 2, max.nc = 8, method ="ward.D")


# For k-means clustering:
  
  if(require("factoextra") == FALSE) {install.packages("factoextra")}; {library(factoextra)}
  
  # use Silhouette method
  fviz_nbclust(airlinesNorm, kmeans, method = "silhouette")
  + labs(subtitle = "Silhouette method")
  
  # OR
  
  # use Elbow method
  fviz_nbclust(airlinesNorm, kmeans, method = "wss") 
  + geom_vline(xintercept = 4, linetype = 2)
  + labs(subtitle = "Elbow method")
  
  # OR
  
  # use NbClust package NbClust() with method set to kmeans
  
  if(require("NbClust") == FALSE) {install.packages("NbClust")};{library(NbClust)}
  
   NbClust(data = airlinesNorm, diss = NULL, distance = "euclidean", min.nc = 2, max.nc = 8, method ="kmeans")
  
  #////////////

#code for plotting profile plot of centroids
  # plot an empty scatter plot
  plot(c(0), xaxt = 'n', ylab = "", type = "l",
       ylim = c(min(KMC.airlines$centers), max(KMC.airlines$centers)), xlim = c(0, 7))
  # label x-axes
  axis(1, at = c(1:7), labels = names(airlinesNorm))
  # plot centroids
  for (i in c(1:5))
    lines(KMC.airlines$centers[i,], lty = i, lwd = 2, col = ifelse(i %in% c(1, 3, 5),
                                                                   "black", "dark grey"))
  # name clusters
  text(x = 0.5, y = KMC.airlines$centers[, 1], labels = paste("Cluster", c(1:5)))



