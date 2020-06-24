#### Get overlapping transcripts ####

##### ----------- PLOT DATA WITH UPSETR ----------------####

library(UpSetR)
library(ggplot2)
### Nipponbare ###
# Load data with Moroberekan as reference
files_nippon <- list.files(path="unique_db_entry/", pattern="*vsNipponbare.out.blastn.filt*",
                         full.names = T)
files_name <- list.files(path="unique_db_entry/", pattern="*vsNipponbare.out.blastn.filt*")
data_nippon <- lapply(files_nippon, read.table)
# Rename list elements 
names(data_nippon) <- c("Nipponbare", "N22", "Dular", "Anjali", "CT9993", "M202", "Moroberekan", "IR62266", "IR64", "IR72")
head(data_nippon[[4]])

# Get the Nipponbare Identifier in coloumn 1
data_nippon_IDs <- lapply(data_nippon, '[[', 2)
# Create upSetR input df
upSet_df_nippon <- fromList(data_nippon_IDs)
upset(upSet_df_nippon, sets=rev(c("Dular", "N22", "Anjali", "IR62266", "IR64", "IR72", "CT9993","M202", "Moroberekan", "Nipponbare")),
      point.size = 4, line.size = 1.5, text.scale = c(1.5, 1.5, 1.5, 1.5, 2, 2), nintersects = 15, mb.ratio = c(0.65, 0.35),
      mainbar.y.label = "Transcript Intersections", sets.x.label = "Number of transcripts", order.by = c("freq"), keep.order = T,
      cutoff = 3, sets.bar.color = c("#56B4E9", rep("gray23", 9)), number.angles = 30)

### IR64 ###
# Load data with IR64 as reference
files_ir64 <- list.files(path="unique_db_entry/", pattern="*vsIR64.out.blastn.filt",
                         full.names = T)
files_name <- list.files(path="unique_db_entry/", pattern="*vsIR64.out.blastn.filt")
data_ir64 <- lapply(files_ir64, read.table)
# Rename list elements 
names(data_ir64) <- c("Nipponbare", "N22", "Dular", "Anjali", "CT9993", "M202", "Moroberekan", "IR62266", "IR64", "IR72")
head(data_ir64[[1]])

# Get the IR64 Identifier in coloumn 1
data_ir64_IDs <- lapply(data_ir64, '[[', 2)
# Create upSetR input df
upSet_df_ir64 <- fromList(data_ir64_IDs)
upset(upSet_df_ir64, sets=rev(c("Dular", "N22", "Anjali", "IR62266", "IR64", "IR72", "CT9993","M202", "Moroberekan", "Nipponbare")),
      point.size = 4, line.size = 1.5, text.scale = c(1.5, 1.5, 1.5, 1.5, 2, 2), nintersects = 15, mb.ratio = c(0.65, 0.35),
      mainbar.y.label = "Transcript Intersections", sets.x.label = "Number of transcripts", order.by = c("freq"), keep.order = T,
      cutoff = 3, number.angles = 30, sets.bar.color = c(rep("gray23", 5), "#56B4E9", rep("gray23", 4)))

### N22 ###
# Load data with Moroberekan as reference
files_N22 <- list.files(path="unique_db_entry/", pattern="*vsN22.out.blastn.filt",
                        full.names = T)
#files_name <- list.files(path="C:/Users/Schaarschmidt/Nextcloud/PhD/PacBio/4_Collapsing/3_compare_cultivars_afterCollapse/5_blast_PB_overlap/unique_db_entry/", pattern="*vsN22.out.blastn.filt")
files_name <- list.files(path="unique_db_entry/", pattern="*vsN22.out.blastn.filt")


data_N22 <- lapply(files_N22, read.table)
# Rename list elements 
names(data_N22) <- c("Nipponbare", "N22", "Dular", "Anjali", "CT9993", "M202", "Moroberekan", "IR62266", "IR64", "IR72")
head(data_N22[[1]])

# Get the N22 Identifier in coloumn 1
data_N22_IDs <- lapply(data_N22, '[[', 2)
# Create upSetR input df
upSet_df_N22 <- fromList(data_N22_IDs)
upset(upSet_df_N22, sets=rev(c("Dular", "N22", "Anjali", "IR62266", "IR64", "IR72", "CT9993","M202", "Moroberekan", "Nipponbare")),
      point.size = 4, line.size = 1.5, text.scale = c(1.5, 1.5, 1.5, 1.5, 2, 2), nintersects = 15, mb.ratio = c(0.65, 0.35),
      mainbar.y.label = "Transcript Intersections", sets.x.label = "Number of transcripts", order.by = c("freq"), keep.order = T,
      cutoff = 3, sets.bar.color = c(rep("gray23", 8),"#56B4E9", "grey23"), number.angles = 30)



##### ----------- GET AUS SPECIFIC TRANSCRIPTS ----------------####
### Select transcripts only in N22
library(tidyverse)
rownames(upSet_df_N22) = str_replace_all(data_N22_IDs$N22, "\\(|\\+|\\-|\\)", "")  
head(upSet_df_N22)

upSet_df_n22_names = read_tsv("ids_N22.tsv")
rownames(upSet_df_N22) = upSet_df_n22_names$rownames.upSet_df_N22.

onlyN22 = upSet_df_N22[which(upSet_df_N22$N22 == 1 & rowSums(upSet_df_N22) == 1), ]
onlyN22_Dular = upSet_df_N22[which(upSet_df_N22$N22 == 1 & upSet_df_N22$Dular == 1 & rowSums(upSet_df_N22) == 2), ]
onlyN22_Dular_Anjali = upSet_df_N22[which(upSet_df_N22$N22 == 1 & upSet_df_N22$Dular == 1 & upSet_df_N22$Anjali == 1 & rowSums(upSet_df_N22) == 3), ]

# Load annotation data
anno_combined = read.csv("N22_annotations.txt", sep = "\t")

# Merge onlyN22
ids_onlyN22 = data.frame(IDENTIFIER=rownames(onlyN22))
merged_onlyN22 = merge(anno_combined, ids_onlyN22, by="IDENTIFIER", all.y = T) # included duplicated annotations from mercator, missing PB transcripts

# Merge only N22 and Dular
ids_onlyN22_Dular = data.frame(IDENTIFIER=rownames(onlyN22_Dular))
merged_onlyN22_Dular = merge(anno_combined, ids_onlyN22_Dular, by="IDENTIFIER", all.y=T)

# Merge only N22, Dular and Anjali
ids_onlyN22_Dular_Anjali = data.frame(IDENTIFIER=rownames(onlyN22_Dular_Anjali))
merged_onlyN22_Dular_Anjali = merge(anno_combined, ids_onlyN22_Dular_Anjali, by="IDENTIFIER", all.y=T)

# Create final data frames
final_df_onlyN22 = data.frame(Identifier=merged_onlyN22$IDENTIFIER, Gene_ID=merged_onlyN22$GENE_ID,
                              Transcript_ID=merged_onlyN22$TRANSCRIPT_ID, 
                              Mercator_BinName=merged_onlyN22$MERCATOR_BIN,
                              Mercator_Description=merged_onlyN22$MERCATOR_DESCRIPTION,
                              BlastX=merged_onlyN22$BLASTX,
                              Blastp=merged_onlyN22$BLASTP,
                              PFAM=merged_onlyN22$PFAM, PFAM_GO=merged_onlyN22$GO)
write_excel_csv(final_df_onlyN22, "onlyInN22_dbEntryN22.csv")

final_df_onlyN22_Dular = data.frame(Identifier=merged_onlyN22_Dular$IDENTIFIER, 
                                    Gene_ID=merged_onlyN22_Dular$GENE_ID,
                                    Transcript_ID=merged_onlyN22_Dular$TRANSCRIPT_ID, 
                                    Mercator_BinName=merged_onlyN22_Dular$MERCATOR_BIN,
                                    Mercator_Description=merged_onlyN22_Dular$MERCATOR_DESCRIPTION,
                                    BlastX=merged_onlyN22_Dular$BLASTX,
                                    Blastp=merged_onlyN22_Dular$BLASTP,
                                    PFAM=merged_onlyN22_Dular$PFAM, 
                                    PFAM_GO=merged_onlyN22_Dular$GO)
write_excel_csv(final_df_onlyN22_Dular, "onlyInN22_dbEntryN22_Dular.csv")
