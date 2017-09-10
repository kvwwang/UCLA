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
option.iter = 500;

%% Part 1
rng(5); 
k = 100;  %change k between 10,50,100
[U,V,n_iter,time,f_resid] = wnmfrule(R,k,option);

R_new = U*V;
R_n2 = norm((W.*R_new-R_0));

%% Part 2
[r,c] = size(R);
R_vect = reshape(R',1,r*c);
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
option.iter = 200; %reduce max iterations to speed up computation

%%

n_cv = 10; test_sz = n_data/10;
err = zeros(1,n_cv);
%change k between 10,50,100
% rng(111);
% k = 10; 
rng(111);
k = 50;
% rng(1111);
% k = 100; 


for l = 1:n_cv
    R_v = R_vect;
    for j =cv_ind(l):(cv_ind(l+1)-1)
        R_v(d_i(j)) = NaN;
    end
    R_cv = reshape(R_v,c,r)';
    
    [U,V,n_iter,time,f_resid] = wnmfrule(R_cv,k,option);

    R_cv_new = U*V;
    p_err = abs(R_cv_new-R_0);
    p_err_vect = reshape(p_err',1,r*c);
    tot_err = 0;
    for p = cv_ind(l):(cv_ind(l+1)-1)
        tot_err=tot_err+p_err_vect(d_i(p));
    end
    err(l) = tot_err/test_sz;
end

%%
avg_err = mean(err);
max_err = max(err);
min_err = min(err);
err_ = [avg_err,max_err,min_err];

%% Part 3
[r,c] = size(R);
R_vect = reshape(R',1,r*c);
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
option.iter = 200; %reduce max iterations to speed up computation
%%
n_cv = 10; test_sz = n_data/10;
err = zeros(1,n_cv);
%change k between 10,50,100
% rng(111);
% k = 10; 
% rng(111);
% k = 50;
rng(1111);
k = 100; 

% threshold = 2.5:0.01:3.5; 
threshold = 1.5:0.1:4.5;
t_l = length(threshold);
prec = zeros(n_cv,t_l);
rec = zeros(n_cv,t_l);

for l = 1:n_cv
    R_v = R_vect;
    for j =cv_ind(l):(cv_ind(l+1)-1)
        R_v(d_i(j)) = NaN;
    end
    R_cv = reshape(R_v,c,r)';
    
    [U,V,n_iter,time,f_resid] = wnmfrule(R_cv,k,option);

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
                if (R_vect(d_i(p))) > threshold(z)
                    n_p = n_p+1;
                end                    
                n_p_tot = n_p_tot+1;
            end
            if (R_vect(d_i(p))) > threshold(z)
                if (R_cv_new_vect(d_i(p))) > threshold(z)
                    n_r = n_r+1;
                end                    
                n_r_tot = n_r_tot+1;
            end   
        end
        prec(l,z) = n_p/n_p_tot;
        rec(l,z) = n_r/n_r_tot;
        
    end
    l
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
plot(threshold,roc);
xlabel('threshold'); ylabel('ROC');

% title('ROC for k=10');
% title('ROC for k=50');
title('ROC for k=100');






