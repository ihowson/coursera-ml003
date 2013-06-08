function [J, grad] = lrCostFunction(theta, X, y, lambda)
%LRCOSTFUNCTION Compute cost and gradient for logistic regression with 
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

H = sigmoid(X * theta); % the h_theta(x^(i)) term for this iteration

% printf('lrCostFunction\n');
% disp(H);

term1 = -y .* log(H);


oneminusH = 1 - H;
logH = log(oneminusH);
oneminusY = 1 - y;
term2 = oneminusY .* logH;

termsum = term1 - term2;
% termsum should be a vector

J = sum(termsum) / m;

% calculate the gradients
betai = H - y;
grad = X' * betai / m; % the summation at the bottom of page 6 of ex3.pdf


% J should be a scalar

%J = J + (-y(i) * log(h) - (1 - y(i)) * log(1 - h));

if 0,
    for i = 1:m,
        %printf('h = \n');
        % disp(h);

        % J = J + -y(i) * log(h) - 1 + y(i)) * log(1 - h));
        for j = 1:nFeatures;
            grad(j, 1) = grad(j, 1) + (h - y(i)) * X(i, j);
        end

    end
    J = J / m;
    grad = grad / m;
end



% Hint: The computation of the cost function and gradients can be
%       efficiently vectorized. For example, consider the computation
%
%           sigmoid(X * theta)
%
%       Each row of the resulting matrix will contain the value of the
%       prediction for that example. You can make use of this to vectorize
%       the cost function and gradient computations. 
%
% Hint: When computing the gradient of the regularized cost function, 
%       there're many possible vectorized solutions, but one solution
%       looks like:
%           grad = (unregularized gradient for logistic regression)
%           temp = theta; 
%           temp(1) = 0;   % because we don't add anything for j = 0  
%           grad = grad + YOUR_CODE_HERE (using the temp variable)
%


end
