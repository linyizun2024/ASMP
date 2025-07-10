function [u] = iotarho( x, rho1, rho2 )

if x<rho1
    u = rho1;
elseif x>rho2
    u = rho2;
else
    u = x;
end
        
end

