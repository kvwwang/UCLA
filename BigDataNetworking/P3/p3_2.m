data = [VarName1,VarName2,VarName3,VarName4];
n_data = length(VarName1);

%%
R = NaN(943,1682);

for q = 1:n_data
    R(data(q,1),data(q,2)) = data(q,3);
end

%%
W = isnan(R);
R_0 = R; R_0(W) = 0;
W = ~W; W = double(W); 

%%
option.residual = 1e-2;
option.iter = 200;

%% Part 4

rng(5); 
k = 50;  %change k between 10,50,100
[U,V,n_iter,time,f_resid] = wnmfrule_4(R,k,option);
% [U,V,n_iter,time,f_resid] = wnmfrule(R,k,option);

R_new = U*V;

%%
R_n2 = norm((R_0.*R_new-R_0));
R_nf = norm((R_0.*R_new-R_0),'fro');

e4 = [R_nf,R_n2];

%%
[r,c] = size(R);
R_vect = reshape(R',1,r*c);
W_vect = reshape(W',1,r*c);
d_index = zeros(1,n_data);
d = 1;
for q =1:length(R_vect)
    if(~isnan(R_vect(q)))
        d_index(d) = q;
        d = d+1;
    end    
end

%%

d_i = zeros(1,n_data);
rng(777);
shuf = randperm(n_data);
cv_ind = [1:10000:n_data,n_data+1];
for q = 1:n_data
    d_i(q)=d_index(shuf(q));
end


%%
option.lambda = 1;
option.iter = 30; %reduce max iterations to speed up computation

n_cv = 1; test_sz = n_data/10;
err = zeros(1,n_cv);
%change k between 10,50,100
rng(111);
k = 10; 
% rng(111);
% k = 50;
% rng(1111);
% k = 100; 

threshold = 0.4:0.025:1.0;
t_l = length(threshold);
prec = zeros(n_cv,t_l);
rec = zeros(n_cv,t_l);

for l = 1:n_cv
    R_v = R_vect;
    for j =cv_ind(l):(cv_ind(l+1)-1)
        R_v(d_i(j)) = NaN;
    end
    R_cv = reshape(R_v,c,r)';
    
    [U,V,n_iter,time,f_resid] = wnmfrule_reg(R_cv,k,option);

    R_cv_new = U*V;
    R_cv_new_vect = reshape(R_cv_new',1,r*c);
    
    p_err = abs(R_cv_new-R_0);
    p_err_vect = reshape(p_err',1,r*c);
    tot_err = 0;
    for p = cv_ind(l):(cv_ind(l+1)-1)
        tot_err=tot_err+p_err_vect(d_i(p));
    end    
    err(l) = tot_err/test_sz;
    
    
    for z = 1:t_l
        n_p = 0; n_p_tot = 0;
        n_r = 0; n_r_tot = 0;
        for p = cv_ind(l):(cv_ind(l+1)-1)
            if (R_cv_new_vect(d_i(p))) > threshold(z)
                if (R_vect(d_i(p))) >= 3
                    n_p = n_p+1;
                end                    
                n_p_tot = n_p_tot+1;
            end
            if (R_vect(d_i(p))) >= 3
                if (R_cv_new_vect(d_i(p))) > threshold(z)
                    n_r = n_r+1;
                end                    
                n_r_tot = n_r_tot+1;
            end   
        end
        prec(l,z) = n_p/n_p_tot;
        rec(l,z) = n_r/n_r_tot;
        
    end
end


%%
avg_p = zeros(1,t_l);
avg_r = zeros(1,t_l);
for j = 1:t_l
    avg_p(j) = mean(prec(:,j));
    avg_r(j) = mean(rec(:,j));
end

%%
roc = avg_p./avg_r;
figure;
plot(threshold,roc);
xlabel('threshold'); ylabel('ROC');
title('Lambda=1');

%% Part 5

rng(5); 
option.lambda = 0.1;
option.iter = 50;
k = 10;  %change k between 10,50,100
n_cv = 1;

test_sz = n_data/10;

threshold = 0.4:0.025:1.0;
t_l = length(threshold);
prec = zeros(n_cv,t_l);
rec = zeros(n_cv,t_l);
%%
[r,c] = size(R);
R_vect = reshape(R',1,r*c);
W_vect = reshape(W',1,r*c);
d_index = zeros(1,n_data);
d = 1;
for q =1:length(R_vect)
    if(~isnan(R_vect(q)))
        d_index(d) = q;
        d = d+1;
    end    
end

d_i = zeros(1,n_data);
rng(777);
shuf = randperm(n_data);
cv_ind = [1:10000:n_data,n_data+1];
for q = 1:n_data
    d_i(q)=d_index(shuf(q));
end

%%
R_v = R_vect;
for j =cv_ind(l):(cv_ind(l+1)-1)
    R_v(d_i(j)) = NaN;
end
R_cv = reshape(R_v,c,r)';

[U,V,n_iter,time,f_resid] = wnmfrule_reg(R_cv,k,option);

%%

R_cv_new = U*V;
R_cv_new_vect = reshape(R_cv_new',1,r*c);

p_err = abs(R_cv_new-R_0);
p_err_vect = reshape(p_err',1,r*c);
tot_err = 0;
for p = cv_ind(l):(cv_ind(l+1)-1)
    tot_err=tot_err+p_err_vect(d_i(p));
end    
err = tot_err/test_sz;
%%

W = isnan(R);
R_0 = R; R_0(W) = 0;
W = ~W; W = double(W); 

W_cv = isnan(R_cv);
% R_cv0 = R_cv; R_cv0(W_cv) = 0;
% W_cv = ~W_cv; W_cv = double(W_cv); 
test_W = (W.*W_cv);
Rp = test_W.*R_cv_new;

%%
L = 5;
n_Act = zeros(1,r); n_Pred = zeros(1,r);
for f=1:r
    maxL = zeros(1,L);
    Rpc = Rp;
    for l=1:L
        [m,ind] = max(Rpc(f,:));
        maxL(l) = ind;
        Rpc(f,ind) = -inf;
    end
    n_p_tot=0; n_p=0;
    for y = 1:L
        if (Rp(maxL(y)) > 0)
           if R_cv_new(maxL(y)) > 0.9
              if R(maxL(y)) >= 3
                  n_p = n_p+1;
              end
              n_p_tot = n_p_tot+1;
           end
        end
    end
    n_Act(f) = n_p;
    n_Pred(f) = n_p_tot;
end

%%
sum(n_Act)/sum(n_Pred)

%%
Rp = test_W.*R_cv_new;
hit = zeros(1,10);
fa = zeros(1,10);

for L=1:10
    SUG = zeros(1,r); LIKE = zeros(1,r);
    FALSE = zeros(1,r); NOT = zeros(1,r);
    for f=1:r 
        maxL = zeros(1,L);
        Rpc = Rp;
        for l=1:L
            [m,ind] = max(Rpc(f,:));
            maxL(l) = ind;
            Rpc(f,ind) = -inf;
        end
        n_sug=0; n_like=0;
        n_f = 0; n_not =0;
        for y = 1:L
            if (Rp(maxL(y)) > 0)
               if R(maxL(y)) >= 3
                  if R_cv_new(maxL(y)) > 1
                      n_sug = n_sug+1;
                  end
                  n_like = n_like+1;
               end
               
               if R(maxL(y)) < 3
                  if R_cv_new(maxL(y)) > 1
                      n_f = n_f+1;
                  end
                 n_not = n_not+1;
               end
            end
        end
        SUG(f) = n_sug;
        LIKE(f) = n_like;
        FALSE(f) = n_f;
        NOT(f) = n_not;
    end
    hit(L) = sum(SUG)/sum(LIKE);
    fa(L) = sum(FALSE)/sum(NOT);
end

%%
scatter(hit,fa);
xlabel('Hit Rate');
ylabel('False Alarm Rate');
title('Hit vs. False Alarm Rates for various L');

%%
R_n2 = norm((W.*R_new-R_0));
R_nf = norm((W.*R_new-R_0),'fro');

e4 = [R_nf,R_n2];









