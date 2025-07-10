function [w] = AFBA1(Param,matR,vecmu)
%% Input
% Param: Model and algorithm parameters
% matR: matrix R
% vecmu: vector mu

%% Output
% w: Combination coefficients of the securities

%% Initialization
[T,N] = size(matR);

Sigma = matR'*matR/T;
Sigmat = [Sigma, zeros(N,1); zeros(1,N), 0];
vecmut = [vecmu; -1];

Lipconst = 2*norm(Sigmat+Param.lambda*vecmut*vecmut',2);
beta = Param.betacoe*2/Lipconst;

v_pre = [ones(N,1)/N; (Param.rho1+Param.rho2)/2];
v = [ones(N,1)/N; (Param.rho1+Param.rho2)/2];

RE = zeros(Param.MaxIter+1,1);
RE(1) = inf;

%% FPPA iteration
k = 1;
while k<=Param.MaxIter && RE(k)>Param.tol
    y = v+(Param.a*(k-2).^Param.omega+Param.b-1)/(Param.a*(k-1).^Param.omega+Param.b)*(v-v_pre);
    v_pre = v;
    subgraddesc = y-2*beta*(Sigmat*y+Param.lambda*vecmut*y'*vecmut);
    v = [mysimpproj(subgraddesc(1:N)); iotarho(subgraddesc(N+1), Param.rho1, Param.rho2)];
    
    k = k+1;
    RE(k+1) = norm(v-v_pre,2)/norm(v_pre,2); 
end

w = v(1:N);

end