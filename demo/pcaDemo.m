
% Create 2D curve GAMMA parameterized by T.
t=5:14;
gamma=[t.^(1/2);log(t)]';

% Create 2D curve NU, again parameterized by T.
nu=gamma-5;

% Center GAMMA (same as centering NU).
cGamma = gamma-repmat(mean(gamma,1),size(gamma,1),1);

% Project GAMMA, NU, and normalized GAMMA onto PC.
[gammaHat,~]=pcaProj(gamma);
[nuHat,~]=pcaProj(nu);
[cGammaHat,pc]=pcaProj(cGamma);

% Initialize figure.
figure(1);
h1=subplot(3,2,1); hold on
title('$\gamma $','Interpreter','LaTeX')
xlim([-6 6]), xlabel('X')
ylim([-6 6]), ylabel('Y')
axis square
h3=subplot(3,2,3); hold on
title('$\nu $','Interpreter','LaTeX')
xlim([-6 6]), xlabel('X')
ylim([-6 6]), ylabel('Y')
axis square
h5=subplot(3,2,5); hold on
title('$$\gamma -\bar{\gamma}$$','Interpreter','LaTeX')
xlim([-6 6]), xlabel('X')
ylim([-6 6]), ylabel('Y')
axis square

h2=subplot(3,2,2); hold on
title('projection onto PC')
xlim([4 15]), xlabel('t')
ylim([-6 6]), ylabel('$$\hat{\gamma}$$','Interpreter','LaTeX')
axis square
h4=subplot(3,2,4); hold on
title('projection onto PC')
xlim([4 15]), xlabel('t')
ylim([-6 6]), ylabel('$$\hat{\nu}$$','Interpreter','LaTeX')
axis square


h6=subplot(3,2,6); hold on
title('projection onto PC')
xlim([4 15]), xlabel('t')
ylim([-6 6]), ylabel('$$\hat{\nu}$$','Interpreter','LaTeX')
axis square

% Plot GAMMA and PC.
axes(h1)
plot(gamma(:,1),gamma(:,2),'.-black')
quiver(zeros(2,1),zeros(2,1),pc(:,1),pc(:,2));

% Plot projection of GAMMA onto PC.
axes(h2)
plot(t,gammaHat,'.-black')

% Plot NU and PC.
axes(h3)
hold on
plot(nu(:,1),nu(:,2),'.-black')
quiver(zeros(2,1),zeros(2,1),pc(:,1),pc(:,2));
hold off

% Plot projection of NU onto PC.
axes(h4)
plot(t,nuHat,'.-black')

% Plot GAMMA (centered) and PC.
axes(h5)
hold on
plot(cGamma(:,1),cGamma(:,2),'.-black')
quiver(zeros(2,1),zeros(2,1),pc(:,1),pc(:,2));
hold off

% Plot projection of GAMMA (centered) onto PC.
axes(h6)
plot(t,cGammaHat,'.-black')