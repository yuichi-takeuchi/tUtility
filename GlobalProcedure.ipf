#pragma rtGlobals = 1		// Use modern global access method.
#pragma version = 1.00	//by Yuichi Takeuchi 120124
#pragma IgorVersion = 6.1	//Igor Pro 6.1 or later

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This procedure (tUtility) offers the general purpose GUI (control panel) with necessory library.
// This is written by Yuichi Takeuchi PhD and mainly used for analyses and figure preparation of in vitro patch-clamp recordings.
// But it can be utilized for other analyses including in vivo intra- and extracellular recordings, calcium imagings etc.
//
// Claims to Yuichi Takeuchi PhD, Department of Physiology, University of Szeged, Hungary
// Email: yuichi-takeuchi@umin.net
// 
// Dependency:
// Several functions depend on the following libraries.
// SetWindowExt.XOP (http://fermi.uchicago.edu/freeware/LoomisWood/SetWindowExt.shtml)
// PPT.XOP (http://www.mpibpc.mpg.de/groups/neher/index.php?page=software)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Menu "Utilities"
	"NewControlPanel", t_NewControlPanel() //Display Main Control Panel
	"DisplayControlPanel", t_DisplayControlPanel()
	"GlobalProcedure.ipf", DisplayProcedure/W= 'GlobalProcedure.ipf'
End

Proc t_NewControlPanel()
	t_global_variable()
	t_MakeLines()
	t_cpN00()
endMacro

Proc t_DisplayControlPanel()
	if(WinType("ControlPanel") != 0))
	DoWindow/F ControlPanel 
	endif
endMacro

Window t_MakeControlPanel() : Panel
	t_global_variable()
	t_MakeLines()
	t_cpN00()
endMacro

Function tYT_FolderCheck()
	If(DataFolderExists("root:Packages:YT"))
		else
			If(DataFolderExists("root:Packages"))
					NewDataFolder root:Packages:YT
				else
					NewDataFolder root:Packages
					NewDataFolder root:Packages:YT
			endif
	endif
End

Function t_global_variable()
	tYT_FolderCheck()
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:Packages:YT
	Variable/G v_e = 0
	Variable/G v_nc = 0
	Variable/G v_ns = 0 
	Variable/G v_nis = 0
	Variable/G jwv_e = 0
	Variable/G jwv_nc = 0
	Variable/G jwv_ns = 0
	Variable/G cc_ns = 0
	Variable/G cc_slope = 10
	Variable/G vline = 0
	Variable/G hline = 0
	Variable/G vca_posi = 0
	Variable/G tangent_line = 0
	Variable/G markers = 0
	Variable/G delete_p = 0
	Variable/G vca_fit_charge = 4e-2
	Variable/G vca_dis_f_arti = 1e-3
	Variable/G vca_onset_var = 0.70
	Variable/G AX = 0
	Variable/G AY = 0
	Variable/G RX = 1
	Variable/G RY = 1
	Variable/G lmin = 0
	Variable/G lmax = 1
	Variable/G bmin = 0
	Variable/G bmax = 1
	Variable/G graphslider_X = 0
	Variable/G graphslider_Y = 0
	Variable/G tWinCategory = 0
	Variable/G PN = 1
	Variable/G GraphLN = 0
	Variable/G SweepViewer = 0
	Variable/G IIRHi = NaN
	Variable/G IIRLow = 0.06
	String/G tWin = "Select tWin!"
	String/G tWinL = "Select tWinL!;"
	String/G tWinCategoryList ="All;Graphs;Tables;Layouts;Notebooks;Panels;Procedure Windows;XOP target windows;"
	String/G tWave0 = "Select tWave0!"
	String/G tWave1 = "Select tWave1!"
	String/G tWL ="Select WL!;"
	String/G tjw = "def"
	String/G tjwsub = "def"
	
	SetDataFolder fldrSav0
end

//////////////////////////////////////////////////////////////////////////////////////////

Function t_cpN00()
	SVAR tWin = 	root:Packages:YT:tWin
	PauseUpdate; Silent 1		// building window...
//	NewPanel/N=ControlPanel/W=(600, 5, 1000, 655)
	NewPanel/N=ControlPanel/W=(1185,5,1585,655)
	TabControl tb0 pos={2,2}, size={398,648}, proc=t_TabProc
	TabControl tb0, tabLabel(0) = "V&S"
	TabControl tb0, tabLabel(1) = "JW"
	TabControl tb0, tabLabel(2) ="02"
	TabControl tb0, tabLabel(3) ="03"
	TabControl tb0, tabLabel(4) ="04"
	TabControl tb1 pos={4, 305}, size={392,341}, proc=t_TabProc
	TabControl tb1, tabLabel(0) = "GEN"
	TabControl tb1, tabLabel(1) = "Edit"
	TabControl tb1, tabLabel(2) = "Analy"
	TabControl tb1, tabLabel(3) = "CC"
	TabControl tb1, tabLabel(4) = "VCA"
	TabControl tb1, tabLabel(5) = "TCA"
//tab00	
	GroupBox gbtwin_tab00,pos={13,25},size={373,119},title="Target Window "
	Button BttWin_tab00,pos={15,40},size={50,20},proc=t_tWinButton,title="tWin"
	Button BtRenametWin_tab00,pos={65,40},size={50,20},proc=t_rename_tWin,title="RNtWin"
	Button BtCleartWin_tab00,pos={115,40},size={25,20},proc=t_CleartWin,title="tWi"
	Button BtCleartWin_tab00,fColor=(0,15872,65280)
	SetVariable settwin_tab00,pos={142,40},size={89,16},title=" ",value= root:Packages:YT:tWin
	PopupMenu Poptwin_tab00 pos={233,38},size={105,20},bodyWidth= 105,value= winlist("*", ";", ""), proc=t_PopMenuProc_tWin
	SetVariable t_setvartWinpopNum_tab00,pos={353,40},size={30,16},proc=t_SetProc_tWinpopNum_tab00,title=" ", value = root:Packages:YT:PN, limits={0,inf,1}
	Button BtGettWinList_tab00 pos = {15, 80}, title="GWinL", proc=t_GetWinList
	Button BtAddToWinL_tWin_tab00,pos={65,80},size={50,20},proc=t_tWinTotWinList,title="tWin>L"
	Button BtKillWinList_tab00,pos={115,80},size={50,20},proc=t_DoWinKillWinList,title="DW/KL"
	Button BtCleartWinL_tab00,pos={166,80},size={25,20},proc=t_CleartWinList,title="tWi",fColor=(0,15872,65280)
	SetVariable settWinList_tab00,pos={170,81},size={123,16},value= root:Packages:YT:tWinL,bodyWidth= 100, title = " "
	PopupMenu t_PopUp_Check_tWinL_tab00,pos={294,79},size={80,20},bodyWidth= 80,value= #"root:Packages:YT:tWinL"
	Button BtShowCategories_tab00 title ="SCatgs", proc = t_SHCategories, pos={15,60}
	Button BtHideCategories_tab00 title ="HCatgs", proc = t_SHCategories, pos={65,60}
	Button BtGetRecreationMacro_tab00,pos={15,100},size={50,20},proc=t_GetRecreationMacro,title="DW/R"
	Button BtGetRecreationMacroKill_tab00,pos={65,100},size={50,20},proc=t_GetRecreationMacro,title="DW/R/K"
	Button BtGetWindowWsize_tab00,pos={115, 100},size={50,20},proc=t_GetWindowWsize, title="Wsize"
	Button BtRebornControlPanel_tab00,pos={165,100},size={50,20},proc=t_RebornControlPanel,title="Reborn"
	Button BtSHideGCon_tab00 title="GCon", pos={15, 120}, proc = t_GraphControlPanel
	Button BtSHideStat_tab00 title="Stat", pos={65,120}, proc = t_StatPanel
	Button BtSHideImage_tab00 title="Image", pos={115, 120}, proc = t_ImagePanel
	Button BtTestPanel_tab00 title="Test", pos={165, 120}, proc = t_TestPanel
	Button BtHelpBrowser_tab00 title="Help", pos={215,120}, proc = t_HelpBrowser
	SetVariable t_setvarSweepViewer_tab00,pos={294,122},size={80,16},proc=t_SweepViewer,title=" Sweep",limits={0,inf,1},value= root:Packages:YT:SweepViewer

	PopupMenu t_PopUp_tWinCategory_tab00, pos={175,60},proc=t_PopUpProc_tWinCategory, bodyWidth=100 ,value = #"root:Packages:YT:tWinCategoryList"
	GroupBox gbtWave0_tab00,pos={12,148},size={373,135},title="Target Wave & Global Variable"
	Button BtCleartWave0_tab00,pos={65,160},size={44,20},proc=t_CleartWave0,title="tWave0"
	Button BtCleartWave0_tab00,fColor=(0,15872,65280)
	Button BtCsrAtWave0_tab00 pos={15, 160}, title="CsrA_W", proc=t_CsrAtWave0
	Button BtCleartWave1_tab00,pos={65,180},size={44,20},proc=t_CleartWave1,title="tWave1"
	Button BtCleartWave1_tab00,fColor=(0,15872,65280)
	SetVariable settWave0_tab00,pos={110,160},size={100,16},title=" "
	SetVariable settWave0_tab00,value=root:Packages:YT:tWave0,bodyWidth= 100
	Button BtCsrBtWave1_tab00 pos={15, 180}, title="CsrB_W", proc=t_CsrBtWave1	
	SetVariable settWave1_tab00,pos={110,180},size={100,16},title=" "
	SetVariable settWave1_tab00,value= root:Packages:YT:tWave1,bodyWidth= 100
	PopupMenu PoptWave0_tab00 pos={210, 160}, size={75,20}, value= wavelist("*", ";", ""), proc=t_PopMenuProc_tWave,bodyWidth=75
	PopupMenu PoptWave0intw_tab00 pos={290, 160}, size={75,20}, value="witwin", proc=t_PopMenuProc_tWave,bodyWidth=75
	PopupMenu PoptWave1_tab00 pos={210, 180}, size={75,20}, value= wavelist("*", ";", ""), proc=t_PopMenuProc_tWave,bodyWidth=75
	PopupMenu PoptWave1intw_tab00 pos={290, 180}, size={75,20}, value="witwin", proc=t_PopMenuProc_tWave,bodyWidth=75
	Button BtChange01_tab00 pos={115, 200}, title="Ch01", proc=t_change01
	Button BtGetWaveNameFromTable0_tab00 ,pos={15,200},size={50,20},proc=t_GetWaveNameFromTable,title="WFTabl0"
	Button BtGetWaveNameFromTable1_tab00,pos={65,200},size={50,20},proc=t_GetWaveNameFromTable,title="WFTabl1"
	Button BtGettWaveList_tab00 pos = {15, 220}, title="GetWL", proc=t_gettwavelist
	Button BtAddToWL_tWave_tab00,pos={65,220},size={50,20},proc=t_tW0ToWL,title="tW0>tWL"
	Button BtGVTotWL_tab00,pos={115,220},size={50,20},proc=t_GVTotWL,title="GV>tWL"
	Button BtCleartWL_tab00,pos={166,220},size={25,20},proc=t_CleartWL,title="tWL",fColor=(0,15872,65280)
	Button BtWLMaquee_tab00,pos={165,200},size={50,20},proc=t_GetWL_Maquee,title="WLMarq"
	SetVariable settWaveList_tab00,pos={170,221},size={123,16},value=root:Packages:YT:tWL,bodyWidth= 100, title = " "
	PopupMenu t_PopUp_Check_tWL_tab00,pos={294,219},size={80,20},bodyWidth= 80,value= #"root:Packages:YT:tWL"
	Button BttWave0_tab00 title="gv>tW0", proc = t_tWave0Button, pos = {15, 240}
	Button BtJw_GV_tab00 title="Jw_GV", proc = t_Jw_GVButton, pos = {65, 240}
	Button Buttonrename_tab00 title="rename", proc=t_rename, pos={115,240}
	Button BtReNamePatchMaster_tab00,pos={65,260},size={50,20},proc=t_renamePatchMaster,title="ReNPMP"
	Button BtRenameABF_tab00,pos={115,260},size={50,20},proc=t_renameABF,title="ReNABF"
	Button BtDispAllWaves_tab00,pos={165,260},size={50,20},proc=t_dispallwaves,title="DispAW"
	SetVariable sv_v_e_tab00,pos={171,242},size={48,16},proc=t_SetVarProc,title="E"
	SetVariable sv_v_e_tab00,value=root:Packages:YT:v_e,bodyWidth= 37,limits={0,inf,1}
	SetVariable sv_v_nc_tab00,pos={220,242},size={49,16},proc=t_SetVarProc,title="C"
	SetVariable sv_v_nc_tab00,value=root:Packages:YT:v_nc,bodyWidth= 37,limits={0,inf,1}
	SetVariable sv_v_ns_tab00,pos={270,242},size={48,16},proc=t_SetVarProc,title="S"
	SetVariable sv_v_ns_tab00,value=root:Packages:YT:v_ns,bodyWidth= 37,limits={0,inf,1}
	SetVariable sv_v_nis_tab00,pos={322,242},size={51,16},proc=t_SetVarProc,title="IS"
	SetVariable sv_v_nis_tab00,value=root:Packages:YT:v_nis,bodyWidth= 37,limits={0,inf,1}
//tab01
	Make/O root:Packages:YT:jw
	Make/O root:Packages:YT:jwsub
	SetVariable sv_tjw_tab01 pos={20, 30}, size={150, 20}, title="JW is ", proc=t_SetJwVarProc, value=root:Packages:YT:tjw
	TitleBox Titleb_minus_tab01 title="-",pos={180,30}, frame=0
	SetVariable sv_tjwsub_tab01 pos={220, 30}, size={150, 20}, title ="JWSub", value = root:Packages:YT:tjwsub
	GroupBox gbgv1_tab01 title="JW Variable",pos={15,55},size={360,63}
	SetVariable sv_jwv_e_tab01 pos={20, 73}, size={75, 20}, proc=t_SetJwVarProc,value=root:Packages:YT:jwv_e,limits={0,inf,1}
	SetVariable sv_jwv_nc_tab01 pos={100, 73}, size={75, 20}, proc=t_SetJwVarProc,value=root:Packages:YT:jwv_nc,limits={0,inf,1}
	SetVariable sv_jwv_ns_tab01 pos={180, 73}, size={75, 20}, proc=t_SetJwVarProc,value=root:Packages:YT:jwv_ns,limits={0,inf,1}
	Button BtDoWinJw_tab01 title = "DoWinJ", proc = t_DoWinJw, pos = {210, 90}
	Button BtDoWinJwsub_tab01 title = "DoWJS", proc = t_DoWinJwSub, pos = {160, 90}
	Button BtSetAxisLMan_tab01 title ="SetALM", proc=t_setaxis_jw, pos={260, 70}
	Button BtSetAxisLA_tab01 title = "SetALA", proc=t_setaxis_jw, pos={310, 70}
	Button BtSetAxisBMan_tab01 title = "SetABM", proc=t_setaxis_jw, pos={260, 90}
	Button BtSetAxisBA_tab01 title = "SetABA", proc=t_setaxis_jw, pos={310, 90}
	PopupMenu PoptWave0_tab01 pos={50, 93}, size={75,20}, value= wavelist("*", ";", ""), proc=t_PopMenuProc_tJwWave
	TitleBox Titleb_attention_tab01 title="The target window is only graph_jw !",pos={20,120},frame=0
	Button BtDpjw_tab01 title="dpjw", proc=t_dpjw, pos={5, 130}
	Button BtDpjwsub_tab01 title="dpsub", proc=t_dpjwsub, pos={5, 150}
	Button BtKillwavesJw_tab01 title="KillJw", proc=t_KillWavesJw, pos={55, 130}
	Button BtJwsubtW0_tab01 title="JStW0", proc=t_JwsubtW0, pos={55, 150}
	Button BtJw2tWave0_tab01,pos={105,130},size={50,20},proc=t_BtJw2tWave0,title="Jw2tW0"
	Button BTShowInfo_tab01 title="SInfo", proc=t_info, pos={170, 220}
	Button BTShowTools_tab01 title="STools", proc=t_info, pos={220, 220}
	
//tab10
	Button BtLabeLCursol_tab10,pos={5,325},size={50,20},help={"Cursor control"},fColor=(0,12800,52224),title="Cursor"
	Button BtAlignCs_tab10,pos={55,325},size={30,20},proc=t_AlignCsrX,title="ACs"
	Button BtMIntCs_tab10,pos={85,325},size={35,20},proc=t_MCsrs,title="icsr"
	Button BtMHorCs_tab10,pos={120,325},size={35,20},proc=t_MCsrs,title="hcsr"
	Button BtVCs_tab10,pos={155,325},size={50,20},proc=t_vcsra,title="vcsrA"
	Button BtXCs_tab10,pos={205,325},size={50,20},proc=t_xcsra,title="xcsrA"
	Button BtKillCsr_tab10,pos={255,325},size={50,20},proc=t_KillCsr,title="killc"
	CheckBox CheckVL_tab10,pos={310,327},size={27,14},variable=root:Packages:YT:vline,proc=t_vhCheckProc,title="vl"
	CheckBox CheckHL_tab10,pos={340,327},size={27,14},variable=root:Packages:YT:hline,proc=t_vhCheckProc,title="hl"
	Button BtLabelGraph_tab10,pos={5,345},size={50,20},help={"Graph control"},fColor=(16384,16384,65280),title="Graph"
	Button BTDisplay_tab10,pos={55,345},size={50,20},proc=t_disp,title="Disp"
	Button BTDisplayvs_tab10,pos={105,345},size={50,20},proc=t_dispvs,title="Dispvs"
	Button BtDispWaveList_tab10,pos={155,345},size={50,20},proc=t_dispwl,title="DispWL"
	Button BtAppToGraph_tab10,pos={205,345},size={50,20},proc=t_atg,title="ATG"
	Button BtmAppToGraph_tab10,pos={255,345},size={50,20},proc=t_matg,title="mATG"
	Button BtAppToGraphWL_tab10,pos={305,345},size={50,20},proc=t_atgwl,title="ATGWL"
	Button BtAppendToGraph_NewAxis_tab10,pos={360,345},size={30,20},proc=t_AppendToGraphNewAxis,title="NAx"
	Button BtDispByGV_tab10, pos = {55, 365}, size= {50, 20}, proc = t_bvc, title = "DispGV"
	Button BtRvFG_tab10,pos={105,365},size={50,20},proc=t_rfg,title="RFG"
	Button BtMakeUnit_tab10,pos={155,365},size={50,20},proc=t_MakingUnit,title="Unit"
	Button BtShowInfo_tab10,pos={205,365},size={50,20},proc=t_Showinfo,title="ShowInf."
	Button BtOffset_tab10,pos={255,365},size={50,20},proc=t_GraphOffset,title="Offset"
	Button BtIVCrossing_tab10,pos={305,365},size={50,20},proc=t_IVCrossing,title="IVCross"
	Button BtLabelTable_tab10,pos={5,385},size={50,20},title="Table"
	Button BtLabelTable_tab10,fColor=(0,0,65280)
	Button BtEdit_tab10,pos={56,385},size={50,20},proc=t_Edit,title="Edit"
	Button BtAppToTable_tab10,pos={106,385},size={50,20},proc=t_att,title="ATT"
	Button BtATTWL_tab10,pos={155,385},size={50,20},proc=t_ATTWL,title="ATTWL"
	Button BtRvFT_tab10,pos={205,385},size={50,20},proc=t_rft,title="RFT"
	Button BtMT_tab10,pos={255,385},size={50,20},proc=t_mt,title="MT"
	Button BtMT_tab10,help={"Decreasing sizes of columns and fonts"}
	
	Button BtLabelLayout_tab10,pos={5,405},size={50,20},help={"Commands on layout"},fColor=(16384,16384,65280),title="Layout"
	Button Btnl_tab10,pos={55,405},size={50,20},proc=t_nl,title="Layout"
	Button Btll_tab10,pos={105,405},size={50,20},proc=t_nl,title="lLayout"
	Button BtPPLyOut_tab10,pos={155,405},size={50,20},proc=t_PPLayout,title="PPLyOut"
	Button BtATLG_tab10,pos={205,405},size={50,20},proc=t_atlg,title="ATLG"
	Button BtATLG_tab10,help={"Append selected graph to layout"}
	Button BtATLT_tab10,pos={255,405},size={50,20},proc=t_atlt,title="ATLT"
	Button BtATLT_tab10,help={"Append selected table to layout"}
	Button BtRTL_tab10,pos={305,405},size={50,20},proc=t_rfl,title="RFL"
	Button BtRTL_tab10,help={"Remove selected object from layout"}
	Button BtDrawRectPPT_tab10,pos={55,425},size={50,20},proc=t_pptrec,title="PPTRec"
	Button BtAllObjectOnLayoutTrans_tab10,pos={105,425},size={50,20},proc=t_getstrans,title="Transp"
	
	Button BtLabelNotebook_tab10,pos={5,445},size={50,20},help={"Open a notebook"},fColor=(0,15872,65280),title="Notebk"
	Button BtCN_tab10,pos={155,445},size={50,20},proc=t_note,title="CNote"
	Button BtPN_tab10,pos={55,445},size={50,20},proc=t_note,title="PNote"
	Button BtFN_tab10,pos={105,445},size={50,20},proc=t_note,title="FNote"
	Button BtIOLabel_tab10,pos={5,465},size={50,20},title="IOWaves", fColor=(29440,0,58880)
	Button BtSavewaves_tab10,pos={55,465},size={50,20},proc=t_Savewaves,title="SaveWs"	
	Button BtCategoryPlot_tab10,pos={5,485},size={50,20},title="CatPlot"
	Button BtCategoryPlot_tab10,fColor=(13056,0,26112)
	Button BtCatTableWave_tab10,pos={55,485},size={50,20},proc=t_PrepTable_Waves,title="Ts&Ws"
	Button BtApproxWL_tab10,pos={105,485},size={50,20},proc=t_Approx_tWL,title="ApprWL"
	Button BtCPWL_tab10,pos={155,485},size={50,20},proc=BtCPWL_tab10,title="CPtWL"
	Button BtErrorBarWL_tab10,pos={205,485},size={50,20},proc=t_ErrorBarWL,title="EB_WL"
	Button BtSingleTable_tab10,pos={255,485},size={50,20},proc=t_Single_Category,title="S. Cat"

//tab11
	Button BTDuplicateWs_tab11,pos={55,325},size={50,20},proc=t_dupws,title="DupWs"
	Button BtDuplicateWL_tab11,pos={105,325},size={50,20},proc=t_DuplicatetWL,title="DuptWL"
	Button BtKillWaves_tab11,pos={5,345},size={50,20},proc=t_killwaves,title="KillWV"
	Button BtKillWaves_tab11,help={"Kill target waves"}
	Button BtKillWavesFromList_tab11 title="KillWL",proc=t_Button_KillWaveList, pos = {55, 345}, help = {"Kill waves on the target wavelist"}
	Button Bt0toNaN_tab11,pos={105,345},size={50,20},proc=t_0toNaN,title="02NaN"
	Button Bt0toNaN_tab11,help={"Convert Zero to NaN on the target wave"}
	Button Bt0toNaNWL_tab11,pos={155,345},size={50,20},proc=t_0toNaNWL,title="02NWL"
	Button BtNan20_tab11, pos={205, 345}, size={50, 20}, proc=t_NaNtoZero, title="Nan20"
	Button BtNan20WL_tab11, pos={255,345}, size={50,20}, proc=t_NaNtoZeroWL, title="N20WL"	
	Button BtMakeWavestoT_tab11,pos={5,325},size={50,20},proc=t_makewst,title="MWsT"
	Button BtMakeWavestoT_tab11,help={"Make a new wave or textwave"}
	Button BtRenameWs_tab11,pos={155,325},size={50,20},proc=t_RenameWs,title="ReNWs"
	Button BtRenameVariable_tab11,pos={251,325},size={45,20},proc=t_RenameVariable,title="ReNVW"
	Button BtRenameWL_tab11,pos={206,325},size={45,20}, proc=t_RenametWL,title="ReNtWL"
	Button BtConnectsWaves_tab11,pos={296,325},size={45,20},proc=t_ConnectWs,title="ConWs"
	Button BtContiConWsReNWs_tab11,pos={341,325},size={50,20},proc=t_ContiConWsReNWs,title="CWRWs"
	Button BtContiConWaveList_tab11,pos={305,345},size={50,20},proc=t_ContiConWL,title="ConWL"
	Button Bt_subtraction_tab11,pos={5,365},size={50,20},proc=t_subtraction,title="0-1"
	Button Bt_subtraction_tab11,help={"Make knew wave as tWave0 - tWave1"}
	Button Bt_subtractionbase_tab11,pos={105,365},size={50,20},proc=t_subtractionbase,title="sub_csr"
	Button Bt_subtractionbase_tab11,help={"Subtract value of vcsr(A) from tWave0"}
	Button Bt_msubtractionbase_tab11,pos={155,365},size={50,20},proc=t_subtractionbase,title="msub_csr"
	Button Bt_msubtractionbase_tab11,help={"Subtract value of vcsr(A) from waves w_(v_e)_(v_nc)_(v_nis) to w_(v_e)_(v_nc)_(v_ns)"}
	Button BtSubtW0FtWL_tab11,pos={5,385},size={50,20},proc=t_SubtWave0FromtWL,title="tWL-0"
	Button BtSub_tWL_tab11,pos={55,385},size={50,20},proc=t_subCursol_tWL,title="scsr_tWL"
	Button BtplusC_tab11,pos={105,385},size={50,20},proc=t_plusCWL,title="plusCWL"
	Button BtbyC_tab11,pos={155,385},size={50,20},proc=t_byCWL,title="byCWL"
	Button BtNormalize_tab11,pos={205,385},size={50,20},proc=t_NormalizeWave,title="Normalz"
	Button BtInvertPoints_tab11,pos={256,385},size={50,20},proc=t_InvertPoints,title="InvertPs"
	Button BtLineBetween2pnt_tab11,pos={5,405},size={50,20},proc=t_line_between_2pnt,title="line2pnt"
	Button BtArtiToNaN_tab11,pos={55,405},size={50,20},proc=t_Artifact2NaN,title="Art2NaN"
	Button BtMiniEventAvg_tab11,pos={255,405},size={50,20},proc=t_MiniEventAverage,title="EvenAvg"
	Button BtWaveABS_tab11,pos={5,425},size={50,20},proc=t_WaveABS,title="ABS"
	Button BtEliminate_left_par_tab11,pos={55,425},size={50,20},proc=t_eliminate_left_parenthesis,title="Elim("
	Button BtLowPassFilterWL_tab11,pos={105,425},size={50,20},proc=t_LowPassFilterWL,title="LPFWL"
	SetVariable Setvar_IIRHi_tab11,pos={160,428},size={70,16},title="Hi",value= root:Packages:YT:IIRHi
	SetVariable Setvar_IIRLow_tab11,pos={235,428},size={70,16},title="Low",value= root:Packages:YT:IIRLow
	Button Bt_Base_tab11,pos={5,445},size={50,20},proc=t_mkbasewave,title="Basel"
	Button BtModifyTargetWave_tab11,pos={5,465},size={50,20},proc=t_ModifyTargetWave0,title="tW0 = "
	Button BtRec2DGauss_tab11,pos={5,485},size={50,20},proc=t_Rec2DGauss,title="Rec2D"
	Button BtRecDouble2DGauss_tab11,pos={55,485},size={50,20},proc=t_RecDouble2DGauss,title="RecD2D"
	Button Bt_in_vivo_001_tab11,pos={5,505},size={50,20},proc=t_in_vivo_001,title="vivo_1"
	Button BtMakeNOE_tab11,pos={5,525},size={50,20},proc=t_noe,title="NOE"

//tab12
	Button Buttonautostats_tab12,pos={5,325},size={50,20},proc=t_astats,title="AuStats"
	Button BtAutoStatsWL_tab12,pos={55,325},size={50,20},proc=t_atatswl,title="AuSTWL"
	Button BtAutoStatsStimNum_tab12,pos={105,325}, size = {50,20}, proc=t_astatssn, title = "AuSTSN"
	Button Buttonavg_tab12,pos={155,325},size={50,20},proc=t_find_w_avg,title="waveavg"
	Button BtCV_tab12,pos={5,345},size={50,20},proc=t_CV,title="CV"
	Button BtSilentSynapseGraph_tab12,pos={55,345},size={50,20},proc=t_DisplaySilentSynapse,title="SilentS"
	Button BtEuclideanCombi_tab12,pos={105,345},size={50,20},proc=t_Euclidean_combinations,title="EucliC"
	Button BtFindBaryCenter_tab12,pos={155,345},size={50,20},proc=t_FindBaryCenter,title="BCenter"
	Button BtBranchingNodeDistances_tab12,pos={205,345},size={50,20},proc=t_BranchingNodeDistances,title="NodeDs"
	Button BtEliminationAvg_tab12,pos={5,365},size={50,20},proc=t_elimination_average,title="ElAG2"
	Button BtEliminationAvg3_tab12,pos={55,365},size={50,20},proc=t_elimination_average3,title="ElAG3"
	Button BtWavestats_tab12,pos={5,385},size={50,20},proc=t_WaveStats_targetWave,title="WaveSts"
	Button BtHistogram_tab12,pos={5,405},size={50,20},proc=t_Histgram,title="Hist"
	Button BtCumulative_tab12,pos={55,405},size={50,20},proc=t_Cumulative_Probability,title="Cumlate"
	Button BtIntegrate1DWave_tab12,pos={5,425},size={50,20},proc=t_Integrate1DWave,title="Int1DWs"
	Button BtIntegrate2DWave_tab12,pos={55,425},size={50,20},proc=t_Integrate2DWave,title="Int2DWs"
	Button BtIntegrate2DWave2_tab12,pos={105,425},size={50,20},proc=t_Integrate2DWave2,title="Int2DW2"
	Button BtTrim2dWave_tab12,pos={155,425},size={50,20},proc=t_Triming2dwave,title="Trim2dW"
	Button BtMakeGauss1d_tab12,pos={205,425},size={50,20},proc=t_m_d_1d_gaussian,title="MGass1"
	Button BtMake2dgauss_tab14,pos={255,425},size={50,20},proc=t_m_d_2d_gaussian,title="MGass2"
	Button BtCDF_01_tab12,pos={5,445},size={50,20},proc=t_CDF_01,title="CDF2D"
	Button BtCDF2D_sum_tab12,pos={55,445},size={50,20},proc=t_CDF2D_sum,title="CDF2DS"
	Button BtCorrelation_tab12,pos={5,464},size={50,20},proc=t_CorrelationTest,title="CorTest"
	Button BtDeltaRatio_tab12,pos={5,483},size={50,20},proc=t_StimDeltaRatio,title="DeltaR"
	
//tab13
	Button Buttonpreptw_tab13 title="ptw", proc=t_jwSpikeTable, pos={15,325}
	Button BtSkipS_tab13 title="skip", proc=t_skips, pos={65, 325}
	Button BtCcDelete_tab13 title="delete", proc=t_cc_delete, pos={65, 345}
	Button Btffs_tab13 title= "ffs", proc=t_find_fspike, pos={115, 325}
	Button Btmfs_tab13 title="mfs", proc=t_find_fspike, pos={115,345}
	Button Btsss_tab13,pos={165,325},size={50,20},proc=t_find_sspikes,title="fss"
	Button Btmss_tab13 title="mss", proc=t_find_sspike, pos={165,345}
	Button BtEnd_tab13 title="end", proc=t_ends, pos= {215, 325}
	Button Buttonfep_tab13 title="fep", proc=t_find_each_param, pos={265,325}
	SetVariable SetVar_CC_slope_tab13,pos={320,325},size={70,16},title="slope",value= root:Packages:YT:cc_slope
	Button BtKillCsr_tab13 title="killc", proc=t_KillCsr, pos={15, 345}
	SetVariable sv_cc_ns_tab13 pos={20, 368}, size={75, 20}, proc=t_SetVarProc,value=root:Packages:YT:cc_ns
	Button BtSpikeTable_tab13 title="spiket", proc=t_spiketable, pos={15,385}
	Button BtSpikeNum_tab13 title = "SpikeNum", proc= t_spikenum, pos ={65, 385}
	Button BtARate_tab13 title="arate", proc=t_arate, pos={115,385}
	Button BtDispSpikeNum_tab13 title = "dispsn", proc = t_display_spike_num, pos={165,385}
	Button BtDispARate_tab13 title="dispar", proc=t_display_arate, pos={215,385}
	Button BtVrest_tab13 title= "Vrest", proc=t_Vrest, pos={15, 405}
	Button BtRinput_tab13 title="Rinp", proc=t_Rinput, pos={65, 405}
	
//tab14
	Button BtPreptwvc_tab14 title="ptwvc", proc=t_prep_table_wave_vclamp, pos={15,325}
	Button BtSkipS_tab14 title="skip", proc=t_skipmisaf, pos={65, 325}
	Button BtFfs_tab14 title= "ffstim", proc=t_find_fstim, pos={115, 325}
	Button Btdelete_tab14 title= "delete", proc=t_vca_delete, pos={65, 345}
	Button Btmfs_tab14 title= "mfstim", proc=t_find_fstim, pos={115, 345}
	Button BtFsm_tab14 title="sstim", proc=t_find_sstim, pos={165, 325}
	Button Btmsm_tab14 title="mstim", proc=t_find_sstim, pos={165, 345}
	Button BtsetAMPA_tab14 title="AMPA", proc=t_setAMPANMDA, pos={215, 345}
	Button BtsetNMDA_tab14 title="NMDA", proc=t_setAMPANMDA, pos={265, 345}
	Button BtEnd_tab14 title="end", proc=t_end, pos={215, 325}
	Button BtDisplay_tab14 title="display", proc=t_display_each_param_vc, pos={265, 325}
	Button Bt00660Csr_tab14,pos={315,325},size={50,20},proc=t_00660,title="00660"
	Button Bt01160Csr_tab14,pos={315,345},size={50,20},proc=t_01160,title="01160"
	Button Bt00960_tab14,pos={320,485},size={50,20},proc=t_BtISISet,title="00960"
	Button Bt01660_tab14,pos={320,505},size={50,20},proc=t_BtISISet,title="01660"
	Button Bt03660_tab14,pos={320,525},size={50,20},proc=t_BtISISet,title="03660"
	Button Bt00821_tab14,pos={320,545},size={50,20},proc=t_BtISISet,title="00821"
	Button Bt10821_tab14,pos={320,565},size={50,20},proc=t_BtISISet,title="10821"
	Button BtKillCsr_tab14 title="killc", proc=t_KillCsr, pos={15, 345}
	CheckBox Checkvca_posi_tab14 title="posi",pos={30,370}, value=0,variable=root:Packages:YT:vca_posi, proc=t_vcaCheckProc
	CheckBox Checkvca_tl_tab14 title="tangent_line",pos={30,390}, value=0,variable=root:Packages:YT:tangent_line, proc=t_vcaCheckProc
	CheckBox Checkvca_markers_tab14 title="markers", pos={30, 410}, value=0, variable=root:Packages:YT:markers, proc=t_vcaCheckProc
	SetVariable sv_v_dis_f_arti_tab14 pos={120, 370}, size={200, 20}, proc=t_SetVarProc,value=root:Packages:YT:vca_dis_f_arti,limits={0,inf,0.001}
	SetVariable sv_v_nc_tab14 pos={120, 390}, size={200, 20}, proc=t_SetVarProc,value=root:Packages:YT:vca_fit_charge, limits={0,inf,0.005}
	SetVariable sv_v_onset_tab14 pos={120, 410}, size={200, 20}, proc=t_SetVarProc, value=root:Packages:YT:vca_onset_var,limits={0,1,0.05}
	Slider Slider_vca_fig_charge_tab14 fsize = 10, pos={20,425},size={350,20},vert=0,side=2, limits={0, 4e-1,0}, ticks=10, variable=root:Packages:YT:vca_fit_charge
	Button Bt7msHight_tab14 title="7msH", proc=t_7msH, pos={15, 485}
	Button Btm7msHight_tab14 title="m7msH", proc=t_m7msH, pos={65, 485}
	Button BtNMDA_AMPA_Ratio_tab14 title="N/A r", proc=t_AMPA_NMDA_ratio, pos = {15, 505}
	Button BtTestDoAbort_tab14,pos={65,505},size={50,20},proc=t_TestDoAbort,title="tesAbort"
	Button BtXAnchor_tab14,pos={115,485},size={50,20},proc=t_XAnchor,title="Anchor"
	Button BtMTAnchor_tab14,pos={115,505},size={50,20},proc=t_MoveToXAnchor,title="MTAnch"
	
//tab15
	Button Btprepvc_tab15  title="PrepTC",pos={5,325}, proc = t_PrepTimecourseAnalysis
	Button BtTimeCourseAnalysis_tab15 title="DoAnali",proc=BtDoTimeCourseAnalysis,pos={55,325}
	Button BtTimecourse_tab15 title = "xaxis", proc = t_timeaxis, pos={105, 325}
	Button Btdisp_tab15 title="graph",	proc=t_display_vc, pos={155,325}
	Button Btamp0vsbottom_tab15,pos={5,345},size={50,20},proc=t_TC_amp_vs_bottom,title="AmpvsB"
	Button BtRsN_tab15,pos={105,345},size={50,20},proc=t_BtRsN,title="RsN"
	Button Bt_BaselineNormalize_tab15,pos={55,345},size={50,20},proc=t_BaselineNormalize,title="BaseNor"
	Button BtPercentInhibition_tab15,pos={155,345},size={50,20},proc=t_TimecoursePercentInhibition,title="%inhibit"
	Button Bt_TracePicker_tab15,pos={205,345},size={50,20},proc=t_TracePicker,title="Picker"
	Button BtDelete_tab15 title = "Delete", proc = t_Delete, pos={215,455}
	Button BtRFG_tab15 title = "RFG_DP", proc = t_rfg_dp, pos={265,455}
	Button BtKillWaves_DP_tab15 title = "KillWV", proc = t_kws_dp, pos={315,455}
	SetVariable sv_dp_tab15 pos={115, 458}, size={90, 20}, proc=t_SetVarProc,value=root:Packages:YT:delete_p

//tab16	
//
	ModifyControlList ControlNameList("",";","!*_tab00") disable=1
	ModifyControlList ControlNameList("",";","*_tab10") disable=0
	ModifyControl tb0 disable=0
	ModifyControl tb1 disable=0
end

//CursorMovedInfo///////////////////////////////////////////////////

//Old Eazy Methods : <Code> is executed when any cursor is moved.//

Function t_MakeLines()
	Make/O root:Packages:YT:vline_A, root:Packages:YT:vline_B, root:Packages:YT:hline_A, root:Packages:YT:hline_B
end

Function CursorMovedHook(info)
	String info
	If(DataFolderExists("WinGlobals"))
		RemoveCursorGlobals()
	endif
	CursorGlobalsForGraph()
	CursorDependencyForGraph()
end

Function CursorGlobalsForGraph()
	String graphName= WinName(0,1)
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName
		String/G S_CursorAInfo, S_CursorBInfo
		SetDataFolder df
	endif
End

Function RemoveCursorGlobals()
	String graphName= WinName(0,1)
	If(DataFolderExists("WinGlobals:"+WinName(0,1)))
		if( strlen(graphName)  )
			KillDataFolder root:WinGlobals:$graphName
		endif
	endIf
End

Function CursorDependencyForGraph()
	String graphName= WinName(0,1)
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName
 		String/G S_CursorAInfo, S_CursorBInfo
		Variable/G dependentA
		SetFormula dependentA, "CursorMoved(S_CursorAInfo, 0)"
		SetDataFolder root:WinGlobals:$graphName
 		Variable/G dependentB
		SetFormula dependentB,"CursorMoved(S_CursorBInfo, 1)"
		SetDataFolder df
	endif
End

Function CursorMoved(info, isB)
	String info
	Variable isB 	// 0 if A cursor, non-zero if B cursor
	NVAR vline = root:Packages:YT:vline
	NVAR hline = root:Packages:YT:hline
	Variable d
	Wave vline_A=root:Packages:YT:vline_A
	Wave vline_B=root:Packages:YT:vline_B
	Wave hline_A=root:Packages:YT:hline_A
	Wave hline_B=root:Packages:YT:hline_B
	Variable result= NaN	// error result
	// Check that the top graph is the one in the info string.
	String topGraph= WinName(0,1)
//	String fw = WaveName("",0,1)
	If(isB)
		String fw = CsrWave(B)
	else
		fw = CsrWave(A)
	endIf
	String graphName= StringByKey("GRAPH", info)
	if( CmpStr(graphName, topGraph) == 0 )
		// If the cursor is being turned off
		// the trace name will be zero length.
		String ax = Axislist(graphname)
		String axis = ListMatch(ax, "l1*")
		String tName= StringByKey("TNAME", info)
		if( strlen(tName) )	// cursor still on
			if( isB )
				SetDataFolder root:Packages:YT:
				if(strlen(WaveList("vline_B",";","Win:"))>7)
					RemoveFromGraph vline_B
				endif
				SetDataFolder root:
				if(vline == 1)
					vline_B = xcsr(B)
					Wavestats/Q $fw
					d = (V_max-V_min)/128
					SetScale/P x v_min,d,"", vline_B
					if(strlen(axis))
						AppendToGraph/VERT/L=l1 vline_B
					else
						AppendToGraph/VERT vline_B
					endif
					ModifyGraph rgb(vline_B)=(0,12800,52224)
				endif
				SetDataFolder  root:Packages:YT:
				if(strlen(WaveList("hline_B",";","Win:")))
					RemoveFromGraph hline_B
				endif
				SetDataFolder root:
				if(hline == 1)
					Duplicate/O $fw hline_B
					hline_B = vcsr(B)
				if(strlen(axis))
					AppendToGraph/L=l1 hline_B
				else
					AppendToGraph hline_B
				endif
					ModifyGraph rgb(hline_B)=(0,12800,52224)
				endif
			else
				SetDataFolder  root:Packages:YT:
				if(strlen(WaveList("vline_A",";","Win:")) >7)
					RemoveFromGraph vline_A
				endif
				SetDataFolder root:
				if(vline == 1)
					vline_A = xcsr(A)
					Wavestats/Q $fw
					d = (V_max-V_min)/128
					SetScale/P x v_min,d,"", vline_A	
				if(strlen(axis))
					AppendToGraph/VERT/L=l1 vline_A
				else
					AppendToGraph/VERT vline_A
				endif
					ModifyGraph rgb(vline_A)=(0,39168,0)
				endif
				SetDataFolder root:Packages:YT:
				if(strlen(WaveList("hline_A",";","Win:")) >7)
					RemoveFromGraph hline_A
				endif
				SetDataFolder root:
				if(hline == 1)
					Duplicate/O $fw hline_A
					hline_A = vcsr(A)
				if(strlen(axis))
					AppendToGraph/L=l1 hline_A
				else
					AppendToGraph hline_A
				endif
					ModifyGraph rgb(hline_A)=(0,39168,0)
				endif
			endif
		endif
	endif
	return result
End

//Functions on the Control Panel///////////////////////////////////////////////////////////////
//tab00
Function t_TabProc (ctrlName, tabNum) : TabControl
	String ctrlname
	Variable tabNum
	strswitch(ctrlname)	// string switch
		case "tb0":
			String controlsInATab0= ControlNameList("",";","*_tab0*")
			String curTabMatch0="*_tab0"+Num2str(tabNum)
			String controlsInCurTab0= ListMatch(controlsInATab0, curTabMatch0)
			String controlsInOtherTab0= ListMatch(controlsInATab0, "!"+curTabMatch0)
			ModifyControlList controlsInCurTab0 disable = 0 //show
			ModifyControlList controlsInOtherTab0 disable = 1 //hide
			if(tabNum>=2)
				String tb = ControlNameList("",";","tb*")
				String tbMatch= "tb0"
				String tbOther=ListMatch(tb, "!"+tbMatch)
				ModifyControlList tbOther disable = 1
				String tabcont = ControlNameList("",";","*_tab*")
				String tabnottab0 = ListMatch(tabcont, "!"+curTabMatch0)
				ModifyControlList tabnottab0 disable = 1
			else
				ControlInfo/W=ControlPanel tb1
				if(V_disable == 0)
					break
				else
					ModifyControl tb1 disable = 0
					String currentactive = "*_tab1"+Num2str(V_Value)
					ModifyControlList ControlNameList("",";", currentactive) disable = 0
				endif
			endif
			break			
		case "tb1":
			String controlsInATab1= ControlNameList("",";","*_tab1*")
			String curTabMatch1="*_tab1"+Num2str(tabNum)
			String controlsInCurTab1= ListMatch(controlsInATab1, curTabMatch1)
			String controlsInOtherTab1= ListMatch(controlsInATab1, "!"+curTabMatch1)
			ModifyControlList controlsInCurTab1 disable = 0 //show
			ModifyControlList controlsInOtherTab1 disable = 1 //hide
			break
		default:
			break
	endswitch
end

Function t_CleartWin(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	tWin = ""
End

Function t_PopUpProc_tWinCategory(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	NVAR tWinCategory = root:Packages:YT:tWinCategory
//	Print popNum
	Switch (popNum)
		case 1 :
			tWinCategory = 0
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "")
			break;
		case 2 :
			tWinCategory = 1
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:1")
			break;
		case 3 :
			tWinCategory = 2
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:2")
			break;
		case 4 :
			tWinCategory = 4
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:4")
			break;
		case 5 :
			tWinCategory = 16
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:16")
			break;
		case 6 :
			tWinCategory = 64
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:64")
			break;
		case 7 :
			tWinCategory = 128
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:128")
			break;
		case 8 :
			tWinCategory = 4096
			PopupMenu Poptwin_tab00 value=winlist("*", ";", "Win:4096")
		default :
			break;
	endswitch
End

Function t_SetProc_tWinpopNum_tab00(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	NewDataFolder/O root:Pack
	
	SVAR tWin = root:Packages:YT:tWin
	NVAR tWinCategory = root:Packages:YT:tWinCategory
	String WinNam
	If(tWinCategory == 0)
		tWinCategory = 4311
		WinNam = StringFromList(varNum, winlist("*", ";", "Win:4311"))
//		Print "WinName(varNum, tWinCategory) =" + WinNam
		If(strlen(WinNam) != 0)
			If(strlen(WinName(0,4247)) != 0)
//				Print "Previous Win =" + WinName(0,4247)
				If(stringmatch(WinName(0, 4247), "*.ipf"))
					HideProcedures
				else
					If(WinType(WinNam) == 0)
						HideProcedures
					else
						DoWindow/Hide = 1 $(WinName(0, 4247))
					endif
				endif
				tWin = WinNam
				If(stringmatch(WinNam, "*.ipf"))
					DisplayProcedure/W=$WinNam
				else
					If(WinType(WinNam) == 0)
						DisplayProcedure/W=$WinNam
					else
						DoWindow/F $WinNam
					endif
				endif
			endif
			PopUpMenu Poptwin_tab00 Win = ControlPanel, value = winlist("*", ";", "")
		endif
		tWinCategory = 0
	else
		WinNam = StringFromList(varNum, winlist("*",";","Win:"+Num2str(tWinCategory)))
		If(strlen(WinNam) != 0)
			If(tWinCategory != 64)
				If(stringmatch(WinName(0, 4247), "*.ipf"))
					HideProcedures
				else
					If(WinType(WinNam) == 0)
						HideProcedures
					else
						DoWindow/Hide = 1 $(WinName(0, tWinCategory))
					endif
				endif
			endif
			tWin = WinNam
			If(stringmatch(WinNam, "*.ipf")  == 1)
				DisplayProcedure/W=$WinNam
			else
				If(WinType(WinNam) == 0)
					DisplayProcedure/W=$WinNam
				else
					DoWindow/F $WinNam
				endif
			endif
			PopUpMenu Poptwin_tab00 Win = ControlPanel, value = #"winlist(\"*\",\";\", \"Win:\"+ Num2str(tWinCategory))"
		endif
	endif
end

Function t_GetWinList(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWinL = root:Packages:YT:tWinL
	NVAR tWinCategory = root:Packages:YT:tWinCategory
	tWinL = tWinL + winlist("*",";","Win:"+Num2str(tWinCategory))
End

Function t_tWinTotWinList(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWinL = root:Packages:YT:tWinL
	tWinL = tWinL + tWin + ";"
End

Function t_DoWinKillWinList(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWinL = root:Packages:YT:tWinL
	
	String sfl = ""
	Variable i = 0
	
	do
		sfl = StringFromList(i, tWinL)
		if(strlen(sfl) == 00)
			break
		endif
		DoWindow/K $sfl
		i += 1
	while(1)
End

Function t_CleartWinList(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWinL = root:Packages:YT:tWinL
	tWinL = ""
End

Function t_SHCategories(ctrlName) : ButtonControl
	String ctrlName
	String SFL
	NVAR tWinCategory =root:Packages:YT:tWinCategory
	Variable i = 0
	if(tWinCategory != 128) // if not procedure category
		if(tWinCategory == 0)
			do
				SFL = StringFromList(i, WinList("*",";","Win:4119"))
				if(strlen(SFL) == 0)
					break
				endif
				StrSwitch(ctrlName)
					case "BtShowCategories_tab00" :
						DoWindow/HIDE = 1 $SFL
						DoWindow/HIDE = 0 $SFL
						break
					case "BtHideCategories_tab00" :
						DoWindow/HIDE = 1 $SFL
						break
					default :
						break
				endSwitch
				i += 1
			while(1)
		else
			do
				SFL = StringFromList(i, WinList("*",";","WIN:"+ Num2str(tWinCategory)))
				if(strlen(SFL) == 0)
					break
				endif
				StrSwitch(ctrlName)
					case "BtShowCategories_tab00" :
						DoWindow/HIDE = 1 $SFL
						DoWindow/HIDE = 0 $SFL
						break
					case "BtHideCategories_tab00" :
						DoWindow/HIDE = 1 $SFL
						break
					default :
						break
				endSwitch
				i += 1
			while(1)
		endif
	else
		StrSwitch(ctrlName)
			case "BtShowCategories_tab00":
					do
						SFL = StringFromList(i, WinList("*",";","WIN:128"))
						If(strlen(SFL) == 0)
							break
						endif
						DisplayProcedure/W=$SFL
						i += 1
					while(1)
				break
			case "BtHideCategories_tab00":
				HideProcedures
				break
			default:
				break
		endSwitch
			
	endif
end

Function t_GetRecreationMacro(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	StrSwitch (ctrlName)
	String cmd
		case "BtGetRecreationMacro_tab00":
			cmd = "DoWindow/R "+ tWin
			Execute/P/Q cmd
			break
		case "BtGetRecreationMacroKill_tab00":
			cmd = "DoWindow/R/K "+ tWin
			Execute/P/Q cmd
			break
		default:
			break
	endSwitch
End

Function t_GetWindowWsize(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	GetWindow $tWin, wsize
	String str = Num2str(V_left) + ", " + Num2str(V_top) + ", " + Num2str(V_right) + ", " + Num2str(V_bottom)
	Print str
End

Function t_RebornControlPanel(ctrlName) : ButtonControl
	String ctrlName
	
	KillWindow ControlPanel
	String DoStr = "t_NewControlPanel()"
	Execute DoStr
End

Function t_GraphControlPanel(ctrlName) : ButtonControl
	String ctrlName
	If(WinType("GraphControlPanel") == 7)
		DoWindow/HIDE = ? GraphControlPanel
		If(V_flag == 1)
			DoWindow/HIDE = 1 GraphControlPanel
		else
			DoWindow/HIDE = 0/F GraphControlPanel
			AutoPositionWindow/E/M=1/R=ControlPanel
		endif
	else
		t_cpN01()
	endif	
end

Function t_StatPanel(ctrlName) : ButtonControl
	String ctrlName
	If(WinType("StatPanel") == 7)
		DoWindow/HIDE = ? StatPanel
		if(V_flag == 1)
			DoWindow/HIDE = 1 StatPanel
		else
			DoWindow/HIDE = 0 StatPanel
		endif
	else
		t_cpN02()
	endif
end

Function t_ImagePanel(ctrlName) : ButtonControl
	String ctrlName
	If(WinType("ImagePanel") == 7)
		DoWindow/HIDE = ? ImagePanel
		If(V_flag == 1)
			DoWindow/HIDE = 1 ImagePanel
		else
			DoWindow/HIDE = 0/F ImagePanel
		endif
	else
		t_cpN03()
	endif
end

Function t_TestPanel(ctrlName) : ButtonControl
	String ctrlName
	If(WinType("TestPanel") == 7)
		DoWindow/HIDE = ? TestPanel
		If(V_flag == 1)
			DoWindow/HIDE = 1 TestPanel
		else
			DoWindow/HIDE = 0/F TestPanel
		endif
	else
		t_cpN04()
	endif
end

Function t_HelpBrowser(ctrlName) : ButtonControl
	String ctrlName
	DoIgorMenu "Windows", "Help Browser"
end

Function t_SweepViewer(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	String SFLGraph = "", StrWaveList = "", SFLWave = ""
	String GraphList = Winlist("*",";","Win:1")
	Variable i = 0, j = 0
	do
		SFLGraph = StringFromList(i, GraphList)
		If(Strlen(SFLGraph) == 0)
			break
		endif
		
		GetWindow $SFLGraph, hide
		If(V_Value & 2^0 || V_Value & 2^1)
			i += 1
			continue
		endIf
		
		StrWaveList = WaveList("*", ";", "WIN:"+SFLGraph)
		j = 0
		do
			SFLWave = StringFromList(j, StrWaveList)
			If(Strlen(SFLWave) == 0)
				break
			endif
			
			If(StringMatch(SFLWave, "*_"+ varStr))
				RemoveFromGraph/W=$SFLGraph $SFLWave
				AppendToGraph/W=$SFLGraph $SFLWave
				ModifyGraph/W=$SFLGraph rgb($SFLWave)=(0,0,0)
			else
				ModifyGraph/W=$SFLGraph rgb($SFLWave)=(65280,0,0)
			endif
			j += 1
		while(1)
		i += 1
	while(1)
end

Function t_CsrAtWave0(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		String SFL
		DoWindow/F $tWin
		SFL = StringFromList(0, Wavelist("*", ";", "WIN:"))
		Cursor A $SFL leftx($SFL)
		tWave0 = StringByKey("TNAME", CsrInfo(A))
		//		tWave0
	else
		tWave0 = StringByKey("TNAME", CsrInfo(A))
	endif
end

Function t_CsrBtWave1(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave1 = root:Packages:YT:tWave1
	SVAR tWin = root:Packages:YT:tWin
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		String SFL
		DoWindow/F $tWin
		SFL = StringFromList(0, Wavelist("*", ";", "WIN:"))
		Cursor B $SFL leftx($SFL)
		tWave1 = StringByKey("TNAME", CsrInfo(B))
		//		tWave0
	else
		tWave1 = StringByKey("TNAME", CsrInfo(B))
	endif
end

Function t_CleartWave0(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	tWave0 = ""
End

Function t_CleartWave1(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave1 = root:Packages:YT:tWave1
	tWave1 = ""
End

Function t_PopMenuProc_tWin(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	
	Variable popNum
	String popStr
	SVAR tWin = root:Packages:YT:tWin
//	Print popNum, popStr
	If(stringmatch(popStr, "*.ipf"))
		DisplayProcedure/W = $popStr
	else
		DoWindow/F $popStr
	endif
	tWin = popStr
	switch(WinType(tWin))	// numeric switch
		case 1:
			PopupMenu PoptWave0intw_tab00  value= wavelist("*", ";", "Win:"), win=ControlPanel
			PopupMenu PoptWave1intw_tab00  value= wavelist("*", ";", "Win:"), win=ControlPanel
			break
		case 2:		// execute if case matches expression
			PopupMenu PoptWave0intw_tab00  value= wavelist("*", ";", "Win:"),  win=ControlPanel
			PopupMenu PoptWave1intw_tab00  value= wavelist("*", ";", "Win:"),  win=ControlPanel
			break
		default:		// optional default expression executed
			PopupMenu PoptWave0intw_tab00  value="none", win=ControlPanel
			PopupMenu PoptWave1intw_tab00  value= "none", win=ControlPanel
	endswitch
	ControlUpdate/A
	If(stringmatch(popStr, "*.ipf"))
		DisplayProcedure/W = $popStr
	else
		If(stringmatch(popStr, "Procedure"))
			DisplayProcedure/W = $"Procedure"
		else
			DoWindow/F $popStr
		endif
	endif
end

Function t_tWinButton(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	DoWindow/B ControlPanel
	tWin = WinName(0,87)
	If(StringMatch(tWin, "ControlPanel") || StringMatch(tWin, "Select tWin!"))
		tWin = "Select tWin!"
		Abort
	endIf
	DoWindow/F ControlPanel
	If(Strlen(tWin) == 0)
		Abort
	endIf
	switch(WinType(tWin))	// numeric switch
	case 1:
		PopupMenu PoptWave0intw_tab00  value= wavelist("*", ";", "Win:"), win=ControlPanel
		PopupMenu PoptWave1intw_tab00  value= wavelist("*", ";", "Win:"), win=ControlPanel
		break
	case 2:		// execute if case matches expression
		PopupMenu PoptWave0intw_tab00  value= wavelist("*", ";", "Win:"),  win=ControlPanel
		PopupMenu PoptWave1intw_tab00  value= wavelist("*", ";", "Win:"),  win=ControlPanel
		break
	default:		// optional default expression executed
		PopupMenu PoptWave0intw_tab00  value="none", win=ControlPanel
		PopupMenu PoptWave1intw_tab00  value= "none", win=ControlPanel
	endswitch
//	ControlUpdate/A
	DoWindow/F $tWin
	
	Variable key = 0
	key = GetKeyState(0)
	If(key & 4) //Shift Pressed
		ModifyGraph/W=$tWin width = 113.386,height=113.386
	endif
end

Function t_rename_tWin (ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	String name
	If(StringMatch(tWin, "Select tWin!") == 0)
		Prompt name, tWin + "->"
		DoPrompt "Change tWin Name", name
		If(V_flag)
			Abort
		endif
		DoWindow/C/W = $tWin $name
		tWin = name
	endif
end

Function t_tWave0Button(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	tWave0 = "w_" + Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(v_ns)
end

Function t_Jw_GVButton(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR jwv_e = root:Packages:YT:jwv_e
	NVAR jwv_nc = root:Packages:YT:jwv_nc
	NVAR jwv_ns = root:Packages:YT:jwv_ns
	v_e = jwv_e
	v_nc = jwv_nc
	v_ns = jwv_ns
end

Function t_PopMenuProc_tWave(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	StrSwitch(ctrlName)
	case "PoptWave0_tab00" :
//		Print popNum, popStr
		tWave0 = popStr
		break
	case "PoptWave0intw_tab00" :
//		Print popNum, popStr
		tWave0 = popStr
		break
	case "PoptWave1_tab00" :
//		Print popNum, popStr
		tWave1 = popSTr
		break
	case "PoptWave1intw_tab00" :
//		Print popNum, popStr
		tWave1 = popSTr
		break
	default :
		break
	endswitch
End

Function t_SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
End

Function t_change01(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	String temp0
	String temp1
	temp0 = tWave0
	temp1 = tWave1
	tWave0 = temp1
	tWave1 = temp0
	return 0
end

Function t_GetWaveNameFromTable(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	String tCellCoor
	Variable n
	tCellCoor = StringByKey("TARGETCELL", Tableinfo(tWin, -2))
	sscanf tCellCoor, "%d,%d", n, n
	StrSwitch (ctrlName)
		case "BtGetWaveNameFromTable0_tab00":
			tWave0 = StringByKey("COLUMNNAME",Tableinfo(tWin, n))
			tWave0 = tWave0[0,strlen(tWave0)-3]
			break;
		case "BtGetWaveNameFromTable1_tab00":
			tWave1 = StringByKey("COLUMNNAME",Tableinfo(tWin, n))
			tWave1 = tWave1[0,strlen(tWave1)-3]
			break;
		default:
			break;
	endSwitch
end

Function t_gettwavelist(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	SVAR tWin = root:Packages:YT:tWin
	tWL = wavelist("*", ";", "WIN:")
end

Function t_GVTotWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	String scrw
	Variable i
	for(i = v_nis; i<=v_ns; i += 1)
		scrw = "w_"+Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(i)
		tWL = tWL + scrw + ";"
	endfor
End

Function t_GetWL_Maquee(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:YT:tWin
	SVAR tWL = root:Packages:YT:tWL

	tWL = ""
	
	If(WinType(tWin) == 1)
		DoWindow/F $tWin
	endIf
	
	GetMarquee bottom, left
	
	String EventWaveList = WaveList("*", ";", "WIN:")
	Variable i = 0		
	do
		String SFL = StringFromList(i, EventWaveList)
		If(Strlen(SFL) < 1)
			break
		endIf
		Wave srcW = $SFL
		WaveStats/Q/R=(V_left, V_right) srcW
		If(V_min > V_top || V_max < V_bottom)
		
		else
			tWL += SFL + ";"
		endIf
		i += 1		
	while(1)
	Print tWL
End

Function t_tW0ToWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWL = root:Packages:YT:tWL
	tWL = tWL + tWave0 + ";"
End

Function t_CleartWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	tWL = ""
End

Function t_rename(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	variable m = 1
	do
		variable n = 1
		do
			string exists_search = "Pulse_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(n)
			if(exists(exists_search) == 1) 
				wave t=$exists_search
				string w_name="w_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(n)
				rename t, $w_name
			else
				n = n + 1
			endif
		while(n<=v_ns)
		m = m + 1
	while(m<=v_nc)
end

Function t_renameABF(ctrlName) : ButtonControl
	String ctrlName
	
	Variable n = 0
	Variable m = 0
	Variable i = 0
	String Prefix
	String Dup
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shit key pressed
		Prefix = "a"
		Dup = "Default, No"
	else	
		Prompt Prefix, "Enter Prefix"
		Prompt Dup, "Duplicate?", popup "Default, No;Yes;"
		DoPrompt "Tell Igor Prefix", Prefix, Dup
		If(V_Flag)
			Abort
		endIf
	endif
	
	do
		m=0
		do
			String wavel = WaveList(Prefix+"*_"+Num2str(n)+"_"+Num2str(m), ";", "")
			i=0
			do
				String SFL = StringFromList(i, wavel)
				If(strlen(SFL)==0)
					break
				endIf
				If(exists(SFL)==1) 
					wave t=$SFL
					Variable NumChar=strsearch(SFL, "_",0)
					string w_name="w_"+Num2str(100*Str2Num(SFL[NumChar-3])+10*Str2Num(SFL[NumChar-2])+Str2Num(SFL[NumChar-1]))+"_"+Num2str(n)+"_"+Num2str(m)
					StrSwitch (Dup)
						case "Default, No":
							rename t, $w_name
							break;
						case "Yes":
							Duplicate/O t, $w_name
//							KillWaves t
							break;
						default:
							break;
					EndSwitch
				endIf
				i+=1
			while(1)
			m+=1
		while(m<1000)
		n+=1
	while(n<16)
End

Function t_renamePatchMaster(ctrlName) : ButtonControl
	String ctrlName
	Variable ngroup, nseries, nepisode, i, ntrace
	String Prefix = "PMPulse"
	String Dup, strntrace, SFL
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shit key pressed
		Prefix = "PMPulse"
		Dup = "Default, No"
		strntrace = "Default, 2"
	else	
//		Prompt Prefix, "Enter Prefix", popup "PMPluse;"
		Prefix = "PMPulse"
		Prompt Dup, "Duplicate?", popup "Default, No;Yes;"
		Prompt strntrace, "ntrace?", popup "Default, 2;1"
		DoPrompt "Tell Igor information", strntrace, Dup
		If(V_Flag)
			Abort
		endIf
	endif
	
	StrSwitch(strntrace)
		case "Default, 2":
			ntrace = 2;
			break;
		case "1":
			ntrace = 1;
			break
		default:
			break;
	endswitch
	
	String wavel = Wavelist(Prefix+"*_"+Num2str(ntrace), ";", "")
	Print wavel
	i = 0
	do
		SFL = StringFromList(i, wavel)
		If(strlen(SFL) == 0)
			break
		endif
		sscanf SFL, Prefix+"_%f_%f_%f_%f", ngroup, nseries, nepisode, ntrace
		wave t=$SFL
		String w_name="w_"+Num2str(ngroup)+"_"+Num2str(nseries)+"_"+Num2str(nepisode)
		StrSwitch (Dup)
			case "Default, No":
				rename t, $w_name
				break;
			case "Yes":
				Duplicate/O t, $w_name
				break;
			default:
				break;
		EndSwitch
		i += 1
	while(1)
End

Function t_dispallwaves(ctrlName) : ButtonControl
	String ctrlName
	String str
	Variable i = 0
	String GraphName
	do
		str = StringFromList(i, WaveList("*",";",""))
		if(strlen(str) == 00)
			break
		endif
		if(i == 0)
			If(Strlen(GraphName) == 0)
				Display $str
			else
				Display/N=GraphName $str
			endif
		else
			appendtograph $str
		endif
		i += 1
	while(1)
	showinfo
end

//end of tab00/////////////////////////////////////////////////////////////////////////////////////

//tab01////////////////////////////////////////////////////////////////////////////////////////////
Function t_SetJwVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR jwv_e = root:Packages:YT:jwv_e
	NVAR jwv_nc = root:Packages:YT:jwv_nc
	NVAR jwv_ns = root:Packages:YT:jwv_ns
	SVAR tjw = root:Packages:YT:tjw
	SVAR tjwsub = root:Packages:YT:tjwsub
	SetDataFolder root:Packages:YT:
	Wave jwsub
	Wave jw
	SetDataFolder root:
	if(exists("w_"+Num2str(jwv_e)+"_"+Num2str(jwv_nc)+"_"+Num2str(jwv_ns))==1)
		SetDataFolder root:Packages:YT:
		Duplicate/O jw jwsub
		tjwsub = tjw
		tjw = "w_"+Num2str(jwv_e)+"_"+Num2str(jwv_nc)+"_"+Num2str(jwv_ns)
		Duplicate/O root:$tjw jw
		jwsub = jw - jwsub
		if(WinType("graph_jwsub") == 1)
			execute "setjwsubaxis()"
		endif
	endif
	SetDataFolder root:
End

Proc setjwsubaxis()
	if(WinType("graph_jwsub") == 1)
			GetAxis/W=graph_jw/Q left
			SetAxis/W=graph_jwsub left, V_min, V_max
			GetAxis/W=graph_jw/Q bottom
			SetAxis/W=graph_jwsub bottom, V_min, V_max
	endif
end

Function t_PopMenuProc_tJwWave(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tjw = root:Packages:YT:tjw
	SVAR tjwsub = root:Packages:YT:tjwsub
	Wave jwsub = root:Packages:YT:jwsub
	Wave jw = root:Packages:YT:jw
	tjwsub = tjw
	tjw = popStr
	Duplicate/O $tjw root:Packages:YT:jwsub
	Duplicate/O $tjw root:Packages:YT:jw
	jwsub = jw - jwsub
	if(WinType("graph_jwsub") == 1)
		execute "setjwsubaxis()"
	endif
End

Function t_setaxis_jw(ctrlName) : ButtonControl
	String ctrlName
	StrSwitch (ctrlName)
		case "BtSetAxisLMan_tab01" :
			GetAxis/W=graph_jw/Q left
			SetAxis/W=graph_jw left, V_min, V_max
		break
		case "BtSetAxisLA_tab01" :
			GetAxis/W=graph_jw/Q left
			SetAxis/W=graph_jw/A left
		break
		case "BtSetAxisBMan_tab01" :
			GetAxis/W=graph_jw/Q bottom
			SetAxis/W=graph_jw bottom, V_min, V_max
		break
		case "BtSetAxisBA_tab01" :
			GetAxis/W=graph_jw/Q bottom
			SetAxis/W=graph_jw/A bottom
		default :
		break
	endswitch
	if(WinType("graph_jwsub") == 1)
		GetAxis/W=graph_jw/Q left
		SetAxis/W=graph_jwsub left, V_min, V_max
		GetAxis/W=graph_jw/Q bottom
		SetAxis/W=graph_jwsub bottom, V_min, V_max
	endif
end

Function t_dpjw(ctrlName) : ButtonControl
	String ctrlName
	SVAR tjw = root:Packages:YT:tjw
	if(WinType("graph_jw") == !1)
		if(exists(tjw) == 1)
			SetDataFolder root:Packages:YT:
			display/N=graph_jw/W=(255, 10, 660, 215) jw
			SetDataFolder root:
			showinfo
		endif
	else
		DoWindow/HIDE = ? graph_jw
		If(V_flag == 1)
			DoWindow/HIDE = 1 graph_jw
		else
			DoWindow/HIDE = 0/F graph_jw
		endif
	endif
end

Function t_KillWavesJw(ctrlName) : ButtonControl
	String ctrlName
	NVAR jwv_e = root:Packages:YT:jwv_e
	NVAR jwv_nc = root:Packages:YT:jwv_nc
	NVAR jwv_ns = root:Packages:YT:jwv_ns
	String dw = "w_" + Num2str(jwv_e) + "_" + Num2str(jwv_nc) + "_" + Num2str(jwv_ns)
	Killwaves $dw
end

Function t_dpjwsub(ctrlName) : ButtonControl
	String ctrlName
	SVAR tjw = root:Packages:YT:tjw
	if(WinType("graph_jwsub") == !1)
		if(exists(tjw) == 1)
			SetDataFolder root:Packages:YT:
			display/N=graph_jwsub/W=(255, 300, 660, 505) jwsub
			showinfo
			SetDataFolder root:
		endif
	else
		DoWindow/HIDE = ? graph_jwsub
		If(V_flag == 1)
			DoWindow/HIDE = 1 graph_jwsub
		else
			DoWindow/HIDE = 0/F graph_jwsub
		endif
	endif
end

Function t_DoWinJw(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/HIDE = ? graph_jw
	If(V_flag == 1)
		DoWindow/HIDE = 1 graph_jw
	else
		DoWindow/HIDE = 0/F graph_jw
	endif
end

Function t_DoWinJwsub(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/HIDE = ? graph_jwsub
	If(V_flag == 1)
		DoWindow/HIDE = 1 graph_jwsub
	else
		DoWindow/HIDE = 0/F graph_jwsub
	endif
end

Function t_JwsubtW0(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	SetDataFolder root:Packages:YT:
	If(Exists("jwsub") == 1)
		tWave0 = "jwsub"
	endif
	SetDataFolder root:
	
	t_dupws(ctrlName)
	
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shift key pressed
		Wave dw = $tWave0
		Display dw
	endIf
end

Function t_BtJw2tWave0(ctrlName) : ButtonControl
	String ctrlName
	SVAR tjw = root:Packages:YT:tjw
	SVAR tWave0 = root:Packages:YT:tWave0
	String keyword
	String switchdisp
	Prompt keyword "Enter keyword"
	Prompt switchdisp "Display?", popup "Yes;No;"
	DoPrompt "Define.", keyword, switchdisp
	If(V_flag)
		Abort
	endif
	tWave0 = tjw
	wave srcWave = $tWave0
	String destWave = keyword + "_" + tjw
	Duplicate/O $tWave0 $destWave
	If(StringMatch(switchdisp, "Yes"))
		Display $destWave
		DoWindow/F $WinName(0,1)
	endif
End

//end of tab01////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//GENERAL

Function t_AlignCsrX(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	
	DoWindow/F $tWin
	String CsrAWave = CsrWave(A, tWin)
	String CsrBWave = CsrWave(B, tWin)
	Variable x = (xcsr(A) + xcsr(B))/2
	
	Cursor A, $CsrAWave, x
	Cursor B, $CsrBWave, x	
end

Function t_vcsra(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	print vcsr(A)
	If(Wintype(tWin) == 5)
		Notebook $tWin text = Num2str(vcsr(A))
	endif
end

Function t_xcsra(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	print xcsr(A)
	If(Wintype(tWin) == 5)
		Notebook $tWin text = Num2str(xcsr(A))
	endif
end

Function t_MCsrs(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave sw = $tWave0
		
	Variable key
	key = GetKeyState(0)
	
	switch(key)
		case 4:		// Shift key pressed
			Cursor A $tWave0 0.0660
			Cursor B $tWave0 0.0760
			break
		case 1:		// Ctrl key pressed 
			Cursor A $tWave0 0.1160
			Cursor B $tWave0 0.1260
			break
		default:
			break
	endswitch
		
	StrSwitch(ctrlName)
		case "BtMIntCs_tab10":
			print (xcsr(B)-xcsr(A))
			break
		case "BtMHorCs_tab10":
			print(vcsr(B)-vcsr(A))
			break
		default:
			break
	endswitch
end

Function t_vhCheckProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	NVAR vline = root:Packages:YT:vline
	NVAR hline = root:Packages:YT:hline
	Strswitch (ctrlName)
		case "CheckVL_tab10":
			vline = checked
			break
		case "CheckHL_tab10":
			hline = checked
			break
		default:
			break
	endswitch
	if(checked == 1)
		RemoveCursorGlobals()
		CursorGlobalsForGraph()
		CursorDependencyForGraph()
	endif
End

Function t_nl(ctrlName) : ButtonControl
	String ctrlName
	String LayoutName, RunningText
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shit key pressed
		Prompt LayoutName, "Enter The Notion."
		DoPrompt "In case, you don't enter any charactor, it will be default procedure.", LayoutName
		If(v_flag)
			abort
		endif
		If(Strlen(LayoutName) == 0)
			StrSwitch(ctrlName)
				case "Btnl_tab10":
					Newlayout/W=(5, 40, 355, 500)
					break
				case "Btll_tab10":
					Newlayout/W=(5, 40, 475, 390)/P=Landscape
					TextBox/C/N=text0/F=0/A=LB/X=8.38/Y=91.28 LayoutName
					break
				default :
					break
			endswitch
		else
			StrSwitch(ctrlName)
				case "Btnl_tab10":
					Newlayout/W=(5, 40, 355, 500)
					TextBox/C/N=text0/F=0/A=LB/X=8.38/Y=91.28 LayoutName
					break
				case "Btll_tab10":
					Newlayout/W=(5, 40, 475, 390)/P=Landscape
					TextBox/C/N=text0/F=0/A=LB/X=8.38/Y=91.28 LayoutName
					break
				default :
					break
			endswitch
		endif
		Printsettings/m margins={1,1,1,1}
		Abort
	endif
	
	Prompt LayoutName, "Enter Name of Layout."
	Prompt RunningText, "Enter the Running Text"
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", LayoutName, RunningText
	If(v_flag)
		abort
	endif
	If(Strlen(LayoutName) == 0)
		StrSwitch(ctrlName)
			case "Btnl_tab10":
				Newlayout/W=(5, 40, 355, 500)
				break
			case "Btll_tab10":
				Newlayout/W=(5, 40, 475, 390)/P=Landscape
				break
			default :
				break
		endswitch
	else
		StrSwitch(ctrlName)
			case "Btnl_tab10":
				Newlayout/N=$LayoutName/W=(5, 40, 355, 500)
				break
			case "Btll_tab10":
				Newlayout/N=$LayoutName/W=(5, 40, 475, 390)/P=Landscape
				break
			default :
				break
		endswitch
	endif
	Printsettings/m margins={1,1,1,1}
	If(Strlen(RunningText))
		TextBox/C/N=text_running0/F=0/A=LB/X=3.91/Y=96.55 RunningText
	endif
end

Function t_PPLayout(ctrlName) : ButtonControl
	String ctrlName
	String LayoutName
	Prompt LayoutName, "Enter Name of Layout."
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", LayoutName
	If(Strlen(LayoutName) == 0)
		Newlayout/W=(5, 40, 475, 390)/P=Landscape
	else
		Newlayout/N=$LayoutName/W=(5, 40, 475, 390)/P=Landscape
	endif
	Printsettings/m margins={0.5,0.5,0.5,0.5}
	SetDrawEnv dash= 2
	SetDrawEnv fillpat= 0
	DrawRect 60,25,780,565
End

Function t_atlt(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	AppendLayoutObject table $tWin
end

Function t_atlg(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	AppendLayoutObject graph $tWin
	ModifyLayout frame=0
end

Function t_rfl(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	String t = "RemoveFromLayout $tWin"
	Execute t
end

Function t_pptrec(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	DoWindow/F $tWin
	SetDrawEnv dash= 2
	SetDrawEnv fillpat= 0
	DrawRect 60,25,780,565
End

Function t_getstrans(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	ModifyLayout/W=$tWin trans = 1
End

Function t_Info(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	StrSwitch(ctrlName)
	case "BTShowInfo_tab10" :
		ShowInfo/W=$tWin
		break
	case "BTShowTools_tab10" :
		ShowTools/A/W=$tWin
		break
	case "BTHideInfo_tab10" :
		HideInfo/W=$tWin
		break
	case "BTHideTools_tab10" :
		HideTools/W=$tWin
		break
	case "BTShowInfo_tab01" :
		ShowInfo/W=graph_jw
		break
	case "BTShowTools_tab01" :
		ShowTools/A/W=graph_jw
		break	
	default :
		break
	endswitch
end

Function t_disp(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	String GraphName
	Prompt GraphName, "Enter Name of the Graph."
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", GraphName
	If(V_Flag)
		Abort
	endif
	If(Strlen(GraphName) == 0)
		If(Exists(tWave0) == 1)
			Display $tWave0
		else
			Display
		endif
	else
		If(Exists(tWave0) == 1)
			Display/N=$GraphName $tWave0
		else
			Display/N=$GraphName
		endif
	endif
	Showinfo
end

Function t_dispvs(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	String GraphName
	String Crossing
	Prompt GraphName, "Enter Name of the Graph."
	Prompt Crossing, "Crossing?", popup "No;Yes;"
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", GraphName, Crossing
	
	StrSwitch (Crossing)
		case "No":
			If(Strlen(GraphName) == 0)
				If(Exists(tWave0) == 1 && Exists(tWave1) == 1)
					Display $tWave0 vs $tWave1
				else
					Display
				endif
			else
				If(Exists(tWave0) == 1 && Exists(tWave1) == 1)
					Display/N=$GraphName $tWave0 vs $tWave1
				else
					Display/N=$GraphName
				endif
			endif
			break;
		case "Yes":
			If(Strlen(GraphName) == 0)
				If(Exists(tWave0) == 1 && Exists(tWave1) == 1)
					Display/L=VertCrossing/B=HorizCrossing $tWave0 vs $tWave1
				else
					Display
				endif
			else
				If(Exists(tWave0) == 1 && Exists(tWave1) == 1)
					Display/L=VertCrossing/B=HorizCrossing/N=$GraphName $tWave0 vs $tWave1
				else
					Display/N=$GraphName
				endif
			endif
			break;
		default:
			break
	endSwitch
	Showinfo
end

Function t_dispwl(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	String str
	Variable i = 0
	String GraphName
	Prompt GraphName, "Enter Name of the Graph."
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", GraphName
	If(V_flag)
		Abort
	endif
	do
		str = StringFromList(i, tWL)
		if(strlen(str) == 00)
			break
		endif
		if(i == 0)
			If(Strlen(GraphName) == 0)
				Display $str
			else
				Display/N=GraphName $str
			endif
		else
			appendtograph $str
		endif
		i += 1
	while(1)
	showinfo
end

Function t_bvc(ctrlName) : ButtonControl
	string ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	variable n = v_nis
	String GraphName
	Prompt GraphName, "Enter Name of the Graph."
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", GraphName
	If(Strlen(GraphName) == 0)
		Display
	else
		Display/N=$GraphName
	endif
	do
		wave t = $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n))
		if(exists("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)) == 1)
			appendtograph t
		endif
		n = n + 1
	while(n<=v_ns)
	showinfo
end

Function t_atg(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	SVAR tWin = root:Packages:YT:tWin
	String switchbottom, axisname
	String strvs
	Prompt switchbottom "Select bottom axisname", popup "default" +";"+  axislist(tWin) +";"+ "TextWave;"
	Prompt strvs "tWave0 vs tWave1?", popup "No;Yes;"
	DoPrompt "Axisname", switchbottom, strvs
	If(v_flag)
		Abort
	endif
	strSwitch (switchbottom)
		case "default":
			If(StringMatch(strvs, "No"))
				AppendToGraph/W=$tWin $tWave0
			else
				AppendToGraph/W=$tWin $tWave0 vs $tWave1
			endIf
			break;
		case "TextWave":
			String bottomwave
			Prompt bottomwave "Select bottom wave", popup WaveList("*", ";", "TEXT:1")
			DoPrompt "Textwave (bottomaxis)", bottomwave
			If(V_flag)
				Abort
			endif
			AppendToGraph/W=$tWin $tWave0 vs $bottomwave
			break;
		default:
			String bwname = StringByKey("CWAVE", AxisInfo(tWin, switchbottom))
			Print bwname
			AppendToGraph/W=$tWin $tWave0 vs $bwname
			break;
	endSwitch
end

Function t_matg(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	SVAR tWin = root:Packages:YT:tWin
	Variable n = v_nis
	do
		wave dw = $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n))
		appendtograph/w=$tWin dw
		n=n+1
	while(n<=v_ns)
end

Function t_atgwl(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWL = root:Packages:YT:tWL
	String str
	Variable i = 0
	do
		str = StringFromList(i, tWL)
		if(strlen(str) == 00)
			break
		endif
		
		appendtograph/W=$tWin $str
		i += 1
	while(1)
end

Function t_AppendToGraphNewAxis(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	SVAR tWin = root:Packages:YT:tWin
	String StrNewLeftAxis = ""
	Prompt StrNewLeftAxis "Define a name of new axis." 
	DoPrompt "Define a name of new axis", StrNewLeftAxis
	If(V_flag)
		Abort
	endif
	
	AppendToGraph/L=StrNewLeftAxis $tWave0 vs $tWave1
	ModifyGraph axisEnab(StrNewLeftAxis)={0.75,1},freePos(StrNewLeftAxis)={0,bottom}
	ModifyGraph mode=3,marker($tWave0)=19
End

Function t_rfg(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	RemoveFromGraph/W=$tWin $tWave0 
end

Function t_MakingUnit(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	NewDataFolder/O root:temp
	NewDataFolder/O root:tmp_PauseforCursorDF
	Variable/G root:tmp_PauseforCursorDF:canceled = 0
	String/G root:temp:DUNITS
	String/G root:temp:XUNITS
	SVAR DUNITS = root:temp:DUNITS
	SVAR XUNITS = root:temp:XUNITS
	NewPanel/K=2/w=(300,300,500,500)
	DoWindow/C tmp_PauseforCursor				// Set to an unlikely name

	DUNITS = StringByKey("DUNITS", WaveInfo($tWave0,0))
	XUNITS = StringByKey("XUNITS", WaveInfo($tWave0,0))
	
	DrawText 21,20,"Define Wave Units"
	SetVariable setdunits pos = {20,40}, size = {100, 20}, value = root:temp:DUNITS, title="DUNITS"
	SetVariable setxunits pos = {20,60}, size = {100, 20}, value = root:temp:XUNITS, title ="XUNITS"
	Button button0,pos={80,80},size={92,20},title="Continue"
	Button button0,proc=UserCursorAdjust_ContButtonProc
	Button button1,pos={80,102},size={92,20}
	Button button1,proc=UserCursorAdjust_CancelBProc,title="Cancel"
	
	PauseForUser tmp_PauseforCursor
	
	NVAR gCaneled= root:tmp_PauseforCursorDF:canceled
	Variable canceled= gCaneled
	
	If(canceled)
		KillDataFolder root:tmp_PauseforCursorDF
		KillDataFolder root:temp
		Abort
	endIf
	
	If(StringMatch(DUNITS, StringByKey("DUNITS", WaveInfo($tWave0,0))) == 0)
		SetScale d 0,0, DUNITS, $tWave0
	endIf
	
	If(StringMatch(XUNITS, StringByKey("XUNITS", WaveInfo($tWave0,0))) == 0)
		SetScale/P x 0,1, XUNITS, $tWave0
	endIf
	
	KillDataFolder root:tmp_PauseforCursorDF
	KillDataFolder root:temp
End

Function t_Showinfo(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	If(Strlen(WinList(tWin, ";", "WIN:1"))>0)
		ShowInfo/W=$tWin
	else
		ShowInfo
	endIf
End

Function t_GraphOffset(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	Variable offset
	Prompt offset "Enter offset value."
	DoPrompt "Define offset.", offset
	If(WinType(tWin) == 1)
		String SFL
		Variable i = 0
		do
			DoWindow/F $tWin
			SFL = StringFromList(i, Wavelist("*", ";", "WIN:"))
			If(strlen(SFL)<1)
				break
			endIf
			Wave srcWave =$SFL
			ModifyGraph/W=$tWin offset($SFL)={0,(offset*(-i))}
			i+=1
		while(1)
	else
		String tWinTemp = WinName(0, 1)
		SFL = ""
		i = 0
		do
			DoWindow/F $tWinTemp
			SFL = StringFromList(i, Wavelist("*", ";", "WIN:"))
			If(strlen(SFL)<1)
				break
			endIf
			Wave srcWave =$SFL
			ModifyGraph/W=$tWinTemp offset($SFL)={0,(offset*(-i))}
			i+=1
		while(1)
		
	endIf
End

Function t_IVCrossing(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	If(WinType(tWin) == 1)
		ModifyGraph/W=$tWin freePos(VertCrossing)={0,HorizCrossing}
		ModifyGraph/W=$tWin freePos(HorizCrossing)={0,VertCrossing}
		ModifyGraph/W=$tWin mode=3,marker=8
	endIf
End

Function t_edit(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	String TableName
	String DimLabel
	Prompt TableName, "Enter Name of Table."
	Prompt DimLabel, "Display label?", popup "default;ld;"
	DoPrompt "In case, you don't enter any charactor, it will be default procedure.", TableName, DimLabel
	If(V_Flag)
		Abort
	endif
	If(Strlen(TableName) == 0)
		If(Exists(tWave0) == 1)
			If(StringMatch(DimLabel, "ld"))
				edit $tWave0.ld
			else
				edit $tWave0
			endif
		else
			edit
		endif
	else
		If(Exists(tWave0) == 1)
			If(StringMatch(DimLabel, "ld"))
				edit/N=$TableName $tWave0.ld
			else
				edit/N=$TableName $tWave0
			endif
		else
			edit/N=$TableName
		endif
	endif
end

Function t_att(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	AppendToTable/W=$tWin $tWave0 
end

Function t_ATTWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin =root:Packages:YT:tWin
	SVAR tWL =root:Packages:YT:tWL
	String SFL
	Variable i  = 0
	do
		If(Strlen(StringFromList(i, tWL)) == 0)
			break
		endif
		SFL = StringFromList(i, tWL)
		Wave dw = $SFL
		AppendToTable/W = $tWin dw
		i += 1
	while(1)
End

Function t_rft(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	RemoveFromTable/W=$tWin $tWave0
end

Function t_mt(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	modifytable width = 45, sigDigits = 4, size = 8
end 

Function t_note(ctrlName) : ButtonControl
	String ctrlName
	strswitch(ctrlName)
	case "BtCN_tab10":
		If(Strlen(Winlist("CommandNote",";","WIN:16")) <=10)
			NewNotebook/n=CommandNote/F=0/V=1
		endif
		break
		
	case "BtPN_tab10":
			NewNotebook/F=0/V=1
		break
		
	case "BtFN_tab10":
			NewNotebook/F=1/V=1
		break
	default:	
		break
	endswitch
end

Function t_Savewaves(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWL	= root:Packages:YT:tWL
	String SwitchList
	String SwitchFormat
	String FileName
	Prompt SwitchList "Single wave? or Wave List?", popup "tWave0;tWaveList;"
	Prompt SwitchFormat "Select File Format", popup "IgorText;IgorBinary;DelimitedText;GeneralText;"
	Prompt Filename "Filename"
	DoPrompt "Define parameters", SwitchList, SwitchFormat, FileName
	If(V_flag)
		Abort
	endif
	StrSwitch (SwitchList)
		case "tWave0":
			SwitchList = " "+ tWave0 + " "
			break;
		case "tWaveList":
			SwitchList ="/B " +"\"" + tWL + "\" "
			break;
		default:
			SwitchList = ""
			break;
	endSwitch
	StrSwitch (SwitchFormat)
		case "IgorText":
			SwitchFormat = "/T"
			break;
		case "IgorBinary":
			SwitchFormat = "/J"
			break;
		case "DelimitedText":
			SwitchFormat = "/D"
			break;
		case "GeneralText":
			SwitchFormat = "/G"
			break;
		default:
			SwitchFormat = ""
			break;
	endSwitch
	String t
	t = "Save"+SwitchFormat + SwitchList + "as " + "\"" +FileName+"\""
	Execute t
End

Function t_PrepTable_Waves(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	DoAlert 1, "tWave0 (TextWave) must be selected as a bottom wave. Continue?"
	If(V_Flag == 2)
		Abort
	endIf
	Variable npt
	String Keyword
	String table
	String tablename
	Prompt Keyword "Enter specification word of the waves."
	Prompt npt "Define number of rows (npts of tWave0, testwave)"
	Prompt table "New table or preexisting table?", popup "New table;"+ winlist("*",";","WIN:2")
	Prompt tablename "In case you select New table, define the name of your new table.", popup "default;manual;"
	DoPrompt "Why don't you make a table for graph?", Keyword, npt, table, tablename
	If(V_Flag)
		Abort
	endIf
	StrSwitch(table)
		case "New table":
			StrSwitch (tablename)
				case "default":
					tablename = "Table_"+Keyword
					Edit/W=(5.25,41.75,750,251.75)/N = $tablename
					break;
				case "manual":
					Prompt tablename "Define the name of your new table."
					DoPrompt "Why don't you define the tablename?", tablename
					If(strlen(tablename) == 0)
						Edit/W=(5.25,41.75,750,251.75)
					else
						Edit/W=(5.25,41.75,750,251.75)/N = $tablename
					endif
					break;
				default:
					break;
			endSwitch
			break;
		default:
			DoWindow/F $table
			break;
	endSwitch
	If(StrSearch(Wavelist("*", ";", "WIN:"), tWave0 ,0) == -1)
		AppendToTable $tWave0
	endIf
	String sWaveName
	String SEMsWaveName
	Variable n = 0
	do
		String tWave0_text
		Wave/T destTextWave = $tWave0
		tWave0_text = destTextWave[n]
		sWaveName = keyword + "_" + tWave0_text
		SEMsWaveName = "SEM_" + sWaveName
		Make/O/N = (npt) $sWaveName, $SEMsWaveName
		AppendToTable $sWaveName, $SEMsWaveName
		Wave srcWave0 = $sWaveName
		Wave srcWave1 = $SEMsWaveName
		srcWave0 = NaN
		srcWave0[n] = 0
		srcWave1 = srcWave0
		n += 1
	while(n<npt)
	modifytable sigDigits = 4, size = 8
End

Function t_Approx_tWL(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWL = root:Packages:YT:tWL
	String SFL, sWaveList, keyword, strasterisk, strsort
	Prompt keyword "Define keyword for Make tWL."
	Prompt strasterisk, "strsearchtype"  , popup, "* + keyword;keyword + *;"
	Prompt strsort, "Sort List?", popup, "yes;no;"
	DoPrompt "Why don't you difine the word?", keyword, strasterisk, strsort
	If(V_flag)
		Abort
	endIf
	
	StrSwitch (strasterisk)
		case "keyword + *":
			sWaveList = wavelist(keyword+"*", ";", "")
			break
		case "* + keyword":
			sWaveList = wavelist("*"+keyword, ";", "")
			break
		default:
			break
	endSwitch
	
	Variable i = 0

	do
		SFL = StringFromList(i, sWaveList)
		If(Strlen(SFL) == 0)
			break
		endif
		tWL += SFL+";"
		i += 1
	while(1)
	
	If(StringMatch(strsort, "yes"))
		tWL = SortList(tWL, ";", 16)
	endIf
	
//	Print tWL
End

Function BtCPWL_tab10(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	DoAlert 1, "WaveList must be Selected. Continue?"
	If(V_Flag == 2)
		Abort
	endIf
	SVAR tWL = root:Packages:YT:tWL
	Variable n = 1
	String title
	String graphtitle
	String leftlabeling
	String textWave
	String filling
	String grouping
	String slegend
	Prompt title "Enter the title"
	Prompt graphtitle "Enter graph Title", popup "default;manual;"
	Prompt leftlabeling "Enter the label of left axis"
	Prompt textWave "textWave as a bottom", popup Wavelist("*", ";", "TEXT:1")
	Prompt filling "Select Fill Type", popup "Default;None;Erace;Solid;GradPattern;Gradation3;Gradation5;"
	Prompt grouping "select grouping", popup "None;Keep with next;Draw to next;Add to next;Stack to next;"
	Prompt slegend "Wants legend?", popup "None;Box;Opaque;Transparent"
	DoPrompt "Select TextWave", title, graphtitle, leftlabeling, textWave, filling, grouping, slegend
	If(V_flag)
		Abort
	endif
	Variable vgrouping
	StrSwitch (grouping)
		case "Keep with next":
			vgrouping = -1
			break;
		case "None":
			vgrouping = 0
			break;
		case "Draw to next":
			vgrouping = 1
			break;
		case "Add to next":
			vgrouping = 2
			break;
		case "Stack to next":
			vgrouping = 3
			break;
		default:
			vgrouping = 0
			break;
	endSwitch
	Wave bottomWave = $textWave
	Variable i = 0
	String SFL
	do
		SFL = StringFromList(i, tWL)
		If(Strlen(SFL) == 0)
			break
		endif
		If(i == 0)
			StrSwitch (graphtitle)
				case "default":
					graphtitle = "Graph_" + title
					Display/N=$graphtitle
					break;
				case "manual":
					Prompt graphtitle "Enter graph Title"
					DoPrompt "Graph Title", graphtitle			
					If(strlen(graphtitle) == 0)
						Display
					else
						Display/N=$graphtitle
					endIf
					break;
				default:
					break;
			endSwitch			
		endIf
		Wave srcWave = $SFL
		AppendToGraph srcWave vs bottomWave
		ModifyGraph rgb=(0,0,0)
		StrSwitch(filling)
			case "Default":
				break;
			case "None":
				ModifyGraph hbFill($SFL) = 0
				break;
			case "Erace":
				ModifyGraph hbFill($SFL) = 1
				break;
			case "Solid":
				ModifyGraph hbFill($SFL) = 2
				break;
			case "GradPattern":
				Switch (i)
					case 0:
						ModifyGraph hbFill($SFL) = 1
						break;
					case 1:
						ModifyGraph hbFill($SFL) = 6
						break;
					case 2:
						ModifyGraph hbFill($SFL) = 2
						break;
					default:
						break;
				endSwitch
				break;
			case "Gradation3":
				Switch (i)
					case 0:
						ModifyGraph hbFill($SFL) = 1
						break;
					case 1:
						ModifyGraph hbFill($SFL) = 4
						break;
					case 2:
						ModifyGraph hbFill($SFL) = 2
						break;
					default:
						break;
				endSwitch
				break;
			case "Gradation5":
				Switch (i)
					case 0:
						ModifyGraph hbFill($SFL) = 1
						break;
					case 1:
						ModifyGraph hbFill($SFL) = 5
						break;
					case 2:
						ModifyGraph hbFill($SFL) = 4
						break;
					case 3:
						ModifyGraph hbFill($SFL) = 3
						break;
					case 4:
						ModifyGraph hbFill($SFL) = 2
					default:
						break;
				endSwitch
				break;
			default:
				break;
		endSwitch
		ModifyGraph toMode($SFL) = vgrouping
		i += 1
	while(1)
	If(strlen(title) != 0)
		TextBox/C/N=text0/F=0/B=1 title
	endIf
	If(strlen(leftlabeling) !=0)
		Label left "\\u#2" + leftlabeling
	endIf
	StrSwitch (slegend)
		case "None":
			break;
		case "Box":
			Legend
			break;
		case "Opaque":
			Legend/F=0
			break;
		case "Transparent":
			Legend/F=0/B=1
			break;
		default:
			break;
	endSwitch
	DoUpdate
	GetAxis left
	SetAxis left 0,V_max
	tWin =WinName(0,1)
	DoWindow/F $tWin
End

Function t_ErrorBarWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	String SFL
	String SFLCategory
	DoAlert 1, "WaveList of Error Bar must be Selected as a tWL (Same Number as Ws). Continue?"
	If(V_Flag == 2)
		Abort
	endIf
	DoWindow/F $tWin
	String CPWL = WaveList("*", ";", "WIN:,TEXT:0")
	Print CPWL
	do
		SFL = StringFromList(i, tWL)
		SFLCategory = StringFromList(i, CPWL)
		Print SFL, SFLCategory
		If(Strlen(SFL) == 0)
			break
		endif
		ErrorBars $SFLCategory Y,wave=($SFL,$SFL)
		i += 1
	while(1)
	SetAxis/A
	DoUpDate
	GetAxis left
	SetAxis left 0,V_max
End

Function t_Single_Category(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	DoAlert 1, "tWave0 (TextWave) must be selected as a bottom wave. Continue?"
	If(V_Flag == 2)
		Abort
	endIf
	Variable npt
	String Keyword
	String table
	String tablename
	Prompt Keyword "Enter specification word of the waves."
	Prompt npt "Define number of rows (npts of tWave0, testwave)"
	Prompt table "New table or preexisting table?", popup "New table;"+ winlist("*",";","WIN:2")
	Prompt tablename "In case you select New table, define the name of your new table."
	DoPrompt "Why don't you make a table for graph?", Keyword, npt, table, tablename
	If(V_Flag)
		Abort
	endIf
	StrSwitch(table)
		case "New table":
			If(strlen(tablename) == 0)
				Edit/W=(5.25,41.75,750,251.75)
			else
				Edit/W=(5.25,41.75,750,251.75)/N = $tablename
			endIf
			break;
		default:
			DoWindow/F $table
			break;
	endSwitch
	If(StrSearch(Wavelist("*", ";", "WIN:"), tWave0 ,0) == -1)
		AppendToTable $tWave0
	endIf
	String sWaveName
	String SEMsWaveName
	Variable n = 0
	sWaveName = keyword
	SEMsWaveName = "SEM_" + sWaveName
	Make/O/N = (npt) $sWaveName, $SEMsWaveName
	AppendToTable $sWaveName, $SEMsWaveName
	modifytable sigDigits = 4, size = 8
	
	n = 1
	String title
	String graphtitle
	String leftlabeling
	String textWave
	String filling
	String slegend
	Prompt title "Enter the title"
	Prompt graphtitle "Enter graph Title"
	Prompt leftlabeling "Enter the label of left axis"
	Prompt textWave "textWave as a bottom", popup Wavelist("*", ";", "TEXT:1")
	Prompt filling "Select Fill Type", popup "Default;None;Erace;Solid;"
	Prompt slegend "Wants legend?", popup "None;Box;Opaque;Transparent"
	DoPrompt "Select TextWave", title, graphtitle, leftlabeling, textWave, filling, slegend
	If(V_flag)
		Abort
	endif

	Wave bottomWave = $textWave
	If(strlen(graphtitle) == 0)
		Display
	else
		Display/N=$graphtitle
	endIf
	Wave srcWave = $sWaveName
	AppendToGraph srcWave vs bottomWave
	ModifyGraph rgb=(0,0,0)
	StrSwitch(filling)
		case "Default":
			break;
		case "None":
			ModifyGraph hbFill($sWaveName) = 0
			break;
		case "Erace":
			ModifyGraph hbFill($sWaveName) = 1
			break;
		case "Solid":
			ModifyGraph hbFill($sWaveName) = 2
			break;
		default:
			break;
		endSwitch

	If(strlen(title) != 0)
		TextBox/C/N=text0/F=0/B=1 title
	endIf
	If(strlen(leftlabeling) !=0)
		Label left "\\u#2" + leftlabeling
	endIf
	StrSwitch (slegend)
		case "None":
			break;
		case "Box":
			Legend
			break;
		case "Opaque":
			Legend/F=0
			break;
		case "Transparent":
			Legend/F=0/B=1
			break;
		default:
			break;
	endSwitch
	DoUpdate
	GetAxis left
	SetAxis left 0,V_max
	tWin =WinName(0,1)
	DoWindow/F $tWin
	
	ErrorBars $sWaveName Y,wave=($SEMsWaveName,$SEMsWaveName)
	SetAxis/A
	DoUpDate
	GetAxis left
	SetAxis left 0,V_max
End

// end of GEN tab
/////////////////////////////////////////////////////////////////////////////////////////////

//Edit tab11

Function t_dupws(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	String NewWave, SwitchStr, OW, Where
	Prompt NewWave, "Enter New Wave Name"
	Prompt SwitchStr "target wave?", popup "Yes;No;"
	Prompt OW "Overwrite?", popup "Yes;No;"
	If(StringMatch(ctrlName, "BtJwsubtW0_tab01"))
		Prompt Where "Where does tWave0 exist?", popup "root:Packages:YT:;root;;"
	else
		Prompt Where "Where does tWave0 exist?", popup "root:;root:Packages:YT:;"
	endIf
	DoPrompt "Duplicate Wave", NewWave, SwitchStr, OW, Where
	If(V_flag)
		Abort
	endif
	If(StringMatch(OW, "Yes"))
		If(StringMatch(Where, "root:Packages:YT:"))
			Duplicate/O root:Packages:YT:$tWave0 $NewWave
		else
			Duplicate/O $tWave0 $NewWave
		endif
	else
		If(StringMatch(Where, "root:Packages:YT:"))
			Duplicate root:Packages:YT:$tWave0 $NewWave
		else
			Duplicate $tWave0 $NewWave
		endif
	endif
	StrSwitch (SwitchStr)
		case "Yes":
			tWave0 = NewWave
			break;
		default:
			break;
	endswitch
end

Function t_DuplicatetWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	String Keyword
	String SwitchStr
	String OW
	String SwitchDisplay
	Prompt Keyword, "Enter Keyword"
	Prompt OW "Overwrite?", popup "Yes;No;"
	Prompt SwitchDisplay "Display?", popup "Yes;No;"
	DoPrompt "Duplicate Wave", Keyword, OW, SwitchDisplay
	If(V_flag)
		Abort
	endif
	Variable i = 0
	String SFL
	If(StringMatch(SwitchDisplay, "Yes"))
		Display
	endif
	do
		SFL = StringFromList(i, tWL)
		If(Strlen(SFL) == 0)
			break
		endif
		Wave srcWave = $SFL
		String destWave = Keyword + "_" + Num2str(i)
		If(StringMatch(OW, "Yes"))
			Duplicate/O srcWave $destWave
		else
			Duplicate srcWave $destWave
		endif
		If(StringMatch(SwitchDisplay, "Yes"))
			AppendToGraph $destWave
		endif
		i += 1
	while(1)
End

Function t_RenameWs(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	String NewName
	Wave dw = $tWave0
	Prompt NewName, tWave0 + " ->"
	String StringSwitch
	Prompt StringSwitch "target Wave?", popup "Yes;No;"
	DoPrompt "Rename Wave", NewName, StringSwitch
	If(V_flag == 1)
		Abort
	endif
	Rename dw $NewName
	If(StringMatch(StringSwitch, "Yes"))
		tWave0 = NewName
	endif
end

Function t_RenametWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	String Keyword
	String SwitchStr
	String SwitchDisplay
	Prompt Keyword, "Enter Keyword"
	Prompt SwitchDisplay "Display?", popup "Yes;No;"
	DoPrompt "Rename Wave", Keyword, SwitchDisplay
	If(V_flag)
		Abort
	endif
	Variable i = 0
	String SFL
	If(StringMatch(SwitchDisplay, "Yes"))
		Display
	endif
	do
		SFL = StringFromList(i, tWL)
		If(Strlen(SFL) == 0)
			break
		endif
		Wave srcWave = $SFL
		String destWave = Keyword + "_" + Num2str(i)
		Rename srcWave $destWave
		If(StringMatch(SwitchDisplay, "Yes"))
			AppendToGraph $destWave
		endif
		i += 1
	while(1)
End

Function t_killwaves(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Killwaves $tWave0
	tWave0 = ""
end

Function t_Button_KillWaveList(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	do
		If(strlen(StringFromList(i, tWL)) == 0)
			break
		endif
		KillWaves/Z $StringFromList(i, tWL)
		i += 1
	while(1)
End

Function t_0toNaN(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave dw = $tWave0
	WaveStats/Q $tWave0
	Print V_npnts, V_numNans, V_numINFs
	Variable n = 0
	Variable m = V_npnts + V_numNans + V_numINFs	
	do
		If(dw[n]==0)
			dw[n] = NaN
		endif
		n=n+1
	while(n<=m)
end

Function t_0toNaNWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	String SFL
	do
		If(Strlen(StringFromList(i, tWL)) == 0)
			break
		endif
		SFL = StringFromList(i, tWL)
		Wave dw = $SFL
		WaveStats/Q $SFL
		Print V_npnts, V_numNans, V_numINFs
		Variable n = 0
		Variable m = V_npnts + V_numNans + V_numINFs	
		do
			If(dw[n]==0)
				dw[n] = NaN
			endif
			n=n+1
		while(n<=m)
		i +=1
	while(1)
end

Function t_NaNtoZero(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave dw = $tWave0
	WaveStats/Q $tWave0
	Print V_npnts, V_numNans, V_numINFs
	Variable n = 0
	Variable m = V_npnts + V_numNans + V_numINFs	
	do
		If(numtype(dw[n]) == 2)
			dw[n] = 0
		endif
		n=n+1
	while(n<=m)
End

Function t_NaNtoZeroWL(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	String SFL
	do
		If(Strlen(StringFromList(i, tWL)) == 0)
			break
		endif
		SFL = StringFromList(i, tWL)
		Wave dw = $SFL
		WaveStats/Q $SFL
		Print V_npnts, V_numNans, V_numINFs
		Variable n = 0
		Variable m = V_npnts + V_numNans + V_numINFs
		do
			If(numtype(dw[n]) == 2)
				dw[n] = 0
			endif
			n=n+1
		while(n<=m)
		i +=1
	while(1)
End

Function t_makewst(ctrlName) : ButtonControl
	String ctrlName
	String name
	String t
	String tt
	String sem
	Variable nn
	Prompt name, "Enter WaveName. "
	Prompt sem, "Do you need SEM wave?", popup "No;Yes;"
	Prompt nn, "n? "
	Prompt t, "Select Wave Type", popup "Numeric wave;Text wave;"
	DoPrompt "Enter name, n, textwave", name, sem, nn, t
	
	StrSwitch(t)
		case "Text wave":
			Make/t/n=(nn) $name
			If(Strlen(StringFromList(0, WinList("*", ";", "Win:2"))) > 1)
				Appendtotable $name
			endif
			break;
		case "numeric wave":
			Make/n=(nn) $name
			If(Strlen(StringFromList(0, WinList("*", ";", "Win:2"))) > 1)
				Appendtotable $name
			endif
			If(StringMatch(sem, "Yes"))
				Make/n=(nn) $("SEM_"+name)
				If(Strlen(StringFromList(0, WinList("*", ";", "Win:2"))) > 1)
					Appendtotable $("SEM_"+name)
				endif
			endif
			If(stringmatch(t, "numeric wave") )
				Prompt tt, "NaN Wave?", popup "No;Yes;"
				DoPrompt "Select Data Type.", tt
				If(stringmatch(tt, "Yes"))
					Wave dw = $name
					dw = NaN
					If(StringMatch(sem, "Yes"))
						Wave dw1 = $("SEM_" +name)
						dw1 = NaN
					endif
				endif
			endif
			break;
		default :
			break;
	endswitch
end

Function t_ConnectWs(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	Wave wtWave0 = $tWave0
	Wave wtWave1 = $tWave1
	Variable npnts0
	Variable npnts1
	String pw = "Cn_" + tWave0 + "_" + tWave1
	Duplicate/O $tWave0 $pw
	Wave dw = $pw
	WaveStats/Q $tWave0
	npnts0 = V_npnts
	WaveStats/Q $tWave1
	npnts1 = V_npnts
	Redimension/N=(npnts0+npnts1) dw
	dw[npnts0,] = wtWave1[p-npnts0]
end

Function t_RenameVariable(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable pv_e, pv_nc, pv_nis, i
	String switch_rename_duplicate
	Prompt switch_rename_duplicate "Select mode", popup "rename;duplicate;"
	Prompt pv_e "v_e->"
	Prompt pv_nc "v_nc->"
	Prompt pv_nis "v_nis->"
	DoPrompt "Define Param." switch_rename_duplicate,pv_e, pv_nc, pv_nis
	If(v_flag == 1)
		Abort
	endif
	i = v_nis
	StrSwitch (switch_rename_duplicate)
		case "rename":
			do
				wave srcWave = $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(i))
				rename srcWave $("w_"+Num2str(pv_e)+"_"+Num2str(pv_nc)+"_"+Num2str(pv_nis+i))
				i+=1
			while(i<=v_ns)	
			break;
		case "duplicate":
			do
				wave srcWave = $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(i))
				duplicate/O srcWave $("w_"+Num2str(pv_e)+"_"+Num2str(pv_nc)+"_"+Num2str(pv_nis+i))
				i+=1
			while(i<=v_ns)
			break;
		default:
			break;
	endSwitch
end

Function t_ContiConWsReNWs(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave1 = root:Packages:YT:tWave1
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	variable n = v_nis + 1
	Wave dw0 =$("w_"+Num2str(v_e) + "_"+Num2str(v_nc)+"_"+Num2str(v_nis))
	Variable npnts0, npnts1
	String pw = tWave1
	Duplicate/O dw0 $pw
	Wave dw = $pw
	do
		If(Exists("w_"+Num2str(v_e) + "_"+Num2str(v_nc)+"_"+Num2str(n)) == 1)
			Wave dw1 =$("w_"+Num2str(v_e) + "_"+Num2str(v_nc)+"_"+Num2str(n))
			WaveStats/Q dw
			npnts0 = V_npnts
			WaveStats/Q dw1
			npnts1 = V_npnts
			Redimension/N=(npnts0+npnts1) dw
			dw[npnts0,] = dw1[p-npnts0]
		endif
		n +=1
	while(n <= v_ns)
end

Function t_ContiConWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWL = root:Packages:YT:tWL
	String StrDestW
	Prompt StrDestW, "Enter the name of destination wave."
	DoPrompt "Specify destination wave.", StrDestW
	If(V_flag)
		Abort
	endif
	tWave0 = StrDestW

	Variable i = 0
	String SFL = StringFromList(i, tWL)
	Duplicate/O $SFL, $StrDestW
	Wave dw = $StrDestW
	Variable npnts0, npnts1
	i +=1

	do
		SFL = StringFromList(i, tWL)
		If(strlen(SFL) == 0)
			break
		endif
		Wave srcW = $SFL
		Wavestats/Q dw
		npnts0 = V_npnts
		Wavestats/Q srcW
		npnts1 = V_npnts
		Redimension/N=(npnts0+npnts1) dw
		dw[npnts0,] = srcW[p-npnts0]

		i += 1
	while(1)
End

Function t_subtraction(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	String pw, StringSwitch, displayw
	Prompt pw "Name of destWave? If \"\", default."
	Prompt StringSwitch "target Wave?", popup "Yes;No;"
	Prompt displayw "display?", popup "Yes;No;"
	DoPrompt "Define destWave.", pw, StringSwitch, displayw
	If(V_flag)
		Abort
	endif
	If(Strlen(pw) == 0)
		pw = "sub_" + tWave0 + "_" + tWave1
		If(strlen(pw) > 30)
			pw = pw[0, 29]
		endif
	endif
	Duplicate/O $tWave0, $pw
	wave dw = $pw
	wave tW0 = $tWave0
	wave tW1 = $tWave1
	dw = tW0 - tW1
	If(StringMatch(StringSwitch, "Yes"))
		tWave0 = pw
	endif
	If(Stringmatch(displayw, "Yes"))
		display dw
	endif
end

Function t_subtractionbase(ctrlName) : ButtonControl
	String ctrlName
	
	StrSwitch (ctrlName)
		case "Bt_subtractionbase_tab11" :
			SVAR tWave0 = root:Packages:YT:tWave0
			Wave dw = $tWave0
			variable n1 = dw(xcsr(a))
			dw = dw - n1
			break
		case "Bt_msubtractionbase_tab11" :
			NVAR v_e = root:Packages:YT:v_e
			NVAR v_nc = root:Packages:YT:v_nc
			NVAR v_ns = root:Packages:YT:v_ns
			NVAR v_nis = root:Packages:YT:v_nis
			variable m = v_nis
			variable n2 = 1
			do
				Wave dw = $("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(m))
				n2 = dw(xcsr(a))
				dw = dw - n2
				m = m + 1
			while(m<=v_ns)
			break
		default :
			break
	endswitch
end

Function t_SubtWave0FromtWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWL = root:Packages:YT:tWL
	Variable i
	String srcWName
	do
		srcWName = StringFromList(i, tWL)
		If(strlen(srcWName) == 00)
			break
		endif
		Wave srcW1 = $srcWName
		Wave srcW2 = $tWave0
		srcW1 = srcW1 - srcW2
		i += 1	
	while(1)
End

Function t_subCursol_tWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	Variable i, s = 0
	String SFL
	do
		SFL = StringFromList(i, tWL)
		If(strlen(SFL) == 0)
			break
		endif
		Wave srcW = $SFL
		If(strlen(CsrInfo(A)) == 0)
			Cursor A, $SFL, leftx($SFL)
		endIf
		s= srcW(xcsr(a))
		srcW = srcW - s		
		i += 1
	while(1)
End

Function t_plusCWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	Variable C
	String srcWName
	do
		Prompt C "Enter Variable C (WL + C)"
		DoPrompt "WL = WL + C", C
		If(V_flag)
			Abort
		endif
		i = 0
		do
			srcWName = StringFromList(i, tWL)
			If(strlen(srcWName) == 00)
				break
			endif
			Wave srcW = $srcWName
			srcW = srcW + C
			i += 1
		while(1)
		DoAlert 2, "OK?"
		If(V_flag == 1 )
			break
		endif
		If(V_flag == 2)
			i = 0
			do
				srcWName = StringFromList(i, tWL)
				If(strlen(srcWName) == 00)
					break
				endif
				Wave srcW = $srcWName
				srcW = srcW - C
				i += 1
			while(1)
		endif
		If(V_flag == 3)
			i = 0
			do
				srcWName = StringFromList(i, tWL)
				If(strlen(srcWName) == 00)
					break
				endif
				Wave srcW = $srcWName
				srcW = srcW - C
				i += 1
			while(1)
			break
		endif
	while(1)
End

Function t_byCWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	Variable C
	String srcWName
	Prompt C "Enter Variable C (WL * C)"
	DoPrompt "WL = WL * C", C
	If(V_flag)
		Abort
	endif
	i = 0
	do
		srcWName = StringFromList(i, tWL)
		If(strlen(srcWName) == 00)
			break
		endif
		Wave srcW = $srcWName
		srcW = srcW * C
		i += 1
	while(1)
End

Function t_NormalizeWave(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Wave srcWave = $tWave0
	String strdestWave = "w_Normalized_" + tWave0
	Duplicate/O $tWave0 $strdestWave
	Wave destWave = $strdestWave
	Variable/G root:Packages:YT:Val_Nor
	NVAR Val_Nor = root:Packages:YT:Val_Nor
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shift key pressed
		Val_Nor = ABS(destWave[numpnts(destWave)])
		destWave = destWave/Val_Nor
		tWave0 = strdestWave
	else
		Val_Nor = ABS(destWave[0])
		destWave = destWave/Val_Nor
		tWave0 = strdestWave
	endIf
	
	If(WinType(tWin) == 2)
		AppendToTable/W = $tWin $strdestWave
	endif
End

Function t_InvertPoints(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Variable npts = numpnts($tWave0)
	Variable i = 0
	Duplicate $tWave0, w_InvertPoints
	Wave srcw = $tWave0
	do
		srcw[i] = w_InvertPoints[npts-i-1]
		i += 1
	while(i<npts)
	Killwaves w_InvertPoints
End


Function t_line_between_2pnt(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	Variable a = (srcWave(xcsr(B))-srcWave(xcsr(A)))/(xcsr(B)-xcsr(A))
	Variable b = 0.5*(srcWave(xcsr(A))+srcWave(xcsr(B))-(xcsr(A)+xcsr(B))*a)
	String line, dup, mode, strarea
	Prompt line "Define Name of line"
	Prompt dup "Define Name of duplicated tWave0"
	Prompt mode "Select line mode", popup "default;in;out"
	Prompt strarea "Select area mode", popup "none;yes"
	DoPrompt "Define mode", line, mode, strarea

	duplicate/o srcWave $line
	Wave destWave = $line
	destWave = a*x + b
	AppendToGraph destWave
	
	StrSwitch (mode)
		case "in":
			destWave[,pcsr(A)] = NaN
			destWave[pcsr(B),] = NaN
			break;
		case "out":
			destWave[pcsr(A), pcsr(B)] = NaN
			break;
		default:
			break;
	endSwitch
	
	If(StringMatch(strarea, "yes"))
		DoPrompt "Igor wants to know dup name", dup
		duplicate/o srcWave $dup
		AppendToGraph $dup
		Wave duplicatedWave = $dup
		duplicatedWave[,pcsr(A)] = NaN
		duplicatedWave[pcsr(B),] = NaN
		ModifyGraph mode($line)=7,hbFill($line)=2,toMode($line)=1
	endif
End

Function t_Artifact2NaN(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	String StringSwitch
	Variable r0, r1
	Prompt r0 "Start"
	Prompt r1 "End"
	Prompt StringSwitch "Range?", popup "Cursor;Points;X;"
	DoPrompt "Select Range Difinition", StringSwitch
	If(V_flag)
		Abort
	endif
	If(StringMatch(StringSwitch, "Cursor") != 1)
		DoPrompt "Enter Range.", r0, r1
		If(V_flag)
			Abort
		endif
	endif
	StrSwitch (StringSwitch)
		case "Cursor":
			Variable i = 0
			String SFL
			do
				If(Strlen(StringFromList(i, tWL)) == 0)
					break
				endif
				SFL = StringFromList(i, tWL)
				Wave vari = $SFL
				vari[pcsr(A), pcsr(B)] = NaN
				i += 1
			while(1)
			break;
		case "Points":
			i = 0
			do
				If(Strlen(StringFromList(i, tWL)) == 0)
					break
				endif
				SFL = StringFromList(i, tWL)
				Wave vari = $SFL
				vari[r0, r1] = NaN
				i += 1
			while(1)
			break;
		case "X":
			i = 0
			do
				If(Strlen(StringFromList(i, tWL)) == 0)
					break
				endif
				SFL = StringFromList(i, tWL)
				Wave vari = $SFL
				r0 = x2pnt(vari, r0)
				r1 = x2pnt(vari, r1)
				vari[r0, r1] = NaN
				i += 1
			while(1)
			break;
		default:
			break;
	endSwitch
End 

Function t_MiniEventAverage(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:YT:tWL
	String SFL = "", StrdestWave = ""
	Variable i, j, k, l = 0

	Prompt StrdestWave "NewWaveName?"
	DoPrompt "Define destWaveName!" StrdestWave
	If(V_flag)
		Abort
	endif

	do
		SFL = StringFromList(i, tWL)
		If(strlen(SFL) == 0)
			break
		endif
		If(i==0)
			Duplicate/O $SFL, $StrdestWave
			Wave dw = $StrdestWave
			dw[0,] = 0
		endIf
		sscanf SFL, "w_%f_IX_%f", j, k
		Wave srcWave = $SFL
		dw += srcWave*k
		l += k
		i+=1
	while(1)
	dw /= l
	Printf "Event number is %d.\r", l
End

Function t_WaveABS(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	srcWave[x,] = ABS(srcWave[x])
End

Function t_eliminate_left_parenthesis(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave/T srcW = $tWave0
	Variable d, npnts, i
	npnts = numpnts(srcW)
	
	String StrDestWave = ""
//	Prompt StrDestWave "Specify destWave! Default: wave3x"
//	DoPrompt "Name of Destination Wave", StrDestWave
//	If(v_flag)
//		Abort
//	endif

	If(Strlen(StrDestWave) == 0)
		StrDestWave = "wave3x" 
	endif
	
	If(Exists(StrDestWave))
		StrDestWave += "0"
	endif

	Make/n = (npnts) $StrDestWave

	Wave destW = $StrDestWave

	For(i = 0; i < npnts; i += 1)
		sscanf srcW[i], "(%f", d
		destW[i] = d
	endfor
	RemoveFromTable $tWave0
	Killwaves $tWave0
	Rename destW, $tWave0
	AppendToTable $tWave0
end

Function t_LowPassFilterWL(ctrlName) : ButtonControl
	String ctrlName

	NVAR IIRHi = root:Packages:YT:IIRHi
	NVAR IIRLow = root:Packages:YT:IIRLow
	SVAR tWL = root:Packages:YT:tWL
	Variable i = 0
	String SFL
	
	do
		SFL = StringFromList(i, tWL)
		If(strlen(SFL)<1)
			break
		endif
		Wave srcW = $SFL	
		Duplicate/O srcW, $("Filtd_"+ SFL)
		Wave destW = $("Filtd_"+ SFL)
		
		Variable bit = 0
		
		If(numtype(IIRHi))
		else	
			bit += 2^0
		endIf
		
		If(numtype(IIRLow))
		else
			bit += 2^1
		endIf
		
		switch(bit)	// numeric switch
			case 1:		// execute if case matches expression
				FilterIIR/CASC/HI=(IIRHi) destW
				break						// exit from switch
			case 2:		// execute if case matches expression
				FilterIIR/CASC/LO=(IIRLow) destW
				break
			case 3:
				FilterIIR/CASC/LO=(IIRLow)/HI=(IIRHi) destW
				break
			default:
				Abort						// optional default expression executed
				break						// when no case matches
		endswitch
		
		If(i<1)
			display destW
		else	
			AppendToGraph destW
		endIf
		
		i += 1
	while(1)
End

Function t_mkbasewave(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	String pw = "b_"+tWave0
	Duplicate/O $tWave0 $pw
	wave dw = $pw
	dw[0,] = vcsr(A)
	AppendToGraph dw
end

Function t_ModifyTargetWave0(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	String Command
	Prompt Command tWave0 + " = "
	DoPrompt "Enter Command line", Command
	String t = tWave0 + " = " + Command
	Execute t
End

Function t_RecDouble2DGauss(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	Wave srcWave = $tWave1
	Wave destWave = $tWave0
	destWave = srcWave[0]*exp(-1/(2*(1-srcWave[1]^2))* ( ((x-srcWave[2])/srcWave[3])^2 + ((y-srcWave[4])/srcWave[5])^2 - 2*srcWave[1]*(x-srcWave[2])*(y-srcWave[4])/(srcWave[3]*srcWave[5]) )) + srcWave[6]*exp(-1/(2*(1-srcWave[7]^2))* ( ((x-srcWave[8])/srcWave[9])^2 + ((y-srcWave[10])/srcWave[11])^2 - 2*srcWave[7]*(x-srcWave[8])*(y-srcWave[10])/(srcWave[9]*srcWave[11]) ))
End

Function t_Rec2DGauss(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	Wave srcWave = $tWave1
	Wave destWave = $tWave0
	destWave = srcWave[0]*exp(-1/(2*(1-srcWave[1]^2))* ( ((x-srcWave[2])/srcWave[3])^2 + ((y-srcWave[4])/srcWave[5])^2 - 2*srcWave[1]*(x-srcWave[2])*(y-srcWave[4])/(srcWave[3]*srcWave[5]) ))	
End

Function t_in_vivo_001(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	SVAR tWin = root:Packages:YT:tWin
	String SFL
	Variable i, s = 0
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		DoWindow/F $tWin
		do
			
			SFL = StringFromList(i, Wavelist("*", ";", "WIN:"))
			If(strlen(SFL) == 0)
				break
			endif
			Cursor A $SFL leftx($SFL)
			Wave srcW = $SFL
			s= srcW(xcsr(a))
			srcW = srcW - s		
			i += 1
		while(1)
	else
		DoWindow/F $tWin	
		do
			
			SFL = StringFromList(i, Wavelist("*", ";", "WIN:"))
			If(strlen(SFL) == 0)
				break
			endif
			Wave srcW = $SFL
			s= srcW(xcsr(a))
			srcW = srcW - s		
			i += 1
		while(1)
	endif
	
	SetAxis/W=$tWin left -5, 5
End


//end of Edit tab
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Analysis
Function t_astats(ctrlName) : ButtonControl
	string ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	//
	String sw_mean, sw_sdev, sw_sem, sw_num
	Prompt sw_mean "mean?", popup "No;Yes;"
	Prompt sw_sdev "sdev?", popup "No;Yes;"
	Prompt sw_sem "sem?", popup "No;Yes;"
	Prompt sw_num "num?", popup "No;Yes;"
	DoPrompt "Igor wants to know", sw_mean, sw_sdev, sw_sem, sw_num
	If(V_flag)
		Abort
	endif
	//
	variable n = v_nis
	string as ="w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)
	n = n + 1
	do
		if(exists("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)) == 1)
			as = as + " "+ "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)
		endif
		n=n+1
	while(n<=v_ns)
	string t = "Autostats " + as
	execute t
	duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_ns)) tswave_mean
	duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_ns)) tswave_sdev
	duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_ns)) tswave_sem
	duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_ns)) tswave_num
	string t_mean ="tswave_mean = swave_mean"
	string t_sdev = "tswave_sdev = swave_sdev"
	string t_sem = "tswave_sem = swave_sem"
	string t_num ="tswave_num = swave_num"
	execute t_mean
	execute t_sdev
	execute t_sem
	execute t_num
	rename tswave_mean $("w_mean_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
	rename tswave_sdev $("w_sdev_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
	rename tswave_sem $("w_sem_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
	rename tswave_num $("w_num_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
	//
		If(stringmatch(sw_mean, "No"))
			killwaves $("w_mean_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
		endif
		If(stringmatch(sw_sdev, "No"))
			killwaves $("w_sdev_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
		endif
		If(stringmatch(sw_sem, "No"))
			killwaves $("w_sem_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
		endif
		If(stringmatch(sw_num, "No"))
			killwaves $("w_num_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)+"__"+Num2str(v_ns))
		endif
	//
	killwaves swave_mean, swave_sdev, swave_sem, swave_num
end

Function t_atatswl(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWL = root:Packages:YT:tWL
	SVAR tWave0 = root:Packages:YT:tWave0
	String t
	if(strlen(StringFromList(0, tWL)) != 0)
		Wave srcWave = $StringFromList(0, tWL)
		String destWName, sw_mean, sw_sdev, sw_sem, sw_num, target, appendtg, as
		Prompt destWName, "Enter the KeyWord for Name of results"
		Prompt sw_mean "mean?", popup "Yes;No;"
		Prompt sw_sdev "sdev?", popup "No;Yes;"
		Prompt sw_sem "sem?", popup "No;Yes;"
		Prompt sw_num "num?", popup "No;Yes;"
		Prompt target "target wave?", popup "Yes;No;"
		Prompt appendtg "AppendToGraph?", popup "Yes;No;"
		
		DoPrompt "Igor wants to know", destWName, sw_mean, sw_sdev, sw_sem, sw_num, target, appendtg
		If(V_flag)
			Abort
		endif
		Print ReplaceString(";", tWL, " ")
		t = "Autostats " + ReplaceString(";", tWL, " ")
		execute t
		duplicate/O srcWave tswave_mean
		duplicate/O srcWave tswave_sdev
		duplicate/O srcWave tswave_sem
		duplicate/O srcWave tswave_num
		string t_mean ="tswave_mean = swave_mean"
		string t_sdev = "tswave_sdev = swave_sdev"
		string t_sem = "tswave_sem = swave_sem"
		string t_num ="tswave_num = swave_num"
		execute t_mean
		execute t_sdev
		execute t_sem
		execute t_num
		rename tswave_mean $("w_mean_"+ destWName)
		rename tswave_sdev $("w_sdev_"+ destWName)
		rename tswave_sem $("w_sem_"+ destWName)
		rename tswave_num $("w_num_"+ destWName)
		If(stringmatch(sw_mean, "No"))
			killwaves $("w_mean_"+ destWName)
		endif
		If(stringmatch(sw_sdev, "No"))
			killwaves $("w_sdev_"+ destWName)
		endif
		If(stringmatch(sw_sem, "No"))
			killwaves $("w_sem_"+ destWName)
		endif
		If(stringmatch(sw_num, "No"))
			killwaves $("w_num_"+ destWName)
		endif
		killwaves swave_mean, swave_sdev, swave_sem, swave_num
		
		If(StringMatch(target, "Yes"))
			tWave0 = "w_mean_" + destWName
		endIf
		
		If(StringMatch(appendtg, "Yes"))
			AppendToGraph/W=$tWin $("w_mean_" + destWName)
			ModifyGraph/W=$tWin rgb($("w_mean_" + destWName))=(8704,8704,8704)
		endIf
	endif
end

Function t_astatssn(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis 
	Variable i = 0
	Variable j = 0
	Variable stimnum = 0
	String keyword, sw_mean, sw_sdev, sw_sem, sw_num, switch_display, as
	Prompt keyword "Definition"
	Prompt stimnum "How many stimulation?"
	Prompt sw_mean "mean?", popup "No;Yes;"
	Prompt sw_sdev "sdev?", popup "No;Yes;"
	Prompt sw_sem "sem?", popup "No;Yes;"
	Prompt sw_num "num?", popup "No;Yes;"
	Prompt switch_display "display?", popup "No;Yes;"
	DoPrompt "Igor wants to know", keyword, stimnum, sw_mean, sw_sdev, sw_sem, sw_num, switch_display
	If(V_flag)
		Abort
	endif
	If(StringMatch(switch_display, "Yes"))
		display
	endif
	i = v_nis
	do
		as = ""
		for(j = 0;j<stimnum;j+=1)
			if(exists("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(i+j)) == 1)
				as += "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(i+j) + " "
			endif
		endfor
		Print as
		String t = "Autostats " + as
		execute t
		duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)) $("w_mean_"+ keyword + "_" + Num2str(i))
		duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)) $("w_sdev_"+ keyword + "_" + Num2str(i))
		duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)) $("w_sem_"+ keyword + "_" + Num2str(i))
		duplicate/O $("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)) $("w_num_"+ keyword + "_" + Num2str(i))
		Wave swave_mean, swave_sdev, swave_sem, swave_num
		Wave vari0 = $("w_mean_"+ keyword + "_" + Num2str(i))
		Wave vari1 = $("w_sdev_"+ keyword + "_" + Num2str(i))
		Wave vari2 = $("w_sem_"+ keyword + "_" + Num2str(i))
		Wave vari3 = $("w_num_"+ keyword + "_" + Num2str(i))
		vari0 = swave_mean
		vari1 = swave_sdev
		vari2 = swave_sem
		vari3 = swave_num
		If(stringmatch(sw_mean, "No"))
			killwaves $("w_mean_"+ keyword + "_" + Num2str(i))
		endif
		If(stringmatch(sw_sdev, "No"))
			killwaves $("w_sdev_"+ keyword + "_" + Num2str(i))
		endif
		If(stringmatch(sw_sem, "No"))
			killwaves $("w_sem_"+ keyword + "_" + Num2str(i))
		endif
		If(stringmatch(sw_num, "No"))
			killwaves $("w_num_"+ keyword + "_" + Num2str(i))
		endif
		killwaves swave_mean, swave_sdev, swave_sem, swave_num
		i+=stimnum
		If(StringMatch(switch_display, "Yes"))
			AppendToGraph vari0
		endif
	while(i<v_ns)
end

Function t_find_w_avg(ctrlName) : ButtonControl  //各コマンドのトレースを平均化し、テーブルに加える（ウェイブは連番ではなくても可：delete可）
	string ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	variable m = 1
	do
		variable en = 1
		do
			string exists_search = "w_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(en)
			if(exists(exists_search) == 1) 
					string w_dup = "w_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(en)
					Duplicate/O $w_dup w_sum
					Duplicate/O $w_dup w_avg 
					w_sum[0,] = 0
					variable denomination = v_ns
					variable n = 1
					do
						string s_incri = "w_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(n)
						if (exists(s_incri) == 1)
							wave incrimental = $("w_"+Num2str(v_e)+"_"+Num2str(m)+"_"+Num2str(n))
							w_sum = w_sum + incrimental 
							n=n+1
						else
							denomination = denomination - 1
							n=n+1
						endif
					while(n<=v_ns)
					w_avg = w_sum/denomination
					string w_avg_num = "w_avg_"+Num2str(v_e)+"_"+Num2str(m)
					Duplicate/O w_avg $w_avg_num
//					Display $w_avg_num
					Killwaves w_avg
					Killwaves w_sum
					string table = "t_"+Num2str(v_e)+"_"+ Num2str(m)
					AppendToTable/W = $table $w_avg_num
					en = v_ns + 1
			else
				en = en + 1
			endif
		while(en<=v_ns)
		m = m + 1
	while(m<=v_nc)
end

Function t_CV(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Wave dw = $tWave0
	Variable cv
	Wavestats/Q/R=(xcsr(A), xcsr(B)) dw
	cv = abs(V_sdev/V_avg)
	print "CV = "+" ", cv
	If(Wintype(tWin) == 5)
		Notebook $tWin text = "CV = "+" "+ Num2str(cv) + "\r"
	endif
end

Function t_elimination_average(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	do
		If(Exists("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)) != 0)
			Wave dw = $("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n))
			String nw = "W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(100 + n)
			duplicate/O dw $(nw)
			wave pw = $(nw)
			If(Exists("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n+1)) != 0)
				Wave sw = $("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n+1))
				pw = (dw + sw)/2
			else
				pw = dw
			endif
		else
			String nw2 = "W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(100 + n)
			Wave sw = $("W_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n+1))
			duplicate/O sw $(nw2)
		endif
		n = n + 2
	while(n<=v_ns)
end

Function t_elimination_average3(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	do
		Variable n1 = 0
		Variable n2 = 0
		Variable n3 = 0
		Variable n4 = 0
		String s1 = "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n)
		String s2 = "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n+1)
		String s3 = "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(n+2)
		String nw =  "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(100 + n)
		If(Exists(s1) == 1)
			n1 = 1
		endif
		If(Exists(s2) == 1)
			n2 = 3
		endif
		If(Exists(s3) == 1)
			n3 = 5
		endif
		n4 = n1 + n2 + n3
		switch(n4)
			case 1:
				print 1
				Wave w1 = $s1
				duplicate/o w1, $nw
				Wave pw = $nw
				pw = w1
				break
			case 3:
				Wave w2 = $s2
				duplicate/o w2, $nw
				Wave pw = $nw
				pw = w2
				break
			case 5:
				Wave w3 = $s3
				duplicate/o w3, $nw
				Wave pw = $nw
				pw = w3
				break
			case 4:
				Wave w1 = $s1
				Wave w2 = $s2
				duplicate/o w1, $nw
				Wave pw = $nw
				pw = (w1 + w2)/2
				break
			case 6:
				Wave w1 = $s1
				Wave w3 = $s3
				duplicate/o w1, $nw
				Wave pw = $nw
				pw = (w1 + w3)/2
				break
			case 8:
				Wave w2 = $s2
				Wave w3 = $s3
				duplicate/o w2, $nw
				Wave pw = $nw
				pw = (w2 + w3)/2
				break
			case 9:
				print 9
				Wave w1 = $s1
				Wave w2 = $s2
				Wave w3 = $s3
				duplicate/o w1, $nw
				Wave pw = $nw
				pw = (w1 + w2 + w3)/3
				break
			default:
				break
		endswitch
		n = n + 3
	while(n<=v_ns)
end

Function t_DisplaySilentSynapse(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_ns - v_nis + 1
	Variable m = v_nis
	Variable i = 1
	Variable rmin
	Variable rmax
	Prompt rmin, "Enter leftaxis min"
	Prompt rmax, "Enter leftaxis max"
	DoPrompt "Decision of Range", rmin, rmax
	String axisname
	display
	for(i = 1; i<=n; i +=1)
		Wave ow = $"w_" + Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(m)
		axisname = "l" + Num2str(i)
		AppendToGraph/L=$axisname/B = bottom ow
		ModifyGraph axisEnab($axisname) = {(1-(i/n))+0.01,(1-(i/n)+(1/n))-0.01}, freePos($axisname) = 0
		SetAxis $axisname rmin, rmax
		m += 1
	endfor
	ModifyGraph margin(left)=50
end

Function t_Euclidean_combinations(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	
	Wave/C srcW = $tWave0
	Variable npnts = ((Dimsize(srcW, 0)^2 - Dimsize(srcW, 0))/2)
	String StrDestWave
	Prompt StrDestWave "Specify destWave! Default: EuclideanDistances"
	DoPrompt "Name of Destination Wave", StrDestWave
	If(v_flag)
		Abort
	endif

	If(Strlen(StrDestWave) == 0)
		StrDestWave = "EuclideanDistances" 
	endif
	
	If(Exists(StrDestWave))
		StrDestWave += "0"
	endif

	Make/n = (npnts) $StrDestWave

	Wave destW = $StrDestWave
	Variable Ax, Ay, Az, Bx, By, Bz, d, i, j, k
	k = 0
	For(i = 0; i < Dimsize(srcW, 0); i += 1)
		Ax = srcW[i][0]
		Ay = srcW[i][1]
		Az = srcW[i][2]
		
		For(j = i; j < Dimsize(srcW, 0); j += 1)
			If(j == i)
				continue
			else
				Bx = srcW[j][0]
				By = srcW[j][1]
				Bz = srcW[j][2]
				d = t_3dim_euclidean_distance(Ax, Ay, Az, Bx, By, Bz)
			endIF
			destW[k] = d
			k += 1
		endFor
	endFor
	
	tWave0 = StrDestWave
	Edit destW
end

Function t_3dim_euclidean_distance(Ax, Ay, Az, Bx, By, Bz)
	Variable Ax, Ay, Az, Bx, By, Bz
	
	Variable distance
	distance = sqrt((Ax-Bx)^2+(Ay-By)^2+(Az-Bz)^2)
	return distance
end

Function t_FindBaryCenter(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	tWave0 = "xyzTriplet0"					//temp
	SVAR tWin = root:Packages:YT:tWin
	tWin = "Graph0"							//temp
	
	Wave/C srcW = $tWave0
	Variable npnts = (Dimsize(srcW, 0))
	String StrDestWave
	Prompt StrDestWave "Specify destWave! Default: W_BaryCenter"
	DoPrompt "Name of Destination Wave", StrDestWave
	If(v_flag)
		Abort
	endif
	
	If(Strlen(StrDestWave) == 0)
		StrDestWave = "W_BaryCenter" 
	endif
	
	If(Exists(StrDestWave))
		StrDestWave += "0"
	endif
	
	GetMarquee/W=$tWin bottom, left
	
	Variable i = 0, baryX = 0, baryY = 0, baryZ = 0, k = 0
	do
		If((V_left < srcW[i][0]) && (srcW[i][0] < V_right) && (V_bottom < srcW[i][1]) && (srcW[i][1] < V_top))
			baryX += srcW[i][0]
			baryY += srcW[i][1]
			baryZ += srcW[i][2]
			k += 1
		endIf
		i += 1
	while(i < npnts)
	
	baryX /= k
	baryY /= k
	baryZ /= k
	
	Duplicate/O srcW, $StrDestWave
	Wave/C destWave = $StrDestWave
	Redimension/N= (1, 3) $StrDestWave
	destWave[0][0] = baryX
	destWave[0][1] = baryY
	destWave[0][2] = baryZ
	
	tWave0 = StrDestWave
	AppendToGraph/W=$tWin destWave[][%YW] vs destWave[][%XW]
	ModifyGraph/W=$tWin mode=3,rgb($StrDestWave)=(0,0,65280)
end

Function t_BranchingNodeDistances(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0	//branching nodes, Triplet
	tWave0 = "Branches"						//temp
	SVAR tWL = root:Packages:YT:tWL			//Barycenters
	
	Wave/C srcW = $tWave0
	Variable npnts = (Dimsize(srcW, 0))
	String StrDestWave
	Prompt StrDestWave "Specify destWave! Default: Branch_Distances"
	DoPrompt "Name of Destination Wave", StrDestWave
	If(v_flag)
		Abort
	endif
	
	If(Strlen(StrDestWave) == 0)
		StrDestWave = "Branch_Distances" 
	endif
	
	If(Exists(StrDestWave))
		StrDestWave += "0"
	endif
	
	Make/n = (npnts) $StrDestWave
	Wave destWave =$StrDestWave
	
	Variable Ax, Ay, Az, Bx, By, Bz = 0
	Variable i = 0
	do
		Variable j = 0
		Variable tempDistance0, tempDistance1 = 0
		Ax = srcW[i][0]
		Ay = srcW[i][1]
		Az = srcW[i][2]
		do
			String SFL = StringFromList(j, tWL)
			If(Strlen(SFL) == 0)
				break
			endif
			Wave srcBaryCenter = $SFL
			Bx = srcBaryCenter[0][0]
			By = srcBaryCenter[0][1]
			Bz = srcBaryCenter[0][2]
			If(j)
				tempDistance1 = t_3dim_euclidean_distance(Ax, Ay, Az, Bx, By, Bz)
				If(tempDistance1 < tempDistance0)
					tempDistance0 = tempDistance1
				endif
			else
				tempDistance0 = t_3dim_euclidean_distance(Ax, Ay, Az, Bx, By, Bz)
			endif
			j += 1
		while(1)
		destWave[i] = tempDistance0
		i += 1
	while(i < npnts)
	
	tWave0 = StrDestWave
	edit $tWave0
end

Function t_WaveStats_targetWave(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	String swt
	Prompt swt "Select Range.", popup "Whole Range;Cursors;Marquee;"
	DoPrompt "target Wave. Range." swt
	If(V_flag)
		Abort
	endif
	Print tWave0
	StrSwitch (swt)
		case "Whole Range":
			WaveStats $tWave0
			 break
		case "Cursors":
			WaveStats/R=(xcsr(A), xcsr(B)) $tWave0
			break
		case "Marquee":
			GetMarquee bottom
			WaveStats/R=(V_left, V_right) $tWave0
			break
		default:
			break
	endswitch
	
	If(WinType(tWin))
		DoWindow/F $tWin
	endIf
End

Function t_Histgram(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Variable Num_Bins, Bin_Start, Bin_Width
	String srcWave_name, Cumulate
	Prompt srcWave_name "Select_targetWave", popup "default(" + tWave0 +");" + wavelist("*",";", "")
	Prompt Num_Bins "Number of Bins (integer)"
	Prompt Bin_Start "Bin Start"
	Prompt Bin_Width "Bin Width"
	Prompt Cumulate "Cumulate?", popup "yes;no;"
	DoPrompt "Define Each Param."srcWave_name, Num_Bins, Bin_Start, Bin_Width, Cumulate
	If(V_flag)
		Abort
	endif
	If(StringMatch(srcWave_name, "default("+tWave0+")"))
		srcWave_name = tWave0
	endif
	Make/N=(Num_Bins)/O $("Hist_" + srcWave_name)
	Histogram/B={Bin_Start, Bin_Width, Num_Bins} $srcWave_name, $("Hist_" + srcWave_name)
	If(WinType(tWin) == 2)
		AppendToTable/W = $tWin $("Hist_" + srcWave_name)
	endif
	
	If(StringMatch(Cumulate, "yes"))
		t_Cumulative_Probability_Func("Hist_" + srcWave_name, "yes")
	endif
	
	tWave0 = "Cum_Pro_" + srcWave_name
End

Function t_Cumulative_Probability_Func(NameOfHistWave, ZeroPoint)
	String NameOfHistWave, ZeroPoint
	SVAR tWin = root:Packages:YT:tWin
	String Hist_name, Cum_name, Cum_Pro_name
	String PlusOne
	Hist_name = NameOfHistWave
	PlusOne = ZeroPoint
	Cum_name = ReplaceString("Hist", Hist_name, "Cum")
	Cum_Pro_name = ReplaceString("Hist", Hist_name, "Cum_Pro")
	Duplicate/O $Hist_name, $Cum_name, $Cum_Pro_name
	Wave Hist = $Hist_name
	Wave Cum = $Cum_name
	Wave Cum_Pro = $Cum_Pro_name
	Wavestats/Q Cum
	Variable npt = V_npnts + V_numNaNs + V_numINFs
//	Print npt
	Variable n = 1
	Cum[0] = Hist[0]
	do
		Switch (numtype(Hist[n]))
			case 0:
				Cum[n,] = Cum[n-1] + Hist[n]
				break;
			case 1:
				Cum[n,] = Cum[n-1]
				break;
			case 2:
				Cum[n,] = Cum[n-1]
				break;
			default:
				break;
		endSwitch
		n += 1
	while(n<=npt)
	Cum_Pro[p,] = Cum[p]/Cum[npt]
	If(StringMatch(PlusOne, "yes") == 1)
		InsertPoints 0,1, Cum
		Cum[0] = 0
		InsertPoints 0,1, Cum_Pro
		Cum_Pro[0] = 0
	endIf
	If(WinType(tWin) == 2)
		AppendToTable/W = $tWin Cum, Cum_Pro
	endif
End

Function t_Cumulative_Probability(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	DoAlert 1, "tWin must be a Table which contains Histogram wave. OK?"
	If(V_flag == 2)
		Abort
	endif
	String Hist_name, Cum_name, Cum_Pro_name
	String PlusOne
	Prompt Hist_name "Select Hist Wave", popup wavelist("*", ";", "WIN:" + tWin)
	Prompt PlusOne "Insert Zero Point?", popup "Yes;No;"
	DoPrompt "Define.", Hist_name, PlusOne
	If(V_flag)
		Abort
	endif
	Cum_name = ReplaceString("Hist", Hist_name, "Cum")
	Cum_Pro_name = ReplaceString("Hist", Hist_name, "Cum_Pro")
	Duplicate/O $Hist_name, $Cum_name, $Cum_Pro_name
	Wave Hist = $Hist_name
	Wave Cum = $Cum_name
	Wave Cum_Pro = $Cum_Pro_name
	Wavestats/Q Cum
	Variable npt = V_npnts + V_numNaNs + V_numINFs
	Print npt
	Variable n = 1
	Cum[0] = Hist[0]
	do
		Switch (numtype(Hist[n]))
			case 0:
				Cum[n,] = Cum[n-1] + Hist[n]
				break;
			case 1:
				Cum[n,] = Cum[n-1]
				break;
			case 2:
				Cum[n,] = Cum[n-1]
				break;
			default:
				break;
		endSwitch
		n += 1
	while(n<=npt)
	Cum_Pro[p,] = Cum[p]/Cum[npt]
	If(StringMatch(PlusOne, "Yes") == 1)
		InsertPoints 0,1, Cum
		Cum[0] = 0
		InsertPoints 0,1, Cum_Pro
		Cum_Pro[0] = 0
	endIf
	If(WinType(tWin) == 2)
		AppendToTable/W = $tWin Cum, Cum_Pro
	endif
End

Function t_Integrate1DWave(ctrlName) : ButtonControl
	String ctrlName
	Variable xmin, xmax
	Prompt xmin, "xmin?"
	Prompt xmax, "xmax?"
	DoPrompt "Define range of integrated wave (tWave0)." xmin, xmax
	If(V_flag)
		Abort
	endif
	Print Integrate1d(t_Integrate1DWave_UserFunc0, xmin, xmax)
	return 0
end

Function t_Integrate1DWave_UserFunc0(inX)
	Variable inX
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave SrcWave = $tWave0
	
	return SrcWave(inX)
end

Function t_Integrate2DWave(ctrlName) : ButtonControl
	String ctrlName
	Variable xmin, xmax, ymin, ymax
	Prompt xmin, "xmin?"
	Prompt xmax, "xmax?"
	Prompt ymin, "ymin?"
	Prompt ymax, "ymax?"
	DoPrompt "Define range of integrated wave (tWave0)." xmin, xmax, ymin, ymax
	If(V_flag)
		Abort
	endif
	
	Variable/G root:Packages:YT:gxmin2d = xmin
	Variable/G root:Packages:YT:gxmax2d = xmax
	Variable/G root:Packages:YT:gY2d
	
	Variable ret = integrate1D(t_Integrate2DWave_UserFunc1, ymin, ymax)
	Print ret
	return ret
end

Function t_Integrate2DWave_UserFunc0(inX)
	Variable inX
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave SrcWave = $tWave0
	
	NVAR gY2d = root:Packages:YT:gY2d
	
	return SrcWave(inX)(gY2d)
end

Function t_Integrate2DWave_UserFunc1(inY)
	Variable inY
	
	NVAR gY2d = root:Packages:YT:gY2d
	gY2d = inY
	NVAR gxmin2d = root:Packages:YT:gxmin2d
	NVAR gxmax2d = root:Packages:YT:gxmax2d
	
	return integrate1D (t_Integrate2DWave_UserFunc0, gxmin2d, gxmax2d)
end

Function t_Triming2dwave(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Variable thresx, thresy
	Prompt thresx, "thresx?"
	Prompt thresy, "thresy?"
	DoPrompt "Define coordinate for the threshold (tWave0)." thresx, thresy
	If(V_flag)
		Abort
	endif
	Duplicate/O $tWave0, trimed2dwave
	Wave dw = trimed2dwave
	Variable threshold = dw(thresx)(thresy)
	Print "threshold = ", threshold
	Variable numpntsx = DimSize(trimed2dwave, 0)
	Variable numpntsy = DimSize(trimed2dwave, 1)
	Variable i, j
	for(i = 0; i<numpntsx; i+=1)
		for(j = 0; j<numpntsy; j+=1)
			If(trimed2dwave[i][j] < threshold)
				trimed2dwave[i][j] = 0
			endif
		endfor
	endfor

//	NewImage trimed2dwave
	tWave0 = "trimed2dwave"
end

Function t_Integrate2DWave2(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
//	Variable xmin, xmax, ymin, ymax
//	Prompt xmin, "xmin?"
//	Prompt xmax, "xmax?"
//	Prompt ymin, "ymin?"
//	Prompt ymax, "ymax?"
//	DoPrompt "Define range of integrated wave (tWave0)." xmin, xmax, ymin, ymax
//	If(V_flag)
//		Abort
//	endif
	Variable numpntsx = DimSize($tWave0, 0)
	Variable numpntsy = DimSize($tWave0, 1)
	Variable dx = DimDelta($tWave0, 0)
	Variable dy = DimDelta($tWave0, 1)
	Variable offx = DimOffset($tWave0, 0)
	Variable offy = DimOffset($tWave0, 1)
//	print numpntsx, numpntsy, dx, dy, offx, offy
	If(Exists("tempwave0"))
		Redimension/n=(numpntsy) tempwave0
//		print 1
	else
		Make/n=(numpntsy) tempwave0
//		print 2
	endif
	SetScale/P x offy, dy,"", tempwave0

	If(Exists("tempwave1"))
		Redimension/n=(numpntsx) tempwave1
//		print 3
	else
		Make/n=(numpntsx) tempwave1
//		print 4
	endif
	SetScale/P x offx, dx,"", tempwave1
	
	Variable i, j = 0
	Wave srcW = $tWave0
	For(i = 0; i<numpntsx; i+=1)
		tempwave0[] = srcW[i][p]
		tempwave1[i] = area(tempwave0)
	endfor
//	Killwaves tempwave0, tempwave1
	Print area(tempwave1)
	return area(tempwave1)
end

Function t_gaussian1d(x, a, d, u)
	Variable x, a, d, u
	return exp(-(x-u)^2/(2*d^2))*a/(sqrt(2*pi)*d)
end

Function t_m_d_1d_gaussian(ctrlName, strwavename, n) : ButtonControl
	String ctrlName
	String strwavename
	Variable n
	If(exists(strwavename))
		Redimension/n=(n) $strwavename
	else
		Make/n=(n) $strwavename
	Endif
	SetScale/I x, -5, 5, "", $strwavename
	Wave dw = $strwavename
	dw = t_gaussian1d(x, 1, 1.5, 0)//(x, a, d, u)
	Display $strwavename
end

Function t_gaussian2d(x, y, a, dx, dy, cor, ux, uy)
	Variable x, y, a, dx, dy, cor, ux, uy
	return exp(-((x-ux)^2/dx^2 + (y-uy)^2/dy^2 - 2*cor*(x-ux)*(y-uy)/(dx*dy))/(2*(1-cor)))*a/(2*pi*dx*dy*sqrt(1-cor^2))
end

Function t_m_d_2d_gaussian(ctrlName, strwavename, n) : ButtonControl
	String ctrlName
	String strwavename
	Variable n
	If(exists(strwavename))
		Redimension/n=(n, n) $strwavename
	else
		Make/n=(n, n) $strwavename
	Endif
	SetScale/I x, -5, 5, "", $strwavename
	SetScale/I y, -5, 5, "", $strwavename
	Wave dw = $strwavename
	dw = t_gaussian2d(x, y, 1, 1, 1, 0.5, 0, 0)//(x, y, a, dx, dy, cor, ux, uy)
	NewImage $strwavename
end

Function t_CDF_01(ctrlName) : ButtonControl
	String ctrlName
	Variable xmin, xmax, dx, ymin, ymax
	Prompt xmin, "xmin?"
	Prompt xmax, "xmax?"
	Prompt dx, "deltax?"
	Prompt ymin, "ymin?"
	Prompt ymax, "ymax?"
	DoPrompt "Define range of integrated wave (tWave0)." xmin, xmax, dx ymin, ymax
	If(V_flag)
		Abort
	endif
	SVAR tWave1 = root:Packages:YT:tWave1
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave sw = $tWave1
	Wave dw = $tWave0

	Variable i = 0
	Variable npt = numpnts(dw)
	
	Variable/G root:Packages:YT:gxmin2d = xmin
	Variable/G root:Packages:YT:gxmax2d = xmax
	Variable/G root:Packages:YT:gY2d
	
	NVAR gxmax2d = root:Packages:YT:gxmax2d
	gxmax2d = xmin	
		
	do
		
		dw[i] = integrate1D(t_Integrate2DWave_UserFunc3, ymin, ymax)
		gxmax2d += dx
		i += 1
	while(i<npt)
end

Function t_Integrate2DWave_UserFunc2(inX)
	Variable inX
	SVAR tWave1 = root:Packages:YT:tWave1
	Wave SrcWave = $tWave1
	
	NVAR gY2d = root:Packages:YT:gY2d
	
	return SrcWave(inX)(gY2d)
end

Function t_Integrate2DWave_UserFunc3(inY)
	Variable inY
	
	NVAR gY2d = root:Packages:YT:gY2d
	gY2d = inY
	NVAR gxmin2d = root:Packages:YT:gxmin2d
	NVAR gxmax2d = root:Packages:YT:gxmax2d
	
	return integrate1D (t_Integrate2DWave_UserFunc2, gxmin2d, gxmax2d)
end

Function t_CDF2D_sum(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0 //
	Wave sw = $tWave0
	String sdw
	Prompt sdw, "Name of destWave (CDF) ?"
	DoPrompt "Define" sdw
	If(V_flag)
		Abort
	endif
	tWave0 = sdw
	Duplicate/O sw, $sdw
	Redimension/N=-1 $sdw
	Wave dw = $sdw
	Variable i, n, npts, int = 0
	npts = numpnts(dw)
	do
		n=0
		int = 0
		do
			int += sw[i][n]
			n += 1
		while(n<npts)
		
		If(i == 0)
			dw[i] = int
		else
			dw[i] = dw[i-1] + int
		endif
		i += 1
	while(i<npts)
	dw /= dw[i]
End

Function t_CorrelationTest(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1

	Wave srcWave0 = $tWave0
	Wave srcWave1 = $tWave1
	
	Variable PearsonsR = StatsCorrelation(srcWave0, srcWave1)
	
	Printf "Pearsons r = %f\r", PearsonsR
	
	StatsLinearCorrelationTest srcWave0, srcWave1
	StatsRankCorrelationTest srcWave0, srcWave1
	StatsCircularCorrelationTest/NAA srcWave0, srcWave1
End

Function t_StimDeltaRatio(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 =  root:Packages:YT:tWave0

	Wave srcW = $tWave0
	
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		WaveStats/Q/R=[0, 18] srcW
	else
		WaveStats/Q/R=[pcsr(A), pcsr(B)] srcW
	endif

	String StrDestW = tWave0 + "_R"
	Duplicate/O srcW, $StrDestW
	Wave destW = $StrDestW
	destW /= V_avg 
	destW *= 100
	Display destW
End

//end of Analysis tab
/////////////////////////////////////////////////////////////////////
//Current Clamp spike analysis

Function t_jwSpikeTable(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tjw = root:Packages:YT:tjw
	String CtWave
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			break
		case 1:
			CtWave = tjw
			break
		default:
			break
	endswitch
	String jst = "st_"+ CtWave
	String sn = "SpikeNum_" + CtWave
	String vpl = "VPL_"+ CtWave
	String vpv = "VPV_"+ CtWave
	String aptl = "APTL_" + CtWave
	String aptv = "APTV_" + CtWave
	String amp = "AMP_" + CtWave
	String adpa = "ADPA_"+ CtWave
	String rt = "RT_" + CtWave
	String osl = "ONSETL_" + CtWave
	String osv = "ONSETV_" + CtWave
	String hw = "HalfW_" + CtWave
	edit/N=$jst
	make/O $sn, $vpl, $vpv, $aptl, $aptv, $amp, $adpa, $rt, $osl, $osv, $hw
	AppendToTable/W=$jst $sn, $vpl, $vpv, $aptl, $aptv, $amp, $adpa, $rt, $osl, $osv, $hw
	wave t = $sn
	t = x + 1
end

Function t_skips(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	Wave dw =$sdw
	DoWindow/F $CtWin
//	String sn = "SpikeNum_" + CtWave
//	wave wsn = $sn
	if(strlen(csrInfo(A)) == 0)
		cursor A $sdw leftx(dw)
		cursor B $sdw leftx(dw)+1e-3
	else
		cursor A $sdw xcsr(A) + 0.5e-3
		cursor B $sdw xcsr(B) + 0.5e-3
	endif
	variable x1, x2, x3, y1, y2, y3
	do
		FindPeak/Q/M=-10e-3/R=(xcsr(A), xcsr(B)) dw
		x1 = V_PeakLoc
		y1 = V_PeakVal
		FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.25e-3, xcsr(B)+0.25e-3) dw
		x2 = V_PeakLoc
		y2 = V_PeakVal
		FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.5e-3, xcsr(B)+0.5e-3) dw
		x3 = V_PeakLoc
		y3 = V_PeakVal
		cursor A $sdw xcsr(A) + 0.25e-3
		cursor B $sdw xcsr(B) + 0.25e-3
	while((x1 != x2 || x1 != x3 || V_flag != 0) && xcsr(A) + 1e-3 <= rightx(dw))
	print "V_PeakLoc=", V_PeakLoc, "V_PeakVal=", V_PeakVal, "V_frag =", V_flag
end

Function t_cc_delete(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	Wave dw =$sdw
	String sn = "SpikeNum_" + CtWave
	String vpl = "VPL_"+ CtWave
	String vpv = "VPV_"+ CtWave
	String aptl = "APTL_" + CtWave
	String aptv = "APTV_" + CtWave
	String amp = "AMP_" + CtWave
	String adpa = "ADPA_"+ CtWave
	String rt = "RT_" + CtWave
	String osl = "ONSETL_" + CtWave
	String osv = "ONSETV_" + CtWave
	String hw = "HalfW_" + CtWave
	String temp = "SN_"+ CtWave
	NVAR sntemp = root:$temp
	if(sntemp > 0)
		sntemp = sntemp - 1
		endif
	print "SpikeNum =", sntemp
	Redimension/N=(sntemp) $sn, $vpl, $vpv, $aptl, $aptv, $amp, $adpa, $rt, $osl, $osv, $hw
end

Function t_find_fspike(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			Wave dw =$sdw
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			Wave dw = root:Packages:YT:jw
			break
		default:
			break
	endswitch

	String jst = "st_"+ CtWave
	String sn = "SpikeNum_" + CtWave
	String vpl = "VPL_"+ CtWave
	String vpv = "VPV_" + CtWave
	String aptl = "APTL_" + CtWave
	String aptv = "APTV_" + CtWave
	String amp = "AMP_" + CtWave
	String adpa = "ADPA_" + CtWave
	String rt = "RT_" + CtWave
	String osl = "ONSETL_" + CtWave
	String osv = "ONSETV_" + CtWave
	String hw = "HalfW_" + CtWave
	DoWindow/F $CtWin
	if(stringmatch(ctrlName, "Btffs_tab13"))
		cursor A $sdw leftx(dw)
		cursor B $sdw leftx(dw)+1e-3
		variable x1, x2, x3, y1, y2, y3
		do
			FindPeak/Q/M=-10e-3/R=(xcsr(A), xcsr(B)) dw
			x1 = V_PeakLoc
			y1 = V_PeakVal
			FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.25e-3, xcsr(B)+0.25e-3) dw
			x2 = V_PeakLoc
			y2 = V_PeakVal
			FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.5e-3, xcsr(B)+0.5e-3) dw
			x3 = V_PeakLoc
			y3 = V_PeakVal
			cursor A $sdw xcsr(A) + 0.25e-3
			cursor B $sdw xcsr(B) + 0.25e-3
		while((x1 != x2 || x1 != x3 || V_flag != 0) && xcsr(A) + 1e-3 <= rightx(dw))
		print "V_PeakLoc=", V_PeakLoc, "V_PeakVal=", V_PeakVal, "V_frag =", V_flag
	endif
	
	String temp = "SN_"+CtWave
	if(xcsr(A)+1e-3 >= rightx(dw))
		print "end"
		Variable/g $temp = 0
	else
		Variable/g $temp = 1
	endif
	Variable n = 1
	Redimension/N=(n) $sn, $vpl, $vpv, $aptl, $aptv, $amp, $adpa, $rt, $osl, $osv, $hw
	wave w_vpl = $vpl
	wave w_vpv = $vpv
	NVAR snum = root:$temp
	if(snum !=0)
		if(stringmatch(ctrlName, "Btffs_tab13"))
			w_vpl[0] = V_PeakLoc
			w_vpv[0] = V_PeakVal
		else
			w_vpl[0] = xcsr(A)
			w_vpv[0] = vcsr(A)
		endif
	else
		w_vpl[0] = 0
		w_vpv[0] = 0
	endif
end

Function t_find_sspikes(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			Wave dw =$sdw
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			Wave dw = root:Packages:YT:jw
			break
		default:
			break
	endswitch

	variable x1, x2, x3, y1, y2, y3
	String jst = "st_"+ CtWave
	String sn = "SpikeNum_" + CtWave
	String vpl = "VPL_"+ CtWave
	String vpv = "VPV_" + CtWave
	String aptl = "APTL_" + CtWave
	String aptv = "APTV_" + CtWave
	String amp = "AMP_" + CtWave
	String adpa = "ADPA_" + CtWave
	String rt = "RT_" + CtWave
	String osl = "ONSETL_" + CtWave
	String osv = "ONSETV_" + CtWave
	String hw = "HalfW_" + CtWave
	String temp = "SN_"+ CtWave
	Dowindow/F $CtWin
	if(stringmatch(ctrlName, "Btsss_tab13"))
		cursor A $sdw xcsr(A) + 0.5e-3
		cursor B $sdw xcsr(B) + 0.5e-3
		do
			FindPeak/Q/M=-10e-3/R=(xcsr(A), xcsr(B)) dw
			x1 = V_PeakLoc
			y1 = V_PeakVal
			FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.25e-3, xcsr(B)+0.25e-3) dw
			x2 = V_PeakLoc
			y2 = V_PeakVal
			FindPeak/Q/M=-10e-3/R=(xcsr(A)+0.5e-3, xcsr(B)+0.5e-3) dw
			x3 = V_PeakLoc
			y3 = V_PeakVal
			cursor A $sdw xcsr(A) + 0.25e-3
			cursor B $sdw xcsr(B) + 0.25e-3
		while((x1 != x2 || x1 != x3 || V_flag != 0) && xcsr(A) + 1e-3 <= rightx(dw))
	endif
	
	if(xcsr(A)+1e-3 >= rightx(dw))
		print "end"
	else
		NVAR sntemp = root:$temp
		sntemp = sntemp + 1
		print "SN=", sntemp
		Redimension/N=(sntemp) $sn, $vpl, $vpv, $aptl, $aptv, $adpa, $amp, $rt, $osl, $osv, $hw
		wave w_sn = $sn
		wave w_vpl = $vpl
		wave w_vpv = $vpv
		w_sn[sntemp-1] = sntemp
		if(stringmatch(ctrlName, "Btsss_tab13"))
			print "V_PeakLoc=", V_PeakLoc, "V_PeakVal=", V_PeakVal, "V_frag =", V_flag
			w_vpl[sntemp-1] = V_PeakLoc
			w_vpv[sntemp-1] = V_PeakVal
		else
			w_vpl[sntemp-1] = xcsr(A)
			w_vpv[sntemp-1] = vcsr(A)
		endif
	endif
end

Function t_ends(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			Wave dw = $sdw
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			Wave dw = root:Packages:YT:jw
			break
		default:
			break
	endswitch
	print "end!"
	Cursor/K/W=$CtWin A
	Cursor/K/W=$CtWin B
end

Function t_find_each_param(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	NVAR slope = root:Packages:YT:cc_slope
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			Wave dw = $sdw
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			Wave dw = root:Packages:YT:jw
			break
		default:
			break
	endswitch
	String vpl = "VPL_"+ CtWave
	String vpv = "VPV_" + CtWave
	String aptl = "APTL_" + CtWave
	String aptv = "APTV_" + CtWave
	String amp = "AMP_" + CtWave
	String adpa = "ADPA_" + CtWave
	String rt = "RT_" + CtWave
	String osl = "ONSETL_" + CtWave
	String osv = "ONSETV_" + CtWave
	String hw = "HalfW_" + CtWave
	String temp = "SN_"+ CtWave
	Wave w_vpl = $vpl
	Wave w_vpv = $vpv
	Wave w_aptl = $aptl
	Wave w_aptv = $aptv
	Wave w_amp = $amp
	Wave w_adpa = $adpa
	Wave w_rt = $rt
	Wave w_osl = $osl
	Wave w_osv = $osv
	Wave w_hw = $hw
	NVAR sn = root:$temp
	DoWindow/F $CtWin
	variable n = 0
	if(sn !=0)
		do
			Cursor A $sdw w_vpl[n]-0.25e-3
			do
				variable avg_slope
				avg_slope = (dw(xcsr(A)+deltax(dw)*3)-dw(xcsr(A)-deltax(dw)*3))/(deltax(dw)*6)
				Cursor A $sdw xcsr(A)-deltax(dw)*2
			while(avg_slope>=slope)
			print avg_slope, xcsr(A), n
			w_aptl[n] = xcsr(A)
			w_aptv[n] = dw(xcsr(A))
			w_amp[n] = w_vpv[n]-w_aptv[n]
			w_adpa[n] = w_amp[n]/w_amp[0]
			Cursor B $sdw xcsr(A)
			do
				Cursor B $sdw xcsr(B) + deltax(dw)
			while(vcsr(B)<w_aptv[n]+(0.01*w_amp[n]))
			w_osl[n] = xcsr(B)
			w_osv[n] = dw(xcsr(B))
			do
				Cursor A $sdw xcsr(A) + deltax(dw)
			while(vcsr(A)<w_aptv[n]+(0.2*w_amp[n]))
			do
				Cursor B $sdw xcsr(B) + deltax(dw)
			while(vcsr(B)<w_aptv[n]+(0.8*w_amp[n]))
			w_rt[n] = xcsr(B) - xcsr(A)
			do
				Cursor A $sdw xcsr(A) + deltax(dw)
			while(vcsr(A) < w_aptv[n]+(0.5*w_amp[n]))
			Cursor B $sdw w_vpl[n]
			do
				Cursor B $sdw xcsr(B) + deltax(dw)
			while(vcsr(B) > w_vpv[n] - (0.5*w_amp[n]))
			w_hw[n] =  xcsr(B) - xcsr(A)	
			n = n + 1
		while(n<=sn-1)
	else
		w_vpl[0] = 0
		w_vpv[0] = 0
		w_aptl[0] = 0
		w_aptv[0] = 0
		w_amp[0] = 0
		w_adpa[0] = 0
		w_rt[0] = 0
		w_osl[0] = 0
		w_osv[0] = 0
		w_hw[0] = 0
	endif
end

Function t_KillCsr(ctrlName) : ButtonControl
	String ctrlName
	
	String CtWin
	SVAR tWin = root:Packages:YT:tWin
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWin = tWin
			break
		case 1:
			CtWin = "graph_jw"
			break
		default:
			break
	endswitch
	Cursor/K/W=$CtWin A
	Cursor/K/W=$CtWin B	
end

Function t_spiketable(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	edit/N=SpikeSum
	edit/N=ArateISI
	make/O InjC, SpikeNum, SpikeIndex
	AppendToTable/W=SpikeSum InjC, SpikeNum
	AppendToTable/W=ArateISI SpikeIndex
	do
		String temp = "Arate_" + Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(n)
		make/O $temp
		AppendToTable/W=ArateISI $temp
		n = n + 1
	while(n<=v_ns)
	InjC = -150e-12 + 50e-12*x
	SpikeIndex = x + 1
end

Function t_spikenum (ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	Variable m = 1
	Wave InjC
	Wave SpikeNum
	do
		String temp = "SN_"+ "w_"+ Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(n)
		NVAR sn = $temp
		If(Exists(temp) == 2)
			SpikeNum[m -1] = sn
		else
			SpikeNum[m-1] = 0
		endif
		m = m + 1
		n = n + 1
	while(n<=v_ns)
	Redimension/N=(v_ns - v_nis + 1) SpikeNum
	Redimension/N=(v_ns - v_nis + 1) InjC
end

Function t_arate (ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	Variable m = 1
	do
		String temp = Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(n)
		Wave dw = $("Arate_" + temp)
		NVAR sn = $("SN_"+"w_"+ temp)
		m = 1
		If(Exists("SN_"+"w_"+ temp) == 2)
			do
				Wave w_vpl = $("VPL_"+"w_" +temp)
	
				If(sn>=3)
					dw[0,1] = 1
					dw[m-1] = (w_vpl[m-1] - w_vpl[m-2])/(w_vpl[1]-w_vpl[0])
				else
					dw[0,] = 1
				endif
				If(sn > 0)
					Redimension/N = (sn) dw
				else
					Redimension/N = 1 dw
				endif
				m = m + 1
			while(m<=sn)
		else
			dw[0] = 1
			Redimension/N = 1 dw
		endif
		n = n + 1
	while(n<=v_ns)
end

Function t_arate1 (ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	NVAR cc_ns = root:Packages:YT:cc_ns
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	Variable n = cc_ns
	print n
	wave SpikeNum
	wave ARateISI
//	do
		String temp = "SN_"+CtWave
		NVAR sn = root:$temp
		String vpl = "VPL_"+CtWave
		Wave w_vpl = $vpl
		SpikeNum[n-1] = sn
		if(sn>=3)
			ARateISI[n-1] =(w_vpl[(x2pnt(w_vpl, rightx(w_vpl))-1)]-w_vpl[(x2pnt(w_vpl, rightx(w_vpl))-2)]) / (w_vpl[1]-w_vpl[0])
		else
			ARateISI[n-1] = 1
		endif
//		n=n+1
//	while(n<=cc_ns)
end

Function t_display_spike_num (ctrlName) : ButtonControl
	String ctrlName
	Wave InjC
	Wave SpikeNum
	Display SpikeNum vs InjC
	ModifyGraph mode=3,marker=8
	Label left "Number of Spikes"
	Label bottom "InjC (A)"
end

Function t_display_arate(ctrlName) : ButtonControl
	String ctrlName
	NVAR v_e = rootPack:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = v_nis
	Variable m = 1
	
	do
		String temp = Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(n)
		Wave dw = $("Arate_" + temp)
		String sntemp = "SN_w_"+temp
		NVAR sn = root:$sntemp
		String buttomaxis = "buttom_" + temp
		If(sn > 0)
			make/O/N = (sn) $buttomaxis
		else
			make/O/N = (1) $buttomaxis
		endif
		Wave sw = $buttomaxis 
		sw = m
		If(m == 1)
			Display dw vs sw
			ModifyGraph mode=3
			Label left "Adaptation Rate"
			Label bottom "Sweep Index"
		else
			AppendToGraph dw vs sw
			ModifyGraph mode($("Arate_" + temp))=3
		endif
		n = n + 1
		m = m + 1
	while (m <= v_ns)
end

Function t_Vrest(ctrlName) : ButtonControl
	String ctrlName
	String CtWave
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			break
		case 1:
			CtWave = tjw
			break
		default:
			break
	endswitch
	wave w_rest = $CtWave
	wavestats w_rest 
	Duplicate/O w_rest $("V_resting_"+CtWave)
	Wave V_resting = $("V_resting_"+CtWave)
	V_resting = V_avg
	String vr = Num2str(V_avg)
	Display w_rest
	SetAxis left -0.08,-0.04
	AppendToGraph $("V_resting_"+CtWave)
	TextBox/C/N=vrest/F=0/A=MC "V_rest ="
	TextBox/C/N=vrest/B=1
	Appendtext/N=vrest vr
	ModifyGraph lsize(V_resting)=2,rgb(V_resting)=(0,0,52224)
end

Function t_Rinput(ctrlName) : ButtonControl
	String ctrlName
	String CtWave
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			break
		case 1:
			CtWave = tjw
			break
		default:
			break
	endswitch
	wave dw =  $CtWave
	variable v1 = 1
	variable v2 = 1
	variable vavg = 1
	variable Rinput = 1
	wavestats/r= (0, 0.1) dw
	v1 = v_avg
	wavestats/r=(0.2, 0.3) dw
	v2 = v_avg
	vavg = v1-v2
	print vavg
	Rinput = vavg/50e-12
	print Rinput
	display dw
	String svr = Num2str(Rinput)
	TextBox/C/N=ri/F=0/A=MC "R_input ="
	TextBox/C/N=ri/B=1
	Appendtext/N=ri svr
end

// end of current clamp (CC) tab

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//vclamp_analysis
Function t_vcaCheckProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
//	NVAR vca_posi
//	NVAR tangent_line
//	NVAR markers
//	Strswitch (ctrlName)
//		case "Checkvca_posi_tab15":
//			vca_posi = checked
//			break
//		case "Checkvca_tl_tab15":
//			tangent_line = checked
//			break
//		case "Checkvca_markers_tab15":
//			markers = checked
//			break
//		default:
//			break
//	endswitch
End

Function t_prep_table_wave_vclamp(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tjw = root:Packages:YT:tjw
	String CtWave
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			break
		case 1:
			CtWave = tjw
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	String jvct = "vct_"+ CtWave
	String sn = "StimNum_" + CtWave
	String arti = "Arti_" + CtWave
	String artiv = "ArtiV_" + CtWave
	String pbase = "pBase_" + CtWave
	String vpl = "VcPL_"+ CtWave
	String vpv = "VcPV_"+ CtWave
	String osl = "VcOSL_" + CtWave
	String osv = "VcOSV_" + CtWave
	String base = "Vc_Base" + CtWave
	String amp = "Vc_AMP_" + CtWave
	String lat = "Latency_" + CtWave
	String rt = "Vc_RT_" + CtWave
	String decay = "Decay_" + CtWave
	String fdecay = "fDecay_" + CtWave
	String sdecay = "sDecay_" + CtWave
	String charge = "Charge_" + CtWave
	String stp = "STP_" + CtWave
//	print jvct
	SetDataFolder root:Packages:YT:
	edit/N=$jvct/W=(15, 15, 805, 165)
	DoWindow/F $jvct
	AutoPositionWindow/E/M=1/R=$tWin
	make/O $sn, $arti, $artiv, $pbase, $vpl, $vpv, $osl, $osv, $base, $amp, $lat, $rt,  $decay, $fdecay, $sdecay, $charge, $stp
	AppendToTable/W=$jvct $sn, $arti, $pbase, $vpl, $vpv, $osl, $osv, $base, $amp, $lat, $rt, $decay, $fdecay, $sdecay, $charge, $stp
	modifytable width = 45, sigDigits = 4, size = 8
	wave t = $sn
	t = x + 1
	SetDataFolder root:
	DoWindow/F ControlPanel
end

Function t_skipmisaf(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	DoWindow/F $CtWin
	Wave dw =$sdw
	if(strlen(csrInfo(A)) == 0)
		Cursor A $sdw leftx($sdw)
		Cursor B $sdw leftx($sdw)+deltax($sdw)
	else
		Cursor A $sdw xcsr(A) + 1e-3
		Cursor B $sdw xcsr(A) + deltax(dw)
	endif
	variable slope0, slope1, slope2, slope3, slope4
	do
		slope0 = (dw(xcsr(A)+4*deltax(dw))-dw(xcsr(A)))/(4*deltax(dw))
		slope1 = (dw(xcsr(B)+3*deltax(dw))-dw(xcsr(B)))/(3*deltax(dw))
		slope2 = (dw(xcsr(A)+5*deltax(dw))-dw(xcsr(A)+4*deltax(dw)))/deltax(dw)
		slope3 = (dw(xcsr(B)+5*deltax(dw))-dw(xcsr(B)+4*deltax(dw)))/deltax(dw)
		slope4 = (dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)+5*deltax(dw)))/deltax(dw)
		Cursor A $sdw xcsr(A) + deltax(dw)
		Cursor B $sdw xcsr(B) + deltax(dw)
	while((abs(slope2)<=50*abs(slope0) || abs(slope3)<=50*abs(slope1) || slope2*slope3<=0||slope3*slope4<=0||abs(dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)))<30e-12) && xcsr(A) + deltax(dw)*7 <= rightx(dw))
end

Function t_vca_delete(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	Wave dw =$sdw
	String jvct = "vct_"+ CtWave
	String sn = "StimNum_" + CtWave
	String arti = "Arti_" + CtWave
	String artiv = "ArtiV_" + CtWave
	String pbase = "pBase_" + CtWave
	String vpl = "VcPL_"+ CtWave
	String vpv = "VcPV_"+ CtWave
	String osl = "VcOSL_" + CtWave
	String osv = "VcOSV_" + CtWave
	String lat = "Latency_" + CtWave
	String base = "Vc_Base" + CtWave
	String amp = "Vc_AMP_" + CtWave
	String rt = "Vc_RT_" + CtWave
	String decay = "Decay_" + CtWave
	String fdecay = "fDecay_" + CtWave
	String sdecay = "sDecay_" + CtWave
	String charge = "Charge_" + CtWave
	String stp = "STP_" + CtWave
	String temp = "StimN_"+ CtWave
	NVAR stimntemp = root:Packages:YT:$temp
	SetDataFolder root:Packages:YT:
	if(stimntemp > 0)
		DoWindow/F $CtWin
		String tls = "tl_"+ CtWave + "_" + Num2str(stimntemp-1)
		if(strlen(WaveList(tls,";","Win:"))>7)
			RemoveFromGraph $tls
		endif
		stimntemp = stimntemp - 1
//		print "StimNum =", stimntemp
		Redimension/N=(stimntemp) $sn, $arti, $artiv, $pbase, $vpl, $vpv, $osl, $osv, $lat, $base, $amp, $rt,  $decay, $fdecay, $sdecay, $charge, $stp
	endif
	SetDataFolder root:
end

Function t_find_fstim(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String CtWaveRaw
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	NVAR tangent_line = root:Packages:YT:tangent_line
	NVAR markers = root:Packages:YT:markers
	NVAR vca_fit_charge = root:Packages:YT:vca_fit_charge
	NVAR vca_dis_f_arti = root:Packages:YT:vca_dis_f_arti
	NVAR vca_onset_var = root:Packages:YT:vca_onset_var
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	Wave dw =$sdw
	String jvct = "vct_"+ CtWave
	String sn = "StimNum_" + CtWave
	String arti = "Arti_" + CtWave
	String artiv = "ArtiV_" + CtWave
	String pbase = "pBase_" + CtWave
	String vpl = "VcPL_"+ CtWave
	String vpv = "VcPV_"+ CtWave
	String osl = "VcOSL_" + CtWave
	String osv = "VcOSV_" + CtWave
	String lat = "Latency_" + CtWave
	String base = "Vc_Base" + CtWave
	String amp = "Vc_AMP_" + CtWave
	String rt = "Vc_RT_" + CtWave
	String decay = "Decay_" + CtWave
	String fdecay = "fDecay_" + CtWave
	String sdecay = "sDecay_" + CtWave
	String charge = "Charge_" + CtWave
	String stp = "STP_" + CtWave
	String temp = "StimN_"+ CtWave
	SetDataFolder root:Packages:YT:
	DoWindow/F $CtWin
	if(stringmatch(ctrlName, "BtFfs_tab14") )
		String switchffstim
		Prompt switchffstim "Do you like to search from leftx?", popup "yes;no"
		DoPrompt "Select mode" switchffstim
		If(StringMatch(switchffstim, "yes"))
				Cursor A $sdw leftx($sdw)
		endif
		
		Cursor B $sdw xcsr(A)+deltax($sdw)
		
		variable slope0, slope1, slope2, slope3, slope4
		do
			slope0 = (dw(xcsr(A)+4*deltax(dw))-dw(xcsr(A)))/(4*deltax(dw))
			slope1 = (dw(xcsr(B)+3*deltax(dw))-dw(xcsr(B)))/(3*deltax(dw))
			slope2 = (dw(xcsr(A)+5*deltax(dw))-dw(xcsr(A)+4*deltax(dw)))/deltax(dw)
			slope3 = (dw(xcsr(B)+5*deltax(dw))-dw(xcsr(B)+4*deltax(dw)))/deltax(dw)
			slope4 = (dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)+5*deltax(dw)))/deltax(dw)
			Cursor A $sdw xcsr(A) + deltax(dw)
			Cursor B $sdw xcsr(B) + deltax(dw)
		while((abs(slope2)<=50*abs(slope0) || abs(slope3)<=50*abs(slope1) || slope2*slope3<=0||slope3*slope4<=0||abs(dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)))<30e-12) && xcsr(A) + deltax(dw)*7 <= rightx(dw))
	endif
	
	if(xcsr(A)>=(rightx(dw)-deltax(dw)*7))
		print "end"
		Variable/G $temp = 0
	else
		Variable/G $temp = 1
	endif
	
	Variable n = 1
	Redimension/N=(n) $sn, $arti, $artiv, $pbase, $vpl, $vpv, $osl, $osv, $lat, $base, $amp, $rt,  $decay, $fdecay, $sdecay, $charge, $stp
	wave w_arti = $arti
	NVAR snum = root:Packages:YT:$temp
	
	if(snum !=0)
		if(stringmatch(ctrlName,"BtFfs_tab14"))
			Cursor A $sdw xcsr(A) + deltax(dw)*4
			Cursor B $sdw xcsr(B) + deltax(dw)*4
		endif
		w_arti[0] = xcsr(A)
		
		wave w_pbase = $pbase
		wavestats/q/r=(leftx(dw), xcsr(A)) dw
		w_pbase[0] = V_avg
		print "pBase_V_adev=", V_adev
		
		Cursor A $sdw xcsr(A) + vca_dis_f_arti
		Cursor B $sdw xcsr(A) + (deltax(dw)*4)
		variable x1, x2, x3, y1, y2, y3
		NVAR vca_posi = root:Packages:YT:vca_posi
		if(vca_posi == 0)
			do
				FindPeak/N/Q/R=(xcsr(A), xcsr(B)) dw
				x1 = V_PeakLoc
				y1 = V_PeakVal
				FindPeak/N/Q/R=(xcsr(A)+deltax(dw), xcsr(B)+deltax(dw)) dw
				x2 = V_PeakLoc
				y2 = V_PeakVal
				FindPeak/N/Q/R=(xcsr(A)+(deltax(dw)*2), xcsr(B)+(deltax(dw)*2)) dw
				x3 = V_PeakLoc
				y3 = V_PeakVal
				cursor A $sdw xcsr(A) + deltax(dw)
				cursor B $sdw xcsr(B) + deltax(dw)
			while((x1 != x2 || x1 != x3||x2 !=x3|| abs((V_avg-V_PeakVal)/V_adev)<100 ||V_flag != 0) && (xcsr(A) <= (w_arti[0] + 20e-3)))
		else
			do
				FindPeak/Q/R=(xcsr(A), xcsr(B)) dw
				x1 = V_PeakLoc
				y1 = V_PeakVal
				FindPeak/Q/R=(xcsr(A)+deltax(dw), xcsr(B)+deltax(dw)) dw
				x2 = V_PeakLoc
				y2 = V_PeakVal
				FindPeak/Q/R=(xcsr(A)+(deltax(dw)*2), xcsr(B)+(deltax(dw)*2)) dw
				x3 = V_PeakLoc
				y3 = V_PeakVal
				cursor A $sdw xcsr(A) + deltax(dw)
				cursor B $sdw xcsr(B) + deltax(dw)
			while((x1 != x2 || x1 != x3||x2 !=x3|| abs((V_avg-V_PeakVal)/V_adev)<100 ||V_flag != 0) && (xcsr(A) <= (w_arti[0] + 20e-3)))
		endif
		print "V_PeakLoc=", V_PeakLoc, "V_PeakVal=", V_PeakVal, "V_flag =", V_flag
			wave w_vpl = $vpl
			wave w_vpv = $vpv
			NVAR snum = root:Packages:YT:$temp
		if(V_flag == 0 && xcsr(A) <= w_arti[0] + 20e-3)
			w_vpl[0] = V_PeakLoc
			w_vpv[0] = V_PeakVal
		else
			wavestats/q/r=((w_arti[0]+vca_dis_f_arti), (w_arti[0]+20e-3)) dw
			variable comp_max = abs(V_max - w_pbase[0])
			variable comp_min = abs(V_min - w_pbase[0])
			if(comp_min>=comp_max)
				w_vpl[0] = V_minLoc
				w_vpv[0] = V_min
			else
				w_vpl[0] = V_maxLoc
				w_vpv[0] = V_max
			endif
			print v_max, v_min
			print "w_vpl=", w_vpl[0]
		endif

		wave w_osl = $osl
		wave w_osv = $osv
		variable pseud_amp = abs(w_vpv[0]-w_pBase[0])
		Cursor A $sdw w_vpl[0] - deltax(dw)
		Cursor B $sdw xcsr(A) + deltax(dw)*4
		do
			Cursor A $sdw xcsr(A) - deltax(dw)
		while((abs(vcsr(A)-w_pBase[0])/abs(w_vpv[0]-w_pBase[0]))>0.01 && ((xcsr(B)-xcsr(A))<(vca_onset_var)*(w_vpl[0]-w_arti[0])) && ((vcsr(A)-w_pBase[0])*(w_vpv[0]-w_pBase[0]))>0)
		if((xcsr(B) - xcsr(A))<(vca_onset_var)*(w_vpl[0]-w_arti[0]))
			w_osl[0] = xcsr(A)
			w_osv[0] = vcsr(A)
		else
			if(((vcsr(A)-w_pBase[0])*(w_vpv[0]-w_pBase[0]))<0)
				Cursor A $sdw xcsr(A) + deltax(dw)
				w_osl[0] = xcsr(A)
				w_osv[0] = vcsr(A)
			else
				cursor B $sdw w_vpl[0]
				wavestats/R=(xcsr(A), xcsr(B)) dw
				variable comp_max2 = abs(V_max - w_pbase[0])
				variable comp_min2 = abs(V_min - w_pbase[0])
				if(comp_min2<=comp_max2)
					w_osl[0] = V_minLoc
					w_osv[0] = V_min
				else
					w_osl[0] = V_maxLoc
					w_osv[0] = V_max
				endif
			endif
		endif
		
		wave w_lat = $lat
		w_lat[0] = w_osl[0] - w_arti[0]
		
		wave w_base =$base
		w_base[0] = (sum(dw, (w_osl[0] - (deltax(dw)*2)), w_osl[0])/3)
	
		wave w_decay = $decay
		cursor A $sdw w_vpl[0] + 5*deltax(dw)
		cursor B $sdw xcsr(A) + vca_fit_charge
		SetDataFolder root:Packages:YT:
		CurveFit/Q/M=0 exp_XOffset  dw[pcsr(A),pcsr(B)] /D
		w_decay[0] = k2
		RemoveFromGraph $("fit_"+sdw)
		String fit_w = "fit_" + sdw
		Print fit_w
		If(strlen(fit_w)>31)
			fit_w = fit_w[0, 30]
			Killwaves $("root:Packages:YT:"+fit_w)
		else
			Killwaves $("root:Packages:YT:"+fit_w)
		endif
		
		SetDataFolder root:Packages:YT:
		wave w_fdecay = $fdecay
		wave w_sdecay = $sdecay
		CurveFit/Q/M=0 dblexp_XOffset  dw[pcsr(A),pcsr(B)] /D
		w_fdecay[0] = k2
		w_sdecay[0] = k4
		RemoveFromGraph $("fit_"+sdw)
		fit_w = "fit_" + sdw
		print fit_w
		If(strlen(fit_w)>31)
			fit_w = fit_w[0, 30]
			Killwaves $("root:Packages:YT:"+fit_w)
		else
			Killwaves $("root:Packages:YT:"+fit_w)
		endif
		
		wave w_charge = $charge
		variable a = (dw(xcsr(B))-w_osv[0])/(xcsr(B)-w_osl[0])
		variable b = 0.5*(w_osv[0]+dw(xcsr(B))-(w_osl[0]+xcsr(B))*a)
		duplicate/o dw charge0, charge1
		charge0 = a*x + b
		charge1 = dw - charge0
		w_charge[0] = abs(area(charge1, xcsr(A), xcsr(B)))
		string tls = "tl_"+ CtWave + "_0"
		if(strlen(WaveList(tls,";","Win:"))>7)
			RemoveFromGraph $tls
		endif

		SetScale/P x w_osl[0],deltax(dw),"s", charge0
		variable tln = (xcsr(B)-w_osl[0])/deltax(dw)
		redimension/N = (tln) charge0
		charge0 = a*x + b
		duplicate/o charge0 $tls
		if(tangent_line != 0)
			appendtograph $tls
			ModifyGraph rgb($tls)=(0,52224,0)
		endif
		killwaves charge0, charge1
		
		wave w_amp = $amp
//		w_amp[0] = abs(w_vpv[0] - w_base[0])	
		wave tl = $tls
		w_amp[0] = abs(w_vpv[0] - tl(w_vpl[0]))
		
		if(strlen(WaveList(artiv,";","Win:"))>7)
			RemoveFromGraph $artiv
		endif
		if(strlen(WaveList(osv,";","Win:"))>7)
			RemoveFromGraph $osv
		endif
		if(strlen(WaveList(vpv,";","Win:"))>7)
			RemoveFromGraph $vpv
		endif
		if(markers != 0)
			appendtograph $artiv vs $arti
			appendtograph $osv vs $osl
			appendtograph $vpv vs $vpl
			ModifyGraph mode($artiv)=3, rgb($artiv)=(0,26112,0)
			ModifyGraph mode($osv)=3, rgb($osv)=(0,26112,0)
			ModifyGraph mode($vpv)=3, rgb($vpv)=(0,26112,0)
		endif		
		
		wave w_rt = $rt
		cursor A $sdw w_osl[0]
		do
			cursor A $sdw xcsr(A)+deltax(dw)
		while(abs(vcsr(A)-w_base[0])<0.1*w_amp[0])
		cursor B $sdw w_osl[0]
		do
			cursor B $sdw xcsr(B)+deltax(dw)
		while(abs(vcsr(B)-w_base[0])<0.9*w_amp[0])
		w_rt[0] = xcsr(B) - xcsr(A)
		
		wave w_stp = $stp
		w_stp[0] = w_amp[0]/w_amp[0]
	else
		w_arti[0] = 0
	endif
	SetDataFolder root:
	KillWaves W_sigma, W_fitConstants
end

Function t_find_sstim(ctrlName) : ButtonControl
	String ctrlName
	
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	NVAR tangent_line = root:Packages:YT:tangent_line
	NVAR markers = root:Packages:YT:markers
	NVAR vca_fit_charge = root:Packages:YT:vca_fit_charge
	NVAR vca_dis_f_arti = root:Packages:YT:vca_dis_f_arti
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	Wave dw =$sdw
	String jvct = "vct_"+CtWave
	String sn = "StimNum_" +CtWave
	String arti = "Arti_" +CtWave
	String artiv = "ArtiV_"+CtWave
	String pbase = "pBase_" +CtWave
	String vpl = "VcPL_"+CtWave
	String vpv = "VcPV_"+CtWave
	String osl = "VcOSL_" +CtWave
	String osv = "VcOSV_" +CtWave
	String lat = "Latency_" +CtWave
	String base = "Vc_Base" +CtWave
	String amp = "Vc_AMP_" +CtWave
	String rt = "Vc_RT_" +CtWave
	String decay = "Decay_" +CtWave
	String fdecay = "fDecay_" +CtWave
	String sdecay = "sDecay_" +CtWave
	String charge = "Charge_" +CtWave
	String stp = "STP_" +CtWave
	String temp = "StimN_"+CtWave
	SetDataFolder root:Packages:YT:
	DoWindow/F $CtWin
	if(stringmatch(ctrlName,"BtFsm_tab14"))
		Cursor A $sdw xcsr(A) + 5e-3
		Cursor B $sdw xcsr(A) + deltax(dw)
		variable slope0, slope1, slope2, slope3,slope4
		do
			slope0 = (dw(xcsr(A)+4*deltax(dw))-dw(xcsr(A)))/(4*deltax(dw))
			slope1 = (dw(xcsr(B)+3*deltax(dw))-dw(xcsr(B)))/(3*deltax(dw))
			slope2 = (dw(xcsr(A)+5*deltax(dw))-dw(xcsr(A)+4*deltax(dw)))/deltax(dw)
			slope3 = (dw(xcsr(B)+5*deltax(dw))-dw(xcsr(B)+4*deltax(dw)))/deltax(dw)
			slope4 = (dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)+5*deltax(dw)))/deltax(dw)
			Cursor A $sdw xcsr(A) + deltax(dw)
			Cursor B $sdw xcsr(B) + deltax(dw)
		while((abs(slope2)<=50*abs(slope0) || abs(slope3)<=50*abs(slope1) || slope2*slope3<0||slope3*slope4<0||abs(dw(xcsr(A)+6*deltax(dw))-dw(xcsr(A)))<30e-12) && xcsr(A) + deltax(dw)*7 <= rightx(dw))
	endif
	
	if(xcsr(A)>=(rightx(dw)-deltax(dw)*7))
		print "end"
	else
		NVAR stimntemp = root:Packages:YT:$temp
		stimntemp = stimntemp + 1
		print "StimNum =", stimntemp
		Redimension/N=(stimntemp) $sn, $arti, $artiv, $pbase, $vpl, $vpv, $osl, $osv, $lat, $base, $amp, $rt,  $decay, $fdecay, $sdecay, $charge, $stp
		wave w_sn = $sn
		w_sn[stimntemp-1] = stimntemp
		
		wave w_arti = $arti
		if(stringmatch(ctrlName,"BtFsm_tab14"))
			Cursor A $sdw xcsr(A) + deltax(dw)*4
			Cursor B $sdw xcsr(B) + deltax(dw)*4
		endif
		w_arti[stimntemp-1] = xcsr(A)

		wave w_pbase = $pbase
		wavestats/q/r=(xcsr(A)-deltax(dw)*8, xcsr(A)) dw
		w_pbase[stimntemp-1] = V_avg
		print "pBase_V_adev=", V_adev
		
		Cursor A $sdw xcsr(A) + vca_dis_f_arti
		Cursor B $sdw xcsr(A) + (deltax(dw)*8)
		variable x1, x2, x3, y1, y2, y3
		NVAR vca_posi = root:Packages:YT:vca_posi
		if(vca_posi == 0)
			do
				FindPeak/N/Q/R=(xcsr(A), xcsr(B)) dw
				x1 = V_PeakLoc
				y1 = V_PeakVal
				FindPeak/N/Q/R=(xcsr(A)+deltax(dw), xcsr(B)+deltax(dw)) dw
				x2 = V_PeakLoc
				y2 = V_PeakVal
				FindPeak/N/Q/R=(xcsr(A)+(deltax(dw)*2), xcsr(B)+(deltax(dw)*2)) dw
				x3 = V_PeakLoc
				y3 = V_PeakVal
				Cursor A $sdw xcsr(A) + deltax(dw)
				Cursor B $sdw xcsr(B) + deltax(dw)
			while((x1 != x2 || x1 != x3|| abs((V_avg-V_PeakVal)/V_adev)<100 ||V_flag != 0) && (xcsr(A) <= (w_arti[0] + 20e-3)))
		else
						do
				FindPeak/Q/R=(xcsr(A), xcsr(B)) dw
				x1 = V_PeakLoc
				y1 = V_PeakVal
				FindPeak/Q/R=(xcsr(A)+deltax(dw), xcsr(B)+deltax(dw)) dw
				x2 = V_PeakLoc
				y2 = V_PeakVal
				FindPeak/Q/R=(xcsr(A)+(deltax(dw)*2), xcsr(B)+(deltax(dw)*2)) dw
				x3 = V_PeakLoc
				y3 = V_PeakVal
				Cursor A $sdw xcsr(A) + deltax(dw)
				Cursor B $sdw xcsr(B) + deltax(dw)
			while((x1 != x2 || x1 != x3|| abs((V_avg-V_PeakVal)/V_adev)<100 ||V_flag != 0) && (xcsr(A) <= (w_arti[0] + 20e-3)))
		endif
		print "V_PeakLoc=", V_PeakLoc, "V_PeakVal=", V_PeakVal, "V_frag =", V_flag
		wave w_vpl = $vpl
		wave w_vpv = $vpv
		if(V_flag == 0 && xcsr(A) <= w_arti[0] + 20e-3)
			w_vpl[stimntemp - 1] = V_PeakLoc
			w_vpv[stimntemp - 1] = V_PeakVal
		else
			wavestats/q/r=((w_arti[stimntemp-1]+vca_dis_f_arti), (w_arti[stimntemp-1]+20e-3)) dw
			variable comp_max = abs(V_max - w_pbase[stimntemp-1])
			variable comp_min = abs(V_min - w_pbase[stimntemp-1])
			if(comp_min>=comp_max)
				w_vpl[stimntemp-1] = V_minLoc
				w_vpv[stimntemp-1] = V_min
			else
				w_vpl[stimntemp-1] = V_maxLoc
				w_vpv[stimntemp-1] = V_max
			endif
			print v_max, v_min
			print "w_vpl=", w_vpl[stimntemp-1]
		endif
		
		wave w_osl = $osl
		wave w_osv = $osv
		variable pseud_amp = abs(w_vpv[stimntemp - 1]-w_pBase[stimntemp - 1])
		Cursor A $sdw w_vpl[stimntemp - 1] - deltax(dw)
		Cursor B $sdw xcsr(A) + deltax(dw)*4
		do
			Cursor A $sdw xcsr(A) - deltax(dw)
		while((abs(vcsr(A)-w_pBase[stimntemp -1])/abs(w_vpv[stimntemp -1]-w_pBase[stimntemp -1]))>0.01 && ((xcsr(B)-xcsr(A))<(3/4)*(w_vpl[stimntemp-1]-w_arti[stimntemp-1])) && (vcsr(A)-w_pBase[stimntemp -1])*(w_vpv[stimntemp -1]-w_pBase[stimntemp -1])>0)
		if((xcsr(B) - xcsr(A))<(3/4)*(w_vpl[stimntemp-1]-w_arti[stimntemp-1]))
			w_osl[stimntemp -1] = xcsr(A)
			w_osv[stimntemp -1] = vcsr(A)
		else
			if((vcsr(A)-w_pBase[stimntemp -1])*(w_vpv[stimntemp -1]-w_pBase[stimntemp -1])<0)
				Cursor A $sdw xcsr(A) + deltax(dw)
				w_osl[stimntemp -1] = xcsr(A)
				w_osv[stimntemp -1] = vcsr(A)
			else
				Cursor B $sdw w_vpl[stimntemp -1]
				wavestats/R=(xcsr(A), xcsr(B)) dw
				variable comp_max2 = abs(V_max - w_pbase[stimntemp -1])
				variable comp_min2 = abs(V_min - w_pbase[stimntemp -1])
				if(comp_min2<=comp_max2)
					w_osl[stimntemp -1] = V_minLoc
					w_osv[stimntemp -1] = V_min
				else
					w_osl[stimntemp -1] = V_maxLoc
					w_osv[stimntemp -1] = V_max
				endif
			endif
		endif
		
		wave w_lat = $lat
		w_lat[stimntemp - 1] = w_osl[stimntemp -1] - w_arti[stimntemp -1]
		
		wave w_base =$base
		w_base[stimntemp - 1] = (sum(dw, (w_osl[stimntemp - 1] - (deltax(dw)*2)), w_osl[stimntemp - 1])/3)

		wave w_decay = $decay
		Cursor A $sdw w_vpl[stimntemp - 1] + 5*deltax(dw)
		Cursor B $sdw xcsr(A) + vca_fit_charge
		SetDataFolder root:Packages:YT:
		CurveFit/Q/M=0 exp_XOffset  dw[pcsr(A),pcsr(B)] /D 
		w_decay[stimntemp - 1] = k2
		RemoveFromGraph $("fit_"+sdw)
		String fit_w = "fit_" + sdw
		If(strlen(fit_w)>31)
			fit_w = fit_w[0, 30]
			Killwaves $("root:Packages:YT:"+fit_w)
		else
			Killwaves $("root:Packages:YT:"+fit_w)
		endif
		
		SetDataFolder root:Packages:YT:
		wave w_fdecay = $fdecay
		wave w_sdecay = $sdecay
		SetDataFolder root:Packages:YT:
		CurveFit/Q/M=0 dblexp_XOffset  dw[pcsr(A),pcsr(B)] /D 
		w_fdecay[stimntemp-1] = k2
		w_sdecay[stimntemp-1] = k4
		RemoveFromGraph $("fit_"+sdw)
		fit_w = "fit_" + sdw
		If(strlen(fit_w)>31)
			fit_w = fit_w[0, 30]
			Killwaves $("root:Packages:YT:"+fit_w)
		else
			Killwaves $("root:Packages:YT:"+fit_w)
		endif
		
		wave w_charge = $charge
		variable a = (dw(xcsr(B))-w_osv[stimntemp-1])/(xcsr(B)-w_osl[stimntemp-1])
		variable b = 0.5*(w_osv[stimntemp-1]+dw(xcsr(B))-(w_osl[stimntemp-1]+xcsr(B))*a)
		duplicate/o dw charge0, charge1
		charge0 = a*x + b
		charge1 = dw - charge0
		w_charge[stimntemp-1] = abs(area(charge1, xcsr(A), xcsr(B)))
		
		string tls = "tl_"+ CtWave + "_" + Num2str(stimntemp-1)
		if(strlen(WaveList(tls,";","Win:"))>7)
			RemoveFromGraph $tls
		endif
		if(tangent_line == 0)
			killwaves charge0, charge1
		else	
			SetScale/P x w_osl[stimntemp - 1],deltax(dw),"s", charge0
			variable tln = (xcsr(B)-w_osl[stimntemp -1])/deltax(dw)
			redimension/N = (tln) charge0
			charge0 = a*x + b
			duplicate/o charge0 $tls
			appendtograph $tls
			ModifyGraph rgb($tls)=(0,52224,0)
			killwaves charge0, charge1
		endif
		
		wave w_amp = $amp
//		w_amp[stimntemp - 1] = abs(w_vpv[stimntemp - 1] - w_base[stimntemp - 1])
		wave tl = $tls
		w_amp[stimntemp - 1] = abs(w_vpv[stimntemp - 1] - tl(w_vpl[stimntemp - 1]))
		
		if(strlen(WaveList(artiv,";","Win:"))>7)
			RemoveFromGraph $artiv
		endif
		if(strlen(WaveList(osv,";","Win:"))>7)
			RemoveFromGraph $osv
		endif
		if(strlen(WaveList(vpv,";","Win:"))>7)
			RemoveFromGraph $vpv
		endif
		if(markers != 0)
			appendtograph $artiv vs $arti
			appendtograph $osv vs $osl
			appendtograph $vpv vs $vpl
			ModifyGraph mode($artiv)=3, rgb($artiv)=(0,26112,0)
			ModifyGraph mode($osv)=3, rgb($osv)=(0,26112,0)
			ModifyGraph mode($vpv)=3, rgb($vpv)=(0,26112,0)
		endif		
		
		wave w_rt = $rt
		Cursor A $sdw w_osl[stimntemp - 1]
		do
			Cursor A $sdw xcsr(A)+deltax(dw)
		while(abs(vcsr(A)-w_base[stimntemp - 1])<0.1*w_amp[stimntemp - 1])
		Cursor B $sdw w_osl[stimntemp - 1]
		do
			Cursor B $sdw xcsr(B)+deltax(dw)
		while(abs(vcsr(B)-w_base[stimntemp - 1])<0.9*w_amp[stimntemp - 1])
		w_rt[stimntemp - 1] = xcsr(B) - xcsr(A)
		
		wave w_stp = $stp
		w_stp[stimntemp - 1] = w_amp[stimntemp - 1]/w_amp[0]
	endif
	SetDataFolder root:
	KillWaves W_sigma, W_fitConstants
end

Function t_end(ctrlName) : ButtonControl
	String ctrlName
	String CtWin
	String CtWave
	String sdw
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			CtWin = tWin
			sdw = CtWave
			break
		case 1:
			CtWave = tjw
			CtWin = "graph_jw"
			sdw = "jw"
			break
		default:
			break
	endswitch
	Wave dw =$sdw
	DoWindow/F $CtWin
	Cursor/K/W=$CtWin A
	Cursor/K/W=$CtWin B
	print "end!"
end

Function t_display_each_param_vc(ctrlName) : ButtonControl
	String ctrlName
	String CtWave
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tjw = root:Packages:YT:tjw
	ControlInfo/W=ControlPanel tb0
	Switch(V_value)
		case 0:
			CtWave = tWave0
			break
		case 1:
			CtWave = tjw
			break
		default:
			break
	endswitch
	If(strlen(CtWave) > 22)
		CtWave = CtWave[0, 21]
	endif
	String jvct = "vct_"+CtWave
	String sn = "StimNum_" +CtWave
	String arti = "Arti_" +CtWave
	String pbase = "pBase_" +CtWave
	String vpl = "VcPL_"+CtWave
	String vpv = "VcPV_"+CtWave
	String osl = "VcOSL_" +CtWave
	String osv = "VcOSV_" +CtWave
	String lat = "Latency_" +CtWave
	String base = "Vc_Base" +CtWave
	String amp = "Vc_AMP_" +CtWave
	String rt = "Vc_RT_" +CtWave
	String decay = "Decay_" +CtWave
	String fdecay = "fDecay_" +CtWave
	String sdecay = "sDecay_" +CtWave
	String charge = "Charge_" +CtWave
	String stp = "STP_" +CtWave
	wave w_sn = $sn
	wave w_amp = $amp
	wave w_charge = $charge
	wave w_stp = $stp
	Display w_amp vs w_sn
	ModifyGraph mode=3,marker=8,mrkThick=2
	ModifyGraph sep(bottom)=1,manTick(bottom)={0,1,0,1},manMinor(bottom)={0,50}
	SetAxis/A/E=1 left
	TextBox/C/N=text0/F=0/A=MC "amplitude"
	Display w_charge vs w_sn
	ModifyGraph mode=3,marker=8,mrkThick=2
	ModifyGraph sep(bottom)=1,manTick(bottom)={0,1,0,1},manMinor(bottom)={0,50}
	SetAxis/A/E=1 left
	TextBox/C/N=text0/F=0/A=MC "charge"
	Display w_stp vs w_sn
	ModifyGraph mode=3,marker=8,mrkThick=2
	ModifyGraph sep(bottom)=1,manTick(bottom)={0,1,0,1},manMinor(bottom)={0,50}
	SetAxis/A/E=1 left
	ModifyGraph sep(bottom)=1,manTick(bottom)={0,1,0,1},manMinor(bottom)={0,50}
	TextBox/C/N=text0/F=0/A=MC "STP"
end

Function t_00660(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave sw = $tWave0
	
	Cursor A $tWave0 0.0660
	
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		Cursor B $tWave0 0.0760
	endIf
End

Function t_01160(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave sw = $tWave0
	Cursor A $tWave0 0.1160
	
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		Cursor B $tWave0 0.1260
	endIf
End

Function t_BtISISet(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave sw = $tWave0
	StrSwitch(ctrlName)
		case "Bt00960_tab14":
			Cursor A $tWave0 0.0960
			break
		case "Bt01660_tab14":
			Cursor A $tWave0 0.1660
			break
		case "Bt03660_tab14":
			Cursor A $tWave0 0.3660	
			break
		case "Bt00821_tab14":
			Cursor A $tWave0 0.0821
			break
		case "Bt10821_tab14":
			Cursor A $tWave0 1.0821
			break
		default:
			break
	endswitch	
End

Function t_7msH (ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Wave pw = $("VcOSL_"+tWave0)
	Cursor A $tWave0 pw[0]
	Cursor B $tWave0 pW[0] + 0.007
	print "NMDA Amplitude = "+ Num2str(vcsr(B) - vcsr(A))
	If(Wintype(tWin) == 5)
		Notebook $tWin text ="Amplitude = "+ Num2str(vcsr(B) - vcsr(A)) + "\r"
	endif
end

Function t_m7msH (ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Wave pw = $("VcOSL_"+tWave0)
	Cursor B $tWave0 pW[0] + 0.007
	print "NMDA Amplitude = "+ Num2str(vcsr(B) - vcsr(A))
	If(Wintype(tWin) == 5)
		Notebook $tWin text ="NMDA Amplitude = "+ Num2str(vcsr(B) - vcsr(A)) + "\r"
	endif
end

Function t_AMPA_NMDA_ratio(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	SVAR tWin = root:Packages:YT:tWin
	Wave pw = $("VcOSL_"+tWave0)
	Variable nmda, ampa, ratio
	Cursor A $tWave0 pw[0]
	Cursor B $tWave0 pW[0] + 0.007
	nmda = vcsr(B) - vcsr(A)
	print "NMDA Amplitude = "+ Num2str(nmda)
	If(Wintype(tWin) == 5)
		Notebook $tWin text ="NMDA Amplitude = "+ Num2str(nmda) + "\r"
	endif
	Wave qw = $("Vc_AMP_" + tWave1)
	ampa = qw[0]
	ratio = ampa/nmda
	print "AMPA Amplitude = " + Num2str(ampa)
	print "AMPA/NMDA ratio = " + Num2str(ratio)
	If(Wintype(tWin) == 5)
		Notebook $tWin text ="AMPA Amplitude = "+ Num2str(ampa) + "\r"
		Notebook $tWin text ="AMPA/NMDA ratio = "+ Num2str(ratio) + "\r"
	endif
end

Function t_setAMPANMDA(ctrlName) :ButtonControl
	String ctrlName
	
	NVAR vca_dis_f_arti = root:Packages:YT:vca_dis_f_arti
	NVAR vca_fit_charge = root:Packages:YT:vca_fit_charge
	NVAR vca_onset_var = root:Packages:YT:vca_onset_var
	StrSwitch (ctrlName)
		case "BtsetAMPA_tab14":
			vca_dis_f_arti = 1e-3
			vca_fit_charge = 2e-2
			vca_onset_var = 0.7
			break
		case "BtsetNMDA_tab14":
			vca_dis_f_arti = 7e-3
			vca_fit_charge = 0.55
			vca_onset_var = 0.9
			break
		default :
			break
	endswitch
end

Function t_TestDoAbort(ctrlName) : ButtonControl
	String ctrlName				// Wrote Original.
	SVAR tWin = root:Packages:YT:tWin			// Wrote Original.
	SVAR tWave0 = root:Packages:YT:tWave0	// Wrote Original.
	
	Variable startTicks = ticks
	Variable endTicks = startTicks + 100*60
	Variable lastMessageUpdate = startTicks
	
	t_PressEscapeToAbort(0, "PressEsc", "DoAbortPanel")
	
	Wave srcWave = $tWave0		//Wrote Original
	
	do
		Cursor A $tWave0 xcsr(A) + deltax(srcWave)		// Wrote Original.
		
		String message
		message = ""
		if (ticks>=lastMessageUpdate+60)				// Time to update message?
			Variable remaining = (endTicks - ticks) / 60
			sprintf message, "Time remaining: %.1f seconds", remaining
			lastMessageUpdate = ticks
		endif

		if (t_PressEscapeToAbort(1, "", message))
			Print "Test aborted by Escape."
			break
		endif
	while(ticks < endTicks)

	t_PressEscapeToAbort(2, "", "")					// Kill panel.
End

Function t_XAnchor(ctrlName) : ButtonControl
	String ctrlName
	Variable/G root:Packages:YT:XAnchor = xcsr(A)
End

Function t_MoveToXAnchor(ctrlName) : ButtonControl
	String ctrlName
	NVAR xanchor = root:Packages:YT:xanchor
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	DoWindow/F $tWin
	Cursor A $tWave0 xanchor
End

// end of Voltage-clamp (VC) tab

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Timcourse_analysis _tab15

Function t_PrepTimecourseAnalysis(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	String keyword, strEdit, ampl0, ampl1, aavg, rs, ppr, area0, tau, tau_fast, tau_slow, tau_weighted, bottom, switchnwpnt
	Variable nwpnt = v_ns - v_nis + 1
	Prompt keyword, "Enter Definition Keyword!"
	Prompt strEdit, "AppendToTable?", popup "New Table;tWin;none;"
	Prompt ampl0, "Make the ampl0 (wave) ?", popup "No;Yes;"
	Prompt ampl1, "Make the ampl1 (wave) ?", popup "No;Yes;"
	Prompt aavg, "Make the aavg?", popup "No;Yes;"
	Prompt rs, "Make the rs (wave) ?", popup "No;Yes;"
	Prompt ppr, "Make the ppr (wave) ?", popup "No;Yes;"
	Prompt area0, "Make the area0 (wave) ?", popup "No;Yes;"
	Prompt tau, "Make the tau (wave) ?", popup "No;Yes;"
	Prompt tau_fast, "Make the tau_fast (wave) ?", popup "No;Yes;"
	Prompt tau_slow, "Make the tau_slow (wave) ?", popup "No;Yes;"
	Prompt tau_weighted, "Make the tau_weighted (wave) ?", popup "No;Yes;"
	Prompt bottom, "Make the bottom (wave) ?", popup "No;Yes;"
	Prompt switchnwpnt, "You'd like to define number of wave point?", popup "No. Default.;Yes;"
	DoPrompt "Specify waves by \"keyword\". And Select waves which you need.", keyword, strEdit, ampl0, ampl1, aavg, rs, ppr, area0
	If(V_flag == 1)
		Abort
	endif
	If(strlen(keyword) == 0)
		DoAlert 1, "Please Define (input) keyword! "
		If(V_flag == 1)
			DoPrompt "Enter keyword.", keyword
		else
			Abort  "Aborting Function..."
		endif
		If(strlen(keyword) == 0)
			Abort
		endif
	endif
	DoPrompt "Select waves which you need. (continue)", tau, tau_fast, tau_slow, tau_weighted, bottom, switchnwpnt
	If(V_flag == 1)
		Abort
	endif
	If(stringmatch(switchnwpnt, "Yes"))
		Prompt nwpnt, "Enter number of waves (variable)."
		DoPrompt "Specification of the number of waves", nwpnt
	endif
	
	If(stringmatch(bottom, "Yes"))
		Make/n = (nwpnt) $(keyword + "_bottom")
	endif
	
	If(stringmatch(ampl0, "Yes"))
		Make/n = (nwpnt) $(keyword + "_base0")
		Make/n = (nwpnt) $(keyword + "_ampl0")
	endif
	
	If(stringmatch(ampl1, "Yes"))
		Make/n = (nwpnt) $(keyword + "_base1")
		Make/n = (nwpnt) $(keyword + "_ampl1")
	endif
	
	If(stringmatch(aavg, "Yes"))
		Make/n = (nwpnt) $(keyword+"_aavg")
	endif
	
	If(stringmatch(rs, "Yes"))
		Make/n = (nwpnt) $(keyword + "_base2")
		Make/n = (nwpnt) $(keyword + "_rs")
		Make/n = (nwpnt) $(keyword + "_realrs")
	endif
	
	If(stringmatch(ppr, "Yes"))
		Make/n = (nwpnt) $(keyword + "_ppr")
	endif
	
	If(stringmatch(area0, "Yes"))
		Make/n = (nwpnt) $(keyword + "_area0")
	endif
	
	If(stringmatch(tau, "Yes"))
		Make/n = (nwpnt) $(keyword + "_tau")
	endif
	
	If(stringmatch(tau_fast, "Yes"))
		Make/n = (nwpnt) $(keyword + "_tau_fast")
	endif

	If(stringmatch(tau_slow, "Yes"))
		Make/n = (nwpnt) $(keyword + "_tau_slow")
	endif
	
	StrSwitch (strEdit)
		case "New Table":
			Edit/N = $("Table_"+ keyword)
			String ATT = wavelist(keyword+"_*", "; ", "")
			Variable i = 0
			do
				If(strlen(StringFromList(i, ATT)) == 0)
					break
				endif
				AppendToTable $StringFromList(i, ATT)
				i += 1
			while(1)
			break;
		case "tWin":
			If(WinType(tWin) != 2)
				DoAlert 1, "tWin isn't a Table. Do you like to make a new Table?"
				If(V_flag == 1)
					Edit/N = $("Table_"+ keyword)
					tWin = "Table_" + keyword
				endif
			endif
			ATT = wavelist(keyword+"_*", "; ", "")
			i = 0
			do
				If(strlen(StringFromList(i, ATT)) == 0)
					break
				endif
				AppendToTable/W=$tWin $StringFromList(i, ATT)
				i += 1
			while(1)
			break;
		default :
			break;
	endSwitch
end

Function BtDoTimeCourseAnalysis(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	String aprox, SwitchAnali
	Variable nwpnt = v_ns - v_nis + 1
	String renwpnt
	aprox = wavelist("*_base0", ";", "") + wavelist("*_ampl0", ";", "") + wavelist("*_base1", ";", "") + wavelist("*_ampl1",";", "") + wavelist("*_aavg",";","") + wavelist("*_base2", ";", "") +  wavelist("*_rs", ";", "")
	aprox += wavelist("*_ppr", ";", "") + wavelist("*_area0", ";", "") + wavelist("*_tau", ";", "") + wavelist("*_tau_fast", ";", "") + wavelist("*_tau_slow", ";", "") + wavelist("*_tau_weighted", ";", "")
	Prompt SwitchAnali, "Select", popup aprox
	Prompt renwpnt, "Do you like to redimension target wave?", popup "No;default (v_ns - v_nis + 1);Yes! (Manual)"
	DoPrompt "Target Analysis Wave", SwitchAnali, renwpnt
	StrSwitch (renwpnt)
		case "No":
			break;
		case "default (v_ns - v_nis + 1)":
			redimension/n = (nwpnt) $SwitchAnali
			break;
		case "Yes! (Manual)":
			Prompt nwpnt, "Enter the number of point."
			DoPrompt "numpnt, target wave", nwpnt
			redimension/n = (nwpnt) $SwitchAnali
			break;
		default:
			break;
	endSwitch
	Print SwitchAnali
	
	If(stringMatch(SwitchAnali, "*_ampl*"))
		NewDataFolder root:temp_amp
		Variable/G root:temp_amp:xsd = 5
		Variable sdev
		NewPanel/K=1 /W=(100,100,350,200)
		DoWindow/C tmp_PauseforCursor
		DrawText 21,20,"Enter integer, (If(Int*V_sdev)...)"
		SetVariable Setsdev, pos = {100,35}, value= root:temp_amp:xsd, title = "Int"
		Button button0,pos={80,58},size={92,20},title="Continue"
		Button button0,proc=UserCursorAdjust_ContButtonProc
		Button button1,pos={80,80},size={92,20}
		Button button1,proc=UserCursorAdjust_CancelBProc,title="Cancel"
		
		PauseForUser tmp_PauseforCursor
		NVAR xsd = root:temp_amp:xsd
	endif
	
	If(WinType(tWin) == 1)
		DoWindow/F $tWin
	endif
	If(stringMatch(SwitchAnali, "*_base0"))
//		Print "*_base0"
		variable i, l
		wave base0 = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				wavestats/q/r=(xcsr(A),xcsr(B)) vari
				base0[i]=V_avg
//				print "base0["+Num2str(i-1)+"]=" print V_avg
			else
				base0[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif

	If(stringMatch(SwitchAnali, "*_ampl0"))
//		Print "*_ampl0"
		NewDataFolder/O root:tmp_ampl
		Variable/G root:tmp_ampl:xcsrA
		Variable/G root:tmp_ampl:xcsrB
		NVAR xcsrA = root:tmp_ampl:xcsrA
		NVAR xcsrB = root:tmp_ampl:xcsrB
		xcsrA = xcsr(A)
		xcsrB = xcsr(B)
		variable peak
		variable abs_max
		variable abs_min
		wave ampl0 = $SwitchAnali
		wave base0 = $ReplaceString("_ampl0", SwitchAnali, "_base0")
		
		Variable rval= UserCursorAdjust(tWin)
		if (rval == -1)							// Graph name error?
			return -1;
		endif

		if (rval == 1)								// User canceled?
			DoAlert 0,"Canceled"
			return -1;
		endif
		
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
//				print "base0["+Num2str(i)+"]=" print base0[i] 
				wavestats/q/r=(xcsr(A), xcsr(B)) vari
				sdev = V_sdev
				wavestats/q/r=(xcsrA,xcsrB) vari
				abs_max=abs(V_max-base0[i])
				abs_min=abs(V_min-base0[i])
				if (abs_max>=abs_min)
					peak=V_max-base0[i]
				else
					peak=V_min-base0[i]
				endif
				
				if(abs(peak) >= xsd*sdev)
					ampl0[i]= peak
//					print "peak,", "ampl0["+Num2str(i)+"]=" print ampl0[i]
				else
					ampl0[i]= base0[i]
//					print "avg, ", "ampl0["+Num2str(i)+"]=" print ampl0[i]
				endif
				
			else
				ampl0[i]=NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
		String WaveOnGraph = "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)
		SetDataFolder root:
		DoWindow/F $tWin
		Cursor A $WaveOnGraph xcsrA
		Cursor B $WaveOnGraph xcsrB
		KillDataFolder root:tmp_ampl
		KillDataFolder root:temp_amp
	endif
	
	If(stringMatch(SwitchAnali, "*_base1"))
		Print "*_base1"
		wave base1 = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				wavestats/q/r=(xcsr(A),xcsr(B)) vari
				base1[i]=V_avg
				print "base1["+Num2str(i-1)+"]="
				print V_avg
			else
				base1[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
	
	If(stringMatch(SwitchAnali, "*_ampl1"))
		Print "*_ampl1"
		NewDataFolder/O root:tmp_ampl
		Variable/G root:tmp_ampl:xcsrA
		Variable/G root:tmp_ampl:xcsrB
		NVAR xcsrA = root:tmp_ampl:xcsrA
		NVAR xcsrB = root:tmp_ampl:xcsrB
		xcsrA = xcsr(A)
		xcsrB = xcsr(B)
		wave ampl1 = $SwitchAnali
		wave base1 = $ReplaceString("_ampl1", SwitchAnali, "_base1")
		
		rval= UserCursorAdjust(tWin)
		if (rval == -1)							// Graph name error?
			return -1;
		endif

		if (rval == 1)								// User canceled?
			DoAlert 0,"Canceled"
			return -1;
		endif
		
		i = 0
		l = v_nis	
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				print "base1["+Num2str(i)+"]="
				print base1[i] 
				wavestats/q/r=(xcsr(A),xcsr(B)) vari
				sdev = V_sdev
				wavestats/q/r=(xcsrA,xcsrB) vari
				abs_max=abs(V_max-base1[i])
				abs_min=abs(V_min-base1[i])
				if (abs_max>=abs_min)
					peak=V_max-base1[i]
				else
					peak=V_min-base1[i]
				endif
				
				if(abs(peak) >= xsd*sdev)
					ampl1[i]= peak
					print "peak,", "ampl1["+Num2str(i)+"]="
					print ampl1[i]
				else
					ampl1[i]= base1[i]
					print "avg, ", "ampl1["+Num2str(i)+"]="
					print ampl1[i]
				endif
				
			else
				ampl1[i]=NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
		WaveOnGraph = "w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(v_nis)
		SetDataFolder root:
		DoWindow/F $tWin
		Cursor A $WaveOnGraph xcsrA
		Cursor B $WaveOnGraph xcsrB
		KillDataFolder root:tmp_ampl
		KillDataFolder root:temp_amp
	endif
	
	If(stringMatch(SwitchAnali, "*_base2"))
//		Print "*_base2"
		wave base2 = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				wavestats/q/r=(xcsr(A),xcsr(B)) vari
				base2[i]=V_avg
//				print "base2["+Num2str(i-1)+"]=" print V_avg
			else
				base2[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
	
	If(stringMatch(SwitchAnali, "*_aavg"))
		Print "*_aavg"
		wave aavg = $SwitchAnali
		wave ampl0 = $ReplaceString("_aavg", SwitchAnali, "_ampl0")
		Variable initial, stimnum, j
		Prompt initial "Define initial sweep (1->0)"
		Prompt stimnum "Define Stim times."
		DoPrompt "Enter Integer", initial, stimnum
		i = initial - 1
		do
			Variable summation = 0
			Variable pnt = 0
			for(j=0;j<stimnum;j+=1)
				If(ampl0[i+j] != NaN)
					summation += ampl0[i+j]
					pnt += 1
					aavg[i+j] = NaN
				endif
			endfor
			If(pnt != 0)
				aavg[i] = summation/pnt
			else
				aavg[i] = NaN
			endif
			i += stimnum
		while(i<v_ns)
	endif
	
	
	If(stringMatch(SwitchAnali, "*_rs"))
		Print "*_rs"
		wave rs = $SwitchAnali
		wave base2 = $ReplaceString("_rs", SwitchAnali, "_base2")
		wave realrs = $ReplaceString("_rs", SwitchAnali, "_realrs")
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
//				print "base2["+Num2str(i)+"]=" print base2[i] 
				wavestats/q/r=(xcsr(A),xcsr(B)) vari
				abs_max=abs(V_max-base2[i])
				abs_min=abs(V_min-base2[i])
				if (abs_max>=abs_min)
					peak=V_max-base2[i]
				else
					peak=V_min-base2[i]
				endif
				rs[i]=peak
				if(i==0)
					variable nor = rs[0]
				endif
				rs[i]=nor/rs[i]
				realrs[i] = (5e-9)/abs(peak)
//				print "rs["+Num2str(i)+"]=" print rs[i]
			else
				rs[i] = NaN
			endif
			i+=1
			l+=1
		while (l<=v_ns)	
	endif
	
	If(stringMatch(SwitchAnali, "*_ppr"))
		Print "*_ppr"
		wave ppr = $SwitchAnali
		wave ampl0 = $ReplaceString("_ppr", SwitchAnali, "_ampl0")
		wave ampl1 = $ReplaceString("_ppr", SwitchAnali, "_ampl1")
		i = 0
		do
			if(ampl0[i] != 0)
				if(ampl0[i] != NaN)
					if(ampl0[i]*ampl1[i]>=0)
						ppr[i] = abs(ampl1[i]/ampl0[i])
						print "ppr["+Num2str(i)+"]="
						print ppr[i]
					else
						ppr[i] = NaN
					endif
				else
					ppr[i] = NaN
				endif
			else
				ppr[i] = NaN
			endif
			i += 1
		while(i<= v_ns - v_nis)
	endif
	
	If(stringMatch(SwitchAnali, "*_area0"))
		Print "*_area0"
		wave area0 = $SwitchAnali
		tWave0 = SwitchAnali
		String StrArea
		Prompt StrArea "Select Area Mode", popup "Fill to 0;rectangle;trapezoid"
		DoPrompt "Subtraction Mode", StrArea
		StrSwitch (StrArea)
			case "Fill to 0":
				i = 0
				l = v_nis
				do
					wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
					if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
						area0[i] = abs(area(vari , xcsr(A), xcsr(B)))
						print "area0["+Num2str(i)+"]="
						print area0[i]
					else
						area0[i] = NaN
					endif
					l+=1
					i+=1
				while (l<=v_ns)	
				break;
			case "rectangle":
				i = 0
				l = v_nis
				do
					wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
					if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
						variable rect
						if(abs(vcsr(a))<=abs(vcsr(b)))
							rect = abs(vcsr(a))*abs(xcsr(b) - xcsr(a))
						else
							rect = abs(vcsr(b))*abs(xcsr(b) - xcsr(a))
						endif
						area0[i] = abs(area(vari , xcsr(A), xcsr(B))) - rect
						print "area0["+Num2str(i)+"]="
						print area0[i]
					else
						area0[i] = NaN
					endif
					l+=1
					i+=1
				while (l<=v_ns)
				break;
			case "trapezoid":
				i = 0
				l = v_nis
				do
					wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
					if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
						variable a = (vari(xcsr(B))-vari(xcsr(A)))/(xcsr(B)-xcsr(A))
						variable b = 0.5*(vari(xcsr(A))+vari(xcsr(B))-(xcsr(A)+xcsr(B))*a)
						duplicate/o vari charge0, charge1
						charge0 = a*x + b
						charge1 = vari - charge0
						area0[i] = abs(area(charge1, xcsr(A), xcsr(B)))
						print "area0["+Num2str(i)+"]="
						print area0[i]
						killwaves charge0 , charge1
					else
						area0[i] = NaN
					endif
					l+=1
					i+=1
				while (l<=v_ns)
				break;	
			default:
				break;
		endSwitch
	endif
	
	If(stringMatch(SwitchAnali, "*_tau"))
		Print "*_tau"
		wave tau = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				CurveFit exp_XOffset  vari[pcsr(A),pcsr(B)] /D 
				tau[i] = k2
				print "tau["+Num2str(i)+"]="
				print tau[i]
				String fit_w = "fit_" + SwitchAnali
				If(strlen(fit_w)>31)
					fit_w = fit_w[0, 30]
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				else
					RemoveFromGraph $(fit_w)
					Killwaves $("fit_"+ SwitchAnali)
				endif
			else
				tau[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
	
	If(stringMatch(SwitchAnali, "*_tau_fast"))
		Print "*_tau_fast"
		wave tau_fast = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				CurveFit dblexp_XOffset  vari[pcsr(A),pcsr(B)] /D 
				tau_fast[i] = k2
				print "tau_fast["+Num2str(i)+"]="
				print tau_fast[i]
				fit_w = "fit_" + SwitchAnali
				If(strlen(fit_w)>31)
					fit_w = fit_w[0, 30]
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				else
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				endif
			else
				tau_fast[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
	
	If(stringMatch(SwitchAnali, "*_tau_slow"))
		Print "*_tau_slow"
		wave tau_slow = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				CurveFit dblexp_XOffset  vari[pcsr(A),pcsr(B)] /D 
				tau_slow[i] = k4
				print "tau_slow["+Num2str(i)+"]="
				print tau_slow[i]
				fit_w = "fit_" + SwitchAnali
				If(strlen(fit_w)>31)
					fit_w = fit_w[0, 30]
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				else
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				endif
			else
				tau_slow[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
	
	If(stringMatch(SwitchAnali, "*_tau_weighted"))
		Print "*_tau_weighted"
		wave tau_weighted = $SwitchAnali
		i = 0
		l = v_nis
		do
			wave vari =$("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l))
			if(strlen(WaveList("w_"+Num2str(v_e)+"_"+Num2str(v_nc)+"_"+Num2str(l),";","Win:"))>7)
				CurveFit dblexp_XOffset  vari[pcsr(A),pcsr(B)] /D 
				tau_weighted[i] = abs(k1)*k2/(abs(k1)+abs(k3)) + abs(k3)*k4/(abs(k1)+abs(k3))
				print "tau_weighted["+Num2str(i)+"]="
				print tau_weighted[i]
				fit_w = "fit_" + SwitchAnali
				If(strlen(fit_w)>31)
					fit_w = fit_w[0, 30]
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				else
					RemoveFromGraph $(fit_w)
					Killwaves $(fit_w)
				endif
			else
				tau_weighted[i] = NaN
			endif
			l+=1
			i+=1
		while (l<=v_ns)
	endif
End

Function t_timeaxis(ctrlName) : ButtonControl
	String ctrlName
	String aprox, SwitchAnali
	SVAR tWave1 = root:Packages:YT:tWave1
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable nwpnt = v_ns - v_nis + 1
	Variable Hz
	String renwpnt, scaletype
	aprox = wavelist("*_bottom", ";", "")
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shit key pressed
		wave bottom = TC_bottom
		bottom = x/(0.1*60)
		SetScale/P x 0,1,"min", bottom
		tWave1 = "TC_bottom"
		Abort
	endif
	
	Prompt SwitchAnali, "Select", popup aprox
	Prompt scaletype, "Select Scale Type", popup "Time Scale;Stimulus Scale"
	Prompt renwpnt, "Do you like to redimension target wave?", popup "No;default (v_ns - v_nis + 1);Yes! (Manual)"
	DoPrompt "Set bottom wave properties", SwitchAnali, scaletype, renwpnt
	If(V_flag)
		Abort
	endif	
	StrSwitch (renwpnt)
		case "No":
			break;
		case "default (v_ns - v_nis + 1)":
			redimension/n = (nwpnt) $SwitchAnali
			break;
		case "Yes! (Manual)":
			Prompt nwpnt, "Enter the number of point."
			DoPrompt "numpnt, target wave", nwpnt
			redimension/n = (nwpnt) $SwitchAnali
			break;
		default:
			break;
	endSwitch
	
	StrSwitch (scaletype)
		case "Time Scale":
			Prompt Hz, "Enter Stimlus Hz!"
			DoPrompt "Stimlus Hz?",  Hz
			wave bottom = $SwitchAnali
			bottom = x/(Hz*60)
			SetScale/P x 0,1,"min", bottom
			break;
		case "Stimulus Scale":
			Variable stiminitial, stimdelta, stimnum, i, j, summation
			Prompt stiminitial, "initial stimlus intensity"
			Prompt stimdelta, "delta (increment)"
			Prompt stimnum, "stim times (integer)"
			DoPrompt "Define Param.", stiminitial, stimdelta, stimnum
			wave bottom = $SwitchAnali
			i = 0
			summation = stiminitial - stimdelta
			do
				summation += stimdelta
				for(j=0;j<stimnum;j+=1)
					bottom[i+j] = summation
				endfor
				i += stimnum
			while(i<=v_ns)
			SetScale/P x 0,1,"uA", bottom
			break;
		default:
			break;
	endSwitch
end

Function t_display_vc(ctrlName) : ButtonControl
	string ctrlName
	String StrSwitchFirst
	Prompt StrSwitchFirst "Select Mode", popup "Prompt Mode;Previous Mode(iExt1, iExt2, base1, ppr, Rs)"
	DoPrompt "Switch Mode", StrSwitchFirst
	
	StrSwitch (StrSwitchFirst)
		case "Prompt Mode":
			String srcWL = ""
			String cand
			do
				Prompt cand "Select cand  category", popup "base0;ampl0;base1;ampl1;base2;rs;ppr;area0;tau;tau_fast;tau_slow;tau_weighted"
				DoPrompt "Select cand category"cand
				Prompt cand "Select cand", popup wavelist("*_"+cand, ";", "")
				DoPrompt "Make srcWaveList" cand
				If(strlen(cand) >= 1)
					srcWL +=  cand + ";"
				endif
				DoAlert 2, "srcWL =" + srcWL + "     Do you like to operate another wave?"
				If(V_flag !=1)
					break
				endif	
			while(1)
			Print "srcWL = " + srcWL
			DoAlert 1, "Do you select Prompt mode? else Display Each wave mode."
			If(V_flag == 1)
				String StrFromWL
				Variable i = 0
				Display
				do
					String X_axisname, Y_axisname, Ex_x_axisname, Ex_y_axisname
					Prompt StrFromWL "Select srcWave", popup srcWL
					Prompt Y_axisname "Select Y axis",  popup "default;new axis;" + AxisList("")
					Prompt X_axisname "Select X axis",  popup "default (includes vs another wave);new axis;" + AxisList("") + wavelist("*_bottom", ";", "")
					DoPrompt "Set Wave and Axis Property", StrFromWL, Y_axisname, X_axisname
					StrSwitch (Y_axisname)
						case "default":
							Ex_y_axisname = ""
							Y_axisname = "left"
							break;
						case "new axis":
							Ex_y_axisname = "/L =" + "l" + Num2str(i)
							Y_axisname = "l" + Num2str(i)
							break;
						default:
							Ex_y_axisname = "/L=" + Y_axisname
							break;
					endSwitch
					StrSwitch (X_axisname)
						case "default (includes vs another wave)":
							String switchvs
							Prompt switchvs "bottom wave?", popup "none;" + wavelist("*_bottom", ";", "")
							DoPrompt "need bottom wave?"switchvs
							If(stringmatch(switchvs, "none"))
								Ex_x_axisname = ""
								X_axisname = "bottom"
							else
								String t = "AppendToGraph " + StrFromWL + " vs " + switchvs
								Execute t
								Variable T_flag = 0
							endif
							break;
						case "new axis":
							Ex_x_axisname = "/B =" + "b" + Num2str(i)
							X_axisname = "b" + Num2str(i)
							break;
						case "*_bottom":
							break;
						default:
							Ex_x_axisname = "/B= " + X_axisname
							break;
					endSwitch
					
					If(T_flag)
						t = "AppendToGraph" + Ex_y_axisname + Ex_x_axisname + " "+ StrFromWL
						Execute t
					endif

					If(stringmatch(Y_axisname, "l*"))
						String t_y_axislist = ""
						Variable j = 0
						Variable k = 0
						do
							If(strlen(StringFromList(j, AxisList(""))) == 0)
								break;
							endif
							If(StringMatch("left", StringByKey("AXTYPE", AxisInfo("",StringFromList(j, AxisList(""))))))
								t_y_axislist += StringFromList(j, AxisList("")) + ";"
								k += 1
							endif
							j += 1
						while(1)
//						Print Num2str(k), t_y_axislist
						If(k > 1)
							j = 0
							do
								ModifyGraph axisEnab($StringFromList(j, t_y_axislist)) = {(1-((j+1)/k))+0.01,(1-((j+1)/k)+(1/k))-0.01}
								do
									Variable l = 0
									Prompt l "Set FreePos of New Left Axis"
									DoPrompt "FreePos", l
									ModifyGraph freePos($StringFromList(j, t_y_axislist)) = l
									DoAlert 1, "OK?"
									If(V_flag == 1)
										break;
									endif
								while(1)
								j += 1
							while(k>j)
						endif
					endif
					DoAlert 1, "Another Wave?"
					i += 1
					If(V_flag != 1)
						break
					endif
				while(1)
				Print "OK"
			else
				StrFromWL += ""
			endif
			break;
		case "Previous Mode(iExt1, iExt2, base1, ppr, Rs)":
			String str_iExt1, str_iExt2, str_base1, str_ppr, str_rs, str_stimint
			Prompt str_iExt1 "Select iExt1", popup wavelist("*_ampl0", ";", "")
			Prompt str_iExt2 "Select iExt2", popup wavelist("*_ampl1", ";", "")
			Prompt str_base1 "Select base1", popup wavelist("*_base0", ";", "")
			Prompt str_ppr "Select ppr", popup wavelist("*_ppr", ";", "")
			Prompt str_rs "Select Rs", popup wavelist("*_rs", ";", "")
			Prompt str_stimint "Select stimint", popup wavelist("*_bottom", ";", "")
			DoPrompt "Wave Selection", str_iExt1, str_iExt2, str_base1, str_ppr, str_rs, str_stimint
			If(V_flag)
				Abort
			endif		
			wave iExt1 = $str_iExt1
			wave iExt2 = $str_iExt2
			wave base1 = $str_base1
			wave ppr = $str_ppr
			wave Rs = $str_rs
			wave stimint = $str_stimint
			
			stimint = 0.16666667 * x
			Display iExt1 vs stimint
			Appendtograph iExt2 vs stimint
			Appendtograph/L=base base1 vs stimint
			AppendToGraph/L=ppr ppr vs stimint
			AppendToGraph/L=rs Rs vs stimint
			ModifyGraph axisEnab(left)={0.75,1},freePos(left)=0
			ModifyGraph axisEnab(base)={0.5,0.71},freePos(base)=0
			ModifyGraph axisEnab(ppr)={0.25,0.46},freePos(ppr)=0
			ModifyGraph axisEnab(Rs)={0,0.21},freePos(Rs)=0
			ModifyGraph axisEnab(bottom)={0,0.9}
			SetAxis Rs 0,2
			SetAxis ppr 0, 5 
			SetAxis left -5.0e-10,0
			SetAxis base -5.0e-10, 0
			ModifyGraph zero(left)=1, zero(base)=1
			ModifyGraph mode($str_iExt1)=3,marker($str_iExt1)=8,mode($str_iExt2)=3,marker($str_iExt2)=19
			ModifyGraph mode($str_base1)=4,marker($str_base1)=17, mode($str_ppr)=3,marker($str_ppr)=6,mode($str_Rs)=3,marker($str_Rs)=5
			Label bottom "time (min)"
			Label left "\\Z06\\u#2synaptic current (pA)"
			Label base "\\Z06\\u#2base current (pA)"
			Label ppr "PPR"
			Label Rs "Rs" 
			TextBox/C/N=text0/B=1/F=0/A=MC "\\s(" + str_iExt1 + ")iExt1\r\\s(" + str_iExt2 + ")iExt2\r\\s(" + str_base1 +")Base\r\\s(" + str_ppr + ")PPR\r\\s(" + str_Rs+ ")Rs"
			break;
		default:
			break;
	endSwitch
end

Function t_TC_amp_vs_bottom(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWave1 = root:Packages:YT:tWave1
	tWave0 = "TC_ampl0"
	tWave1 = "TC_bottom"
	Wave amp = $tWave0
	Wave bottom = $tWave1
	Display amp vs bottom
End

Function t_BtRsN(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Duplicate/O $tWave0 RsN
	Wave TC_rs
	RsN *= TC_rs
	//Range specification
	Variable v = 0
	Wavestats/Q/R=[0, 29] RsN
	v = V_avg
	//Normalize
	Duplicate/O RsN Normalized_amp2
	Normalized_amp2 /= (v*0.01)
	AppendToTable/W=Table_TC Normalized_amp2
	Display Normalized_amp2 vs TC_bottom
	AppendToGraph Normalized_amp vs TC_bottom
	ModifyGraph mode=3,marker=8,rgb(Normalized_amp2)=(0,0,65280)
	ModifyGraph rgb(Normalized_amp)=(65280,0,0)
	SetAxis left 0,130
	ModifyGraph axisEnab(left)={0,0.6}
	AppendToGraph/L=RealRsAxis TC_realrs vs TC_bottom
	ModifyGraph axisEnab(left)={0,0.6},axisEnab(RealRsAxis)={0.7,1}
	ModifyGraph freePos(RealRsAxis)={0,bottom}
	SetAxis RealRsAxis 0,20
	ModifyGraph mode=3,marker(TC_realrs)=5
	tWave0 = "Normalized_amp2"
End

Function t_BaselineNormalize(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	String StrDup = ""
	String StrTarget = ""
	String StrAppendToTable = ""
	Variable key = 0
	key = GetKeyState(0)
	
	If(key & 4) //Shit key pressed
		Variable v = 0
		Wavestats/Q/R=[0, 29] $tWave0
		v = V_avg
		Duplicate/O $tWave0 Normalized_amp
		Normalized_amp /= (v*0.01)
		tWave0 = "Normalized_amp"
		AppendToTable/W=$WinName(0,2) Normalized_amp
		Abort
	endif
	
	Prompt StrDup "Enter the duplicated wave."
	Prompt StrTarget "TargetWave?" popup, "Yes;No;"
	Prompt StrAppendToTable "AppendToTable?" popup, "Yes;No;"
	DoPrompt "Specify." StrDup, StrTarget, StrAppendToTable
	If(V_Flag)
		Abort
	endif
	
	//Duplicate or Overwrite
	Duplicate/O $tWave0, $StrDup
	Wave destWave = $StrDup
		
	//Range specification
	v = 0
	Wavestats/Q/R=[pcsr(A), pcsr(B)] $tWave0
	v = V_avg
	
	//Normalize
	destWave /= (v*0.01)
	
	If(StringMatch(StrTarget, "Yes"))
		tWave0 = StrDup
	endif
	
	If(StringMatch(StrAppendToTable, "Yes"))
		AppendToTable/W=$WinName(0,2) $StrDup
	endif
End

Function t_TimecoursePercentInhibition(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	SVAR tWin = root:Packages:YT:tWin
	Variable v = 0
	Wavestats/Q/R=[pcsr(A), pcsr(B)] $tWave0
	v = V_avg
	Printf "V_avg = %f, and %inhibition = %f\r", v, (100 - v)	
End

Function t_TracePicker(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWL = root:Packages:YT:tWL
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	String scrw
	Variable i
	DoWindow/F $tWin
	tWL = ""
	for(i = pcsr(A); i<= pcsr(B); i += 1)
		scrw = "w_"+Num2str(v_e) + "_" + Num2str(v_nc) + "_" + Num2str(i) + ";"
		tWL += scrw
	endfor
	
	String t
	if(strlen(StringFromList(0, tWL)) != 0)
		Wave srcWave = $StringFromList(0, tWL)
		String destWName, sw_mean, sw_sdev, sw_sem, sw_num, target, appendtg, as
		Prompt destWName, "Enter the KeyWord for Name of results"
		Prompt sw_mean "mean?", popup "Yes;No;"
		Prompt sw_sdev "sdev?", popup "No;Yes;"
		Prompt sw_sem "sem?", popup "No;Yes;"
		Prompt sw_num "num?", popup "No;Yes;"
		Prompt target "target wave?", popup "Yes;No;"
		Prompt appendtg "AppendToGraph?", popup "No;Yes;"
		
		DoPrompt "Igor wants to know", destWName, sw_mean, sw_sdev, sw_sem, sw_num, target, appendtg
		If(V_flag)
			Abort
		endif
//		Print ReplaceString(";", tWL, " ")
		t = "Autostats " + ReplaceString(";", tWL, " ")
		execute t
		duplicate/O srcWave tswave_mean
		duplicate/O srcWave tswave_sdev
		duplicate/O srcWave tswave_sem
		duplicate/O srcWave tswave_num
		string t_mean ="tswave_mean = swave_mean"
		string t_sdev = "tswave_sdev = swave_sdev"
		string t_sem = "tswave_sem = swave_sem"
		string t_num ="tswave_num = swave_num"
		execute t_mean
		execute t_sdev
		execute t_sem
		execute t_num
		rename tswave_mean $("w_mean_"+ destWName)
		rename tswave_sdev $("w_sdev_"+ destWName)
		rename tswave_sem $("w_sem_"+ destWName)
		rename tswave_num $("w_num_"+ destWName)
		If(stringmatch(sw_mean, "No"))
			killwaves $("w_mean_"+ destWName)
		endif
		If(stringmatch(sw_sdev, "No"))
			killwaves $("w_sdev_"+ destWName)
		endif
		If(stringmatch(sw_sem, "No"))
			killwaves $("w_sem_"+ destWName)
		endif
		If(stringmatch(sw_num, "No"))
			killwaves $("w_num_"+ destWName)
		endif
		killwaves swave_mean, swave_sdev, swave_sem, swave_num
		
		If(StringMatch(target, "Yes"))
			tWave0 = "w_mean_" + destWName
		endIf
		
		If(StringMatch(appendtg, "Yes"))
			AppendToGraph/W=$tWin $("w_mean_" + destWName)
			ModifyGraph/W=$tWin rgb($("w_mean_" + destWName))=(8704,8704,8704)
		endIf
	endif
End

Function t_Delete(ctrlName) : ButtonControl
	String ctrlName
	NVAR delete_p = root:Packages:YT:delete_p
	Wave base1, base2, base3, iExt1, iExt2, Rs, ppr
	DoAlert 0, "Sorry. Under Construction!"
//	base1[delete_p] = NaN
//	base2[delete_p] = NaN
//	base3[delete_p] = NaN
//	iExt1[delete_p] = NaN
//	iExt2[delete_p] = NaN
//	Rs[delete_p] = NaN
//	ppr[delete_p] = NaN
end

Function t_rfg_dp(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	NVAR delete_p = root:Packages:YT:delete_p
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n =delete_p + v_nis
	String dw = "w_"+Num2str(v_e) + "_"+ Num2str(v_nc) + "_" + Num2str(n)
	RemoveFromGraph/W=$tWin $dw 
end

Function t_kws_dp(ctrlName) : ButtonControl
	String ctrlName
	NVAR delete_p = root:Packages:YT:delete_p
	NVAR v_e = root:Packages:YT:v_e
	NVAR v_nc = root:Packages:YT:v_nc
	NVAR v_ns = root:Packages:YT:v_ns
	NVAR v_nis = root:Packages:YT:v_nis
	Variable n = delete_p + v_nis
	String dw = "w_"+Num2str(v_e) + "_"+ Num2str(v_nc) + "_" + Num2str(n)
	Killwaves $dw
end

// end of time course (TC) tab
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//GraphControlPanel 

Function t_cpN01()
	NewPanel/N=GraphControlPanel/W=(300, 5, 680, 355)
	AutoPositionWindow/E/M=1/R=ControlPanel
	TabControl tb2 pos={5,5}, size={370,340}, proc=t_TabProc01
	TabControl tb2, tabLabel(0) = "1"
	TabControl tb2, tabLabel(1) = "2"

//tab20
	Button BtMakeNOE_tab20,pos={10,25},size={50,20},proc=t_noe,title="NOE"
	Button BtAppendNOE2Graph_tab20,pos={60,25},size={50,20},proc=t_AppendNOE2Graph,title="A2NOE"
	Button BtLabel_tab20,pos={60,45},size={50,20},proc=t_AxisLabelButtonProc,title="AxLabel"
	Button BtAxisOff_tab20,pos={60,65},size={50,20},proc=t_AxisOff,title="AxisOff"
	Button BtAxisOn_tab20,pos={60,85},size={50,20},proc=t_AxisOn,title="AxisOn"
	Button BtGetAxisScale_tab20,pos={60,105},size={50,20},proc=t_GetAxisScale,title="GetScal"
	Button BtRecoverAxis_tab20,pos={60,125},size={50,20},proc=t_RecoverAxis,title="RecvAx"
	Button BtPrepCategory_vs_Scat_tab20,pos={10,45},size={50,20},proc=t_Prep_Cat_vs_Scat,title="P_CvsS"
	Button BtModifyGraphSize_tab20,pos={10,85},size={50,20},proc=t_ModifyGraphSize,title="ModSize"
	Button BtGraphmargin_tab20,pos={10,105},size={50,20},proc=t_Graphmargin,title="Margin"
	Button BtModifyGraphWidthPlan_tab20,pos={10,125},size={50,20},proc=t_ModifyGraphWidthPlan,title="WidPlan"
	PopupMenu PopupMenuColor_tab20,pos={185,50},size={50,20},proc=t_PopMenuProcColor
	PopupMenu PopupMenuColor_tab20,mode=1,popColor= (0,0,0),value= #"\"*COLORPOP*\""
	PopupMenu PopupMenuLineStyle_tab20,pos={186,75},size={100,20},proc=t_PopMenuProcLineStyle
	PopupMenu PopupMenuLineStyle_tab20,mode=1,bodyWidth= 100,popvalue="",value= #"\"*LINESTYLEPOP*\""
	PopupMenu PopupMenuMarker_tab20,pos={185,100},size={100,20},proc=t_PopMenuProcMarker
	PopupMenu PopupMenuMarker_tab20,mode=9,bodyWidth= 100,popvalue="",value= #"\"*MARKERPOP*\""
	PopupMenu PopupMenuPattern_tab20,pos={185,125},size={100,20},proc=t_PopMenuProcPattern
	PopupMenu PopupMenuPattern_tab20,mode=1,bodyWidth= 100,popvalue="",value= #"\"*PATTERNPOP*\""
	PopupMenu PopupMenuMode_tab20,pos={185,25},size={100,20},proc=t_PopMenuProcGraphMode
	PopupMenu PopupMenuMode_tab20,mode=1,bodyWidth= 100,popvalue="Lines between points",value= #"\"Lines between points;Sticks to zero;Dots;Markers;Lines and markers;Bars;Cityscape;Fill to zero;Sticks and markers;Sticks to next;Bars to next;Fill to next;Sticks and markers to next\""
	SetVariable Setvar_GraphLN_tab20,pos={117,25},size={63,16},proc=t_SetVarProc_GraphLN,title="GLN"
	SetVariable Setvar_GraphLN_tab20,limits={0,inf,1},value= root:Packages:YT:GraphLN,bodyWidth= 37
	Button BtAppend_CvsS_tab20,pos={10,65},size={50,20},proc=t_Append_Category_vs_Scat,title="A_CvsS"

//tab21
	Slider SlGraph_X_tab21 pos={90,235}, fsize = 8, size={220 ,20},vert=0,side=2, limits={-101, 101, 0}, ticks=10, proc=t_graphslider_X, variable=root:Packages:YT:graphslider_X
	Slider SlGraph_Y_tab21 pos={40,70}, fsize = 8, size={40 ,200},vert=1,side=2, limits={-101, 101, 0}, ticks=10, proc=t_graphslider_Y, variable=root:Packages:YT:graphslider_Y
	Button BtSet0_tab21 pos={160, 120}, proc = t_set0, title = "Set0%", size = {40, 20}
	Button BtAutoAxis_tab21 pos = {200, 120}, proc = t_AutoAxis, title = "AuAx", size = {40, 20}
	Button BtAutoX_tab21 pos = {190, 295}, proc = t_AutoXY, title = "AX", size = {20, 20}
	Button BtAutoY_tab21 pos = {20, 160}, proc = t_AutoXY, title ="AY", size = {20, 20}
	Button BtRight_tab21 pos = {210, 295}, proc = t_GraphShift, title = ">", size = {20, 20}
	Button BtLeft_tab21 pos = {170, 295}, proc = t_GraphShift, title ="<", size = {20, 20}
	Button BtUp_tab21 pos = {20, 140}, proc = t_GraphShift, title = "A", size = {20, 20}
	Button BtDown_tab21 pos = {20, 180}, proc = t_GraphShift, title = "V", size = {20, 20}
	Button BtExpand_tab21 pos = {180, 140}, proc = t_EX_vs_Shr, title = "+", size = {20, 20}
	Button BtShrink_tab21 pos = {200, 140}, proc = t_EX_vs_Shr, title = "-", size = {20, 20}
	Button BtYExpand_tab21 pos = {20, 120}, proc = t_XYExShr, title = "+", size = {20, 20}
	Button BtYShrink_tab21 pos = {20, 200}, proc = t_XYExShr, title = "-", size = {20, 20}
	Button BtXExpand_tab21 pos = {230, 295}, proc = t_XYExShr, title = "+", size = {20, 20}
	Button BtXShrink_tab21 pos = {150, 295}, proc = t_XYExShr, title = "-", size = {20, 20} 
	SetVariable sv_RX_tab21 pos={230, 200}, size={75, 20}, proc=t_SetVarProc,value=root:Packages:YT:RX
	SetVariable sv_RY_tab21 pos={230, 220}, size={75, 20}, proc=t_SetVarProc,value=root:Packages:YT:RY
	SetVariable sv_AX_tab21 pos={110, 200}, size={75, 20}, proc=t_SetVarProc,value=root:Packages:YT:AX
	SetVariable sv_AY_tab21 pos={110, 220}, size={75, 20}, proc=t_SetVarProc,value=root:Packages:YT:AY
	Button BtCurorAL_tab21,pos={160,100},size={20,20},proc=t_graphcursorA,title="<"
	Button BtCurorAR_tab21,pos={181,100},size={20,20},proc=t_graphcursorA,title=">"
	Button BtCurorBL_tab21,pos={200,100},size={20,20},proc=t_graphcursorB,title="<"
	Button BtCurorBR_tab21,pos={220,100},size={20,20},proc=t_graphcursorB,title=">"
	Button BtZeromax_tab21,pos={20,219},size={20,20},proc=t_ZeroMax_left,title="0M"
//
	ModifyControlList ControlNameList("",";","!*_tab20") disable=1
	ModifyControl tb2 disable=0
end

Function t_TabProc01 (ctrlName, tabNum) : TabControl
	String ctrlname
	Variable tabNum
	String controlsInATab= ControlNameList("",";","*_tab2*")
	String curTabMatch="*_tab2"+Num2str(tabNum)
	String controlsInCurTab= ListMatch(controlsInATab, curTabMatch)
	String controlsInOtherTab= ListMatch(controlsInATab, "!"+curTabMatch)
	ModifyControlList controlsInCurTab disable = 0 //show
	ModifyControlList controlsInOtherTab disable = 1 //hide
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//tab20
Function t_graphslider_X(ctrlName, sliderValue, event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved
	Variable s = 0
	Variable f = 1
	NVAR graphslider_X = root:Packages:YT:graphslider_X
	NVAR AX = root:Packages:YT:AX
	NVAR RX = root:Packages:YT:RX
	GetAxis/Q bottom
	s = AX + RX*graphslider_X/100
	f = AX + RX + RX*graphslider_X/100
	SetAxis bottom s, f
End

Function t_graphslider_Y(ctrlName, sliderValue, event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved
	Variable s = 0
	Variable f = 1
	NVAR graphslider_Y = root:Packages:YT:graphslider_Y
	NVAR AY = root:Packages:YT:AY
	NVAR RY = root:Packages:YT:RY
	GetAxis/Q bottom
	s = AY + RY*graphslider_Y/100
	f = AY + RY + RY*graphslider_Y/100
	SetAxis left s, f
end

Function t_set0(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = root:Packages:YT:RX
	NVAR RY = root:Packages:YT:RY
	NVAR graphslider_X = root:Packages:YT:graphslider_X
	NVAR graphslider_Y = root:Packages:YT:graphslider_Y
	graphslider_X = 0
	graphslider_Y = 0
	GetAxis/Q bottom
	AX = V_min
	RX = V_max - V_min
	GetAxis/Q left
	AY = V_min
	RY = V_max - V_min
end

Function t_AutoXY(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = rootRX
	NVAR RY = root:Packages:YT:RY
	StrSwitch(ctrlName)
	case "BtAutoX_tab20" :
		SetAxis/A bottom
		GetAxis/Q bottom
		AX = V_min
		RX = V_max - V_min
		break
	case "BtAutoY_tab20" :
		SetAxis/A left
		GetAxis/Q left
		AY = V_min
		RY = V_max - V_min
		break
	default :
		break
	endswitch
end
	
Function t_AutoAxis(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = rootRX
	NVAR RY = root:Packages:YT:RY
	SetAxis/A bottom
	GetAxis/Q bottom
	AX = V_min
	RX = V_max - V_min
	SetAxis/A left
	GetAxis/Q left
	AY = V_min
	RY = V_max - V_min
end

Function t_GraphShift(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = root:Packages:YT:RX
	NVAR RY = root:Packages:YT:RY
	GetAxis/Q bottom
	AX = V_min
	RX = V_max - V_min
	GetAxis/Q left
	AY = V_min
	RY = V_max - V_min
	StrSwitch (ctrlName)
	case "BtRight_tab20":
		SetAxis bottom (AX + 0.1 * RX), (AX + RX + 0.1 * RX)
		GetAxis/Q bottom
		AX = V_min
		RX = V_max - V_min		
		break
	case "BtLeft_tab20":
		SetAxis bottom (AX  - 0.1 * RX), (AX + RX - 0.1 * RX)
		GetAxis/Q bottom
		AX = V_min
		RX = V_max - V_min		
		break
	case "BtUp_tab20":
		SetAxis left (AY + 0.1 * RY), (AY + RY + 0.1 * RY)
		GetAxis/Q left
		AY = V_min
		RY = V_max - V_min
		break
	case "BtDown_tab20":
		SetAxis left (AY - 0.1 * RY), (AY + RY - 0.1 * RY)
		GetAxis/Q left
		AY = V_min
		RY = V_max - V_min		
		break
	default:
		break
	endswitch
end

Function t_Ex_vs_Shr(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = root:Packages:YT:RX
	NVAR RY = root:Packages:YT:RY
	GetAxis/Q bottom
	AX = V_min
	RX = V_max - V_min
	GetAxis/Q left
	AY = V_min
	RY = V_max - V_min
	StrSwitch(ctrlName)
		case "BtExpand_tab20":
			SetAxis bottom (AX), (AX + RX - 0.125*RX)
			GetAxis/Q bottom
			AX = V_min
			RX = V_max - V_min
			SetAxis left (AY), (AY + RY - 0.125*RY)
			GetAxis/Q left
			AY = V_min
			RY = V_max - V_min
			break
		case "BtShrink_tab20":
			SetAxis bottom (AX), (AX + RX + 0.125*RX)
			GetAxis/Q bottom
			AX = V_min
			RX = V_max - V_min
			SetAxis left (AY), (AY + RY + 0.125*RY)
			GetAxis/Q left
			AY = V_min
			RY = V_max - V_min
			break
		default:
			break
	endswitch
end

Function t_XYExShr(ctrlName) : ButtonControl
	String ctrlName
	NVAR AX = root:Packages:YT:AX
	NVAR AY = root:Packages:YT:AY
	NVAR RX = root:Packages:YT:RX
	NVAR RY = root:Packages:YT:RY
	GetAxis/Q bottom
	AX = V_min
	RX = V_max - V_min
	GetAxis/Q left
	AY = V_min
	RY = V_max - V_min
	StrSwitch(ctrlName)
		case "BtYExpand_tab20":
			SetAxis left (AY), (AY + RY - 0.125*RY)
			GetAxis/Q left
			AY = V_min
			RY = V_max - V_min
			break
		case "BtYShrink_tab20":
			SetAxis left (AY), (AY + RY + 0.125*RY)
			GetAxis/Q left
			AY = V_min
			RY = V_max - V_min
			break
		case "BtXExpand_tab20":
			SetAxis Bottom (AX), (AX + RX + 0.125*RX)
			GetAxis/Q Bottom
			AX = V_min
			RX = V_max - V_min
			break
		case "BtXShrink_tab20":
			SetAxis Bottom (AX), (AX + RX - 0.125*RX)
			GetAxis/Q Bottom
			AX = V_min
			RX = V_max - V_min
			break
		default:
			break
	endswitch
end

Function t_graphcursorA(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	StrSwitch (ctrlName)
		case "BtCurorAR_tab20":
			Cursor/W=$tWin A $tWave0 xcsr(A) + deltax(srcWave)
			break
		case "BtCurorAL_tab20":
			Cursor/W=$tWin A $tWave0 xcsr(A) - deltax(srcWave)
			break
		default:
			break
	endSwitch
End

Function t_graphcursorB(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	StrSwitch (ctrlName)
		case "BtCurorBR_tab20":
			Cursor/W=$tWin B $tWave0 xcsr(B) + deltax(srcWave)
			break
		case "BtCurorBL_tab20":
			Cursor/W=$tWin B $tWave0 xcsr(B) - deltax(srcWave)
			break
		default:
			break
	endSwitch
End

Function t_ZeroMax_left(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	DoWindow/F $tWin
	SetAxis/A
	DoUpDate
	GetAxis left
	SetAxis left 0,V_max
End

//tab21/////////////////////////////////////////////////////////////////////////////////////////////
Function t_noe (ctrlName) : ButtonControl
	String ctrlName
	
	String name
	String nanwavename
	String axisname
	SVAR tWin = root:Packages:YT:tWin
	
	Variable nn
	
	Variable key
	key = GetKeyState(0)
	If(key & 4) // Shift key pressed
		name = "NOE_" +	Wavename("", 0, 1)
		nanwavename = "NaN_"+name
		axisname = "bottom_"+name
		nn = numpnts($Wavename("", 0, 1))
	else
		DoAlert 1, "Select a graph as a tWin before you continue the procedure.\rContinue?"
		If(V_Flag == 2)
			Abort
		endIf
	
		Prompt name, "Enter NOE WaveName"
		Prompt nanwavename, "Enter NaNWaveName", popup "default;other;"
		Prompt nn, "Enter num. of pnt"
		Prompt axisname, "Enter AxisName", popup "default;other;"
		DoPrompt "Make Num. of Exp. Axis", name, nanwavename, nn, axisname
	
		StrSwitch (nanwavename)
			case "default":
				nanwavename = "NaN_"+name
				break;
			case "other":
				Prompt nanwavename, "Enter NaNWaveName"
				DoPrompt "Define NaNWaveName", nanwavename
				break;
			default:
				break;
		endSwitch
	
		StrSwitch (axisname)
			case "default":
				axisname = "bottom_"+name
				break;
			case "other":
				Prompt axisname, "Enter AxisName"
				DoPrompt "Define AxisName", axisname
				break;
			default:
				break;
		endSwitch
	endIf
		
	Make/t/O/n=(nn) $name
	Make/O/n=(nn) $nanwavename
	Wave NaNWave = $nanwavename
	NaNWave = NaN
	
	If(Strlen(StringFromList(0, WinList("*", ";", "Win:2"))) > 1)
		Appendtotable $name
	endif
	
	If(WinType(tWin) == 1)
		AppendToGraph/B = $axisname $nanwavename vs $name
		ModifyGraph axThick($axisname)=0, freePos($axisname)=18
	endif
end

Function t_AppendNOE2Graph(ctrlName):ButtonControl
	String ctrlName
	DoAlert 1, "NOE wave must be selected as the tWave0. Continue?"
	If(V_flag == 2)
		Abort
	endIF
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	String NaNName = "NaN_"+tWave0
	String bName = "bottom" + tWave0
	Variable nn
	Prompt nn, "Enter num. of pnt"
	DoPrompt "Make Num. of Exp. Axis" nn
	If(V_flag)
		Abort
	endIf
	Make/O/n=(nn) $NaNName
	Wave NaNWave =$NaNName
	NaNWave = NaN
	If(WinType(tWin) == 1)
		AppendToGraph/B = $bName $NaNName vs $tWave0
		ModifyGraph axThick($bName)=0, freePos($bName)=18
	endif
end

Function t_AxisLabelButtonProc(ctrlName) : ButtonControl
	String ctrlName	
	SVAR tWin = root:Packages:YT:tWin
	If(WinType(tWin))
		String AxisnameString, LabelString
		Prompt AxisnameString "Select Axisname", popup Axislist(tWin)
		Prompt LabelString "Write down specified Axis Label"
		DoPrompt "Axis Label", AxisnameString, LabelString
		If(V_flag)
			Abort
		endif
		Label $AxisnameString "\\u#2" + LabelString
	else
		DoAlert 1, "target Window isn't a graph Window."	
	endif
End

Function t_AxisOff(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	String SFL
	Variable i = 0
	do
		If(Strlen(StringFromList(i, AxisList(tWin))) == 0)
			break
		endif
		SFL = StringFromList(i, AxisList(tWin))
		ModifyGraph/W = $tWin noLabel($SFL) = 2, axThick = 0
		i += 1
	while(1)
End

Function t_AxisOn(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	String SFL
	Variable i = 0
	do
		If(Strlen(StringFromList(i, AxisList(tWin))) == 0)
			break
		endif
		SFL = StringFromList(i, AxisList(tWin))
		ModifyGraph/W = $tWin noLabel($SFL) = 0, axThick = 1
		i += 1
	while(1)
End

Function t_GetAxisScale(ctrlName) : ButtonControl
	String ctrlName
	NVAR lmin = root:Packages:YT:lmin
	NVAR lmax = root:Packages:YT:lmax
	NVAR bmin = root:Packages:YT:bmin
	NVAR bmax = root:Packages:YT:bmax
	SVAR tWin = root:Packages:YT:tWin
	GetAxis/W=$tWin/Q left
	lmin = V_min
	lmax = V_max
	GetAxis/W=$tWin/Q bottom
	bmin = V_min
	bmax = V_max
	DoWindow/F $tWin
End

Function t_RecoverAxis(ctrlName) : ButtonControl
	String ctrlName
	NVAR lmin = root:Packages:YT:lmin
	NVAR lmax = root:Packages:YT:lmax
	NVAR bmin = root:Packages:YT:bmin
	NVAR bmax = root:Packages:YT:bmax
	SVAR tWin = root:Packages:YT:tWin
	SetAxis/W=$tWin left, lmin, lmax
	SetAxis/W=$tWin bottom, bmin, bmax
	DoWindow/F $tWin
End

Function t_Prep_Cat_vs_Scat(ctrlName) : ButtonControl
	String ctrlName
	String keyword
	Variable n_column
	SVAR tWin = root:Packages:YT:tWin // graph
	DoAlert 1, "Select target graph as the tWin, and DoWindow/F the table which contain srcWaves as possible.  OK? "
	If(V_flag == 2)
		Abort
	endif
	Prompt keyword, "Define \"keyword\""
	Prompt n_column, "Enter the number of column (integer)"
	DoPrompt "Define Param.", keyword, n_column
	Make/n = (n_column) $("NaN_"+ keyword)
	Make/n = (n_column) $("scale_" + keyword)
	Wave NaN_wave = $("NaN_"+ keyword)
	Wave scale_wave = $("scale_" + keyword)
	NaN_Wave = NaN
	scale_wave = x + 1
	If(Strlen(StringFromList(0, WinList("*", ";", "Win:2"))) > 1)
		AppendToTable NaN_wave, scale_wave
	endif
	If(WinType(tWin) == 1)
		AppendToGraph/W = $(tWin)/B = $("scale_"+keyword) NaN_wave vs scale_wave
		ModifyGraph axThick($("scale_"+keyword))=0
		ModifyGraph noLabel($("scale_"+keyword))=2
		SetAxis $("scale_"+keyword) (0.5),(n_column + 0.5)
	endif
End

Function t_Append_Category_vs_Scat(ctrlName) : ButtonControl
	String ctrlName
	String y_wave_name, x_wave_name, bottom_axis_name
	SVAR tWin = root:Packages:YT:tWin // graph
	DoAlert 1, "Select target graph as the tWin, and DoWindow/F the table which contain srcWaves as possible.  OK? "
	If(V_flag == 2)
		Abort
	endif
	Prompt y_wave_name "Select y_wave", popup wavelist("*", ";","WIN:"+ WinName(0,2))
	Prompt x_wave_name "Select y_wave", popup wavelist("*", ";", "WIN:"+ WinName(0,2))
	Prompt bottom_axis_name "Select axis_name", popup wavelist("scale_*", ";", "")
	DoPrompt "Select Each Param.", y_wave_name, x_wave_name, bottom_axis_name
	If(V_flag)
		Abort
	endif
	Wave y_wave = $y_wave_name
	Wave x_wave = $x_wave_name
	If(WinType(tWin) == 1)	
		AppendToGraph/W=$tWin/B = $bottom_axis_name $y_wave_name vs $x_wave_name
		ModifyGraph mode($y_wave_name) = 3, marker($y_wave_name) = 8, rgb($y_wave_name) = (0,0,0)
	endif
End

Function t_ModifyGraphSize(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:YT:tWin
	String StringSwitch
	Prompt StringSwitch "Select Window Size (cm)", popup "3*3;4*3;3.5*3.5;4*4;5*5;4.5*6;7.5*7.5;10*10;"
	DoPrompt "ModifyGraphSize/W = tWin width = , height =" StringSwitch
	If(V_flag)
		Abort
	endif
	
	Variable x, y
	sscanf StringSwitch, "%f*%f", x, y
	ModifyGraph/W=$tWin width = x*28.3465, height = y*28.3465
End

Function t_Graphmargin(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	String left, bottom, right, top
	Prompt left "Enter left-margin in cm"
	Prompt bottom "Enter bottom-margin in cm"
	Prompt right "Enter right-margin in cm"
	Prompt top "Enter top-margin in cm"
	DoPrompt "Enter numbers in one bite characters.\rNo character will be considered for auto adjustment.", left, bottom, right, top
	Variable vleft = Str2Num(left)
	Variable vbottom = Str2Num(bottom)
	Variable vright = Str2Num(right)
	Variable vtop = Str2Num(top)
	
	If(Strlen(left) == 0)
		ModifyGraph/W=$tWin margin(left)=0
	else
		If(Numtype(vleft) == 0)
			ModifyGraph/W=$tWin margin(left)=28*vleft
		endIf
	endIf
	
	If(Strlen(bottom) == 0)
		ModifyGraph/W=$tWin margin(bottom)=0
	else
		If(Numtype(vbottom) == 0)
			ModifyGraph/W=$tWin margin(bottom)=28*vbottom
		endIf
	endIf
	
	If(Strlen(right) == 0)
		ModifyGraph/W=$tWin margin(right)=0
	else
		If(Numtype(vright) == 0)
			ModifyGraph/W=$tWin margin(right)=28*vright
		endIf
	endIf
	
	If(Strlen(top) == 0)
		ModifyGraph/W=$tWin margin(top)=0
	else
		If(Numtype(vtop) == 0)
			ModifyGraph/W=$tWin margin(top)=28*vtop
		endIf
	endIf
End

Function t_ModifyGraphWidthPlan(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	If(WinType(tWin)==1)
		ModifyGraph/W=$tWin width={Plan, 1, top, left}
	endif
End

Function t_SetVarProc_GraphLN(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	If(Wintype(tWin) == 1)
		String t =  StringFromList(varNum, wavelist("*",";","Win:" + tWin))
		Wave dw = $t
		If(strlen(t) > 0)
			If(strlen(StringByKey("TNAME",CsrInfo(A))) == 00)
				Cursor A $t leftx(dw)
			else
				Cursor A $t xcsr(A)
			endif
 			tWave0 = t
 		endif
	endif
End

Function t_PopMenuProcGraphMode(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tWave0 = root:Packages:YT:tWave0
	String t = "ModifyGraph mode(" + tWave0 + ") =" + Num2str(popNum-1)
	Execute t
End

Function t_PopMenuProcColor(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tWave0 = root:Packages:YT:tWave0
	String t = "ModifyGraph rgb(" + tWave0 + ") = " + popStr
	Execute t
End

Function t_PopMenuProcLineStyle(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tWave0 = root:Packages:YT:tWave0
	String t = "ModifyGraph lstyle(" + tWave0 + ")=" + Num2str(popNum-1)
	Execute t
End

Function t_PopMenuProcMarker(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	SVAR tWave0 = root:Packages:YT:tWave0
	String t = "ModifyGraph marker(" + tWave0 + ")=" + Num2str(popNum - 1)
	Execute t
End

Function t_PopMenuProcPattern(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

End

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//StatPanel

Function t_cpN02()
	NewPanel/N=StatPanel/W=(600, 5, 1000, 655)
	TabControl tb3 pos={4,4}, size={388,610}, proc=t_TabProc02
	TabControl tb3, tabLabel(0) = "1"
	TabControl tb3, tabLabel(1) = "2"
	TabControl tb3, tabLabel(2) ="m"
	TabControl tb3, tabLabel(3) ="2*2"
	TabControl tb3, tabLabel(4) ="distr"
//tab30
	TitleBox TitleBox_1_Wave_tab30,pos={14,27},size={140,12},frame = 0, title="One Wave Analysis or Test"
//tab31
	PopupMenu PopUpPara_or_nonPara_tab31,pos={12,25},size={148,20},mode=1,popvalue="Yes",value= #"\"Yes;No\"",proc=PopMenuPara_nonPara31,title="Parametric Test?"
	PopupMenu PopMenuPapametric_tab31,pos={9,48},size={163,20},mode=1,popvalue="Select",value= #"\"Paired t-test;Un paired t-test (student's or Welch's)\"",proc=PopMenuSelectTestPara31,title="Parametric"
	PopupMenu PopUp_SelectTestNonPara_tab31,pos={15,69},size={223,20},mode=1,popvalue="Select",value= #"\"Wilcoxon signed rank test;Wilcoxon-Mann Whitney U-test\"",proc=PopMenuProcSelectTestNonPara31,title="Non-Para"
	ModifyControlList ControlNameList("",";","!*_tab30") disable=1
	ModifyControl tb3 disable=0
end

Function t_TabProc02 (ctrlName, tabNum) : TabControl
	String ctrlname
	Variable tabNum
	String controlsInATab= ControlNameList("",";","*_tab3*")
	String curTabMatch="*_tab3"+Num2str(tabNum)
	String controlsInCurTab= ListMatch(controlsInATab, curTabMatch)
	String controlsInOtherTab= ListMatch(controlsInATab, "!"+curTabMatch)
	ModifyControlList controlsInCurTab disable = 0 //show
	ModifyControlList controlsInOtherTab disable = 1 //hide
end

//tab30

//tab31
Function PopMenuPara_nonPara31(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	Switch (popNum)
		case 1:
			PopupMenu PopMenuPapametric_tab31 disable=0
			PopupMenu PopUp_SelectTestNonPara_tab31 disable=2
			break
		case 2:
			PopupMenu PopMenuPapametric_tab31 disable=2
			PopupMenu PopUp_SelectTestNonPara_tab31 disable=0
			break
		default:
			break
	endSwitch
End

Function PopMenuSelectTestPara31(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	PopupMenu PopUpPara_or_nonPara_tab31 mode=1
	PopupMenu PopUp_SelectTestNonPara_tab31 disable=2
End

Function PopMenuProcSelectTestNonPara31(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	Print popNum
	PopupMenu PopUpPara_or_nonPara_tab31 mode=2
	PopupMenu PopMenuPapametric_tab31 disable=2
End
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ImagePanel 

Function t_cpN03()
	NewPanel/N=ImagePanel/W=(300, 5, 680, 355)
	TabControl tb4 pos={5,5}, size={370,340}, proc=t_TabProc03
	TabControl tb4, tabLabel(0) = "Cursor"
	TabControl tb4, tabLabel(1) = "Graph"
	TabControl tb4, tabLabel(2) = "Table"
	TabControl tb4, tabLabel(3) = "Edit"
	TabControl tb4, tabLabel(4) = "Analysis"
	

//tab40
	Button BtCursorAUP_tab40,pos={45,30},size={20,20},proc=t_CursorAI,title="A"
	Button BtCursorAD_tab40,pos={45,70},size={20,20},proc=t_CursorAI,title="V"
	Button BtCursorAR_tab40,pos={65,50},size={20,20},proc=t_CursorAI,title=">"
	Button BtCursorAL_tab40,pos={25,50},size={20,20},proc=t_CursorAI,title="<"
	Button BtCursorBUP_tab40,pos={145,30},size={20,20},proc=t_CursorBI,title="A"
	Button BtCursorBD_tab40,pos={145,70},size={20,20},proc=t_CursorBI,title="V"
	Button BtCursorBR_tab40,pos={165,50},size={20,20},proc=t_CursorBI,title=">"
	Button BtCursorBL_tab40,pos={125,50},size={20,20},proc=t_CursorBI,title="<"

//tab41
	Button BtNewImage_tab41,pos={10,25},size={50,20},proc=t_NewImage,title="NewImg"
//tab42
//tab43
	Button BtNagativeTransform_tab43,pos={120,25},size={50,20},proc=t_Negative,title="Nega"
//tab44
	Button BtImageStats_tab44,pos={10,25},size={50,20},proc=t_ImageStats,title="ImgStats"
	Button BtImageProfile_tab44, pos={60, 25}, size={50,20}, proc=t_ImageLineProfile, title="ImgLP"

	ModifyControlList ControlNameList("",";","!*_tab40") disable=1
	ModifyControl tb4 disable=0
end

Function t_TabProc03 (ctrlName, tabNum) : TabControl
	String ctrlname
	Variable tabNum
	String controlsInATab= ControlNameList("",";","*_tab4*")
	String curTabMatch="*_tab4"+Num2str(tabNum)
	String controlsInCurTab= ListMatch(controlsInATab, curTabMatch)
	String controlsInOtherTab= ListMatch(controlsInATab, "!"+curTabMatch)
	ModifyControlList controlsInCurTab disable = 0 //show
	ModifyControlList controlsInOtherTab disable = 1 //hide
end

//tab40
Function t_CursorAI(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	StrSwitch (ctrlName)
		case "BtCursorAUP_tab40":
			Cursor/I/W=$tWin A $tWave0 xcsr(A), vcsr(A) + DimDelta(srcWave, 1)
			break
		case "BtCursorAD_tab40":
			Cursor/I/W=$tWin A $tWave0  xcsr(A), vcsr(A) - DimDelta(srcWave, 1)
			break
		case "BtCursorAR_tab40":
			Cursor/I/W=$tWin A $tWave0  xcsr(A) + DimDelta(srcWave, 0), vcsr(A)
			break
		case "BtCursorAL_tab40":
			Cursor/I/W=$tWin A $tWave0  xcsr(A) - DimDelta(srcWave, 0), vcsr(A)
			break
		default:
			break
	endSwitch		
End

Function t_CursorBI(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	Wave srcWave = $tWave0
	StrSwitch (ctrlName)
		case "BtCursorBUP_tab40":
			Cursor/I/W=$tWin B $tWave0 xcsr(B), vcsr(B) + DimDelta(srcWave, 1)
			break
		case "BtCursorBD_tab40":
			Cursor/I/W=$tWin B $tWave0  xcsr(B), vcsr(B) - DimDelta(srcWave, 1)
			break
		case "BtCursorBR_tab40":
			Cursor/I/W=$tWin B $tWave0  xcsr(B) + DimDelta(srcWave, 0), vcsr(B)
			break
		case "BtCursorBL_tab40":
			Cursor/I/W=$tWin B $tWave0  xcsr(B) - DimDelta(srcWave, 0), vcsr(B)
			break
		default:
			break
	endSwitch		
End

//tab41
Function t_NewImage(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	NewImage $tWave0
End

//tab42

//tab43
Function t_Negative(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWave0 = root:Packages:YT:tWave0
	Make/B/U/O/N=256 negativeLookup=255-x			// create the lookup table	
	String nega = "nega"+tWave0
	Duplicate/O $tWave0 $nega
	Wave w_nega = $nega
	w_nega = negativeLookup[w_nega]		// the lookup transformation
	NewImage w_nega
End
//tab44
Function t_ImageStats(ctrlName) : ButtonControl
	String ctrlName

End

Function t_ImageLineProfile(ctrlName) : ButtonControl
	String ctrlName
	SVAR tWin = root:Packages:YT:tWin
	SVAR tWave0 = root:Packages:YT:tWave0
	DoWindow/F $tWin
	Make/O/N=2 xPoints={xcsr(A),xcsr(B)}, yPoints={vcsr(A),vcsr(B)}
	String SFL
	Variable i = 0
	do
		If(Strlen(StringFromList(i, WaveList("*", ";", "WIN:"+tWin))) == 0)
			Break
		endif
		SFL = StringFromList(i, WaveList("*", ";", "WIN:"+tWin))
		If(StringMatch(SFL, "yPoints"))
			RemoveFromGraph/W=$tWin $SFL
		endif
		i+=1
	while(1)
	AppendToGraph/T yPoints vs xPoints	// display the path on the image
	// calculate the profile
	Wave dw = $tWave0
	ImageLineProfile xwave=xPoints, ywave=yPoints, srcwave=$tWave0
	If(Strlen(Winlist("Graph_LP",";","Win:1"))>1)
		Print "test"
		DoWindow/K Graph_LP
		Display/N=Graph_LP/T M_ImageLineProfile vs W_LineProfileX		// display the profile
	else
		Display/N=Graph_LP/T M_ImageLineProfile vs W_LineProfileX
	endif
End

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TestPanel
Function t_cpN04()
	NewPanel/N=TestPanel/W=(300, 5, 680, 355)
	TabControl tb5 pos={5,5}, size={370,340}, proc=t_TabProc04
	TabControl tb5, tabLabel(0) = "Cursor"
	TabControl tb5, tabLabel(1) = "Graph"

//tab50
	Button BtDoTest_tab50,pos={10,25},size={50,20},proc=t_TestGlobal,title="DoTest"
	PopupMenu Popup_TestPanel_tab50,pos={84,25},size={100,20},proc=t_PopupTestPanel
	PopupMenu Popup_TestPanel_tab50,mode=1,bodyWidth= 100,popvalue="Global_Test.ipf",value= #"\"Global_Test.ipf;Global_Procedure.ipf;Procedure;\""
//
	ModifyControlList ControlNameList("",";","!*_tab50") disable=1
	ModifyControl tb5 disable=0
end

Function t_TabProc04 (ctrlName, tabNum) : TabControl
	String ctrlname
	Variable tabNum
	String controlsInATab= ControlNameList("",";","*_tab5*")
	String curTabMatch="*_tab5"+Num2str(tabNum)
	String controlsInCurTab= ListMatch(controlsInATab, curTabMatch)
	String controlsInOtherTab= ListMatch(controlsInATab, "!"+curTabMatch)
	ModifyControlList controlsInCurTab disable = 0 //show
	ModifyControlList controlsInOtherTab disable = 1 //hide
end

//tab50
Function t_PopupTestPanel(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	DisplayProcedure/W = $popStr
End

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Reference Function

Function UserCursorAdjust(grfName)
	String grfName

	DoWindow/F $grfName				// Bring graph to front
	if (V_Flag == 0)					// Verify that graph exists
		Abort "UserCursorAdjust: No such graph."
		return -1
	endif

	NewDataFolder/O root:tmp_PauseforCursorDF
	Variable/G root:tmp_PauseforCursorDF:canceled= 0

	NewPanel/K=2 /W=(139,341,382,450) as "Pause for Cursor"
	DoWindow/C tmp_PauseforCursor					// Set to an unlikely name
	AutoPositionWindow/E/M=1/R=$grfName			// Put panel near the graph

	DrawText 21,20,"Adjust the cursors and then"
	DrawText 21,40,"press Continue."
	Button button0,pos={80,58},size={92,20},title="Continue"
	Button button0,proc=UserCursorAdjust_ContButtonProc
	Button button1,pos={80,80},size={92,20}
	Button button1,proc=UserCursorAdjust_CancelBProc,title="Cancel"

	PauseForUser tmp_PauseforCursor,$grfName

	NVAR gCaneled= root:tmp_PauseforCursorDF:canceled
	Variable canceled= gCaneled			// Copy from global to local before global is killed
	KillDataFolder root:tmp_PauseforCursorDF

	return canceled
End

Function UserCursorAdjust_ContButtonProc(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/K tmp_PauseforCursor			// Kill self
End

Function UserCursorAdjust_CancelBProc(ctrlName) : ButtonControl
	String ctrlName
	Variable/G root:tmp_PauseforCursorDF:canceled= 1
	DoWindow/K tmp_PauseforCursor			// Kill self
End

Function t_PressEscapeToAbort(phase, title, message)
	Variable phase				// 0: Display control panel with message.
								// 1: Test if Escape is pressed.
								// 2: Close control panel.
	String title					// Title for control panel.
	String message				// Tells user what you are doing.
	
	if (phase == 0)				// Create panel
		DoWindow/F PressEscapePanel
		if (V_flag == 0)
			NewPanel/K=1 /W=(100,100,350,200)
			DoWindow/C PressEscapePanel
			DoWindow/T PressEscapePanel, title
		endif
		TitleBox Message,pos={7,8},size={69,20},title=message
		String abortStr = "Press escape to abort"
		TitleBox Press,pos={6,59},size={106,20},title=abortStr
		DoUpdate
	endif
	
	if (phase == 1)						// Test for Escape
		Variable doAbort = 0
		if (GetKeyState(0) & 32)			// Is Escape pressed now?
			doAbort = 1
		else
			if (strlen(message) != 0)		// Want to change message?
				TitleBox Message,title=message
				DoUpdate
			endif
		endif
		return doAbort
	endif
	
	if (phase == 2)						// Kill panel
		DoWindow/K PressEscapePanel
	endif
	
	return 0
End
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Fit_Function
Function iv(w,x) : FitFunc
	Wave w
	Variable x

	//CurveFitDialog/ These comments were created by the Curve Fitting dialog. Altering them will
	//CurveFitDialog/ make the function less convenient to work with in the Curve Fitting dialog.
	//CurveFitDialog/ Equation:
	//CurveFitDialog/ f(x) = pa_0*(x-pa_1)*1/(1+exp(-(x-pa_2)/pa_3))
	//CurveFitDialog/ End of Equation
	//CurveFitDialog/ Independent Variables 1
	//CurveFitDialog/ x
	//CurveFitDialog/ Coefficients 4
	//CurveFitDialog/ w[0] = pa_0
	//CurveFitDialog/ w[1] = pa_1
	//CurveFitDialog/ w[2] = pa_2
	//CurveFitDialog/ w[3] = pa_3

	return w[0]*(x-w[1])*1/(1+exp(-(x-w[2])/w[3]))
End

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
