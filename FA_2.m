function varargout = FA_2(varargin)
% FA_2 MATLAB code for FA_2.fig
%      FA_2, by itself, creates a new FA_2 or raises the existing
%      singleton*.
%
%      H = FA_2 returns the handle to a new FA_2 or the handle to
%      the existing singleton*.
%
%      FA_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FA_2.M with the given input arguments.
%
%      FA_2('Property','Value',...) creates a new FA_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FA_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FA_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FA_2

% Last Modified by GUIDE v2.5 11-Nov-2019 11:20:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FA_2_OpeningFcn, ...
                   'gui_OutputFcn',  @FA_2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FA_2 is made visible.
function FA_2_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for FA_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FA_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FA_2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% ========== CALCULATE PC  =========================
function pushbutton1_Callback(hObject, eventdata, handles)
global D
D.Num_Variables=size(D.R,2);
D.PC.pc=1;
D.PC.NumberOfFactors=(get(findobj('Tag','NumberOfFactors'),'Value'));
optionsRoT=cellstr(get(findobj('Tag','RotationType'),'String'));
D.PC.RotationType=...
    optionsRoT{get(findobj('Tag','RotationType'),'Value')};
optionsFScCM=cellstr(get(findobj('Tag','FactorScoreCalcMeth'),'String'));
D.PC.FactorScoreCalcMeth=...
    optionsFScCM{get(findobj('Tag','FactorScoreCalcMeth'),'Value')};

if D.PC.pc==1;
    D=fa_PC (D);
end

[a,b]=size(D.PC.Table);
D.PC.TableCell=cell(a,b);
for i=1:a
    for j=1:b
        if D.PC.Table(i,j)==0;
            D.PC.TableCell{i,j}='-';
        else
            D.PC.TableCell{i,j}=D.PC.Table(i,j);
        end
            
    end
end

set (handles.uitable1,'Data', D.PC.TableCell)        
set (handles.uitable1,'RowName', [D.colheaders '----' 'CumPropOfTotVar']);
set (handles.uitable1,'ColumnName', D.PC.Headrs);

name = strsplit(D.file,'.');
name=[name{1} '_2' '.mat'];
save (name);    


% ================== CALCULATE ML  =========================
function pushbutton2_Callback(hObject, eventdata, handles)
global D
D.Num_Variables=size(D.R,2);
D.ML.ml=1;
D.ML.NumberOfFactors=(get(findobj('Tag','popupmenu4'),'Value'));
optionsRoT=cellstr(get(findobj('Tag','popupmenu5'),'String'));
D.ML.RotationType=...
    optionsRoT{get(findobj('Tag','popupmenu5'),'Value')};
optionsFScCM=cellstr(get(findobj('Tag','popupmenu6'),'String'));
D.ML.FactorScoreCalcMeth=...
    optionsFScCM{get(findobj('Tag','popupmenu6'),'Value')};

if D.ML.ml==1;
    D = fa_ML (D);
end

[a,b]=size(D.ML.Table);
D.ML.TableCell=cell(a,b);
for i=1:a
    for j=1:b
        if D.ML.Table(i,j)==0;
            D.ML.TableCell{i,j}='-';
        else
            D.ML.TableCell{i,j}=D.ML.Table(i,j);
        end
            
    end
end
set (handles.uitable2,'Data', D.ML.TableCell) 
set (handles.uitable2,'RowName', [D.colheaders '----' 'CumPropOfTotVar']);
set (handles.uitable2,'ColumnName', D.ML.Headrs);
clear a b

try
    set(findobj('Tag','pvalue'),'String',num2str(D.ML.stats.p));
catch
    set(findobj('Tag','pvalue'),'String','Not available')
    msgbox('Warning: Some unique variances are zero: cannot compute significance');
end

name = strsplit(D.file,'.');
name=[name{1} '_2' '.mat'];
save (name);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global D
if D.PC.NumberOfFactors>1
    figure 
    h1=biplot(D.PC.L, 'varlabels',D.colheaders,'Scores',D.PC.score);
    hold on
    if D.PC.NumberOfFactors==2;
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');
    else %D.PC.NumberOfFactors==3; 
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');zlabel('Latent Factor 3');
    end
    PlotTitle= ['PC - Rotation Type:  ' 'None'] ;
    title(PlotTitle);
    hold off
else 
    msgbox('No plot for 1 factor');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global D
if D.PC.NumberOfFactors>1
    figure 
    h2=biplot(D.PC.L_rot, 'varlabels',D.colheaders,'Scores',D.PC.score_rot);
    hold on
    if D.PC.NumberOfFactors==2;
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');
    else %D.PC.NumberOfFactors==3; 
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');zlabel('Latent Factor 3');
    end
    PlotTitle= ['PC - Rotation Type:  ' D.PC.RotationType] ;
    title(PlotTitle);
    hold off
else 
    msgbox('No plot for 1 factor or no ratation');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global D
if D.PC.NumberOfFactors>1
    figure;
    h3=plot(D.PC.score(:,1),D.PC.score_rot(:,1),'.b');
    hold on
    plot(D.PC.score(:,2),D.PC.score_rot(:,2),'.r')
    PlotTitle= 'Factor Scores Unroted vs Rotated'  ;
    title(PlotTitle);
    xlb='Unrotated'; 
    ylb=['Rotation Type:  ' D.PC.RotationType];
    xlabel(xlb); ylabel(ylb);
    hold off
else 
    msgbox('No plot for 1 factor');
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
close (handles.figure1);
run ('FA_1')

%% ========== ML PLOTS ======================
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global D
if D.ML.NumberOfFactors>1

    figure
    h1=biplot(D.ML.L, 'varlabels',D.colheaders,'Scores',D.ML.score);
    hold on
    if D.ML.NumberOfFactors==2;
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');
    else %D.ML.NumberOfFactors==3; 
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');zlabel('Latent Factor 3');
    end
    PlotTitle= ['ML - Rotation Type:  ' 'None'] ;
    title(PlotTitle);
    hold off
else

    msgbox('No plot for 1 factor');
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
global D
if D.ML.NumberOfFactors>1

    figure
    h2=biplot(D.ML.L_rot, 'varlabels',D.colheaders,'Scores',D.ML.score_rot);
    hold on
    if D.ML.NumberOfFactors==2;
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');
    else %D.ML.NumberOfFactors==3; 
        xlabel('Latent Factor 1'); ylabel('Latent Factor 2');zlabel('Latent Factor 3');
    end
    PlotTitle= ['ML - Rotation Type:  ' D.ML.RotationType] ;
    title(PlotTitle);
    hold off
else
    msgbox('No plot for 1 factor or no ratation');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global D
if D.ML.NumberOfFactors>1
    figure;
    h3=plot(D.ML.score(:,1),D.ML.score_rot(:,1),'.b');
    hold on
    plot(D.ML.score(:,2),D.ML.score_rot(:,2),'.r')
    PlotTitle= 'Factor Scores Unroted vs Rotated'  ;
    title(PlotTitle);
    xlb='Unrotated';
    ylb=['Rotation Type:  ' D.ML.RotationType];
    xlabel(xlb); ylabel(ylb);
    hold off
else

    msgbox('No plot for 1 factor');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
global D    
figure;
h3=plot(D.ML.score(:,1),D.PC.score(:,1),'.b');
hold on
plot(D.ML.score(:,2),D.PC.score(:,2),'.r')
PlotTitle= 'Factor Scores ML vs PC'  ;
title(PlotTitle);
xlb='ML';
ylb='PC';
xlabel(xlb); ylabel(ylb);
hold off

%% ==================================================
function pvalue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pvalue_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RotationType.
function RotationType_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function RotationType_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NumberOfFactors.
function NumberOfFactors_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function NumberOfFactors_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FactorScoreCalcMeth.
function FactorScoreCalcMeth_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function FactorScoreCalcMeth_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
