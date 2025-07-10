function [u] = mysimpproj(x)

% Inputs:
% x: Input vector

% Outputs:
% u: projection of x on the simplex w>=0 and sum(w)=1

x = x(:);
N = numel(x);
u = sort(x,'descend');
csu = cumsum(u);
jprime = find(u>(csu-1)./(1:N)', 1, 'last');
theta = (csu(jprime)-1)/jprime;
u = max(x-theta, 0);

end