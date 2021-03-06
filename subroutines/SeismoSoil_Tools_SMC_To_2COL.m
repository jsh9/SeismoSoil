function varargout = SeismoSoil_Tools_SMC_To_2COL(varargin)
% SEISMOSOIL_TOOLS_SMC_TO_2COL M-file for SeismoSoil_Tools_SMC_To_2COL.fig
%      SEISMOSOIL_TOOLS_SMC_TO_2COL, by itself, creates a new SEISMOSOIL_TOOLS_SMC_TO_2COL or raises the existing
%      singleton*.
%
%      H = SEISMOSOIL_TOOLS_SMC_TO_2COL returns the handle to a new SEISMOSOIL_TOOLS_SMC_TO_2COL or the handle to
%      the existing singleton*.
%
%      SEISMOSOIL_TOOLS_SMC_TO_2COL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEISMOSOIL_TOOLS_SMC_TO_2COL.M with the given input arguments.
%
%      SEISMOSOIL_TOOLS_SMC_TO_2COL('Property','Value',...) creates a new SEISMOSOIL_TOOLS_SMC_TO_2COL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SeismoSoil_Tools_SMC_To_2COL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SeismoSoil_Tools_SMC_To_2COL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SeismoSoil_Tools_SMC_To_2COL

% Last Modified by GUIDE v2.5 09-Dec-2017 00:26:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SeismoSoil_Tools_SMC_To_2COL_OpeningFcn, ...
                   'gui_OutputFcn',  @SeismoSoil_Tools_SMC_To_2COL_OutputFcn, ...
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


% --- Executes just before SeismoSoil_Tools_SMC_To_2COL is made visible.
function SeismoSoil_Tools_SMC_To_2COL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SeismoSoil_Tools_SMC_To_2COL (see VARARGIN)

% Choose default command line output for SeismoSoil_Tools_SMC_To_2COL
handles.output = hObject;

% When this property is set to 1, this GUI will stays open even if "close
% all" command is executed.
setappdata(hObject, 'IgnoreCloseAll', 1)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SeismoSoil_Tools_SMC_To_2COL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SeismoSoil_Tools_SMC_To_2COL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 


% --- Executes during object creation, after setting all properties.
function pushbutton2_select_motions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2_select_motions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

try
    handles.metricdata.uigetfile_start_dir;
catch
    handles.metricdata.uigetfile_start_dir = pwd;
end

handles.metricdata.step4_complete = 0;
guidata(hObject,handles);



% --- Executes on button press in pushbutton2_select_motions.
function pushbutton2_select_motions_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_select_motions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global start_dir0;

filter_spec = {'*.smc','SMC V1 format (*.SMC)';'*.*','All Files (*.*)'};
dlg_title = 'Select SMC data file(s)...';
[motion_file_name,motion_dir_name,filter_index] ...
    = uigetfile(filter_spec,dlg_title,start_dir0,'MultiSelect','on');

if ~isequal(motion_dir_name,0)
    start_dir0 = motion_dir_name;
end

if ischar(motion_file_name) % if motion_file_names is a string
    temp_cell = cell(1,1);
    temp_cell{1} = motion_file_name;
    motion_file_name = cell(1,1);
    motion_file_name{1} = temp_cell{1};
    nr_motion = 1;  % it means that only one motion was selected
else  % otherwise motion_file_names is a cell array
    motion_file_name = motion_file_name.';
    nr_motion = length(motion_file_name);
end

handles.metricdata.motion_file_name = motion_file_name;
handles.metricdata.motion_dir_name = motion_dir_name;
handles.metricdata.nr_motion = nr_motion;

motion = cell(nr_motion,1); % preallocation of cell array
bh = msgbox('Importing data, please wait...','Importing...');
for i = 1 : 1 : nr_motion
    motion{i} = readtext(fullfile(motion_dir_name,motion_file_name{i}));
end
close(bh);
handles.metricdata.motion = motion;
handles.metricdata.step4_complete = 1;

% Initialize baseline correction log
baseline_correction_log = zeros(nr_motion,1);
handles.metricdata.baseline_correction_log = baseline_correction_log;

% Initialize listbox_motions and set selected_motion_indices to 1
handles.metricdata.selected_motion_indices = 1;
temp = handles.metricdata.motion_file_name;
set(handles.listbox_motions,'String',temp,'Value',1);
handles.metricdata.motion_listbox_contents = temp;

guidata(hObject,handles);


% --- Executes on selection change in listbox_motions.
function listbox_motions_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_motions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_motions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_motions

motion_listbox_contents = get(hObject,'String');  
handles.metricdata.motion_listbox_contents = motion_listbox_contents;
selected_motion_indices = get(hObject,'value');
handles.metricdata.selected_motion_indices = selected_motion_indices;
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function listbox_motions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_motions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel1_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.metricdata.factor_to_SI = 1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function uipanel7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.metricdata.factor_from_SI = 1;
guidata(hObject,handles);


% --- Executes when selected object is changed in uipanel7.
function uipanel7_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel7 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton5a'
        factor_from_SI = 1;
    case 'radiobutton5b'
        factor_from_SI = 100;
    case 'radiobutton5c'
        factor_from_SI = 1/9.81;
end
handles.metricdata.factor_from_SI = factor_from_SI;
guidata(hObject,handles);


% --- Executes on button press in checkbox_show_waveforms.
function checkbox_show_waveforms_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_show_waveforms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_show_waveforms

show_waveforms = get(hObject,'Value');
handles.metricdata.show_waveforms = show_waveforms;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function checkbox_show_waveforms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_show_waveforms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.metricdata.show_waveforms = 1;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3_convert_all.
function pushbutton3_convert_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3_convert_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.metricdata.step4_complete == 0
    msgbox('You haven''t selected any files yet.','Warning');
else
    nr_motion = handles.metricdata.nr_motion;
    motion = handles.metricdata.motion;

    motion_dir_name = handles.metricdata.motion_dir_name;
    for i = 1 : 1 : nr_motion
        bh = msgbox(sprintf('Converting %d of %d...',i,nr_motion),'Converting...');
        
        fprintf('%d/%d\n',i,nr_motion);
        current_motion_filename = handles.metricdata.motion_file_name{i};
        [~,fname,ext] = fileparts(current_motion_filename);
        
        switch handles.metricdata.factor_from_SI % Get Tag of selected object.
            case 1
                str1 = 'SI';
                str2 = 'm/s^2';
            case 100
                str1 = 'gal';
                str2 = 'cm/s^2';
            case 1/9.81
                str1 = 'g';
                str2 = 'g';
        end
        new_fname = sprintf('%s_(unit=%s).txt',fname,str1);
        
        current_motion_cell = motion{i};
        factor_from_SI = handles.metricdata.factor_from_SI;
        factor_to_SI = 0.01;
        
        [time,accel] = convertSingleMotion(current_motion_cell,factor_from_SI,factor_to_SI);
        
        dlmwrite(fullfile(motion_dir_name,new_fname),[time,accel],'delimiter','\t','precision',6);
        
        if handles.metricdata.show_waveforms
            plotMotion([time,accel],str2,1.0,fname);
        end
        
        close(bh);
    end
    
    choice = questdlg('Finished. Open containing folder?', ...
	'Finished', ...
	'Yes','No','No');
    switch choice
        case 'Yes'
            dir_absolute = cd(cd(motion_dir_name));
            openFolder(dir_absolute);
        case 'No'
            % do nothing
    end
    
end


% --- Executes on button press in pushbutton4_convert_selected.
function pushbutton4_convert_selected_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4_convert_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

all_motion = handles.metricdata.motion;

if handles.metricdata.step4_complete == 0
    msgbox('You haven''t selected any motions yet.','Warning');
else
    if handles.metricdata.nr_motion == 1
        selected_motion_indices = 1;
        %motion_filenames = handles.metricdata.motion_file_name;
        motion = all_motion(selected_motion_indices);
        nr_selected_motion = 1;
    else
        selected_motion_indices = handles.metricdata.selected_motion_indices;
        %motion_listbox_contents = handles.metricdata.motion_listbox_contents;
        %motion_filenames = motion_listbox_contents(selected_motion_indices);
        motion = all_motion(selected_motion_indices);
        nr_selected_motion = length(motion);
    end

    motion_dir_name = handles.metricdata.motion_dir_name;
    for i = 1 : 1 : nr_selected_motion
        bh = msgbox(sprintf('Converting %d of %d...',i,nr_selected_motion),'Converting...');
        
        fprintf('%d/%d\n',i,nr_selected_motion);
        current_motion_filename = handles.metricdata.motion_file_name{i};
        [~,fname,ext] = fileparts(current_motion_filename);
        
        switch handles.metricdata.factor_from_SI % Get Tag of selected object.
            case 1
                str1 = 'SI';
                str2 = 'm/s^2';
            case 100
                str1 = 'gal';
                str2 = 'cm/s^2';
            case 1/9.81
                str1 = 'g';
                str2 = 'g';
        end
        new_fname = sprintf('%s_(unit=%s).txt',fname,str1);
        
        current_motion_cell = motion{i};
        factor_from_SI = handles.metricdata.factor_from_SI;
        factor_to_SI = 0.01;
        
        [time,accel] = convertSingleMotion(current_motion_cell,factor_from_SI,factor_to_SI);
        
        dlmwrite(fullfile(motion_dir_name,new_fname),[time,accel],'delimiter','\t','precision',6);
        
        if handles.metricdata.show_waveforms
            plotMotion([time,accel],str2,1.0,fname);
        end
        
        close(bh);
    end
    
    choice = questdlg('Finished. Open containing folder?', ...
        'Finished', ...
        'Yes','No','No');
    switch choice
        case 'Yes'
            dir_absolute = cd(cd(motion_dir_name));
            openFolder(dir_absolute);
        case 'No'
            % do nothing
    end
end


function [time,accel] = convertSingleMotion(current_motion_cell,factor_from_SI,factor_to_SI)

    str_a = current_motion_cell{14,1}; % the 14th line
    content_a = str2num(str_a); % convert from string to matrix
    npts = content_a(1); % total number of points in the time series

    str_b = current_motion_cell{18,1}; % the 18th line
    content_b = str2num(str_b); % convert from string to matrix
    srps = content_b(2); % "srps" = sampling rate per second
    dt = 1/srps; % unit: sec

    for i_row = 28 : 1 : size(current_motion_cell,1)
        row_str = current_motion_cell{i_row};
        if row_str(1) == '|'
            i_accel = i_row; % i_accel = row # below which the contents are accel time histories
        else
            break;
        end
    end

    cell_2 = current_motion_cell(i_accel+1:end,1); % extract and construct a new cell array

    accel_matrix = zeros(length(cell_2),8);  % 8 columns (http://escweb.wr.usgs.gov/nsmp-data/smcfmt.html)
    for j = 1 : 1 : length(cell_2)-1  % until the second to the last row
        line_content = cell_2{j};
        if line_content(1) ~= '-'  % negative sign
            line_content = [' ',line_content];
        end
        for k = 1 : 1 : 8
            accel_matrix(j,k) = str2double(line_content((k-1)*10+1:(k-1)*10+10));
        end
    end
    for j = length(cell_2) % last row
        line_content = cell_2{j};
        if ischar(line_content)
            if line_content(1) ~= '-'  % negative sign
                line_content = [' ',line_content];
            end
            for k = 1 : 1 : length(line_content)/10
                accel_matrix(j,k) = str2double(line_content((k-1)*10+1:(k-1)*10+10));
            end
        else % this means that there's only one number in the last line
            accel_matrix(j,1) = line_content;
        end
    end

    time = (dt : dt : dt*npts)';
    accel = zeros(npts,1);
    accel_matrix_tr = accel_matrix';

    for j = 1 : 1 : npts
        accel(j) = accel_matrix_tr(j); % unit of raw "accel" = cm/s/s (http://nsmp.wr.usgs.gov/smcfmt.html)
    end

    accel = accel * factor_to_SI * factor_from_SI;


% --- Executes on button press in pushbutton12_close_all.
function pushbutton12_close_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12_close_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all;



% --- Executes on button press in pushbutton1_return_to_tools.
function pushbutton1_return_to_tools_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_return_to_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close SeismoSoil_Tools_SMC_To_2COL;
SeismoSoil_Tools;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.metricdata.dt_entered = 0;
guidata(hObject,handles);

