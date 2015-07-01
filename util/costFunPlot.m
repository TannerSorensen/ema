function costFunPlot(xC,vC,Fs,eqn,pInit)
% See the webpage 
%  http://de.mathworks.com/help/optim/ug/optimizing-a-simulation-or-ordinary-differential-equation.html
    
    % Set optimization settings.
    options = optimset('MaxFunEvals',1500,'TolFun',1e-1,'TolX',1e-1);
    
    % Initialize return arguments.
    p=NaN(length(xC),length(pInit)+1);
    e=NaN(length(xC),1);
    
    % Optimize a random observation in XC.
    rng(9991);
    i = randi(length(xC));
    x = xC{i};
    t = 0:(1/Fs):(length(x)-1)*(1/Fs);
    v = vC{i};
    ic = [0,v(1)];
    x0 = x(end)-x(1);
    [p,e] = fminsearch(@(p) obj(p),pInit,options);
    
    % Systematically explore parameter space.
    pSpace(1,:) = linspace(0,2*p(1),40);
    pSpace(2,:) = linspace(0,2*p(2),40);
    eqn = 'n';
    cf = NaN(40,40);
    for j=1:40
        k=1;
        while k<41
            
            cf(j,k) = obj([pSpace(1,j) pSpace(2,k)]);
            if isnan(cf(j,k))
                k=41;
            else
                k=k+1;
            end
        end
    end
    figure(9)
    pcolor(pSpace(1,:),pSpace(2,:),log(cf)), hold on
    colormap(gray(10))
    colorbar
    scatter(p(1),p(2),10^2,[1 1 1],'+','LineWidth',2), hold off
    xlabel('$\omega $','Interpreter','LaTeX')
    ylabel('$d$','Interpreter','LaTeX','rot',0)
    
    
    function e = obj(p)
        
        try
            vHat = de(p);
            e = sum(((vHat-v)/length(v)).^2);
        catch err
            e = NaN;
        end
        
    end

    function vHat = de(p)
        
        % Find the solution to the system.
        switch eqn
            case 'l'
                omega = p;
                f = @(t,z)[z(2);...
                    -2*abs(omega)*z(2)-...
                    omega^2*(z(1)-x0)];
            case 'n'
                omega = p(1);
                kappa = p(2);
                f = @(t,z)[z(2);...
                    -2*abs(omega)*z(2)-...
                    omega^2*(z(1)-x0)+...
                    abs(kappa)*(z(1)-x0)^3];
        end
        
        vHat = deval(ode23t(f,t,ic),t);
        vHat = vHat(2,:)';
    end

end