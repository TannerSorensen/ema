function [p,e] = dePar(xC,vC,Fs,eqn,pInit)
% See the webpage 
%  http://de.mathworks.com/help/optim/ug/optimizing-a-simulation-or-ordinary-differential-equation.html
    
    % Set optimization settings.
    options = optimset('MaxFunEvals',1500,'TolFun',1e-1,'TolX',1e-1,...
        'PlotFcns',@optimplotx);
    
    % Initialize return arguments.
    p=NaN(length(xC),length(pInit)+1);
    e=NaN(length(xC),1);
    
    % Estimate parameters.
    wb = waitbar(0,'');
    for i=1:length(xC)
        x = xC{i};
        t = 0:(1/Fs):(length(x)-1)*(1/Fs);
        v = vC{i};
        ic = [0,v(1)];
        x0 = x(end)-x(1);
        [p(i,1:end-1),e(i)] = fminsearch(@(p) obj(p),pInit,options);
        p(i,end) = x0;
        waitbar(i/length(xC),wb,sprintf('%d%%',ceil(100*i/length(xC))))
    end
    close(wb)

    function e = obj(p)
        
        try
            vHat = de(p);
            e = sum(((vHat-v)/length(v)).^2);
        catch err
            e = Inf;
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