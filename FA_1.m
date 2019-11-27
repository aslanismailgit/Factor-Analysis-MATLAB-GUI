function varargout = FA_1(varargin)
% FA_1 MATLAB code for FA_1.fig
%      FA_1, by itself, creates a new FA_1 or raises the existing
%      singleton*.
%
%      H = FA_1 returns the handle to a new FA_1 or the handle to
%      the existing singleton*.
%
%      FA_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FA_1.M with the given input arguments.
%
%      FA_1('Property','Value',...) creates a new FA_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FA_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FA_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FA_1

% Last Modified by GUIDE v2.5 11-Nov-2019 10:45:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FA_1_OpeningFcn, ...
                   'gui_OutputFcn',  @FA_1_OutputFcn, ...
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


% --- Executes just before FA_1 is made visible.
function FA_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FA_1 (see VARARGIN)

% Choose default command line output for FA_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FA_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FA_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global D
[D.file,D.path,D.indx] = uigetfile ('.txt');
D.filename=[D.path D.file];

set(findobj('Tag','edit1'),'String',D.file);


function edit1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ================ Pushbuttons ===================
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close (handles.figure1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global D
if strcmp(get(handles.uitable1,'Data'),'');
    msgbox('Import data first');
else
    close (handles.figure1);
    run ('FA_2')
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

global D
a1=get(findobj('Tag','uipanel4'),'SelectedObject');
choise=get(a1,'string');
switch choise; % Get Tag of selected object.
    case 'Tab';
        delimiterIn = '\t';
    case 'Comma';
        delimiterIn = ',';
    case 'Semicolon';

        delimiterIn = ';';
    case 'Space';
        delimiterIn = ' ';
end

try
    Data=importdata(D.filename,delimiterIn);
    [a b]=size(Data.data);
    Summary_Text1=['Number of variables   : ' num2str(b)];
    Summary_Text2=['Number of observation  :' num2str(a)];
    if length(Summary_Text1)==length(Summary_Text2)
        Summary_Text=[Summary_Text1;Summary_Text2];
    elseif length(Summary_Text1)>length(Summary_Text2)
        d=length(Summary_Text1)-length(Summary_Text2);
        t=' ';
        for i=1:d-1
            t=[t ' '];
        end
        Summary_Text=[Summary_Text1;[Summary_Text2 t]];
    elseif length(Summary_Text1)<length(Summary_Text2)
        d=length(Summary_Text2)-length(Summary_Text1);
        t=' ';
        for i=1:d-1
            t=[t ' '];
        end
        Summary_Text=[[Summary_Text1 t];Summary_Text2];
    end
    set(handles.text4,'String',Summary_Text);
    
    D.X=Data.data;
    D.textdata=Data.textdata;
    D.colheaders=Data.colheaders;
    D.R=corrcoef(D.X);
    D.PC.DataType='Data';
    D.ML.DataType='Data';
    D.Z=zscore(D.X);
    D.FLs={'Est Load 1','Est Load 2','Est Load 3','Est Load 4'};
    D.RFLs={'Rot Load 1','Rot Load 2','Rot Load 3','Rot Load 4'};
    
    set (handles.uitable1,'Data', D.R);
    set (handles.uitable1,'RowName', D.colheaders);
    set (handles.uitable1,'ColumnName', D.colheaders);
catch
    Title='ERROR MESSAGE';
    msgbox('Proper Data and/or Column seperator is not selected',...
        Title);
end

name = strsplit(D.file,'.');
name=[name{1} '_1' '.mat'];
save (name);     

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

set(handles.text4,'String','Summary info will be shown here...');
set(handles.edit1,'String','  - - -  ');
set (handles.uitable1,'Data', '');
set (handles.uitable1,'RowName', '');
set (handles.uitable1,'ColumnName', '');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global D
if strcmp(get(handles.uitable1,'Data'),'');
    msgbox('Import data first');
else
    figure()
    boxplot(D.X,'Orientation','horizontal','Labels',D.colheaders)
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
global D
if strcmp(get(handles.uitable1,'Data'),'');
    msgbox('Import data first');
else
    figure()
    plot(D.X,'.')
    legend(D.colheaders,'Location','best')
    legend('boxoff')
end

%% ============
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
