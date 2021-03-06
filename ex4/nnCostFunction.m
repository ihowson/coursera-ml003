function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

h1 = sigmoid([ones(m, 1) X] * Theta1');
a = sigmoid([ones(m, 1) h1] * Theta2');
% p = predict(Theta1, Theta2, X);
% a = zeros(m, num_labels);
% for i=1:m,
%     a(i, p(i,1)) = 1;
% end

loga = log(a);

flaty = zeros(m, num_labels);
for i=1:m,
    flaty(i, y(i,1)) = 1;
end

term1 = -1 * flaty .* loga;

oneminusY = ones(size(flaty)) - flaty;
oneminusA = ones(size(a)) - a;
term2 = -1 * oneminusY .* log(oneminusA);

J = sum(sum((term1 + term2))) / m;

% regularization terms
t1 = sum(sum(Theta1(:,2:end) .^ 2));
t2 = sum(sum(Theta2(:,2:end) .^ 2));
J = J + (lambda / (2 * m)) * (t1 + t2);

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

Delta1 = zeros(size(Theta1));
Delta2 = zeros(size(Theta2));

for t=1:m,
    % step 1: calculate activations
    % these are all row vectors
    a1 = [1 X(t,:)];
    z2 = a1 * Theta1';
    a2 = [1 sigmoid(z2)];
    z3 = a2 * Theta2';

    a3 = sigmoid(z3)'; % col vec

    % step 2: calculate delta for output layer
    ylogical = flaty(t,:)';
    delta3 = a3 - ylogical;

    % step 3: calculate delta for hidden layer
    z2 = [1 z2];
    delta2 = (delta3' * Theta2 .* sigmoidGradient(z2))';

    % step 4: accumulate gradient
    Delta1 = Delta1 + delta2(2:end) * a1; % skip the first element of delta2
    Delta2 = Delta2 + delta3 * a2;
end

Theta1_grad = Delta1 ./ m;
Theta2_grad = Delta2 ./ m;


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

regterm1 = (lambda / m) .* Theta1;
regterm2 = (lambda / m) .* Theta2;

% zero regterms for j = 0
regterm1(:, 1) = 0;
regterm2(:, 1) = 0;

Theta1_grad = Theta1_grad + regterm1;
Theta2_grad = Theta2_grad + regterm2;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
