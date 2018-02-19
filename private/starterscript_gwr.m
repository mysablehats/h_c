%start script
%load('../share/local_uniform_2d.mat')
%Data = simplecluster_dataset;
%pkg load image %statistics
NODES = 100;

params = struct();

params.use_gpu = false;
params.PLOTIT = true; 
params.RANDOMSTART = false; % if true it overrides the .startingpoint variable
params.RANDOMSET = true;
n = randperm(size(Data,2),2);
params.startingpoint = [n(1) n(2)];
params.removepoints = true;
params.flippoints = true;
params.normdim = true; %% if true normalize the distance by the number of dimensions 

params.amax = 50; %greatest allowed age
params.nodes = NODES; %maximum number of nodes/neurons in the gas
params.en = 0.006; %epsilon subscript n
params.eb = 0.2; %epsilon subscript b
params.MAX_EPOCHS = 10; % this means data will be run over MAX_EPOCHS times
params.gamma = 4;

%Exclusive for gwr
params.STATIC = true;
params.at = 0.90; %activity threshold
params.h0 = 1;
params.ab = 0.95;
params.an = 0.95;
params.tb = 3.33;
params.tn = 3.33;

% %Exclusive for gng
% params.lambda                   = 3;
% params.alpha                    = .5;     % q and f units error reduction constant.
% params.d                           = .99;   % Error reduction factor.
% 
% 
% 
% tic
% A = gas_wrapper(Data,params,'gwr');
% if params.PLOTIT
%     subplot(1,2,1)
%     hold on
% end
% plot(Data(1,:),Data(2,:), '.g', A(1,:)', A(2,:)', '.r')
% 
% toc

params.use_gpu = true;
tic
[A,~,~,GAS ]= gas_wrapper(Data,params,'gwr');
if params.PLOTIT
    subplot(1,2,1)
    hold on
end
plot(Data(1,:),Data(2,:), '.g', A(1,:)', A(2,:)', '.r')

toc

%scatter(A(1,:)', A(2,:)')