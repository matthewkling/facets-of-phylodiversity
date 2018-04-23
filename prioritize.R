
# This R script contains the functions used to calculate conservation priorities
# from occurrences of species or phylogenetic lineages across a set of sites,
# as described in Kling et al 2018, in review.



# convert proportion of range conserved into conservation benefit value
benefit <- function(
      pro, # vector of lineage range proporions protected  
      lambda=1 # free parameter defining shape of function
){
      lambda <- 2^lambda
      (1-(1-pro)^lambda)^(1/lambda)
}

# compute site ranks using forward selection algorithm
prioritize <- function(
      data, # an occurrence matrix, with sites in rows, species or lineages in columns,
            # and occurrence probabilities in cells
      branch_lengths, # vector of branch lengths corresponding to columns of 'data'
      status, # vector of site starting conservation statuses, between 0 and 1, 
            # corresponding to rows of 'data'
      area, # vector of site land areas, corresponding to rows of 'data'
      lambda # parameter defining shape of conservation benefit function
){
      
      require(dplyr)
      
      # weight occurrence probabilities
      data <- data %>%
            apply(2, function(x) x*area) %>% # by land area
            apply(2, function(x) x/sum(x, na.rm=T)) # and by inverse range size
      
      # intermediate reference values
      unconserved <- apply(data, 2, function(x) x * (1-status)) # slack
      branch_sum <- sum(branch_lengths) # total tree length
      pres_sum <- apply(data, 2, sum, na.rm=T) # range sizes
      sites <- 1:length(status) # site IDs
      
      # initialize values to be modified at each step
      branch_benefit_i <- data %>%
            apply(2, function(x) sum(x * status, na.rm=T)) %>%
            benefit(lambda=lambda)
      status_i <- status
      rank <- rep(NA, length(status_i))
      selected <- c()
      selection <- NA
      
      # forward stepwise selection
      for(i in 1:length(rank)){
            writeLines(paste("step", i, "of", length(rank)))
            
            # total conservation benefit
            branch_status_i <- apply(data, 2, function(x) sum(x * status_i, na.rm=T)) / pres_sum
            branch_benefit_i <- benefit(branch_status_i, lambda=lambda)
            prop_0 <- sum(branch_benefit_i * branch_lengths) / branch_sum
            
            # total conservation benefit if each site were fully protected
            prop_1 <- apply(unconserved, 1, 
                            function(x) sum(benefit(branch_status_i + x, lambda=lambda) * 
                                                  branch_lengths) / branch_sum)
            
            # marginal value of proteting each site
            marginal_value <- prop_1 - prop_0
            marginal_value <- marginal_value / area
            
            # eligible sites yet to be protected
            eligible <- setdiff(sites, selected)
            mve <- marginal_value[eligible]
            
            # select elegible site with highest marginal value,
            # breaking ties randomly if they occur
            wm <- which(mve==max(mve))
            wm <- ifelse(length(wm)==1, wm, sample(wm, 1))
            selection <- eligible[wm]
            selected <- c(selected, selection)
            
            # add protection to the selected site
            status_i[selection] <- 1
            rank[selection] <- i
      }
      
      # a vector of ranks, corresponding to rows in 'data'
      # (low rank is high priority)
      return(rank)
}

