%   Fertilizer - input data.

x = Fertilizer';
t = Target';



% Create a Fitting Network
hiddenLayerSize = 12;
TF={'tansig','purelin'};	% Transfer Function
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
net = newff(x,t,hiddenLayerSize,TF,trainFcn);
net.name = 'Model 4';
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

% Results for Target #1
% PlotResults(t(1,:),y(1,:),'All Data (1)');
% PlotResults(trainTargets(1,:),trainOutputs(1,:),'Train Data (1)');
% PlotResults(valTargets(1,:),valOutputs(1,:),'Validation Data (1)');
% PlotResults(testTargets(1,:),testOutputs(1,:),'Test Data (1)');

% Results for Target #2
% PlotResults(t(2,:),y(2,:),'All Data (2)');
% PlotResults(trainTargets(2,:),trainOutputs(2,:),'Train Data (2)');
% PlotResults(valTargets(2,:),valOutputs(2,:),'Validation Data (2)');
% PlotResults(testTargets(2,:),testOutputs(2,:),'Test Data (2)');

% Results for Target #2
% PlotResults(t(3,:),y(3,:),'All Data (3)');
% PlotResults(trainTargets(3,:),trainOutputs(3,:),'Train Data (3)');
% PlotResults(valTargets(3,:),valOutputs(3,:),'Validation Data (3)');
% PlotResults(testTargets(3,:),testOutputs(3,:),'Test Data (3)');

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
    genFunction(net,'simulationFunction');
    y = simulationFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'matrixOnlySimulationFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end
