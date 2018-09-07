% Licensed under the Apache License, Version 2.0

% Produce all the possible combinations of fertilizer provided the same amount of each is used

% results columns: FG%, GI, CUG, Score
inputs = zeros(2047,11);
results = zeros(2047,4);

index = 1;
% k = number of elements in each combination
for k = (1:11)
	combinations = combnk(1:11,k);
	% i = enumerate all combinations of length k
	for i = (1:size(combinations, 1))
		inputRow = [0,0,0,0,0,0,0,0,0,0,0];
		% enumerate each combinations elements
		for j = (1:k)
			inputRow(combinations(i, j)) = 1/k;
		end
		inputs(index,1:11) = inputRow;
		index = index + 1;
	end
end

% produce output
for index = (1:2047)
	results(index, 1:3) = simulationFunction(transpose(inputs(index,1:11)));
end

% calculate scores
normalFG = mapminmax(results(1:end, 1)', 0, 1);
normalGI = mapminmax(results(1:end, 2)', 0, 1);
normalCUG = mapminmax(results(1:end, 3)', 0, 1);

for index = (1:2047)
	results(index, 4) = 0.1 * normalFG(index) + 0.5 * normalGI(index) + 0.4 * normalCUG(index);
end

sortedResults = sortrows(results,4,'descend');
