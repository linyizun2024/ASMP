function [CW,all_w] = Averagestrategy(Param,data)

fullR = (data-1);
[fullT,N] = size(fullR);
T_end = fullT;
all_w = ones(N,fullT)/N;
CW = zeros(T_end,1);
S = 1;

for t = 1:T_end
    % Adjust portfolio for the transaction cost issue
    if t==1
        daily_port_o = zeros(N,1);
    else
        daily_port_o = all_w(:,t-1).*data(t-1, :)'/(data(t-1, :)*all_w(:,t-1));
    end
    S = S*data(t,:)*all_w(:,t)*(1-Param.trancost/2*sum(abs(all_w(:,t)-daily_port_o)));
    CW(t) = S;
end

end