function randNumber = randLaplacian(mu, beta, sizeOut, method)
% RANDLAPLACIAN generates randome numbers with Laplacian distribution.
% Laplacian distribution is also called doubled exponential distribution:
%
%          Laplace(x|mu,beta) = 1/(2*beta)*exp(-|x-mu|/beta),
%
% where mu, beta>0 are real numbers, |.| returns the absolute value.
% The cumulative distribution function (CDF) is
%
%         p = F(x) = 1/2 + 1/2*sgn(x-mu)( 1 - exp(-|x-mu|/beta) ).
%
% The inverse CDF is
%
%         x = F^(-1)（p）= mu - beta*sgn(p-0.5)*ln(1-2*|p-0.5|).
%
% References:
% - https://en.wikipedia.org./wiki/Laplace_distribution
%
% Author:       Zekai Liang
% Last Update:  14.04.2021 Monday

% default Laplacian random number generation method: inverse CDF
if nargin < 4, method = "inverseCDF"; end

% if "size" is a scalar, add 1 as another dimension
if length(sizeOut) == 1, sizeOut = [sizeOut, 1]; end
if length(sizeOut) > 3, error('The dimension of output should be less than 3.'); end


if method == "inverseCDF"  % default method: from inverse CDF
    
    % generate uniform distribution in (-1/2, 1/2)
    U = rand(sizeOut) - 1/2;
    
    % generate Laplacian random numbers through inverse CDF
    randNumber = mu - beta * sign(U) * ln( 1 - 2 * abs(U) );
    
elseif method == "diff2Exp" % 2nd method: difference of two exponentials 
    
    % only work if mu == 0
    if mu ~= 0, error('mu must be zero in "diff2Exp" method.'); end
    
    % generate two independent exponential random variables
    randNumber = exprnd(1/beta) - exprnd(1/beta);
    
end

% end of function
end