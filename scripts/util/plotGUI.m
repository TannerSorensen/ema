function plotGUI(S,t,x,x_t,articulator,srate,audioSrate,spect,vargin,leRe)
    % PLOTGUI - plot the spectrogram of the acoustic signal and the
    % displacement and tangential velocity of the articulator ARTICULATOR
    % signal.
    % If VARGIN is provided, then plot the delimited interval as a
    % (possibly PCA projected) velocity profile in the bottom panel on top
    % of the original tangential velocity signal.
    % 
    % ARGUMENTS:
    % 1. S - structure array containing as its first field 'AUDIO', which
    % contains the acoustic waveform SIGNAL.
    % 2. T - time argument to articulator signal X in milliseconds.
    % length(x)==length(t).
    % 3. X - articulator signal measured in millimeters.
    % 4. X_T - tangential velocity of X. length(x_t)==length(x)
    % 5. ARTICULATOR - string whose value is such that
    % S.(articulator).SIGNAL is the same matrix as X.
    % 6. SRATE - sampling rate of the articulator movement trace.
    % SRATE==S.(articulator).SRATE.
    % 7. audioSrate - sampling rate of the acoustic signal.
    % AUDIOSRATE==S(1).SRATE.
    % 8. VARGIN - cell array whose first six elements are time points in
    % millisecondds and the tangential velocity of the (possibly projected)
    % signal X. 
    %    a. LE - left edge (msec)
    %    b. LEV - left edge velocity (cm/sec)
    %    c. TPV - center (msec)
    %    d. PV - center (cm/sec)
    %    e. RE - right edge (msec)
    %    f. REV - right edge (cm/sec)
    % 9. LERE - double array whose first entry is the left edge of the
    % audio in msec and whose second entry is the right edge of the audio
    % in msec. Used in particular for long XRMB passages. In these cases, X
    % and X_T have already been segmented.
    % 10. SPECT - logical (1-spectrogram,0-no spectrogram)
    % 
    % TS, Jan. 2015
    
    if 8 <= nargin <= 10
        % assign variables
        if nargin == 10
            audio = double(S(1).SIGNAL(ms2sampl(leRe(1),audioSrate):ms2sampl(leRe(2),audioSrate)));
        else
            audio = double(S(1).SIGNAL);
        end
        
        % Open figure and set graphical parameters.
        figure(1);
        bottom1=.7;bottom2=.4;bottom3=.1;left=.15;width=.8;height1=.24;height2=.28;
        
        % top panel: spectrogram (optional)
        if spect
            axes('Position',[left bottom1 width height1]);
            segmentlen = round(10*audioSrate/1000); % 10 msec
            noverlap=round(.99*segmentlen);
            [~,f,spectT,p] = spectrogram(audio,segmentlen,noverlap,[],audioSrate);
            ind = find(f<8000); % 8000Hz cut-off
            surf(spectT./1000,f(ind),10*log10(abs(p(ind,:))),'EdgeColor','none');
            set(gca,'xlim',[0,8000]),axis xy, axis tight, colormap(gray), view(0,90);
            ylabel('Frequency (Hz)'),title(articulator)
            set(gca,'XTickLabel',[],'XTick',[])
        end
        
        % middle panel: displacement
        axes('Position',[left bottom2 width height2]);
        colr = [.8,.3,.3;.3,.8,.3;.3,.3,.8];
        for i=1:size(x,2)
            plot(t,x(:,i)-mean(x(:,i)),'Color',colr(i,:),'LineWidth',2), hold on
        end
        ylabel('x-red, y-green (mm)')
        h = gca;
        set(h,'XTickLabel',[],'XTick',[]),xlim([t(1),t(end)])
        
        % bottom panel: velocity
        axes('Position',[left bottom3 width height2]);
        plot(t,x_t,'LineWidth',2), hold on
        ylabel('tangential velocity (cm/sec)'),xlabel('time (msec)')
        xlim([t(1),t(end)]); ylim([-1 40]);
    else
        error('Error: plotGUI is not called correctly.');
    end
    
    if nargin >= 9
        if ~isempty(vargin)
            [le,lev,tpv,pv,re,rev,vp] = deal(vargin{:});
            projT = le+sampl2ms(1:length(vp),srate).';
            plot(projT,vp,'Color',[0.8,0.2,0.2],'LineWidth',2);
            scatter(le,lev,120,[0.9,0.2,0.2],'filled'); 
            scatter(tpv,pv,120,[0.2,0.9,0.2],'filled'); 
            scatter(re,rev,120,[0.2,0.2,0.9],'filled');
            axes(h);
            scatter([le re],[0 0],'black','filled');
            plot([le re],[0 0],'black');
        end
    end
    hold off
end