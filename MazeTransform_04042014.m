function [] = MazeTransform_04042014()

% -------------------------------------------------------------------------
% GLOBAL VARIABLES
% -------------------------------------------------------------------------
VTData = [];
Spikes = [];
CellNames = [];
VTDataScatter = [];
xy = [];
VTFilePath = [];
XY = [];
plotXY = [];
Boxes = [];
RC = 0;
rottheta = [];
cx = [];
cy = [];
Octagon = [...                          % Perfect octagon coordinates
    1 0.4142136;...
    0.4142136 1;...
    -0.4142136 1;...
    -1 0.4142136;...
    -1 -0.4142136;...
    -0.4142136 -1;...
    0.4142136 -1;...
    1 -0.4142136;...
    1 0.4142136];
radius = [];
oH = [];
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------

% Maze Transform GUI
% ------------------------------------ 
% HANDLES

% -------------------------------------------------------------------------
% HANDLES\Window
% -------------------------------------------------------------------------
ScreenSize = get(0,'ScreenSize');
wH = 323;
wW = 580;
window = figure(...
    'units','pixels',...
    'position',[(ScreenSize(3)-wW)/2,(ScreenSize(4)-wH)/2,wW,wH],...
    'menubar','none',...
    'name','Maze Transform',...
    'numbertitle','off',...
    'resize','off',...
    'WindowButtonUpFcn',@StopDrag);
% -------------------------------------------------------------------------
% HANDLES\VT Data Display and Center Finder
% -------------------------------------------------------------------------
A.pH = 303;
A.pW = 345;
A.panel = uipanel(...
    'Parent',window,...
    'Units','pixels',...
    'FontUnits','pixels',...
    'FontSize',12,...
    'FontWeight','bold',...
    'TitlePosition','lefttop',...
    'Title','Maze Center',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout',...
    'Position',[580-345-10 323-10-303 345 303]);
% -------------------------------------------------------------------------
A.axes = axes(...
    'Parent',A.panel,...
    'Units','pixels',...
    'Box','on',...
    'XTick',[ ],...
    'YTick',[ ],...
    'Position',[10 303-8-10-200 345-20 200]);
A.xh = line(...
    'Parent',A.axes,...
    'XData',[0.5 0.5],...
    'YData',[0 1],...
    'Color',[1 0.5 0],...
    'ButtonDownFcn',@StartDragX,...
    'LineWidth',2,...
    'Visible','off');
A.yh = line(...
    'Parent',A.axes,...
    'XData',[0 1],...
    'YData',[0.5 0.5],...
    'Color',[1 0.5 0],...
    'ButtonDownFcn',@StartDragY,...
    'LineWidth',2,...
    'Visible','off');
% -------------------------------------------------------------------------
A.xy.panel = uipanel(...
    'Parent',A.panel,...
    'Units','pixels',...
    'FontUnits','pixels',...
    'FontSize',12,...
    'FontWeight','bold',...
    'TitlePosition','lefttop',...
    'Title','Coordinates',...
    'BackGroundColor',[.8 .8 .8],...
    'BorderType','beveledout',...
    'Position',[10 303-8-10-200-6-68 94 68]);
% -------------------------------------------------------------------------
A.xy.xText = uicontrol(...
    'Parent',A.xy.panel,...
    'Style','text',...
    'Units','pixels',...
    'FontSize',10,...
    'FontWeight','bold',...
    'BackGroundColor',[.8 .8 .8],...
    'String','X',...
    'HorizontalAlignment','left',...
    'Position',[11 68-8-12-17 20 17]);
A.xy.xEdit = uicontrol(...
    'Parent',A.xy.panel,...
    'Style','edit',...
    'Units','pixels',...
    'FontSize',8,...
    'BackgroundColor','White',...
    'String','',...
    'HorizontalAlignment','left',...
    'Position',[12+20 68-8-12-17 50 17],...
    'Callback',{@PlotCenter});
% -------------------------------------------------------------------------
A.xy.yText = uicontrol(...
    'Parent',A.xy.panel,...
    'Style','text',...
    'Units','pixels',...
    'FontSize',10,...
    'FontWeight','bold',...
    'BackGroundColor',[.8 .8 .8],...
    'String','Y',...
    'HorizontalAlignment','left',...
    'Position',[11 68-8-12-17-5-17 20 17]);
A.xy.yEdit = uicontrol(...
    'Parent',A.xy.panel,...
    'Style','edit',...
    'Units','pixels',...
    'FontSize',8,...
    'BackgroundColor','White',...
    'String','',...
    'HorizontalAlignment','left',...
    'Position',[12+20 68-8-12-17-5-17 50 17],...
    'Callback',{@PlotCenter});
% -------------------------------------------------------------------------
A.line(1) = uipanel(...
    'Parent',A.panel,...
    'Units','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout',...
    'Position',[345-10-221 303-8-10-200-6-8-2 221 2]);
A.line(2) = uipanel(...
    'Parent',A.panel,...
    'Units','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout',...
    'Position',[345-10-221 303-8-10-200-6-8-2-58 221 2]);
A.findCenterPB = uicontrol(...
    'Parent',A.panel,...
    'Units','pixels',...
    'Style','pushbutton',...
    'FontUnits','pixels',...
    'BackGroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'String','Find Center',...
    'Position',[345-10-108 303-8-10-200-6-8-20-6.5 108 20],...
    'CallBack',{@FindCenter});
A.resetPB = uicontrol(...
    'Parent',A.panel,...
    'Units','pixels',...
    'Style','pushbutton',...
    'FontUnits','pixels',...
    'BackGroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'String','Reset Data',...
    'Position',[345-10-108 303-8-10-200-6-8-20-20-5-6.5 108 20],...
    'CallBack',{@ResetCall});
    function [] = ResetCall(varargin)
        PlotVTData;
        set(VTDataFixPB,'Enable','off');
    end
A.vtDataFixPB = uicontrol(...
    'Parent',A.panel,...
    'Units','pixels',...
    'Style','pushbutton',...
    'FontUnits','pixels',...
    'BackGroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'String','VT Data Fix',...
    'Position',[345-10-108-5-108 303-8-10-200-6-8-20-6.5 108 20],...
    'Callback',@VTDataFixCall,...
    'Enable','off');
    function [] = VTDataFixCall(varargin)
        if ~isempty(VTData)
            set(A.vtDataFixPB,'Enable','off');
            [VTData,cx,cy,radius] = VTDataFix(VTData);
            PlotVTData;
        end
    end
A.findBoxesPB = uicontrol(...
    'Parent',A.panel,...
    'Units','pixels',...
    'Style','pushbutton',...
    'FontUnits','pixels',...
    'BackGroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'String','Find Boxes',...
    'Position',[345-10-108-5-108 303-8-10-200-6-8-20-20-5-6.5 108 20],...
    'Callback',@PlotBoxesCall);
    function [] = PlotBoxesCall(varargin)
        if ~isempty(VTData)
            hold on;
            plotXY = [];
            XY = FindBoxes(VTData(:,2:3));
            if exist('Boxes','var') && ~isempty(Boxes) && ishandle(Boxes)
                delete(Boxes);
            end
            if ~isempty(XY)
                plotXY(:,1) = [XY(:,1);XY(1,1)];
                plotXY(:,2) = [XY(:,2);XY(1,2)];
                Boxes = plot(plotXY(:,1),plotXY(:,2),'Parent',A.axes,'Color',[1 0 0]);
                axis equal;
                hold off;
                set(A.vtDataFixPB,'Enable','on');
            else
                set(A.vtDataFixPB,'Enable','off');
                plotXY = [];
            end
        end
    end
% -------------------------------------------------------------------------
% HANDLES\Open VT Data
% -------------------------------------------------------------------------
Menu.openVT = uimenu(...
    'Parent',window,...
    'Label','Open VT File(s)',...
    'Separator','on',...
    'Callback',@GetDataPlotData);
    function [] = GetDataPlotData(varargin)
        GetVTData;
        PlotVTData;
    end
% -------------------------------------------------------------------------
% HANDLES\Open Spike File(s)
% -------------------------------------------------------------------------
Menu.openSF = uimenu(...
    'Parent',window,...
    'Label','Open Spike File(s)',...
    'Separator','on',...
    'Callback',@GetSpikes);
% -------------------------------------------------------------------------
% HANDLES\Options
% -------------------------------------------------------------------------
Option.pH = 0;
Option.pW = 205;
Option.panel = uipanel(...
    'Parent',window,...
    'Units','pixels',...
    'FontUnits','pixels',...
    'FontSize',12,...
    'FontWeight','bold',...
    'TitlePosition','lefttop',...
    'Title','Options',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout');
% Write lap files?
% -------------------------------------------------------------------------
Option.pH = Option.pH+26;
Option.writeLapFiles.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'Value',1,...
    'String','Write lap files',...
    'BackgroundColor',[.8 .8 .8]);
% Write aggregate data?
% -------------------------------------------------------------------------
Option.writeAggregate.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'Value',1,...
    'String','Write aggregate data',...
    'BackgroundColor',[.8 .8 .8]);
% Lap Timestamps?
% -------------------------------------------------------------------------
Option.lapTimestamps.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Lap timestamps',...
    'BackgroundColor',[.8 .8 .8]);
% Plot output?
% -------------------------------------------------------------------------
Option.plotOutput.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Plot output',...
    'BackgroundColor',[.8 .8 .8]);
% Split laps manually?
% -------------------------------------------------------------------------
Option.manualLapSplit.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Split laps manually',...
    'BackgroundColor',[.8 .8 .8],...
    'Callback',@ManualSplitCall);
% Treat VT data as one lap?
% -------------------------------------------------------------------------
Option.oneLap.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Treat VT data as one lap',...
    'BackgroundColor',[.8 .8 .8],...
    'Callback',@OneLapCall);
% rateMap.mat?
% -------------------------------------------------------------------------
Option.rateMap.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Rate Map',...
    'BackgroundColor',[.8 .8 .8],...
    'Callback',@OneLapCall);
% spikeCountVector.mat?
% -------------------------------------------------------------------------
Option.spikeCountVector.check = uicontrol(...
    'Parent',Option.panel,...
    'style','checkbox',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Spike Count Vector (sec)',...
    'BackgroundColor',[.8 .8 .8]);
Option.spikeCountVector.edit = uicontrol(...
    'Parent',Option.panel,...
    'Style','edit',...
    'Units','pixels',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','',...
    'BackGroundColor',[1 1 1],...
    'CallBack',@spikeCountVectorEditCall);
    function [] = spikeCountVectorEditCall(varargin)
        t = str2double(get(Option.spikeCountVector.edit,'String'));
        if isnan(t), t = 0.25; end
        if t < 0, t = 0.25; end
        if t > 10, t = 10; end
        set(Option.spikeCountVector.edit,'String',num2str(t));
    end
Option.spikeCountVector.slide = uicontrol(...
    'Parent',Option.panel,...
    'Style','slide',...
    'Units','pixels',...
    'BackgroundColor','white',...
    'ForegroundColor','white',...
    'CallBack',@spikeCountVectorSliderCall);
    function [] = spikeCountVectorSliderCall(varargin)
    end
% Start lap numbering at: x
% -------------------------------------------------------------------------
Option.firstLap.line = uipanel(...
    'Parent',Option.panel,...
    'Units','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout');
Option.firstLap.text = uicontrol(...
    'Parent',Option.panel,...
    'style','text',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','First lap number',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[.8 .8 .8]);
Option.firstLap.slide = uicontrol(...
    'Parent',Option.panel,...
    'style','slide',...
    'unit','pix',...
    'BackgroundColor','white',...
    'ForegroundColor','white',...
    'min',1,'max',100,'val',3,...
    'SliderStep',[1/99 1/99],...
    'Callback',{@StartLapSliderCall});
Option.firstLap.edit = uicontrol(...
    'Parent',Option.panel,...
    'style','edit',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','1',...
    'HorizontalAlignment','center',...
    'BackgroundColor','white',...
    'Callback',@FixSLEdit);
    function [] = FixSLEdit(varargin)
        set(Option.firstLap.edit,'String',FixString(get(Option.firstLap.edit,'String'),[1 100]));
    end
% Select Bin Length
% -------------------------------------------------------------------------
Option.binSize.line = uipanel(...
    'Parent',Option.panel,...
    'Units','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout');
Option.binSize.text = uicontrol(...
    'Parent',Option.panel,...
    'style','text',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Bin length (cm)',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[.8 .8 .8]);
Option.binSize.slide = uicontrol(...
    'Parent',Option.panel,...
    'style','slide',...
    'unit','pix',...
    'BackgroundColor','white',...
    'ForegroundColor','white',...
    'min',1,'max',10,'val',3,...
    'SliderStep',[1/9 1/9],...
    'Callback',{@BinSliderCall});
Option.binSize.edit = uicontrol(...
    'Parent',Option.panel,...
    'style','edit',...
    'unit','pix',...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','3',...
    'HorizontalAlignment','center',...
    'BackgroundColor','white',...
    'Callback',@FixBLEdit);
    function [] = FixBLEdit(varargin)
        set(Option.binSize.edit,'String',FixString(get(Option.binSize.edit,'String'),[1 10]));
    end

mrgn = 9;

Option.pH = mrgn;
set(Option.binSize.slide,'position',[Option.pW-mrgn-11,Option.pH,11,17]);
set(Option.binSize.edit,'position',[Option.pW-mrgn-11-27,Option.pH,27,17]);
set(Option.binSize.text,'position',[mrgn,Option.pH,Option.pW-mrgn-11-27-mrgn,17]);

Option.pH = Option.pH+17+mrgn/2;
set(Option.binSize.line,'position',[mrgn,Option.pH,Option.pW-2*mrgn,2]);

Option.pH = Option.pH+mrgn/2;
set(Option.firstLap.slide,'position',[Option.pW-mrgn-11,Option.pH,11,17]);
set(Option.firstLap.edit,'position',[Option.pW-mrgn-11-27,Option.pH,27,17]);
set(Option.firstLap.text,'position',[mrgn,Option.pH,Option.pW-mrgn-11-27-mrgn,17]);

Option.pH = Option.pH+17+mrgn/2;
set(Option.firstLap.line,'position',[mrgn,Option.pH,Option.pW-2*mrgn,2]);

Option.pH = Option.pH+mrgn/2;
set(Option.spikeCountVector.slide,'position',[Option.pW-mrgn-11,Option.pH,11,17]);
set(Option.spikeCountVector.edit,'position',[Option.pW-mrgn-11-27,Option.pH,27,17]);
set(Option.spikeCountVector.check,'position',[mrgn,Option.pH,Option.pW-mrgn-11-27-mrgn,17]);

Option.pH = Option.pH+17+mrgn/2;
set(Option.rateMap.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.oneLap.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.manualLapSplit.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.plotOutput.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.lapTimestamps.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.writeAggregate.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn/2;
set(Option.writeLapFiles.check,'position',[mrgn,Option.pH,Option.pW-2*mrgn,17]);
Option.pH = Option.pH+17+mrgn;

Option.pH = Option.pH+8;
set(Option.panel,'position',[10,323-10-Option.pH,Option.pW,Option.pH]);

% -------------------------------------------------------------------------
% HANDLES\Run Pushbutton
% -------------------------------------------------------------------------
Run.panel = uipanel(...
    'Parent',window,...
    'Units','pixels',...
    'FontUnits','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'BorderType','beveledout',...
    'Position',[10 10 205 38]);
Run.PB = uicontrol(...
    'Parent',Run.panel,...
    'Units','pixels',...
    'Style','pushbutton',...
    'FontUnits','pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'FontWeight','Bold',...
    'String','Run',...
    'Position',[9 9 205-18 20],...
    'CallBack',{@RunCall});


% End graphics handles
% -------------------------------------------------------------------------








% -------------------------------------------------------------------------

% Maze Transform GUI
% ------------------------------------ 
% CALLBACKS

% -------------------------------------------------------------------------
% CALLBACKS\Plot Crosshairs
% -------------------------------------------------------------------------
    function [] = PlotCenter(varargin)
        x = str2double(get(A.xy.xEdit,'String'));
        if isnan(x)||isempty(x),x = 1;end
        y = str2double(get(A.xy.yEdit,'String'));
        if isnan(y)||isempty(y),y = 1;end
        set(A.xh,'XData',x*[1 1]);
        set(A.yh,'YData',y*[1 1]);
        AxesLabelsOff;
        hold on;
    end
% -------------------------------------------------------------------------
% CALLBACKS\Drag Crosshairs
% -------------------------------------------------------------------------
    function [] = StartDragX(varargin)
        set(window,'WindowButtonMotionFcn',@DragX);
    end
    function [] = StartDragY(varargin)
        set(window,'WindowButtonMotionFcn',@DragY);
    end
    function [] = DragX(varargin)
        pt = get(A.axes,'CurrentPoint');
        set(A.xh,'XData',pt(1)*[1 1]);
        set(A.xy.xEdit,'String',num2str(pt(1)));
        if exist('oH','var') && ~isempty(oH) && ishandle(oH)
            set(oH,'XData',pt(1)+Octagon(:,1)*radius);
        end
    end
    function [] = DragY(varargin)
        pt = get(A.axes,'CurrentPoint');
        set(A.yh,'YData',pt(3)*[1 1]);
        set(A.xy.yEdit,'String',num2str(pt(3)));
        if exist('oH','var') && ~isempty(oH) && ishandle(oH)
            set(oH,'YData',pt(3)+Octagon(:,2)*radius);
        end
    end
    function [] = StopDrag(varargin)
        set(window,'WindowButtonMotionFcn','');
    end
% -------------------------------------------------------------------------
% CALLBACKS\Plot VT Data
% -------------------------------------------------------------------------
    function [] = PlotVTData(varargin)
        if ~isempty(VTData)
            if exist('VTDataScatter','var') && ~isempty(VTDataScatter) && ishandle(VTDataScatter)
                delete(VTDataScatter);
            end
            if exist('Boxes','var') && ~isempty(Boxes) && ishandle(Boxes)
                delete(Boxes);
            end
            if exist('oH','var') && ~isempty(oH) && ishandle(oH)
            	delete(oH);
            end
            xy = ThinData(VTData(:,2:3),8000);
            maxY = max(xy(:,2));
            minY = min(xy(:,2));
            AxesLabelsOff;
            hold on;
            
            VTDataScatter = plot(...
                xy(:,1),xy(:,2),...
                'Parent',A.axes,...
                'ButtonDownFcn',@StartRot);
            set(A.axes,'YLim',[minY-(maxY-minY)*0.05,maxY+(maxY-minY)*.05]);
            XLim = get(A.axes,'XLim');
            YLim = get(A.axes,'YLim');
            
            if ~isempty(cx) && ~isempty(cy)
                set(A.xh,'XData',cx*[1 1],'YData',YLim);
                set(A.xy.xEdit,'String',num2str(cx));
                set(A.yh,'YData',cy*[1 1],'XData',XLim);
                set(A.xy.yEdit,'String',num2str(cy));
                oH = plot(...
                    Octagon(:,1)*radius+cx,...
                    Octagon(:,2)*radius+cy,...
                    'Color',[1 1/2 0],...
                    'LineWidth',2);
            else
                Minxy = min(xy);
                Maxxy = max(xy);
                XMid = (Maxxy(1)-Minxy(1))/2+Minxy(1);
                YMid = (Maxxy(2)-Minxy(2))/2+Minxy(2);
                
                set(A.xy.xEdit,'String',num2str(XMid));
                set(A.xy.yEdit,'String',num2str(YMid));
                set(A.xh,'Visible','on',...
                    'XData',XMid*[1 1],...
                    'YData',[YLim(1) YLim(2)]);
                set(A.yh,'Visible','on',...
                    'XData',[XLim(1) XLim(2)],...
                    'YData',YMid*[1 1]);
            end
            hold off;
        end            
    end
% -------------------------------------------------------------------------
% CALLBACKS\Run Auto Center Finder
% -------------------------------------------------------------------------
    function [] = FindCenter(varargin)
    end
% -------------------------------------------------------------------------
% CALLBACKS\Import VT Data From Excel
% -------------------------------------------------------------------------
    function [] = GetVTData(varargin)
        [Name,Path] = uigetfile('*.xls','MultiSelect','on');
        if ~isnumeric(Name) && ~isempty(Name) 
            if ischar(Name), Name = {Name}; end
            numFiles = length(Name);
            excelObj = actxserver('Excel.Application');
            m = 0;
            for f = 1:numFiles
                excelWorkbook = excelObj.workbooks.Open([Path Name{f}]);
                worksheets = excelObj.sheets; numSheets = worksheets.Count;
                for p = 1:numSheets
                    WorkSheet = excelWorkbook.Sheets.Item(p);
                    invoke(WorkSheet,'Activate');
                    DataRange = excelObj.ActiveSheet.UsedRange;
                    numUsedCells = excelObj.ActiveSheet.UsedRange.Count;
                    if numUsedCells > 1
                        m = m + 1;
                        tempVTData{m,1} = cell2mat(DataRange.Value(1:end,1:3));
                    end
                end
            end
            excelWorkbook.Close; excelObj.Quit; delete(excelObj);
            tempVTData = cell2mat(tempVTData);
            tempVTData(isnan(tempVTData(:,1)),:) = [];
            tempVTData = unique(tempVTData,'rows');
            tempVTData = sortrows(tempVTData,1);
            VTFilePath = [Path Name{1}];
            VTData = tempVTData;
        end
    end
% -------------------------------------------------------------------------
% CALLBACKS\Get Spike Data From Text File(s)
% -------------------------------------------------------------------------
    function [] = GetSpikes(varargin)
        [CellNames,Path] = uigetfile('*.txt','Select cell file(s)','MultiSelect','on');
        if ~isempty(CellNames) && ~isnumeric(CellNames)
            Spikes = [];
            if ischar(CellNames), CellNames = {CellNames}; end
            CellNames = CellNames.';

            for n = 1:length(CellNames)
                Spikes{n} = importdata([Path filesep CellNames{n}]);
                CellNames{n} = CellNames{n}(1:end-4);
            end
%             Index = strfind(Path,'\');
%             set(CellFileDispText,'String',Path(Index(end-1)+1:end-1));
        end
        
    end
% -------------------------------------------------------------------------
% CALLBACKS\Bin Length Slider
% -------------------------------------------------------------------------
    function [] = BinSliderCall(varargin)
        BinSize = get(Option.binSize.slide,'val');
        set(Option.binSize.edit,'String',num2str(BinSize));
    end
% -------------------------------------------------------------------------
% CALLBACKS\Start Lap Numbering Slider
% -------------------------------------------------------------------------
    function [] = StartLapSliderCall(varargin)
        set(Option.firstLap.edit,'String',num2str(get(Option.firstLap.slide,'Value')));
    end
% -------------------------------------------------------------------------
% CALLBACKS\Options
% -------------------------------------------------------------------------
    function [] = OneLapCall(varargin)
        set(Option.manualLapSplit.check,'Value',0);
    end
    function [] = ManualSplitCall(varargin)
        set(Option.oneLap.check,'Value',0);
    end
% -------------------------------------------------------------------------
% CALLBACKS\Miscellaneous
% -------------------------------------------------------------------------
    function [] = AxesLabelsOff(varargin)
       set(A.axes,'XTick',[ ]);
       set(A.axes,'YTick',[ ]);
       set(A.axes,'Box','on');
       axis equal;
    end
% -------------------------------------------------------------------------
    function [Data] = ThinData(Data,MaxData)
        NumDataPoints = length(Data(:,1));
        if NumDataPoints > MaxData;
            d = (NumDataPoints-MaxData)/NumDataPoints;
            if d < 1
                Index = 1:1/d:NumDataPoints;
                Data(floor(Index),:) = [];
            else
                Index = 1:d:NumDataPoints;
                Data = Data(floor(Index));        
            end
        end
    end
% -------------------------------------------------------------------------
    function [StringFixed] = FixString(String,Limits)
        if isnan(str2double(String))
            StringFixed = '1';
        else
            StringFixed = floor(str2double(String));
            if StringFixed < Limits(1),StringFixed = Limits(1);
            elseif StringFixed > Limits(2),StringFixed = Limits(2);end
        end
    end
% -------------------------------------------------------------------------
% CALLBACKS\Run MazeTransform
% -------------------------------------------------------------------------
    function [] = RunCall(varargin)
        Center = [];
        x = str2double(get(A.xy.xEdit,'string'));
        y = str2double(get(A.xy.yEdit,'string'));
        if ~isempty(x)&&~isempty(y),Center = [x,y];end %If coordinates exist for the center of the maze, set=center
        
        if ~isempty(VTData)&&~isempty(Spikes)&&~isempty(Center)
            FirstLapNum = str2double(get(Option.firstLap.edit,'string')); %User-defined 1st lap #
            if isempty(FirstLapNum),FirstLapNum = 1;end
            
            C.lapTimestamps = get(Option.lapTimestamps.check,'Value');
            C.rateMap = get(Option.rateMap.check,'Value');
            C.spikeCountVector = get(Option.spikeCountVector.check,'Value');
            C.spikeCountTimeInc = str2double(get(Option.spikeCountVector.edit,'String'));
            if isnan(C.spikeCountTimeInc),C.spikeCountTimeInc = 0.25; end
            C.binSize = str2double(get(Option.binSize.edit,'String'));
            C.plotOutput = get(Option.plotOutput.check,'Value');
            C.manualSplit = get(Option.manualLapSplit.check,'Value');
            C.oneLap = get(Option.oneLap.check,'Value');
            C.writeAggregate = get(Option.writeAggregate.check,'Val');
            C.writeLapFiles= get(Option.writeLapFiles.check,'Val');
            C.spikeCountVectorOption = get(Option.spikeCountVector.check,'Val'); %Appears to be redundant and never used
            
            C.VTdata = VTData;
            C.spikes = Spikes;
            C.center = Center;
            C.cellNames = CellNames;
            C.firstLapNum = FirstLapNum;
            C.VTFilePath = VTFilePath;
            
            MazeTransformRun(C);
        end
    end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% ROTATION FUNCTIONS
% -------------------------------------------------------------------------
    function [] = StartRot(varargin)
        set(window,'WindowButtonMotionFcn',@Rot);
        RC = 0;
    end
% -------------------------------------------------------------------------
    function [] = Rot(varargin)
        RC = RC + 1;
        
        cx = str2double(get(A.xy.xEdit,'String'));
        cy = str2double(get(A.xy.yEdit,'String'));
        
        pt = get(A.axes,'CurrentPoint');
        pt = [pt(1),pt(3)];
        
        rottheta(RC,1) = cart2pol(pt(1)-cx,pt(2)-cy);
        
        if RC > 1
            RotAngle = rottheta(RC)-rottheta(RC-1);
            
            xy = [xy(:,1)-cx,xy(:,2)-cy];
            VTData(:,2:3) = [VTData(:,2)-cx,VTData(:,3)-cy];
            
            xy = myRotate(RotAngle,xy);
            VTData(:,2:3) = myRotate(RotAngle,VTData(:,2:3));
            
            xy = [xy(:,1)+cx,xy(:,2)+cy];
            VTData(:,2:3) = [VTData(:,2)+cx,VTData(:,3)+cy];
            
            set(VTDataScatter,'XData',xy(:,1),'YData',xy(:,2));
            
            if exist('Boxes','var') && ~isempty(Boxes) && ishandle(Boxes)
                plotXY = myRotate(RotAngle,[plotXY(:,1)-cx,plotXY(:,2)-cy]);
                plotXY = [plotXY(:,1)+cx,plotXY(:,2)+cy];
                set(Boxes,'XData',plotXY(:,1),'YData',plotXY(:,2));
            end
            
        end
    end
% -------------------------------------------------------------------------

end
% End Callback Functions
% -------------------------------------------------------------------------






% -------------------------------------------------------------------------

% Maze Transform Run
% ------------------------------------ 
% MAZE TRANSFORM

% -------------------------------------------------------------------------
% C = struct(...
%     VTdata,{},...
%     spikes,{},...
%     center,{},...
%     binSize,{},...
%     cellNames,{},...
%     firstLapNum,{},...
%     radius,{},...
%     circ,{},...
%     plotOutput,{},...
%     manualSplit,{},...
%     oneLap,{},...

% Lap = struct(...
%     Index,{},...
%     Time,{},...     % time spent in each bin
%     SC,{},...       % spike count for each bin
%     Freq,{});       % spike count / time
% -------------------------------------------------------------------------
function [] = MazeTransformRun(C)

C.radius = 46.99; %Measure of radius (corner, side, or average?) assuming circle fitting an octagon
C.circ = 2*pi*C.radius; % Circumference of circle approximating octagon
C.numBins = floor(C.circ/C.binSize); %# of bins in the circle rounded down to nearest integer
C.bins = (0:C.binSize:(C.numBins*C.binSize))'; %Vector of bin start points based on circle fitting
C.numBins = C.numBins+1; %Not sure why adding extra bin here???
C.numCells = length(C.cellNames); %# of units/cells based on # of text files loaded

% cartesian -> arc length
C = Transform(C);
% divide MT data (timestamp, arc length) into sets based on gaps in time
[C,sets] = SplitByTime(C);
% interpolate gaps in arc length
for m = 1:C.numSets
    [sets{m}] = Interpolator(C,sets{m});
end


% Three Options:

% 1) MANUAL SPLIT
% -------------------------------------------------------------------------
if C.manualSplit 
    C = getTBnds(C);
    C.numLaps = length(C.tBnds);
    allSets = cell2mat(sets);
    for m = 1:C.numLaps
        [s,~] = find(allSets == C.tBnds{m}(1),1);
        [e,~] = find(allSets == C.tBnds{m}(2),1);
        C.laps{m} = allSets(s:e,:);
    end
    
% 2) TREAT AS ONE LAP
% -------------------------------------------------------------------------
elseif C.oneLap 
    C.laps{1} = cell2mat(sets);
    C.tBnds{1} = [C.laps{1}(1,1),C.laps{1}(end,1)];

% 3) DEFAULT (neither of the above are chosen)
% -------------------------------------------------------------------------
else
    for m = 1:C.numSets
        % split into laps (C.laps = lap data, C.tBnds = lap time bounds)
        [tempLaps,temptBnds] = LapSplitter(C,sets{m});
        if m == 1
            C.laps = tempLaps;
            C.tBnds = temptBnds;
        else
            C.laps(end+1:length(tempLaps)+length(C.laps)) = tempLaps;
            C.tBnds(end+1:length(temptBnds)+length(C.tBnds),:) = temptBnds;
        end
    end
end

% FOR ALL
% -------------------------------------------------------------------------
C.numLaps = length(C.laps);
C.lapNums = C.firstLapNum:C.firstLapNum+C.numLaps-1; %Lables lap #s

Cell = cell(C.numCells,1);
for m = 1:C.numLaps    
    spikes = SpikeSplitter(C.spikes,C.tBnds{m}); % sort spikes by lap
    spikesSplit{m} = spikes;
    binTrans = getBinTrans(C.laps{m},C); % mark bin transitions
    numTrans = length(binTrans(:,1))-1; % num bin transitions
    C.time(:,m) = getTime(binTrans,C); % time per bin for each lap
    for n = 1:C.numCells
        Cell{n}.name = C.cellNames{n}; % cell structure, cell name
        [Cell{n}.freq(:,m),Cell{n}.SC(:,m)] = SpikeSorter(spikes{n},binTrans,numTrans,C.time(:,m),C); % cell structure, spike count, frequency
        Cell{n}.output{m,1} = [C.bins,C.time(:,m),Cell{n}.SC(:,m),Cell{n}.freq(:,m)]; % cell structure excel output
        if C.rateMap
            rateMap{m}(:,n) = Cell{n}.freq(:,m);
        end
    end
end

if C.lapTimestamps
    lapTimestampsSave(cell2mat(C.tBnds),C.lapNums);
end

if C.rateMap
    rateMapSave(rateMap,C.lapNums,C.bins);
end

if C.spikeCountVector
    spikeCountVector = getSpikeCountVector(spikesSplit,C.spikeCountTimeInc,C.tBnds);
    spikeCountSave(spikeCountVector,C.lapNums);
end

if C.writeLapFiles||C.writeAggregate,MTwriteoutput(Cell,C);end
if C.plotOutput,GraphicalOutput(Cell,C);end
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% GET SPIKE COUNT VECTOR
% -------------------------------------------------------------------------
function [spikeCountVector] = getSpikeCountVector(spikesSplit,spikeCountTimeInc,tBnds)
for m = 1:length(spikesSplit)
    timeBins = tBnds{m}(1):spikeCountTimeInc*10^6:tBnds{m}(2);
    for n = 1:length(spikesSplit{m})
        spikeCountVector{m}(n,:) = spikeCountVectorSort(timeBins,spikesSplit{m}{n});
    end
end
end
% -------------------------------------------------------------------------
function [spikeCount] = spikeCountVectorSort(timeBins,spikes)
for m = 1:length(timeBins)-1
    num = find(spikes >= timeBins(m) & spikes < timeBins(m+1));
    spikeCount(m) = length(num);
end
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SAVE SPIKE COUNTS
% -------------------------------------------------------------------------
function [] = spikeCountSave(spikeCountVector,lapNums)
currentFolder = pwd;
[Name,Path] = uiputfile('*.mat','Save Spike Count As...');
for m = 1:length(spikeCountVector)
    lapNameString = [Name(1:end-4) '_Lap' num2str(lapNums(m))];
    data = spikeCountVector{m};
    cd(Path);
    save(lapNameString,'data');
end
cd(currentFolder);
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% SAVE RATE MAPS
% -------------------------------------------------------------------------
function [] = rateMapSave(rateMap,lapNums,bins)
currentFolder = pwd;
[Name,Path] = uiputfile('*.mat','Save Rate Map As...');
for m = 1:length(rateMap)
    lapNameString = [Name(1:end-4) '_Lap' num2str(lapNums(m))];
    data = [bins,rateMap{m}];
    cd(Path);
    save(lapNameString,'data');
end
cd(currentFolder);
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% SAVE TIMESTAMPS
% -------------------------------------------------------------------------
function [] = lapTimestampsSave(timestamps,lapNums)
currentFolder = pwd;
[Name,Path] = uiputfile('*.mat','Save Lap Timestamps As...');
if ~isnumeric(Name)
    lapTimstamps = [lapNums',timestamps];
    cd(Path);
    save(Name,'lapTimstamps');
    cd(currentFolder);
end
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% GET MANUALLY SPLIT VT DATA TIME BOUNDS
% -------------------------------------------------------------------------
function [C] = getTBnds(C)

excelObj = actxserver('Excel.Application');
excelWorkbook = excelObj.workbooks.Open(C.VTFilePath);
worksheets = excelObj.sheets;
NumSheets = worksheets.Count;
for SheetIndex = 1:NumSheets
    WorkSheet = excelWorkbook.Sheets.Item(SheetIndex);
    invoke(WorkSheet,'Activate');
    DataRange = excelObj.ActiveSheet.UsedRange;
    data = str2double(DataRange.Formula(:,1));
    data(isnan(data),:) = [];
    C.tBnds{SheetIndex,1} = [data(1),data(end)];
end
excelWorkbook.Close; excelObj.Quit; delete(excelObj);

end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% TRANSFORM
% -------------------------------------------------------------------------
function [C] = Transform(C)
% isolate timestamps
timestamp = C.VTdata(:,1);
% shift origin to maze center
xy = [C.VTdata(:,2)-C.center(1),C.VTdata(:,3)-C.center(2)];
% cartesian -> radians
radians = cart2pol(xy(:,1),xy(:,2));
radians(radians < 0) = radians(radians < 0)+2*pi;
% define MTdata
arcLength = radians.*C.radius; % S = R*theta
C.MTdata = [timestamp,arcLength]; % timestamp with position
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SPLIT MT DATA BY TIME
% -------------------------------------------------------------------------
function [C,sets] = SplitByTime(C)

timestamp = C.MTdata(:,1); %Time stamps of VT data
numStamps = length(timestamp);

timeDiff = diff(timestamp(:,1)); %Difference in time stamps

splitInd(:,1) = find(timeDiff > 60*10^6); %Finds gaps in time stamps > 60 seconds.
%I assume this is in case the load cleaned VT data includes more than one
%set of laps.?
splitInd = [0;splitInd;numStamps]; %Boundaries detected for sets of lap runs

C.numSets = length(splitInd)-1; %Calculates # of sets of laps
sets = cell(C.numSets,1);
%The following splits up the sets of lap runs. This is important to be aware
%of if the user manually cleaned the tracking data by just deleting chunks 
%of VT data due to bad tracking instead of using an interpolation technique.
for n = 1:C.numSets
    sets{n} = C.MTdata(splitInd(n)+1:splitInd(n+1),:);
end

end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% INTERPOLATOR
%Interpolates gaps in VT data within a set of laps--meaning gaps are < 60s
%due to data already being processed through the 'SplitByTime' function.
% -------------------------------------------------------------------------
function [set] = Interpolator(C,set)

inc = 0.2; % inc is the distance increment at which new ts will be set
timeDiff = diff(set(:,1)); % time difference b/t one pt and the next
posDiff = diff(set(:,2)); % distance diff b/t one pt and the next

[index] = getGapIndexes(posDiff,inc); % gets gap indexes
new = cell(3,1); % new a cell full of new timestamps and positions
for m = 1:3
    if     m == 1, tempPosDiff = posDiff(index{1});
    elseif m == 2, tempPosDiff = posDiff(index{2})+C.circ; % if backward over lap line
    elseif m == 3, tempPosDiff = posDiff(index{3})-C.circ; % if forward over lap line
    end
    label = m;
    if ~isempty(index{m})
        new{m} = Interp(...
            length(index{m}),...
            set(index{m},:),...
            timeDiff(index{m}),...
            tempPosDiff,...
            inc,...
            label);
    else
        new{m} = [];
    end
end

if ~isempty(new{2}),new{2}(new{2}(:,2) >= C.circ,2) = new{2}(new{2}(:,2) >= C.circ,2) - C.circ;end
if ~isempty(new{3}),new{3}(new{3}(:,2) <  0,     2) = new{3}(new{3}(:,2) <  0,     2) + C.circ;end

new = cell2mat(new);
if ~isempty(new)
%     set(:,3) = zeros;
    set(end+1:length(new(:,1))+length(set(:,1)),:) = new;
    set = sortrows(set,1);
end

end
% INTERPOLATOR: Get Index
% -------------------------------------------------------------------------
function [index] = getGapIndexes(posDiff,inc)
ind = find(abs(posDiff) > inc);

cross = ind(abs(posDiff(ind)) > 250);
ind(abs(posDiff(ind)) > 250) = [];
crossNeg = cross(posDiff(cross) < 0);
crossPos = cross(posDiff(cross) > 0);

index{1} = ind;         % mid-lap gaps
index{2} = crossNeg;    % backward over lap line
index{3} = crossPos;    % forward over lap line
end
% INTERPOLATOR: Interpolate
% -------------------------------------------------------------------------
function [new] = Interp(numGaps,set,timeDiff,posDiff,inc,label)

new = cell(numGaps,1);
numNew = ceil(abs(posDiff/inc));
timeInt = timeDiff./numNew;
posInt = posDiff./numNew;

for m = 1:numGaps
    if numNew(m) > 1
        new{m} = zeros(numNew(m)-1,1);
        for n = 1:numNew(m)-1
            new{m}(n,1) = set(m,1)+timeInt(m)*n;
            new{m}(n,2) = set(m,2)+posInt(m)*n;
        end
    else
        new{m} = [];
    end
end
new = cell2mat(new);
% new(:,3) = label;
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% LAP SPLITTER
% -------------------------------------------------------------------------
function [laps,tBnds] = LapSplitter(C,set)

pos = set(:,2); % position
s = pos(1); % start
sR = 0.3; % start radius
fC = C.circ/2; % forward distance traveled criteria

sInd = find(pos >= s-sR & pos <= s+sR); % start index
sIndDiff = diff(sInd); % index difference
sInd(find(sIndDiff < 10)+1) = []; % delete sInd too close to be diff laps
sInd(end+1) = length(pos);

n = 1;
while n < length(sInd)
    forward = 0; % forward distance traveled
    while forward < fC && n < length(sInd)
        s = pos(sInd(n)); % current lap start
        tPos = pos(sInd(n):sInd(n+1)-1); % temp position (b/t start indexes)
        tPos(tPos < s) = tPos(tPos < s) + C.circ;
        tPos = tPos - s;
        Diff = diff(tPos);
        while ~isempty(find(Diff < 0,1))||~isempty(find(abs(Diff) > 250,1))
            tPos(find(Diff > 250)+1) = [];
            Diff = diff(tPos);
            tPos(Diff < -250) = [];
            Diff = diff(tPos);
            tPos(find(Diff < 0)+1) = [];
            Diff = diff(tPos);
        end
        forward = sum(diff(tPos));
        if forward < fC, sInd(n+1) = []; end
    end
%     ff(n) = forward; % final forward distance traveled
    n = n + 1;
end

numLaps = length(sInd)-1;
tBndsArr = set(sInd,1); % time bounds array
if numLaps > 0
    laps = cell(numLaps,1);
    tBnds = cell(numLaps,1);
    for n = 1:numLaps
        laps{n} = set(sInd(n):sInd(n+1)-1,:);
        tBnds{n} = [tBndsArr(n),tBndsArr(n+1)];
    end
else
    laps{1} = set;
end

end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SPIKE SPLITTER
% -------------------------------------------------------------------------
function [spikesLap] = SpikeSplitter(spikes,tBnds)
numCells = length(spikes);
spikesLap = cell(numCells,1);
for k = 1:numCells
    spikesLap{k} = spikes{k}(spikes{k} >= tBnds(1) & spikes{k} < tBnds(2));
end
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% GET BIN TRANSITIONS
% -------------------------------------------------------------------------
function [binTrans] = getBinTrans(lap,C)
% Assigning distance intervals to timestamps from the VT file
for n = 1:C.numBins
    lap(lap(:,2) <= C.bins(n) + C.binSize & lap(:,2) > C.bins(n),3) = C.bins(n);
end
% Find points at which rat transitioned from one bin to another
ind = [1;find(diff(lap(:,3)) ~= 0);length(lap(:,1))];
ind = unique(ind);
binTrans = [lap(ind,1),lap(ind,3)];
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% GET TIME
% -------------------------------------------------------------------------
function [time] = getTime(binTrans,C)
time = zeros(C.numBins,1);
timeTrans = diff(binTrans(:,1))/10^6;
for n = 1:C.numBins
    time(n) = sum(timeTrans(binTrans(1:end-1,2) == C.bins(n)));
end
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SORT SPIKES
% -------------------------------------------------------------------------
function [freq,SC] = SpikeSorter(spikes,binTrans,numTrans,time,C)

SCTrans = zeros(numTrans,1); % spike count transition array
for m = 1:numTrans
    ind = find(spikes > binTrans(m,1) & spikes <= binTrans(m+1,1));
    SCTrans(m) = SCTrans(m) + length(ind);
end

blank = zeros(C.numBins,1); SC = blank;

for m = 1:C.numBins
    SC(m) = sum(SCTrans(binTrans(1:end-1,2) == C.bins(m)));
end

freq = SC./time;
freq(isnan(freq)) = 0;

end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% WRITE OUTPUT
% -------------------------------------------------------------------------
function [] = MTwriteoutput(Cell,C)

[Name Path] = uiputfile('*.xls','Save Maze Transform Output As...');
excelObj = actxserver('Excel.Application');

% LAP FILES
if C.writeLapFiles
    for n = 1:C.numLaps
        Workbook = excelObj.Workbooks.Add;
        for k = 1:C.numCells
            Size = size(Cell{k}.output{n});
            Worksheet = excelObj.sheets.Add;
            Worksheet.Name = Cell{k}.name;
            Range = get(Worksheet,'Range',['A1:' char('a'+Size(2)-1) num2str(Size(1))]);
            Range.Value = Cell{k}.output{n};        
        end
    %   Deleting standard worksheets
        Worksheets = excelObj.sheets;
        numSheets = Worksheets.Count;
        sheetIdx = 1;
        sheetIdx2 = 1;
        while sheetIdx2 <= numSheets
           sheetName = Worksheets.Item(sheetIdx).Name(1:end-1);
           if strcmp(sheetName,'Sheet')
              Worksheets.Item(sheetIdx).Delete;
           else
              sheetIdx = sheetIdx + 1;
           end
           sheetIdx2 = sheetIdx2 + 1;
        end
    %   Saving file
        Workbook.SaveAs([Path Name(1:end-4) '_Lap' num2str(n+C.firstLapNum-1) '.xls']); Workbook.Close;
    end
end

% AGGREGATE FILE
if C.writeAggregate
    blank = zeros(C.numBins+1,C.numLaps+1)/0;
    blank(2:end,1) = C.bins;
    blank(1,2:end) = C.lapNums;
    Size = size(blank);

    Workbook = excelObj.Workbooks.Add;

    for k = 1:C.numCells
        Worksheet = excelObj.sheets.Add;
        Worksheet.Name = [Cell{k}.name '_freq'];
        Range = get(Worksheet,'Range',['A1:' char('a'+Size(2)-1) num2str(Size(1))]);
        output = blank;
        output(2:end,2:end) = Cell{k}.freq;
        Range.Value = num2cell(output);

        Worksheet = excelObj.sheets.Add;
        Worksheet.Name = [Cell{k}.name '_SpikeCount'];
        Range = get(Worksheet,'Range',['A1:' char('a'+Size(2)-1) num2str(Size(1))]);
        output = blank;
        output(2:end,2:end) = Cell{k}.SC;
        Range.Value = num2cell(output);
    end

    Worksheet = excelObj.sheets.Add;
    Worksheet.Name = 'time';
    Range = get(Worksheet,'Range',['A1:' char('a'+Size(2)-1) num2str(Size(1))]);
    output = blank;
    output(2:end,2:end) = C.time;
    Range.Value = num2cell(output);
    
    Worksheet = excelObj.sheets.Add;
    Worksheet.Name = 'lap timestamps';
    lapTimeStampSheet = writeLapTimestampSheet(C.tBnds,C.lapNums,{'Lap','Start','End'});
    sizeSheet = size(lapTimeStampSheet);
    Range = get(Worksheet,'Range',['A1:' char('a'+sizeSheet(2)-1) num2str(sizeSheet(1))]);
    Range.Value = lapTimeStampSheet;

    Worksheets = excelObj.sheets;
    numSheets = Worksheets.Count;
    sheetIdx = 1;
    sheetIdx2 = 1;
    while sheetIdx2 <= numSheets
       sheetName = Worksheets.Item(sheetIdx).Name(1:end-1);
       if strcmp(sheetName,'Sheet')
          Worksheets.Item(sheetIdx).Delete;
       else
          sheetIdx = sheetIdx + 1;
       end
       sheetIdx2 = sheetIdx2 + 1;
    end
    % Saving file
    Workbook.SaveAs([Path Name(1:end-4) '_Aggregate.xls']); Workbook.Close;
end

excelObj.Quit; delete(excelObj);
end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% LAP TIMESTAMP SHEET
% -------------------------------------------------------------------------
function [sheet] = writeLapTimestampSheet(cell,rowHeader,colHeader)
sheet = cell2mat(cell);
sheet(:,3) = diff(sheet,1,2)/10^6;

sizeRowHeader = size(rowHeader);
if sizeRowHeader(2) > 1, rowHeader = rowHeader'; end
sheet = num2cell([rowHeader,sheet]);

sizeColHeader = size(colHeader);
if sizeColHeader(1) > 1, colHeader = colHeader'; end
sheet = [colHeader,{'Length (s)'}; sheet];
end



% -------------------------------------------------------------------------
% GRAPHICAL OUTPUT
% -------------------------------------------------------------------------
function [] = GraphicalOutput(Cell,C)

C.time5 = MakeSets(C.time,5,2);
C.lapNums5 = MakeSets(C.lapNums,5,2);
C.num5Lap = length(C.lapNums5);

for n = 1:C.numCells
    Cell{n}.freq5 = MakeSets(Cell{n}.freq,5,2);
end

for n = 1:C.numCells
    for k = 1:C.num5Lap
        lapNums = C.lapNums5{k};
        setName = [Cell{n}.name ' Laps ' num2str(lapNums(1)) '-' num2str(lapNums(end))];
        CellFigures(Cell{n}.freq5{k},C.time5{k},setName,lapNums,C);
    end
end

end
% CELL FIGURES
% -------------------------------------------------------------------------
function [] = CellFigures(freq5,time5,setName,lapNums,C)

fH = figure(...
    'Name',setName,...
    'numbertitle','off',...
    'Units','normalized',...
    'Position',[1/3 1/10 1/3 4/5]);
text = uicontrol(...
    'Style','text',...
    'units','pixels',...
    'FontUnits','pixels',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[.8 .8 .8],...
    'FontSize',12,...
    'string',setName,...
    'position',[10 10 300 20]);

numLaps = length(lapNums);
for n = 1:numLaps
    maxFreq = max(freq5(:,n));
    maxTime = max(time5(:,n));
    timeScaled = time5(:,n)*maxFreq/maxTime;
    
    subplot(numLaps,1,n);
    hold on;
    bar(C.bins,freq5(:,n),1);
    plot(C.bins,timeScaled);
    hold off;
    
    title(['Lap ' num2str(lapNums(n))]);
    xlabel('Position (cm)');
    ylabel('Avg. Freq. (Hz)');
    set(gca,'XLim',[0 C.bins(end)]);
end

end
% FIVE LAP SETS
% -------------------------------------------------------------------------
function [Sets,Index,numSets] = MakeSets(Data,SetSize,Dimension)
if Dimension == 1 || Dimension == 2
    SizeData = size(Data);

    Index = 0:SetSize:SizeData(Dimension);
    if Index(end) ~= SizeData(Dimension)
        Index(end+1) = SizeData(Dimension);
    end
    
    numSets = length(Index)-1;
    Sets = cell(numSets,1);
    for n = 1:numSets
        if Dimension == 1
            Sets{n} = Data(Index(n)+1:Index(n+1),:);
        elseif Dimension == 2
            Sets{n} = Data(:,Index(n)+1:Index(n+1));
        end
    end
else
    Sets = [];
end

end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% BOX FINDER
% -------------------------------------------------------------------------
function [XY] = FindBoxes(xy)

numBoxes = 0;
CutOff = 0.50;
Increment = -0.05;
while numBoxes ~= 3 && CutOff > 0
    temp = PeakFinder(xy(:,1),CutOff);
    numBoxes = length(temp);
    CutOff = CutOff + Increment;
end
if numBoxes == 3
    XY(:,1) = temp;
else
    XY = [];
end

if ~isempty(XY)
    for n = 1:numBoxes
        xData = xy(xy(:,1) > XY(n) - 5,:);
        xData = xData(xData(:,1) < XY(n) + 5,:);
        CutOff = 0.80;
        Increment = -0.05;
        temp = [];
        while length(temp) ~= 1 && CutOff > 0
            temp = PeakFinder(xData(:,2),CutOff);
            CutOff = CutOff + Increment;
        end
        XY(n,2) = temp;
    end
end

end
% -------------------------------------------------------------------------
function [Output] = PeakFinder(Data,CutOff)

[N1,X] = hist(Data(:,1),ceil(max(Data(:,1))/2-min(Data(:,1))/2));
N2(:,1) = N1;
N2(:,2) = 1:length(N2);

N3 = N2(N2(:,1) >= CutOff*max(N2(:,1)),:);

temp = find(diff(N3(:,2)) > 20);
index = [0;temp;length(N3(:,1))];
numHits = length(index)-1;
Output = zeros(numHits,1);
for n = 1:numHits
    temp = N3(index(n)+1:index(n+1),:);
    Output(n,1) = X(ceil(sum(temp(:,1).*temp(:,2))/sum(temp(:,1))));
end
end
% -------------------------------------------------------------------------






function [NewVTData,cx,cy,radius] = VTDataFix(VTData)
% -------------------------------------------------------------------------
% VTDataFix.m
% -------------------------------------------------------------------------

% Description
% ------------------------------------
% Corrects video tracker data aspect ratio due to tilt of camera/position
% of 8-box maze in frame.
% ------------------------------------
% CURSOR INTERACTIONS
% ------------------------------------
%  Green - move
%    Red - scale
% Yellow - skew
%   Blue - rotate
% ------------------------------------
% LOWER-LEFT CORNER DATA
% ------------------------------------
%     Left = total rotate
%   Middle = angle b/t B0-B1 and B0-B2
%    Right = ratio of line B0-B2:B0-B1
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------

% GLOBAL VARIABLES

% -------------------------------------------------------------------------
ts = VTData(:,1);                       % VT timestamp

xy = VTData(:,2:3);                     % VT x-coordinate data
xylite = ThinData(xy,5000);

XY = FindBoxes(xy);                     % baited box coordinates 

plotXY = [XY;XY(1,:)];                  % baited box coordinate plot data       

[B0,B1,B2,Order] = CategorizeXY(XY);    % B0 = across from hypotenuse
                                        % B1 = short adjacent to B0
                                        % B2 = long adjacent to B0                            

Octagon = [...                          % Perfect octagon coordinates
    1 0.4142136;...
    0.4142136 1;...
    -0.4142136 1;...
    -1 0.4142136;...
    -1 -0.4142136;...
    -0.4142136 -1;...
    0.4142136 -1;...
    1 -0.4142136;...
    1 0.4142136];

center = (max(xy)-min(xy))/2+min(xy);
cx = center(1);                         % x-coordinate of maze center
cy = center(2);                         % y-coordinate of maze center

radius = 1.0823*0.8*((max(xy(:,1))-min(xy(:,1)))/2);% maze radius

aHXLim = [];                            % axes x-limits
aHYLim = [];                            % axes y-limits

C = 0;                                  % cursor motion count

DistB1B2 = [];                          % dist b/t Box1 & Box2, used in 
                                        % scale fcn

OctPt = [];                             % octagon point closes to cursor,
                                        % used for point snaps

rottheta = [];                          % both assist in tracking total
TotalRot = 0;                           % rotate

stheta = [];                            % stores radian values for scale fcn

Point = [];                             % stores current and past cursor
                                        % positions



% -------------------------------------------------------------------------

% OBJECT HANDLES

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% WINDOW HANDLE
% ------------------------------------
% Defines function window
% -------------------------------------------------------------------------
window = figure(...
    'units','pixels',...
    'position',[100 100 1290 800],...
    'name','VT Data Display',...
    'numbertitle','off',...
    'name','VT Data Fix',...
    'resize','off',...
    'CloseRequestFcn',@OutputVTData);

% -------------------------------------------------------------------------
% AXES HANDLE
% ------------------------------------
% Defines the axes on which all function data is plotted
% -------------------------------------------------------------------------
aH = axes(...
    'Parent',window,...
    'XTickLabel','',...
    'YTickLabel','');

hold on;

% -------------------------------------------------------------------------
% VT DATA PLOT
% ------------------------------------
% Video tracker data plot handle: dragging rotates data
% -------------------------------------------------------------------------
VTpH = plot(xylite(:,1),xylite(:,2),...
    'ButtonDownFcn',@StartRot);

% -------------------------------------------------------------------------
% BAITED BOX PLOT
% ------------------------------------
% Shows lines between baited boxes, allowing the user to visualize the
% spatial relationship between them
% -------------------------------------------------------------------------
boxplotH = plot(...
    plotXY(:,1),plotXY(:,2),...
    'Color',[1 0 0]);

% -------------------------------------------------------------------------
% OTCTAGON HANDLE
% ------------------------------------
% Acts as a user guide to proper maze shape
% -------------------------------------------------------------------------
oH = plot(Octagon(:,1)*radius+cx,Octagon(:,2)*radius+cy,...
    'Color',[1 1/2 0],...
    'LineWidth',2);

% -------------------------------------------------------------------------
% BAITED BOX POINT HANDLES
% ------------------------------------
% Manipulating these points reshapes maze data
% -------------------------------------------------------------------------
box0H = scatter(...
    B0(1),B0(2),...
    'Marker','.',...
    'SizeData',625,...
    'MarkerFaceColor',[1 1 0],...
    'MarkerEdgeColor',[1 1 0],...
    'ButtonDownFcn',@StartSkew);
box1H = scatter(...
    B1(1),B1(2),...
    'Marker','.',...
    'SizeData',625,...
    'MarkerFaceColor',[0 1 0],...
    'MarkerEdgeColor',[0 1 0],...
    'ButtonDownFcn',@StartMove);
box2H = scatter(...
    B2(1),B2(2),...
    'Marker','.',...
    'SizeData',625,...
    'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'ButtonDownFcn',@StartScale);


% -------------------------------------------------------------------------
% Fixing axes limits, aspect ratio
% -------------------------------------------------------------------------
set(aH,'YLim',[min(xylite(:,2))-100,max(xylite(:,2))+100]);
axis equal;

aHXLim = get(aH,'XLim');
aHYLim = get(aH,'YLim');

% -------------------------------------------------------------------------
% myRotate LINE HANDLE
% ------------------------------------
% Visible only during rotation, gives user visualization of point about
% which rotation occurs, magnitude of rotation
% -------------------------------------------------------------------------
rlH = line(...
    'Parent',aH,...
    'Color',[1 1/2 0],...
    'LineWidth',2,...
    'Visible','off');

% -------------------------------------------------------------------------
% CROSSHAIR HANDLES
% ------------------------------------
% Dragging the crosshairs positions the center of the maze
% -------------------------------------------------------------------------
xH = line(...
    'Parent',aH,...
    'XData',cx*[1 1],...
    'YData',aHYLim,...
    'Color',[1 1/2 0],...
    'ButtonDownFcn',@StartDragX,...
    'LineWidth',2);
% -------------------------------------------------------------------------
yH = line(...
    'Parent',aH,...
    'Color',[1 1/2 0],...
    'XData',aHXLim,...
    'YData',cy*[1 1],...
    'ButtonDownFcn',@StartDragY,...
    'LineWidth',2);

hold off;

% -------------------------------------------------------------------------
% TOTAL ROTATION TEXT HANDLE
% ------------------------------------
% Tracks user's total rotation of VT data
% -------------------------------------------------------------------------
TotalRotText = uicontrol(...
    'Parent',window,...
    'Style','text',...
    'Units','Pixels',...
    'FontUnits','Pixels',...
    'FontSize',12,...
    'Position',[10 10 80 20]);

% -------------------------------------------------------------------------
% ANGLE TEXT HANDLE
% ------------------------------------
% Tracks angle between lines B0-B1 and B0-B2
% -------------------------------------------------------------------------
AngleText = uicontrol(...
    'Parent',window,...
    'Style','text',...
    'Units','Pixels',...
    'FontUnits','Pixels',...
    'FontSize',12,...
    'Position',[10+90 10 80 20]);

% -------------------------------------------------------------------------
% DISTANCE TEXT HANDLE
% ------------------------------------
% Tracks ratio of B0-B2:B0-B1
% -------------------------------------------------------------------------
DistText = uicontrol(...
    'Parent',window,...
    'Style','text',...
    'Units','Pixels',...
    'FontUnits','Pixels',...
    'FontSize',12,...
    'Position',[10+90+90 10 80 20]);


% -------------------------------------------------------------------------
% VT DATA WRITE PUSHBUTTON
% ------------------------------------
% Prompts user to save new VTData as an excel file
% -------------------------------------------------------------------------
VTDataPB = uicontrol(...
    'Parent',window,...
    'Style','PushButton',...
    'Units','pixels',...
    'Position',[10+90+90+90,10,160,20],...
    'FontUnits','pixels',...
    'FontSize',10,...
    'String','Write VT Data',...
    'Callback',@WriteVTData);
    function [] = WriteVTData(varargin)
        WriteVTDataToExcel(VTData);
    end
% -------------------------------------------------------------------------








% -------------------------------------------------------------------------

% CALLBACK FUNCTIONS

% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% SKEW FUNCTIONS
% ------------------------------------
% B0 fcn; allows data skewing via B0 drag
% -------------------------------------------------------------------------
    function [] = StartSkew(varargin) %Box0 function
        set(window,'WindowButtonMotionFcn',@Skew);
        set(window,'WindowButtonUpFcn',@StopSkew);
        C = 0;
    end
% -------------------------------------------------------------------------
    function [] = Skew(varargin)
        C = C+1;
        % get current point
        pt = get(aH,'CurrentPoint');
        % assign current point to point array
        Point(C,:) = [pt(1),pt(3)];
        
        % theta is the angle between red and green
        skewTheta = cart2pol(B2(1)-B1(1),B2(2)-B1(2));
        midPoint = (B1+B2)/2; % midpoint between red and green
        
        if C > 1
            % get reference points
            RefPts = myRotate(-skewTheta,bsxfun(@minus,Point(C-1:C,:),midPoint));
            % ensure ref pts are above x-axis
            if RefPts(1,2) < 0
                % if not, fix them, add 180 degrees to rotation
                skewTheta = skewTheta + pi;
                RefPts = myRotate(pi,RefPts);
            end
            
            yScale = RefPts(2,2)/RefPts(1,2); % y scaling factor is ratio of pt2 height to pt1 height
            maxHeight = RefPts(2,2); % max height
            maxSkew   = RefPts(2,1)-RefPts(1,1); % max skew is x-difference
            
            % skew and scale the data
            xylite = skewData(skewTheta,yScale,xylite,midPoint,maxSkew,maxHeight);
            plotXY = skewData(skewTheta,yScale,plotXY,midPoint,maxSkew,maxHeight);
            
            B0 = plotXY(Order(1),:); % reassign B0 (yellow)
            set(VTpH    ,{'XData','YData'},{xylite(:,1),xylite(:,2)}); % reset plot data
            set(boxplotH,{'XData','YData'},{plotXY(:,1),plotXY(:,2)});
            set(box0H   ,{'XData','YData'},{    B0(:,1),    B0(:,2)});
            
            % ratio is B0-B2:B0-B1, angle is angle B1,B0,B2
            Angle = AngleBtPts(B0,B1,B2);
            Ratio = DistBtPts(B0,B2)/DistBtPts(B0,B1);
            set(DistText,'String',num2str(Ratio));
            set(AngleText,'String',num2str(Angle));
            FixAxes;
        end
    end
    function [xyOut] = skewData(skewTheta,yScale,xyIn,midPoint,maxSkew,maxHeight)
        xyIn  = myRotate(-skewTheta,bsxfun(@minus,xyIn,midPoint));
        xyIn(:,2) = xyIn(:,2)*yScale;
        xyIn(:,1) = xyIn(:,1)+(xyIn(:,2)/maxHeight)*maxSkew;
        xyOut = bsxfun(@plus,myRotate(skewTheta,xyIn),midPoint);
    end
% -------------------------------------------------------------------------
    function [] = StopSkew(varargin)
        set(window,'WindowButtonMotionFcn','');
        set(window,'WindowButtonUpFcn','');
        if C > 1
            skewTheta = cart2pol(B2(1)-B1(1),B2(2)-B1(2));
            RefPts = myRotate(-skewTheta,bsxfun(@minus,[Point(1,:);Point(C,:)],(B1+B2)/2));
            if RefPts(1,2) < 0
                skewTheta = skewTheta + pi;
                RefPts = myRotate(pi,RefPts);
            end
            yScale = RefPts(2,2)/RefPts(1,2);
            maxHeight = RefPts(2,2);
            maxSkew   = RefPts(2,1)-RefPts(1,1);
            xy = skewData(skewTheta,yScale,xy,(B1+B2)/2,maxSkew,maxHeight);
            VTData = [ts,xy];
%             hold on;
%             temp = ThinData(xy,5000);
%             plot(temp(:,1),temp(:,2),'Color',[1 1/2 0]);
%             axis equal;
%             hold off;
        end
    end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SCALE FUNCTIONS
% -------------------------------------------------------------------------
    function [] = StartScale(varargin) %Box2 function (I think)
        set(window,'WindowButtonMotionFcn',@Scale);
        set(window,'WindowButtonUpFcn',@StopScale);
        C = 0;
        DistB1B2 = [];
        stheta = [];
    end
% -------------------------------------------------------------------------
    function [] = Scale(varargin)
        C = C+1;
        pt = get(aH,'CurrentPoint');
        Point(C,:) = [pt(1),pt(3)];
        
        if C > 1
            B2 = Point(C,:);
            
            DistB1B2(C,1) = DistBtPts(B1,B2);
            stheta(C,1) = cart2pol(B2(1)-B1(1),B2(2)-B1(2));
            
            % Rotation
            RotAngle = stheta(C)-stheta(C-1);
            xylite = myRotate(RotAngle,bsxfun(@minus,xylite,B1));
            plotXY = myRotate(RotAngle,bsxfun(@minus,plotXY,B1));
            
            % Scaling Factor
            SF = DistB1B2(C)/DistB1B2(C-1);
            
            xylite = bsxfun(@plus,SF*xylite,B1);
            plotXY = bsxfun(@plus,SF*plotXY,B1);
            
            B0 = plotXY(Order(1),:); 
            B2 = plotXY(Order(3),:); 
            
            set(VTpH,{'XData','YData'},{xylite(:,1),xylite(:,2)});
            set(boxplotH,{'XData','YData'},{plotXY(:,1),plotXY(:,2)});
            set(box2H,{'XData','YData'},{B2(:,1),B2(:,2)});
            set(box0H,{'XData','YData'},{B0(:,1),B0(:,2)});
            
            FixAxes;
        else
            DistB1B2(C,1) = DistBtPts(B1,Point(C,:));
            stheta(C,1) = cart2pol(Point(C,1)-B1(1),Point(C,2)-B1(2));
        end
    end
% -------------------------------------------------------------------------
    function [] = StopScale(varargin)
        set(window,'WindowButtonMotionFcn','');
        set(window,'WindowButtonUpFcn','');
        % rotate by sum(diff(stheta))
        % scale by sum(DistB1B2(2:end)./DistB1B2(1:end-1))
        if C > 1
            SF = DistB1B2(end)/DistB1B2(1);
            xy = myRotate(sum(diff(stheta)),bsxfun(@minus,xy,B1));
            xy = bsxfun(@plus,SF*xy,B1);
            VTData = [ts,xy];
%             hold on;
%             temp = ThinData(xy,5000);
%             plot(temp(:,1),temp(:,2),'Color',[1 1/2 0]);
%             axis equal;
%             hold off;
        end
    end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% MOVE FUNCTIONS
% -------------------------------------------------------------------------
    function [] = StartMove(varargin)
        set(window,'WindowButtonMotionFcn',@Move);
        set(window,'WindowButtonUpFcn',@StopMove);
        C = 0;
        Point = [];
    end
% -------------------------------------------------------------------------
    function [] = Move(varargin)
        C = C + 1;
        pt = get(aH,'CurrentPoint');
        Point(C,:) = [pt(1),pt(3)];
        
        if C > 1
            MoveXY = Point(C,:)-Point(C-1,:);

            xylite = bsxfun(@plus,xylite,MoveXY);
            set(VTpH,'XData',xylite(:,1),'YData',xylite(:,2));
            
            plotXY = bsxfun(@plus,plotXY,MoveXY);
            set(boxplotH,'XData',plotXY(:,1),'YData',plotXY(:,2));
            
            B0 = plotXY(Order(1),:);
            B1 = plotXY(Order(2),:);
            B2 = plotXY(Order(3),:); 
            set(box0H,'XData',B0(1),'YData',B0(2));
            set(box1H,'XData',B1(1),'YData',B1(2));
            set(box2H,'XData',B2(1),'YData',B2(2));
            
            FixAxes;
        end        
    end
% -------------------------------------------------------------------------
    function [] = StopMove(varargin)
        set(window,'WindowButtonMotionFcn','');
        set(window,'WindowButtonUpFcn','');
        if C > 1
            MoveXY = sum(diff(Point));
            xy = bsxfun(@plus,xy,MoveXY);
            VTData = [ts,xy];
%             hold on;
%             temp = ThinData(xy,5000);
%             plot(temp(:,1),temp(:,2),'Color',[1 1/2 0]);
%             axis equal;
%             hold off;
        end
    end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% ROTATION FUNCTIONS
% -------------------------------------------------------------------------
    function [] = StartRot(varargin)
        set(window,'WindowButtonMotionFcn',@Rot);
        set(window,'WindowButtonUpFcn',@StopRot);
        TotalRot = 0;
        C = 0;
    end
% -------------------------------------------------------------------------
    function [] = Rot(varargin)
        C = C + 1;
        
        pt = get(aH,'CurrentPoint');
        pt = [pt(1),pt(3)];
        
        rottheta(C,1) = cart2pol(pt(1)-cx,pt(2)-cy);
        [ptx,pty] = pol2cart(rottheta(C),radius);
        
        pt = [ptx+cx,pty+cy];
        
        set(rlH,'Visible','on');
        set(rlH,'XData',[cx pt(1)]);
        set(rlH,'YData',[cy pt(2)]);
        
        if C > 1
            RotAngle = rottheta(C)-rottheta(C-1);
            
            xylite = bsxfun(@minus,xylite,[cx,cy]);
            xylite = myRotate(RotAngle,xylite);
            xylite = bsxfun(@plus,xylite,[cx,cy]);
            set(VTpH,'XData',xylite(:,1),'YData',xylite(:,2));
            
            plotXY = bsxfun(@minus,plotXY,[cx,cy]);
            plotXY = myRotate(RotAngle,plotXY);
            plotXY = bsxfun(@plus,plotXY,[cx,cy]);
            set(boxplotH,'XData',plotXY(:,1),'YData',plotXY(:,2));
            
            B0 = plotXY(Order(1),:);
            B1 = plotXY(Order(2),:);
            B2 = plotXY(Order(3),:);
            set(box0H,'XData',B0(1),'YData',B0(2));
            set(box1H,'XData',B1(1),'YData',B1(2));
            set(box2H,'XData',B2(1),'YData',B2(2));
            
            TotalRot = TotalRot+RotAngle;
            set(TotalRotText,'String',num2str(TotalRot*180/pi));
            
            FixAxes;
        end
    end
% -------------------------------------------------------------------------
    function [] = StopRot(varargin)
        set(window,'WindowButtonMotionFcn','');
        set(window,'WindowButtonUpFcn','');
        set(rlH,'Visible','off');
        if C > 1
            xy = bsxfun(@minus,xy,[cx,cy]);
            xy = myRotate(TotalRot,xy);
            xy = bsxfun(@plus,xy,[cx,cy]);
            VTData = [ts,xy];
%             hold on;
%             temp = ThinData(xy,5000);
%             plot(temp(:,1),temp(:,2),'Color',[1 1/2 0]);
%             axis equal;
%             hold off;
        end
    end
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% CROSSHAIR DRAG FUNCTIONS
% -------------------------------------------------------------------------
    function [] = StartDragX(varargin)
        set(window,'WindowButtonMotionFcn',@DragX);
        set(window,'WindowButtonUpFcn',@StopDrag);
    end
% -------------------------------------------------------------------------
    function [] = DragX(varargin)
        pt = get(aH,'CurrentPoint');
        cx = pt(1);
        set(xH,'XData',cx*[1 1]);
        set(oH,'XData',Octagon(:,1)*radius+cx);
        set(oH,'YData',Octagon(:,2)*radius+cy);
    end
% -------------------------------------------------------------------------
    function [] = StartDragY(varargin)
        set(window,'WindowButtonMotionFcn',@DragY);
        set(window,'WindowButtonUpFcn',@StopDrag);
    end
% -------------------------------------------------------------------------
    function [] = DragY(varargin)
        pt = get(aH,'CurrentPoint');
        cy = pt(3);
        set(yH,'YData',cy*[1 1]);
        set(oH,'XData',Octagon(:,1)*radius+cx);
        set(oH,'YData',Octagon(:,2)*radius+cy);
    end
% -------------------------------------------------------------------------
    function [] = StopDrag(varargin)
        set(window,'WindowButtonMotionFcn','');
        set(window,'WindowButtonUpFcn','');
        set(rlH,'Visible','off');
    end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% FIX AXES
% -------------------------------------------------------------------------
    function [] = FixAxes(varargin)
        set(aH,'XLim',aHXLim,'YLim',aHYLim);
        set(aH,'XTickLabel','','YTickLabel','');
        axis equal;
    end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% MOVE CURSOR
% -------------------------------------------------------------------------
    function [] = MoveCursor(varargin)
        
        windowposition = get(window,'Position');
        aHunits = get(aH,'units');
        set(aH,'units','pix');
        aHposition = get(aH,'Position');
        aHxlim = get(aH,'XLim');
        aHylim = get(aH,'YLim');
        set(aH,'units',aHunits);
        set(0,'units','pix');
        
        aHyratio = aHposition(4)/abs(diff(aHylim));
        aHxratio = aHposition(3)/abs(diff(aHxlim));
        
        OctPt = [OctPt(1)-aHxlim(1),OctPt(2)-aHylim(1)];
        OctPtPix = [...
            OctPt(1)*aHxratio+windowposition(1)+aHposition(1),...
            OctPt(2)*aHyratio+windowposition(2)+aHposition(2)];
        
        screenunits = get(0,'units');
        set(0,'units','pix');
        set(0,'PointerLocation',OctPtPix);
        set(0,'units',screenunits);
        
    end
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% CLOSE REQUEST FUNCTION
% ------------------------------------
% Updates VT Data in maze transform workspace
% -------------------------------------------------------------------------
    function [] = OutputVTData(varargin)
        NewVTData = VTData;
        delete(window);
    end
% -------------------------------------------------------------------------

uiwait(window);
end

function [B0,B1,B2,Order] = CategorizeXY(XY)
numBoxes = length(XY(:,1));
D = zeros(numBoxes,numBoxes);
for n = 1:numBoxes
    for k = 1:numBoxes
        D(k,n) = sqrt(sum(abs(XY(k,:)-XY(n,:)).^2));
    end
    D(:,n) = sortrows(D(:,n),1);
end

MaxD = max(D(3,:));
[~,Middle] = find(D(3,:) ~= MaxD);
[~,Across] = find(D(3,:) == MaxD);

Order(1) = Middle;

B0 = XY(Middle,:);
if D(end-1,Across(1)) > D(end-1,Across(2))
    B1 = XY(Across(2),:); B2 = XY(Across(1),:);
    Order(2:3) = [Across(2),Across(1)];
else
    B1 = XY(Across(1),:); B2 = XY(Across(2),:);
    Order(2:3) = [Across(1),Across(2)];
end
end

function [Dist] = DistBtPts(Pt1,Pt2)
Dist = sqrt(sum(abs(Pt1-Pt2).^2));
end

function [Angle] = AngleBtPts(origin,u,v)
u = u - origin; v = v - origin;
CosTheta = dot(u,v)/(norm(u)*norm(v));
Angle = acos(CosTheta)*180/pi;
end

function [] = WriteVTDataToExcel(VTData)
if length(VTData(:,1)) > 65536
    VTData = SplitData(VTData,65536);
else
    VTData = {VTData};
end

[Name,Path] = uiputfile('.xls','Save As');
excelObj = actxserver('Excel.Application');
Workbook = excelObj.Workbooks.Add;
numSheets = length(VTData);

for n = numSheets:-1:1
    Size = size(VTData{n});
    OverShoot = Size(2)-26;
    if OverShoot > 0
        NumAlphabets = ceil(Size(2)/26)-1;
        ExcelRange = ['A1:' char('a'+NumAlphabets-1) char('a'+OverShoot-1) num2str(Size(1))];
    else
        ExcelRange = ['A1:' char('a'+Size(2)-1) num2str(Size(1))];
    end
        
    Worksheet = excelObj.sheets.Add;
    Worksheet.Name = ['NewVTData' num2str(n)];
    Range = get(Worksheet,'Range',ExcelRange);
    Range.Value = VTData{n};    
end

Workbook.SaveAs([Path Name]); Workbook.Close;
excelObj.Quit; delete(excelObj);

end
function [NewData] = SplitData(Data,CutOff)
sizeData = size(Data);
Index = 0:CutOff:sizeData(1);
Index(end+1) = sizeData(1);
numSections = length(Index)-1;
for n = 1:numSections
    NewData{n} = Data(Index(n)+1:Index(n+1),:);
end
end

% -------------------------------------------------------------------------
function [Data] = ThinData(Data,MaxData)
    NumDataPoints = length(Data(:,1));
    if NumDataPoints > MaxData;
        d = (NumDataPoints-MaxData)/NumDataPoints;
        if d < 1
            Index = 1:1/d:NumDataPoints;
            Data(floor(Index),:) = [];
        else
            Index = 1:d:NumDataPoints;
            Data = Data(floor(Index));        
        end
    end
end




% Rotation
% -------------------------------------------------------------------------
function [NewCoord] = myRotate(theta,Coord)
% Theta needs to be in radians
NewCoord(:,1) = Coord(:,1).*cos(theta)-Coord(:,2).*sin(theta);
NewCoord(:,2) = Coord(:,1).*sin(theta)+Coord(:,2).*cos(theta);
end
% -------------------------------------------------------------------------



