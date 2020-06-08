#this code is replacement for chunk that begins at line 346
sum.AVG<-Concentration.AVG %>% group_by(Sample.type) %>% summarize(meanCd=mean(PPM.Cd.in.sample),
                                                                   meanPb=mean(PPM.Pb.in.sample),
                                                                   meanV=mean(PPM.V.in.sample),
                                                                   meanCr=mean(PPM.Cr.in.sample),
                                                                   meanMn=mean(PPM.Mn.in.sample),
                                                                   meanNi=mean(PPM.Ni.in.sample),
                                                                   meanCu=mean(PPM.Cu.in.sample),
                                                                   meanZn=mean(PPM.Zn.in.sample))

sum.AVG<-sum.AVG %>% filter(Sample.type != "method.blank")  #get rid of the method blank row
df<-sum.AVG %>% gather(metal,concentration,-Sample.type)  #put this back into tidy form


#transfer factor is leaf/soil  for Cd and Ni. create a 1 row data.frame with transfer factor for these 2 metals
tf1<-(sum.AVG %>% filter(Sample.type=="leaf") %>% select(meanCd,meanNi))/(sum.AVG %>% filter(Sample.type=="soil") %>% select(meanCd,meanNi))

#transfer factor is leaf/soil.diluted for other metals. create a 1 row data.frame with transfer factor for  other metals
tf2<-(sum.AVG %>% filter(Sample.type=="leaf") %>% select(meanPb,  meanV, meanCr, meanMn,  meanCu, meanZn))/(sum.AVG %>% filter(Sample.type=="soil.diluted") %>% select(meanPb,  meanV, meanCr, meanMn,  meanCu, meanZn))

#use cbind (column bind) to put tf1 and tf2 back together and add a column called Sample type
tf<-cbind(data.frame(Sample.type="transfer factor"),cbind(tf1,tf2))

#trophic.transfer.factor is cata/leaf for all metals 
#just select the metal contrations by using select(-Sample.type) which selects every colums except Sample.type
ttf1<-(sum.AVG %>% filter(Sample.type=="cata") %>% select(-Sample.type))/ (sum.AVG %>% filter(Sample.type=="leaf") %>% select(-Sample.type))
ttf<-cbind(data.frame(Sample.type="trophic.transfer.factor"),ttf1)

# you can try to do the bioaccumulation factor - let me know if you get stuck
                                                
# now use rbind to put  tf, ttf back in sum.AVG
sum.AVG<-rbind(sum.AVG,ttf,tf)   

rm(tf1,tf2,tf,ttf)  #clean up a bit by getting rid (rm means"remove") of all the temporary data.frames that i created

  