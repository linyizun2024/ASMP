function [w] = AFBA2(Param,matR,vecmu)
%% Input
% Param: Model and algorithm parameters
% matR: matrix R
% vecmu: vector mu

%% Output
% w: Combination coefficients of the securities

%% Initialization
[T,N] = size(matR);

[wt] = AFBA1(Param,matR,vecmu);
[~,b] = sort(wt);

m = max(4,ceil(Param.mm*N));
n = N-m;

matR(:,b(1:n))=[];

Sigmam = matR'*matR/T;
Sigmal = [Sigmam, zeros(m,1); zeros(1,m), 0];
vecmul = [vecmu(b(n+1:N)); -1];

Lipconst = 2*norm(Sigmal+Param.lambda*vecmul*vecmul',2);
beta = Param.betacoe*2/Lipconst;

u_pre = [ones(m,1)/m; (Param.rho1+Param.rho2)/2];
u = [ones(m,1)/m; (Param.rho1+Param.rho2)/2];

RE = zeros(Param.MaxIter+1,1);
RE(1) = inf;

%% FPPA iteration
k = 1;
while k<=Param.MaxIter && RE(k)>Param.tol
    z = u+(Param.a*(k-2).^Param.omega+Param.b-1)/(Param.a*(k-1).^Param.omega+Param.b)*(u-u_pre);
    u_pre = u;
    subgraddesc = z-2*beta*(Sigmal*z+Param.lambda*vecmul*z'*vecmul);
    u = [mysimpproj(subgraddesc(1:m)); iotarho(subgraddesc(m+1), Param.rho1, Param.rho2)];
    
    if mod(k,1000)==0
        fprintf('AFBA2: This is the %d iteration....\n',k);
    end
    
    k = k+1;
    RE(k) = norm(u-u_pre,2)/norm(u_pre,2); 
end

ws = zeros(N,1);
a = sort(b(n+1:N));
for i = 1:m
    ws(a(i)) = u(i);
end
w = ws;

end