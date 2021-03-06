function [] = Plot_BasicSimulationTimePlot(flightdata,environment,params, plane)
% Basic plot of flight data vs. time
%   Plot_BasicSimulationTimePlot(...) plots the flightdata (altitude, batters
%   state, all power input and output components) over time.

    time = flightdata.t_array ./3600;

    str=strcat('24h flight overview',' b=',num2str(flightdata.b),' AR=',num2str(flightdata.AR),' mbat=',num2str(flightdata.m_bat));%: DayOfYear=',num2str(environment.dayofyear),' CLR=',num2str(environment.clearness),' Turb=',num2str(environment.turbulence),' b=',num2str(plane.struct.b),' AR=',num2str(plane.struct.AR),' mbat=',num2str(plane.bat.m));
    figurehandle = figure('Name',str);
    
    plotmargins.horiz = 0.05;
    plotmargins.vert = 0.018;
    plotmargins.vert_last = 0.05;
    
    % Altitude
    ax(1)=subplot_tight(5,1,1,[plotmargins.vert plotmargins.horiz]);
    dh_array=zeros(size(flightdata.h_array));
    dh_array(1)=0;
    for i=2:size(flightdata.h_array,2)
        dh_array(i)=flightdata.h_array(i)-flightdata.h_array(i-1);
    end
    plot(time, flightdata.h_array);
    legend('h');
    ylabel('Altitude above MSL [m]');

    %Angles & Sun
    ax(end+1)=subplot_tight(5,1,2,[plotmargins.vert plotmargins.horiz]);
    plot(time, flightdata.irr_array(3,:) * 180 / pi());
    ylabel('Angles');
    legend('Sun incidence angle [�]');
    
    % Battery state
    subplot_tight(5,1,3,[plotmargins.vert plotmargins.horiz]);
    E_bat_max = plane.bat.m * params.bat.e_density;
    [ax(end+1:end+2),~,~] = plotyy(time, flightdata.bat_array/E_bat_max, time, flightdata.bat_array/3600);
    ylabel('Battery Charge State');
    legend('Battery SoC[%]','Battery Energy [Wh]');

    %Power in- and output
    ax(end+1)=subplot_tight(5,1,4,[plotmargins.vert plotmargins.horiz]);
    plot(time, flightdata.P_solar_array,...
         time, flightdata.P_elec_tot_array,...
         time, flightdata.P_prop_array,...
         time, ones(1,numel(flightdata.t_array))*plane.avionics.power,...
         time, flightdata.P_charge_array,...
         time, ones(1,numel(flightdata.t_array))*plane.payload.power);
    ylabel('Power [W] or [W/m^2]');
    legend('P_{Solar}[W]','P_{electot}[W]','P_{prop}[W]','P_{avionics}[W]','P_{battery}[W]','P_{payload}[W]');
    
    %Angles & Sun
    ax(end+1)=subplot_tight(5,1,5,[plotmargins.vert_last plotmargins.horiz]);
    plot(time, [flightdata.eta_array(1,:) ; flightdata.eta_array(2,:)]);
    ylabel('Efficiency');
    legend('\eta_{sm}','\epsilon_{AOI}');
    
    xlabel('Time of Day [h]');
    
    for i=numel(ax)-1:-1:1
        set(ax(i),'XTickLabel','');
    end
    %dcm_obj = datacursormode(figurehandle);
    %set(dcm_obj,'UpdateFcn',{@PlotPrecisionCallback});
    linkaxes(ax,'x');
end

