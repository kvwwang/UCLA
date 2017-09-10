# superbowl --------------------------------------------------------------

colnames(superbowl_t2) <- c("tweets_next")
colnames(superbowl_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(superbowl_t2$tweets_next ~ superbowl_f2$tweets_cur+superbowl_f2$tot_ret+superbowl_f2$tot_fol+superbowl_f2$max_fol+superbowl_f2$time_hour+superbowl_f2$tot_fav+superbowl_f2$tot_ret_c+superbowl_f2$tot_rep)
summary(fit)

fit2 = lm(superbowl_t2$tweets_next ~ superbowl_f2$tweets_cur+superbowl_f2$tot_ret+superbowl_f2$tot_fol+superbowl_f2$tot_fav+superbowl_f2$tot_ret_c+superbowl_f2$tot_rep)
summary(fit2)

fit3 = lm(superbowl_t2$tweets_next ~ superbowl_f2$tweets_cur+superbowl_f2$tot_ret+superbowl_f2$tot_fol+superbowl_f2$tot_fav+superbowl_f2$tot_ret_c)
summary(fit3)

# sb49 --------------------------------------------------------------

colnames(sb49_t2) <- c("tweets_next")
colnames(sb49_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(sb49_t2$tweets_next ~ sb49_f2$tweets_cur+sb49_f2$tot_ret+sb49_f2$tot_fol+sb49_f2$max_fol+sb49_f2$time_hour+sb49_f2$tot_fav+sb49_f2$tot_ret_c+sb49_f2$tot_rep)
summary(fit)

fit2 = lm(sb49_t2$tweets_next ~ sb49_f2$tweets_cur+sb49_f2$tot_ret+sb49_f2$tot_fol+sb49_f2$tot_fav+sb49_f2$tot_ret_c+sb49_f2$tot_rep)
summary(fit2)

fit3 = lm(sb49_t2$tweets_next ~ sb49_f2$tweets_cur+sb49_f2$tot_ret+sb49_f2$tot_fol+sb49_f2$tot_fav+sb49_f2$tot_ret_c)
summary(fit3)

# patriots --------------------------------------------------------------

colnames(patriots_t2) <- c("tweets_next")
colnames(patriots_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(patriots_t2$tweets_next ~ patriots_f2$tweets_cur+patriots_f2$tot_ret+patriots_f2$tot_fol+patriots_f2$max_fol+patriots_f2$time_hour+patriots_f2$tot_fav+patriots_f2$tot_ret_c+patriots_f2$tot_rep)
summary(fit)

fit2 = lm(patriots_t2$tweets_next ~ patriots_f2$tweets_cur+patriots_f2$tot_ret+patriots_f2$tot_fol+patriots_f2$tot_fav+patriots_f2$tot_ret_c+patriots_f2$tot_rep)
summary(fit2)

fit3 = lm(patriots_t2$tweets_next ~ patriots_f2$tweets_cur+patriots_f2$tot_ret+patriots_f2$tot_fol+patriots_f2$tot_fav+patriots_f2$tot_ret_c)
summary(fit3)

# nfl --------------------------------------------------------------

colnames(nfl_t2) <- c("tweets_next")
colnames(nfl_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(nfl_t2$tweets_next ~ nfl_f2$tweets_cur+nfl_f2$tot_ret+nfl_f2$tot_fol+nfl_f2$max_fol+nfl_f2$time_hour+nfl_f2$tot_fav+nfl_f2$tot_ret_c+nfl_f2$tot_rep)
summary(fit)

fit2 = lm(nfl_t2$tweets_next ~ nfl_f2$tweets_cur+nfl_f2$tot_ret+nfl_f2$tot_fol+nfl_f2$tot_fav+nfl_f2$tot_ret_c+nfl_f2$tot_rep)
summary(fit2)

fit3 = lm(nfl_t2$tweets_next ~ nfl_f2$tweets_cur+nfl_f2$tot_ret+nfl_f2$tot_fol+nfl_f2$tot_fav+nfl_f2$tot_ret_c)
summary(fit3)

# gopatriots --------------------------------------------------------------

colnames(gopatriots_t2) <- c("tweets_next")
colnames(gopatriots_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(gopatriots_t2$tweets_next ~ gopatriots_f2$tweets_cur+gopatriots_f2$tot_ret+gopatriots_f2$tot_fol+gopatriots_f2$max_fol+gopatriots_f2$time_hour+gopatriots_f2$tot_fav+gopatriots_f2$tot_ret_c+gopatriots_f2$tot_rep)
summary(fit)

fit2 = lm(gopatriots_t2$tweets_next ~ gopatriots_f2$tweets_cur+gopatriots_f2$tot_ret+gopatriots_f2$tot_fol+gopatriots_f2$tot_fav+gopatriots_f2$tot_ret_c+gopatriots_f2$tot_rep)
summary(fit2)

fit3 = lm(gopatriots_t2$tweets_next ~ gopatriots_f2$tweets_cur+gopatriots_f2$tot_ret+gopatriots_f2$tot_fol+gopatriots_f2$tot_fav+gopatriots_f2$tot_ret_c)
summary(fit3)

# gohawks --------------------------------------------------------------

colnames(gohawks_t2) <- c("tweets_next")
colnames(gohawks_f2) <- c("tweets_cur","tot_ret","tot_fol","max_fol","time_hour","tot_fav","tot_ret_c","tot_rep")

fit = lm(gohawks_t2$tweets_next ~ gohawks_f2$tweets_cur+gohawks_f2$tot_ret+gohawks_f2$tot_fol+gohawks_f2$max_fol+gohawks_f2$time_hour+gohawks_f2$tot_fav+gohawks_f2$tot_ret_c+gohawks_f2$tot_rep)
summary(fit)

fit2 = lm(gohawks_t2$tweets_next ~ gohawks_f2$tweets_cur+gohawks_f2$tot_ret+gohawks_f2$tot_fol+gohawks_f2$tot_fav+gohawks_f2$tot_ret_c+gohawks_f2$tot_rep)
summary(fit2)

fit3 = lm(gohawks_t2$tweets_next ~ gohawks_f2$tweets_cur+gohawks_f2$tot_ret+gohawks_f2$tot_fol+gohawks_f2$tot_fav+gohawks_f2$tot_ret_c)
summary(fit3)

