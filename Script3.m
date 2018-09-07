%   Fertilizer - input data.
%   CUG - target data.

x = Fertilizer';
t = CUG';



% Create a Fitting Network
hiddenLayerSize = 12;
TF={'tansig','purelin'};	% Transfer Function
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
net = newff(x,t,hiddenLayerSize,TF,trainFcn);
net.name = 'Model 3';
net.userdata.note = 'created by Hamed Rezayat';

% Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Performance Function
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
net.plotFcns = {'plotperform', 'ploterrhist', 'plotregression', 'plotfit'};

% Train Parameters
net.trainParam.showWindow=true;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=1000;
net.trainParam.goal=1e-8;
net.trainParam.max_fail=10;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainInd=tr.trainInd;
trainInputs = x(:,trainInd);
trainTargets = t(:,trainInd);
trainOutputs = y(:,trainInd);
trainErrors = trainTargets-trainOutputs;
trainPerformance = perform(net,trainTargets,trainOutputs);

valInd=tr.valInd;
valInputs = x(:,valInd);
valTargets = t(:,valInd);
valOutputs = y(:,valInd);
valErrors = valTargets-valOutputs;
valPerformance = perform(net,valTargets,valOutputs);

testInd=tr.testInd;
testInputs = x(:,testInd);
testTargets = t(:,testInd);
testOutputs = y(:,testInd);
testError = testTargets-testOutputs;
testPerformance = perform(net,testTargets,testOutputs);

% PlotResults(t,y,'All Data');
% PlotResults(trainTargets,trainOutputs,'Train Data');
% PlotResults(valTargets,valOutputs,'Validation Data');
% PlotResults(testTargets,testOutputs,'Test Data');

% View the Network
% view(net);

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotfit(net,x,t)
% figure;
% plotregression(trainTargets,trainOutputs,'Train Data',...
    % valTargets,valOutputs,'Validation Data',...
    % testTargets,testOutputs,'Test Data',...
    % t,y,'All Data')

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
if (false)
    % Generate MATLAB function for neural network for application deployment
    genFunction(net,'simulationFunction1');
    y = simulationFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'matrixOnlySimulationFunction1','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end
