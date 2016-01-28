load("ResBaz_NeSI&RmpiDemo.RData")

ER<-ifelse(Clinical_RNASeq_BRCA$er_status_by_ihc=="Positive", 1, ifelse(Clinical_RNASeq_BRCA$er_status_by_ihc=="Negative", 0, NA))
table(ER)

#Running snow on NeSI
#The R module we've loaded should include snow and the dependancy (RMpi)
library("snow")
cl <- makeMPIcluster() #Do't specify how many cores you want here  - NeSI will assign you them through "slurm" scheduler
#MPI is a more efficient way to communicate between cores/nodes on a larger network
#NeSI recommends MPI (messager passing interface) on the Pan cluster - not installed on my local machine or department server
len<-50 #small test job
p_vals <- cbind(rownames(Data_Matrix_BRCA_RNASeq_Voom)[1:len], rep(NA, len))
colnames(p_vals) <- c("Gene", "ER_pval")
p_vals
clusterExport(cl, list=ls()) #Send all data to each core
system.time({
  p_vals[,2] <- parLapply(cl, as.list(1:len), function(ii){
    print(ii)
    return(t.test(Data_Matrix_BRCA_RNASeq_Voom[ii,]~ER)$p.value)
  })
})
stopCluster(cl) #Ends cluster (note parLapply has returned output to the 'master/parent' core/node)
p_vals
#time = 0.181 sec on 3 cores (0.543 CPU-seconds)
#Same output, substantial increase in speed will help if doing many operations
#Note diminishing returns, communication time between cores, more cores != always faster
save(p_vals, file="test.RData")
#Remember to save your data before script ends

#Core     #Real-time    #CPU-time
#1         0.500         0.500
#2         0.258         0.516
#3         0.181         0.542
#4         0.139         0.556    (use all cores on machine at own risk - may mess with GUI/etc)
#10        0.117         1.170
#25        0.260         6.500
#100       0.987        98.70

#Let's see how fast all genes are on the cluster...