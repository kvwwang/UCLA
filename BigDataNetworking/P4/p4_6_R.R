
colnames(gopatriots6) <- c("fav_count","n_followings","n_followers","n_statuses","len_tweet","n_hashtags")

fit = lm(gopatriots6$len_tweet ~ gopatriots6$n_hashtags)
summary(fit)

fit1 = lm(gopatriots6$n_followers ~ gopatriots6$fav_count+gopatriots6$n_statuses+gopatriots6$n_followings)
summary(fit1)

fit2 = lm(gopatriots6$n_followers ~ gopatriots6$fav_count)
summary(fit2)

fit3 = lm(gopatriots6$n_followers ~ gopatriots6$n_followings)
summary(fit3)

fit4 = lm(gopatriots6$n_followers ~ gopatriots6$n_statuses)
summary(fit4)


# all ---------------------------------------------------------------------

colnames(data6) <- c("fav_count","n_followings","n_followers","n_statuses","len_tweet","n_hashtags")

fit = lm(data6$len_tweet ~ data6$n_hashtags)
summary(fit)

fit1 = lm(data6$n_followers ~ data6$fav_count+data6$n_statuses+data6$n_followings)
summary(fit1)

fit2 = lm(data6$n_followers ~ data6$fav_count)
summary(fit2)

fit3 = lm(data6$n_followers ~ data6$n_followings)
summary(fit3)

fit4 = lm(data6$n_followers ~ data6$n_statuses)
summary(fit4)

fit5 = lm(data6$n_hashtags ~ data6$n_followers)
summary(fit5)

fit6 = lm(data6$len_tweet ~ data6$n_followers)
summary(fit6)


