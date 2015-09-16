function gp = figInit(a,Fa,s,Fs,fn)
% Input: 
%   A - vector of double, audio signal
%   FA - integer, audio signal sampling frequency
%   S - vector of double, EMA signal
%   FS - integer, EMA sampling frequency
%   FN - string, file name

    set(0,'DefaultFigureWindowStyle','docked')
    gp.f=figure(1);
    set(gp.f,'KeyPressFcn', @keyPress);
    
    % Dimensions of four panels.
    gp.bottom=linspace(0.7,0.1,4);
    gp.height=0.2-0.01;
    gp.left=0.15;
    gp.width=0.8;
    
    gp.h1=axes('Position',[gp.left gp.bottom(1) gp.width gp.height]);
    title( fn, 'Interpreter', 'none'), hold on
    gp.h2=axes('Position',[gp.left gp.bottom(2) gp.width gp.height]);
    gp.h3=axes('Position',[gp.left gp.bottom(3) gp.width gp.height]);
    gp.h4=axes('Position',[gp.left gp.bottom(4) gp.width gp.height]);
    
    linkaxes([gp.h2 gp.h3 gp.h4],'x')
    
    %--------------------------------
    % GUI BUTTONS, FIELDS, SLIDERS:
    %--------------------------------
    % Instantiate audio player object.
    gp.ap=audioplayer(a,Fa);
    % play button
    gp.play = uicontrol('Style', 'pushbutton', 'String', 'play',...
        'Position', [20 5 50 20],...
        'Callback', @playSelection);  
    % stop button
    gp.stop = uicontrol('Style', 'pushbutton', 'String', 'stop',...
        'Position', [90 5 50 20],...
        'Callback', @stopSelection);
    % xlim slider
    uicontrol('Style', 'slider',...
        'Min',0,'Max',sampl2ms(size(s,1)-1,Fs),...
        'Value',ceil(sampl2ms(size(s,1)-1,Fs)/2),...
        'Position', [440 5 100 20],...
        'Callback', @slidexlim); 
    % window size slider
    gp.winSizeField = uicontrol('Style','edit',...
        'String','700','Position',[560,5,50,20]);
    % confirm selection (advance)
    gp.confirmToggle = uicontrol('Style','togglebutton',...
        'String','advance','Min',0,'Max',1,'Value',0,...
        'Position',[160 5 50 20]);
    % back
    gp.backToggle = uicontrol('Style','togglebutton',...
        'String','back','Min',0,'Max',1,'Value',0,...
        'Position',[370 5 50 20]);
    % select
    gp.selectToggle = uicontrol('Style','togglebutton',...
        'String','select','Min',0,'Max',1,'Value',0,...
        'Position',[230 5 50 20]);
    % skip
    gp.skipToggle = uicontrol('Style', 'togglebutton',...
        'String', 'skip','Min',0,'Max',1,'Value',0,...
        'Position',[300 5 50 20]);
    
    function playSelection(source,callbackdata)
        win=ms2sampl(get(gp.h2,'xlim'),Fa);
        win(1)=max(1,win(1));
        win(2)=min(length(a),win(2));
        play(gp.ap,win);
    end
    function stopSelection(source,callbackdata)
        stop(gp.ap);
    end
    function slidexlim(source,callbackdata)
        c = get(source,'Value');
        ws = str2double(get(gp.winSizeField,'String'));
        win = ceil([-ws ws]/2);
        win = c+win;
        xlim(gp.h2,win);
    end
    function keyPress(src, e)
        % Assigns keyboard shortcuts to GUI buttons.
         switch e.Key
             case 's'
                 set(gp.selectToggle,'Value',...
                     ~get(gp.selectToggle,'Value'));
             case 'd'
                 set(gp.confirmToggle,'Value',...
                     ~get(gp.confirmToggle,'Value'));
         end
      end
end