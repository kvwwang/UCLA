function [A,Y,numIter,tElapsed,finalResidual]=wnmfrule_4(X,k,option)

tStart=tic;
optionDefault.distance='ls';
optionDefault.iter=1000;
optionDefault.dis=true;
optionDefault.residual=1e-4;
optionDefault.tof=1e-4;
if nargin<3
   option=optionDefault;
else
    option=mergeOption(option,optionDefault);
end

% Weight
W=isnan(X);
X(W)=0;
W=~W;

% Switch weights with data matrix
Q = W; 
W = X;
X = Q;

% iter: number of iterations
[r,c]=size(X); % c is # of samples, r is # of features
Y=rand(k,c);
% Y(Y<eps)=0;
Y=max(Y,eps);
A=X/Y;
% A(A<eps)=0;
A=max(A,eps);
XfitPrevious=Inf;
for i=1:option.iter
    switch option.distance
        case 'ls'
            A=A.*(((W.*X)*Y')./((W.*(A*Y))*Y'));
%             A(A<eps)=0;
                A=max(A,eps);
            Y=Y.*((A'*(W.*X))./(A'*(W.*(A*Y))));
%             Y(Y<eps)=0;
                Y=max(Y,eps);
        case 'kl'
            A=(A./(W*Y')) .* ( ((W.*X)./(A*Y))*Y');
            A=max(A,eps);
            Y=(Y./(A'*W)) .* (A'*((W.*X)./(AY)));
            Y=max(Y,eps);
        otherwise
            error('Please select the correct distance: option.distance=''ls''; or option.distance=''kl'';');
    end
    if mod(i,10)==0 || i==option.iter
        if option.dis
            disp(['Iterating >>>>>> ', num2str(i),'th']);
        end
        XfitThis=A*Y;
        fitRes=matrixNorm(W.*(XfitPrevious-XfitThis));
        XfitPrevious=XfitThis;
        curRes=norm(W.*(X-XfitThis),'fro');
        if option.tof>=fitRes || option.residual>=curRes || i==option.iter
            s=sprintf('Mutiple update rules based NMF successes! \n # of iterations is %0.0d. \n The final residual is %0.4d.',i,curRes);
            disp(s);
            numIter=i;
            finalResidual=curRes;
            break;
        end
    end
end
tElapsed=toc(tStart);
end
