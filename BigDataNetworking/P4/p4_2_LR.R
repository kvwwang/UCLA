
# superbowl ---------------------------------------------------------------

colnames(superbowl_t1) <- c("tweets_next")
colnames(superbowl_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(superbowl_t1$tweets_next ~ superbowl_f1$tweets_cur+superbowl_f1$tot_ret+superbowl_f1$tot_fol+superbowl_f1$max_fol+superbowl_f1$time_hour)
summary(fit)

# sb49 ---------------------------------------------------------------

colnames(sb49_t1) <- c("tweets_next")
colnames(sb49_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(sb49_t1$tweets_next ~ sb49_f1$tweets_cur+sb49_f1$tot_ret+sb49_f1$tot_fol+sb49_f1$max_fol+sb49_f1$time_hour)
summary(fit)

# patriots ---------------------------------------------------------------

colnames(patriots_t1) <- c("tweets_next")
colnames(patriots_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(patriots_t1$tweets_next ~ patriots_f1$tweets_cur+patriots_f1$tot_ret+patriots_f1$tot_fol+patriots_f1$max_fol+patriots_f1$time_hour)
summary(fit)

# nfl ---------------------------------------------------------------

colnames(nfl_t1) <- c("tweets_next")
colnames(nfl_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(nfl_t1$tweets_next ~ nfl_f1$tweets_cur+nfl_f1$tot_ret+nfl_f1$tot_fol+nfl_f1$max_fol+nfl_f1$time_hour)
summary(fit)

# gopatriots --------------------------------------------------------------

gopatriots_t1

colnames(gopatriots_t1) <- c("tweets_next")
colnames(gopatriots_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(gopatriots_t1$tweets_next ~ gopatriots_f1$tweets_cur+gopatriots_f1$tot_ret+gopatriots_f1$tot_fol+gopatriots_f1$max_fol+gopatriots_f1$time_hour)
summary(fit)

# gohawks --------------------------------------------------------------


colnames(gohawks_t1) <- c("tweets_next")
colnames(gohawks_f1) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour")

fit = lm(gohawks_t1$tweets_next ~ gohawks_f1$tweets_cur+gohawks_f1$tot_ret+gohawks_f1$tot_fol+gohawks_f1$max_fol+gohawks_f1$time_hour)
summary(fit)




