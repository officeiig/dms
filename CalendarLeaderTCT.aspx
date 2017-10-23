<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CalendarLeaderTCT.aspx.cs" Inherits="OfficeOne.Web.Administrative.CalendarLeaderTCT" %>


<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lịch lãnh đạo TCT</title>
    <link href="/_layouts/officeone/Theme/Default/Icons/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
    <script type="text/javascript" src="/_layouts/officeone/Theme/Default/Scripts/ext-vn.js">
    </script>
    <script src="/_layouts/officeone/Theme/Default/Scripts/common.js?v=14" type="text/javascript"></script>
    <script src="/_layouts/officeone/Theme/Default/Scripts/encoder.js" type="text/javascript"></script>
    <%--Phần hiển thị chọn người dùng--%>
    <link href="/_layouts/officeone/Theme/Default/Styles/BoxSelect.css" rel="stylesheet" type="text/css" />
    <script src="/_layouts/officeone/Theme/Calendar/BoxSelectDefine.js" type="text/javascript"></script>
    <script src="/_layouts/officeone/Theme/Calendar/doc_inboxselect.js?v=1" type="text/javascript"></script>
    <script src="/_layouts/officeone/Theme/Calendar/doc_inboxselect-data.js" type="text/javascript"></script>

    <link href="/_layouts/officeone/Theme/Calendar/calendarGoogle.css" rel="stylesheet" type="text/css" />
    <link href="/_layouts/officeone/Theme/Calendar/tooltip/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="/_layouts/officeone/Theme/Calendar/tooltip/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="/_layouts/officeone/Theme/Calendar/tooltip/jquery-ui.js" type="text/javascript"></script>
    <%--Add on CSS by vucuongkg --%>
    <link href="/_layouts/officeone/Theme/Default/Styles/v1.css" rel="stylesheet" />
    <link href="/_layouts/officeone/Theme/Calendar/calendarLeader.css" rel="stylesheet" type="text/css" />
    <script>
        $(function () {
            $(document).tooltip({
                items: "img, [data-geo], [title]",
                content: function () {
                    var element = $(this);
                    if (element.is("[title]")) {
                        return element.attr("title");
                    }
                    if (element.is("img")) {
                        return element.attr("alt");
                    }
                }
            });
        });
    </script>
    

</head>
<body>
    <form id="form1" runat="server">
        <script language="javascript" type="text/javascript">

            function filterByLeader() {
                setDataForm();
                Refresh();
            }
            function clearValue() {
                //App.txtLanhDao.clearValue();
                App.hdfIDLanhDao.setValue("");
                App.hdfTenLanhDao.setValue("");
                Refresh();
            }

            var reLoadData = function () {
                Search();
            };

            var searchConstain = function (record) {
                record.query = new RegExp(record.query, 'i');
                record.forceAll = true;
            };
            var addNewCalendar = function (parameters, roomid) {
                url = '/_layouts/officeone/Administrative/Ad_Calendar_Add.aspx?Date=' + parameters + '&RoomId=' + roomid;
                title = '<%=ResourceLabel("Ad_Calendar_Add") %>';
                id = "Ad_Calendar_Add";
                window.top.newWindowCalendar(url, { id: id, title: title, height: 600, width: 1000, modal: true });
            };
            var ThemMoi = function () {
                url = '/_layouts/officeone/Administrative/Ad_Calendar_Add.aspx?type=home';
                title = '<%=ResourceLabel("Ad_Calendar_Add") %>';
                id = "Ad_Calendar_Add";
                window.top.newWindowCalendar(url, { id: id, title: title, height: 600, width: 1000, modal: true });
            };
            var DanhSach = function () {
                var url = '/_layouts/officeone/Administrative/Ad_Calendar_Lists.aspx?type=2';
                window.top.addDefaultTab('Tab_LichHop', url, '<%=ResourceLabel("Ad_Calendar_List") %>', true);
            };

            var LichThang = function () {
                App.btnLichNgay.removeCls("active");
                App.btnLichTuan.removeCls("active");
                App.btnLichThang.addCls("active");
                App.btnRoom.removeCls("active");
                App.direct.LoadCalendarType("p_month");
                App.hdfCalendarType.setValue("p_month");
            };
            var LichTuan = function () {
                App.btnLichNgay.removeCls("active");
                App.btnLichTuan.addCls("active");
                App.btnLichThang.removeCls("active");
                App.btnRoom.removeCls("active");
                App.direct.LoadCalendarType("p_week");
                App.hdfCalendarType.setValue("p_week");
            };
            var LichNgay = function () {
                App.btnLichNgay.addCls("active");
                App.btnLichTuan.removeCls("active");
                App.btnLichThang.removeCls("active");
                App.btnRoom.removeCls("active");
                App.direct.LoadCalendarType("p_day");
                App.hdfCalendarType.setValue("p_day");
            };
            var LichRoom = function () {
                App.btnRoom.addCls("active");
                App.btnLichTuan.removeCls("active");
                App.btnLichThang.removeCls("active");
                App.btnLichNgay.removeCls("active");
                App.direct.LoadCalendarType("p_room");
                App.hdfCalendarType.setValue("p_room");
            };
            var showPopup = function (id, guid) {
                if (guid == null || guid == '' || guid == 'undefined') {
                    guid = '';
                }
                var url = '/_layouts/officeone/Administrative/Ad_Calendar_Detail.aspx?itemid=' + id + '&guid=' + guid;
                title = '<%=ResourceLabel("Ad_Calendar_View") %>';
                id = "Ad_Calendar_View";
                window.top.newWindowCalendar(url, { id: id, title: title, height: 600, width: 1000, modal: true });
            };
            var InLich = function InLich() {

                var divContent = document.getElementById('NoiDungLich');

                var printConent = document.getElementById('LichContent');

                divContent.style.height = 'auto';
                divContent.style.overflow = 'hidden';
                var printHtml = printConent.innerHTML;

                divContent.style.height = (App.pnShowViewDetail.getHeight() - 50) + "px";
                divContent.style.background = '#fff';
                divContent.style.overflow = 'auto';

                var WinPrint = window.open('', '', 'letf=0,top=0,toolbar=0,scrollbars=0,status=0');
                WinPrint.document.write("<head><style> #week-cal-style{border-collapse:collapse!important;float:left}#week-cal-style th{border:1px solid #c6dbff!important;padding:2px!important;padding:2px;word-wrap:break-word!important}#week-cal-style td{border:1px solid #c6dbff!important;padding:2px 0px !important;padding:2px;word-wrap:break-word!important;}#week-cal-style th{font-weight:bold;text-align:center;background-color:#e8eef7;padding-top:7px!important;padding-bottom:7px!important}#week-cal-style tr th.p9{width:9%;font-weight:bold}#week-cal-style tr th.p8{width:9%;word-breadk:break-word;font-weight:bold}#week-cal-style tr th.p13{width:12%}#week-cal-style tr th.p11{width:11%}.TuanThu{font-weight:bold;font-size:11pt}.tuan_khoangtg{font-size:9pt;padding-top:5px}.tblChiTietLich_today{font-weight:bold;width:8%;padding:2px;background:#ffc}.tblChiTietLich{width:9%;font-weight:bold;background-color:#fff;word-wrap:break-word!important}.lichpheduyet{background:#edf3f3;word-wrap:break-word!important;}.lichchuaduyet{background-color:#dabba9;word-wrap:break-word!important;}</style></head><body>" + printHtml + "</body>");
                WinPrint.document.close();
                WinPrint.focus();
                WinPrint.print();
                WinPrint.close();
                return false;
            }
            var FirstLoad = function () {
                //App.btnThemMoi.setText('<%=ResourceLabel("Ad_Calendar_Add") %>');

                App.btnInLich.setText('<%=ResourceLabel("Ad_Calendar_Print") %>');
                App.btnLast.setText('<%=ResourceLabel("CM_LASTWEEK") %>');
                App.btnCurent.setText('<%=ResourceLabel("CM_THISWEEK") %>');
                App.btnNext.setText('<%=ResourceLabel("Ad_Calendar_NextWeek") %>');

                document.getElementById("coporateEmp-inputEl").placeholder = "<%=ResourceLabel("Delegate_Leader")%>";
            };
            var updateResult = function (Ids) {

                if (Ids == "1")
                    Ext.net.Notification.show({
                        html: '<%=ResourceLabel("CM_UpdateSuccess")%><br><br><%=ResourceLabel("Ad_Identical")%>',
                        title: '<%= ResourceLabel("CM_Notice") %>'
                    });
                else
                    Ext.net.Notification.show({
                        html: '<%=ResourceLabel("CM_UpdateSuccess") %>',
                        title: '<%= ResourceLabel("CM_Notice") %>'
                    });
                Refresh();
            }
            var Refresh = function () {
                App.direct.Refresh(true, {
                    success: function (result) {
                    },
                    eventMask: {
                        showMask: true,
                        minDelay: 500
                    }
                });
                //setTitle();
            }
            parent.window.closeCalendar = function (Ids) {
                window.top.Ext.WindowMgr.getActive().destroy();
                delayRefresh(Ids);
            };
            var showtooltip = function () {
            };
            var setTitle = function () {
                //window.top.setTitle();
            };
        </script>

        <script language="javascript" type="text/javascript">

            var isFirtChoice = true;
            var idEmpChoice = "";
            var showEmpWindow = function (idTriger) {
                idEmpChoice = idTriger;
                if (idEmpChoice = "txtCoporateEmp") {
                    App.hdfKindSelect.setValue("1");
                    App.hdfKindType.setValue("chooseUserMulti");
                    App.hdfIsLeader.setValue("false");
                    App.wdShow.getLoader().load();
                    App.wdShow.show();
                }
            };

            // Hiển thị giá trị chọn cá nhân
            var setEmpData = function () {
                var deptTree = App.wdShow.getBody().App.TrpDonVi;
                var empGrid = App.wdShow.getBody().App.gridSelectedUser;
                //Xóa giá trị của grid được chọn, gán giá trị được chọn
                var storeGrid = empGrid.getStore().removeAll();
                // Xóa checked của cây đơn vị
                var allChecked = depTree.getChecked();
                for (var i = 0; i < allChecked.length; i++) {
                    allChecked[i].set('checked', false);
                }
                if (idEmpChoice = "txtCoporateEmp") {
                    var depId = App.hdfCoporateEmpID.getValue();
                    var depName = App.hdfCoporateEmpName.getValue();

                }
                // Gán giá trị không phải lần chọn đầu tiên
                if (isFirtChoice) isFirtChoice = false;
            };

            // Gán giá trị vào grid
            var addEmpToGrid = function (id, title) {
                var RecordDef = Ext.define('Data', {
                    extend: 'Ext.data.Model',
                    fields: [
                        { name: 'ID', type: 'string' },
                        { name: 'Title', type: 'string' }
                    ]
                });
                var NewRecord = new RecordDef({
                    ID: id,
                    Title: title
                });
                App.wdShow.getBody().App.gridSelectedUser.getStore().add(NewRecord);
            };


            var allowAddUser = function () {
                App.wdShow.hide();
                App.direct.AddUser({
                    success: function (result) {
                        //     applyFilter();
                    },
                    eventMask: {
                        showMask: true,
                        minDelay: 500
                    }
                });
            }
            var closeAddUser = function () {
            }
        </script>

        <%--Phần gán giá trị trước khi lưu, Gán giá trị khi sửa form--%>
        <script type="text/javascript">
            var setDataForm = function () {

                //alert(App.Room.displayTplData[0].ID);

                //Lấy giá trị cá nhân tham gia
                var coporateEmp = App.coporateEmp;
                if (coporateEmp.displayTplData != null && coporateEmp.displayTplData.length > 0) {
                    App.hdfCoporateEmpID.setValue(coporateEmp.displayTplData[0].ID);
                    for (var i = 1; i < coporateEmp.displayTplData.length; i++) {
                        App.hdfCoporateEmpID.setValue(App.hdfCoporateEmpID.getValue() + ";" + coporateEmp.displayTplData[i].ID);
                    }
                }
                //Lấy giá trị đơn vị tham gia
                var coporateDep = App.coporateDep;
                if (coporateDep.displayTplData != null && coporateDep.displayTplData.length > 0) {
                    App.hdfDepCoporateID.setValue(coporateDep.displayTplData[0].ID);
                    for (var i = 1; i < coporateDep.displayTplData.length; i++) {
                        App.hdfDepCoporateID.setValue(App.hdfDepCoporateID.getValue() + ";" + coporateDep.displayTplData[i].ID);
                    }
                }
                //Lấy giá trị phòng họp
                var room = App.Room;
                if (room.displayTplData != null && room.displayTplData.length > 0) {
                    App.hdfRoomID.setValue(room.displayTplData[0].ID);
                    //App.hdfRoomName.setValue(room.displayTplData[1].Title);
                }
            };
            // Hàm gán giá trị khi sửa văn bản
            var loadData = function () {
                ////Chủ trì
                //var lsMainEmpID = App.hdfMainEmpID.getValue().split(';');
                //var lsID = new Array();

                //for (var i = 0; i < lsMainEmpID.length; i++) {
                //    lsID[i] = lsMainEmpID[i];
                //}
                //App.UserText.setValue(lsID);

                //Cá nhân tham gia
                var lsCoporateEmp = App.hdfCoporateEmpID.getValue().split(';');
                var lsCE_ID = new Array();
                for (var i = 0; i < lsCoporateEmp.length; i++) {
                    lsCE_ID[i] = lsCoporateEmp[i];
                }
                App.coporateEmp.setValue(lsCE_ID);

                //Phòng ban tham gia
                var lsDepProposeID = App.hdfDepCoporateID.getValue().split(';');
                var lsID = new Array();

                for (var i = 0; i < lsDepProposeID.length; i++) {
                    if (lsDepProposeID[i] != "") {
                        lsID[i] = parseInt(lsDepProposeID[i]);
                    }
                }
                App.coporateDep.setValue(lsID);

                //Phòng họp
                var lsRoom = App.hdfRoomID.getValue().split(';');
                var arrRoom_ID = new Array();
                for (var i = 0; i < lsRoom.length; i++) {
                    arrRoom_ID[i] = lsRoom[i];
                }
                App.Room.setValue(arrRoom_ID);
            };
        </script>
        <script type="text/javascript">


            var triggerClickCoporate = function (el, trigger, tag, auto, index) {

                if (tag == "clearTxtCoporateEmp") {
                    App.hdfCoporateEmpID.setValue('');
                    App.hdfCoporateEmpName.setValue('');
                    Search();
                } else {
                    App.hdfIsLeader.setValue('false');
                    showEmpWindow('txtCoporateEmp');
                }


            }

            var triggerClick = function (el, trigger, tag, auto, index) {
                switch (tag) {
                    case "AddDep":
                        showDepWindow('txtMeetingScope');
                        break;
                    case "ClearDep":
                        //App.txtMeetingScope.setValue("");
                        App.hdfMeetingScopeID.setValue("");
                        App.hdfMeetingScopeName.setValue("");
                        break;
                    case "CleartxtDep":
                        //App.txtDep.setValue("");
                        App.hdfDepCoporateID.setValue("");
                        App.hdfDepCoporateName.setValue("");
                        break;

                    case "AddtxtDep":
                        showDepWindow('txtDep');
                        break;
                }
            };
            var isFirtChoice = true;
            var idDepChoice = "";
            var showDepWindow = function (idTriger) {
                idDepChoice = idTriger;
                App.wdShowdeparment.show();
                // Không phải lần đầu thì gán lại giá trị đã chọn
                //              if (!isFirtChoice) {
                setDepartmentData(idDepChoice);
                //              }
            };
            // Gán giá trị chọn đơn vị
            var getDepartmentData = function (depId, depName) {
                if (idDepChoice == 'txtDep') {
                    App.wdShowdeparment.getBody().App.hdfDepID.setValue(depId);
                    App.wdShowdeparment.getBody().App.hdfDepName.setValue(depName);
                    App.hdfDepCoporateID.setValue(depId);
                    App.hdfDepCoporateName.setValue(Ext.String.htmlDecode(depName));
                    //App.txtDep.setValue(Ext.String.htmlDecode(depName.substring(1, depName.length - 1)));
                }

                else if (idDepChoice == 'txtMeetingScope') {
                    App.hdfMeetingScopeID.setValue(depId);
                    App.hdfMeetingScopeName.setValue(Ext.String.htmlDecode(depName));
                    //App.txtMeetingScope.setValue(Ext.String.htmlDecode(depName));
                }

                App.wdShowdeparment.hide();
            };
            // Hiển thị giá trị chọn đơn vị
            var setDepartmentData = function () {
                var depTree = App.wdShowdeparment.getBody().App.treeDonVi;
                var depGrid = App.wdShowdeparment.getBody().App.gridDonVi;
                //Xóa giá trị của grid được chọn, gán giá trị được chọn
                var storeGrid = depGrid.getStore().removeAll();
                // Xóa checked của cây đơn vị
                var allChecked = depTree.getChecked();
                for (var i = 0; i < allChecked.length; i++) {
                    allChecked[i].set('checked', false);
                }
                switch (idDepChoice) {
                    case 'txtDep':
                        {
                            App.wdShowdeparment.getBody().App.hdfSelectOne.setValue("1");
                            App.wdShowdeparment.getBody().App.hdfDepID.setValue(depId);
                            App.wdShowdeparment.getBody().App.hdfDepName.setValue(depName);
                            var depId = App.hdfDepCoporateID.getValue();
                            var depName = App.hdfDepCoporateName.getValue();
                            break;
                        }

                    case 'txtMeetingScope':
                        {

                            //                  //Xóa giá trị của grid được chọn, gán giá trị được chọn 
                            App.wdShowdeparment.getBody().App.hdfSelectOne.setValue("0");
                            var depId = App.hdfMeetingScopeID.getValue();
                            var depName = App.hdfMeetingScopeName.getValue();
                            App.wdShowdeparment.getBody().App.hdfDepID.setValue(depId);
                            App.wdShowdeparment.getBody().App.hdfDepName.setValue(depName);

                            break;
                        }

                }


            };
            // Gán giá trị vào grid

            var addDepToGrid = function (id, title) {
                var RecordDef = Ext.define('Data', {
                    extend: 'Ext.data.Model',
                    fields: [
                        { name: 'ID', type: 'string' },
                        { name: 'Title', type: 'string' }
                    ]
                });
                var NewRecord = new RecordDef({
                    ID: id,
                    Title: title
                });

                App.wdShowdeparment.getBody().App.gridDonVi.getStore().add(NewRecord);
            };
            var Typeroom = function () {
                App.direct.Typeroom(App.ckbTypeRoom.getValue(), {
                    success: function (result) {
                        //applyFilter();
                    },
                    eventMask: {
                        showMask: true,
                        minDelay: 500
                    }
                });
            }

            var Unsearch = function () {
                App.txtKeyWord.setValue('');
                App.txtTitle.setValue('');
                App.ckbTypeRoom.setValue('');
                App.txtLocal.setValue('');
                App.hdfDepCoporateID.setValue('');
                App.hdfCoporateEmpID.setValue('');
                App.hdfCoporateEmpName.getValue('');
                App.hdfMeetingScopeID.setValue('');
                App.hdfDepCoporateName.setValue('');
                App.hdfMeetingScopeName.setValue('');
                Refresh();
            };

            var clearRoom = function () {
                App.hdfRoomID.setValue('');
            };


            var Search = function () {

                var roomid = "";
                var roomname = "";

                var roomScope = "";

                if (App.coporateEmp.displayTplData.length <= 0) {
                    App.hdfCoporateEmpID.setValue("");
                    App.hdfCoporateEmpName.setValue("");
                }
                if (App.coporateDep.displayTplData.length <= 0) {
                    App.hdfDepCoporateID.setValue("");
                    App.hdfDepCoporateName.setValue("");
                }
                if (App.Room.displayTplData.length <= 0) {
                    App.hdfRoomID.setValue("");
                    App.hdfRoomName.setValue("");
                }
                if (App.hdfRoomID.getValue().trim() != "") {
                    roomid = App.hdfRoomID.getValue();
                }
                if (App.ckbTypeRoom.getValue() != null) {
                    roomScope = App.ckbTypeRoom.getValue().trim();
                    if (roomScope == "0")   //Thuoc quan ly
                        App.txtLocal.setValue("");
                    else //Khong thuoc quan ly
                    {
                        roomid = "";
                        roomname = "";
                    }
                }

                //App.direct.Search(App.hdfCoporateEmpID.getValue(), App.hdfCoporateEmpName.getValue(), App.hdfDepCoporateID.getValue(), App.hdfDepCoporateName.getValue(), App.ckbTypeRoom.getValue(), roomid, roomname,
                //    App.txtKeyWord.getValue(), App.txtTitle.getValue(), App.txtLocal.getValue(), {
                //        success: function(result) {
                //        },
                //        eventMask: {
                //            showMask: true,
                //            minDelay: 10
                //        }
                //    });
                var data = App.coporateEmp.getValue();
                if (data.length == 0) {
                    Ext.Msg.confirm('<%=ResourceLabel("CM_Confirm") %>', '<%=ResourceLabel("Doc_DraftChoseLeader") %>', function (btn) {
                        if (btn == "yes") {
                            App.coporateEmp.focus();
                        }
                    });
                } else {
                    App.direct.LoadCalendarType(App.hdfCalendarType.getValue());
                }
            };

        </script>
        <script type="text/javascript">
            var showCustomSearch = function () {
                var collaped = App.pnCustomSearch.getCollapsed();
                if (collaped) {
                    App.pnCustomSearch.expand();
                    App.btnCustomSearch.setIconCls("icon-arrowin");
                    App.btnCustomSearch.setTooltip('<%=ResourceLabel("btnCustomSearch_Collapse") %>');
                } else {
                    App.pnCustomSearch.collapse();
                    App.btnCustomSearch.setIconCls("icon-arrowout");
                    App.btnCustomSearch.setTooltip('<%=ResourceLabel("btnCustomSearch_Expand") %>');
                }
            };

            var showDataDecode = function () {
                App.txtLocal.setValue(Ext.String.htmlDecode(App.txtLocal.getValue()));
            };

            var loadStaffWindow = function (idTriger) {
                idEmpChoice = idTriger;
                switch (idEmpChoice) {
                    case "txtMainEmp":
                        App.hdfKindSelect.setValue("0");
                        App.hdfKindType.setValue("chooseUserOne");
                        break;
                }

                App.wdStaff.getLoader().load();
                App.wdStaff.show();

            };
            var EventClick = function (val) {
                App.direct.EventClick(val);
            };
            var Export = function () {
                var leader = App.hdfCoporateEmpID.getValue();
                if (leader == '') {
                    Ext.net.Notification.show({
                        html: '<%=ResourceLabel("Ad_Calendar_Choice") %>',
                        title: '<%= ResourceLabel("CM_Notice") %>'
                    });
                } else {

                    window.location.href = '<%=OfficeOneVNA.Util.WebUrl.UrlContext%>' + "/Administrative/ExportDoc.aspx?leader=" + leader;
                    //var array = leader.split(';');
                    //for (var i = 0; i < array.length; i++) {
                    //    ExportData(i, array[i]);
                    //}

                }
            };
            function ExportData(i, val) {
                setTimeout(function () {
                    window.location.href = '<%=OfficeOneVNA.Util.WebUrl.UrlContext%>' + "/Administrative/ExportDoc.aspx?leader=" + val;
                }, i * 5000);
            }


            var backVportal = function () {
                window.open('http://vportal.vietnamairlines.com/_layouts/officeone/default.aspx');
            }

            var changeCalendarView = function (typeView) {
                $("#btnWeekView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnMonthView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnQuaterView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnYearView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");

                $("#btnWeekView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnMonthView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnQuaterView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                $("#btnYearView").removeClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");

                switch (typeView) {
                    case 'week':
                        $("#btnWeekView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnMonthView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnQuaterView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnYearView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        break;
                    case 'month':
                        App.hdfCalendarType.setValue("p_month");
                        App.direct.LoadCalendarType("p_month");
                        $("#btnWeekView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnQuaterView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnYearView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnMonthView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");

                        $("#NoiDungLichNam").css("display", "none");
                        $("#NoiDungLich").css("display", "block");
                        $("#header-month-cal-style").css("display", "block");
                        break;
                    case 'quater':
                        $("#btnWeekView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnMonthView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnYearView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnQuaterView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        break;
                    case 'year':
                        App.hdfCalendarType.setValue("p_year");
                        App.direct.LoadCalendarType("p_year");
                        $("#btnWeekView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnMonthView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnQuaterView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right");
                        $("#btnYearView").addClass("goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right");

                        $("#NoiDungLichNam").css("display", "block");
                        $("#NoiDungLich").css("display", "none");
                        $("#header-month-cal-style").css("display", "none");

                        break;
                    default:
                        break;
                }
                //App.direct.EventClick(val);
                
                
            }


        </script>


        <ext:ResourceManager ID="ResourceManager" runat="server" ShowWarningOnAjaxFailure="False">
            <Listeners>
                <DocumentReady Handler="FirstLoad();showDataDecode();setTitle();loadData();" />
            </Listeners>
        </ext:ResourceManager>
        <ext:Hidden ID="hdfDepApproveID" runat="server" Text="" />
        <ext:Hidden ID="hdfCalendarType" runat="server" Text="" />
        <ext:Hidden ID="hdfIsLeader" runat="server" Text="false" />
        <ext:Hidden ID="hdfIDLanhDao" runat="server" Text="" />
        <ext:Hidden ID="hdfTenLanhDao" runat="server" Text="" />
        <ext:Hidden ID="hdfDepCoporateID" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfDepCoporateName" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfCoporateEmpName" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfCoporateEmpID" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfMeetingScopeName" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfMeetingScopeID" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfRoomID" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfRoomName" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfKindSelect" runat="server" Text="0">
        </ext:Hidden>
        <ext:Hidden ID="hdfKindType" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdftype" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfwidth" runat="server" Text="">
        </ext:Hidden>
        <ext:Hidden ID="hdfTokenKey" runat="server" Text="" />
        <ext:Viewport ID="vp" runat="server" Layout="FitLayout" Frame="true" Padding="0" Border="false" BorderSpec="border-width:0px;">
            <Items>
                <ext:Panel ID="Panel1" runat="server" LabelWidth="120" Region="Center" Collapsible="false" Margins="0 0 0 0" Padding="0"
                    Header="false" Border="false" BodyBorder="0" Layout="BorderLayout">
                    <Items>
                        <ext:Panel ID="pnCustomSearch" runat="server" Region="South" Border="false" CollapseMode="Mini"
                            Split="true" MinWidth="400" MaxWidth="2500" ButtonAlign="Center" MinHeight="140"
                            TitleCollapse="false" HideCollapseTool="true" Collapsed="true" AutoScroll="true">
                            <Items>
                                <ext:Container ID="Container2" runat="server" HideLabel="true" Layout="ColumnLayout" ColumnWidth="1">
                                    <Items>
                                        <ext:Container ID="Container3" runat="server" HideLabel="true" Layout="ColumnLayout" ColumnWidth="1">
                                            <Items>
                                                <ext:TextField ID="txtTitle" runat="server" FieldLabel="Tên lịch" ColumnWidth="0.99"
                                                    MaxLength="255" PaddingSpec="1 5 1 5" LabelWidth="120">
                                                </ext:TextField>
                                            </Items>
                                        </ext:Container>
                                    </Items>
                                </ext:Container>
                                <ext:Container ID="Container4" runat="server" Layout="ColumnLayout" ColumnWidth="1">
                                    <Items>
                                        <ext:FieldContainer ID="fcCaNhanThamGia" runat="server" LabelAlign="Left" Layout="ColumnLayout"
                                            ColumnWidth=".5" Margin="5" FieldLabel="Cá nhân tham gia" LabelWidth="120">
                                            <Items>
                                                <ext:Container PaddingSpec="0" ID="Container5" runat="server" AnchorHorizontal="100%">
                                                </ext:Container>
                                            </Items>
                                        </ext:FieldContainer>
                                        <ext:FieldContainer ID="fcDep" runat="server" LabelAlign="Left" Layout="ColumnLayout"
                                            ColumnWidth=".5" Margin="5" FieldLabel="Phòng ban tham gia" LabelWidth="120">
                                            <Items>
                                                <ext:Container PaddingSpec="0" ID="Container6" runat="server" AnchorHorizontal="100%">
                                                    <Content>
                                                        <div id="txtDep">
                                                        </div>
                                                    </Content>
                                                </ext:Container>
                                            </Items>
                                        </ext:FieldContainer>
                                    </Items>
                                </ext:Container>
                                <ext:Container ID="ContainerDiaDiem_PhongHop" runat="server" Layout="ColumnLayout" ColumnWidth="1">
                                    <Items>
                                        <ext:FieldContainer ID="FieldContainer1" runat="server" Layout="ColumnLayout" ColumnWidth="0.5">
                                            <Items>
                                                <ext:ComboBox ID="ckbTypeRoom" runat="server" Editable="false" ColumnWidth="0.985" FieldLabel="Chọn phòng họp"
                                                    LabelWidth="120" Margin="5">
                                                    <Items>
                                                        <ext:ListItem Text="Thuộc quản lý" Value="0" />
                                                        <ext:ListItem Text="Không thuộc quản lý" Value="1" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <Select Fn="Typeroom">
                                                        </Select>
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </Items>
                                        </ext:FieldContainer>
                                        <ext:FieldContainer ID="fcRoom" runat="server" LabelAlign="Left" Layout="ColumnLayout"
                                            ColumnWidth=".5" FieldLabel="Phòng họp" Margin="5" LabelWidth="120">
                                            <Items>
                                                <ext:Container PaddingSpec="0" ID="containerRoom" runat="server" AnchorHorizontal="100%">
                                                    <Content>
                                                        <div id="cbRoom">
                                                        </div>
                                                    </Content>
                                                </ext:Container>
                                                <ext:TextField ID="txtLocal" runat="server" AnchorHorizontal="100%" ColumnWidth=".985"
                                                    MaxLength="500" Hidden="True" PaddingSpec="0" />
                                            </Items>
                                        </ext:FieldContainer>
                                    </Items>
                                </ext:Container>

                            </Items>
                            <Buttons>
                                <ext:Button ID="btnSearch" runat="server" Height="30" Text="Tìm kiếm" Icon="Zoom" Scale="Medium" Cls="button-default-medium">
                                    <Listeners>
                                        <Click Handler="setDataForm();Search();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnRefesh" runat="server" Height="30" Text="Làm lại" Icon="ArrowRefresh" Scale="Medium" Cls="button-default-medium">
                                    <Listeners>
                                        <Click Handler="Unsearch();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                        <ext:Panel ID="Panel2" runat="server" Region="Center" Header="false" Border="false" Layout="FitLayout">
                            <Content>
                                <ext:Panel ID="pnShowViewDetail" runat="server" Border="false" AutoScroll="False"
                                    Split="true" MinWidth="400" MaxWidth="2500">

                                    <Content>
                                        <div style="display: none;">
                                            <ext:Button ID="btnThemMoi" runat="server" Text="Đăng ký" Icon="Add" Hidden="true">
                                                <Listeners>
                                                    <Click Fn="ThemMoi" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnLast" runat="server" Text="" Icon="BulletLeft">
                                                <Listeners>
                                                    <Click Handler="EventClick('last');"></Click>
                                                </Listeners>
                                            </ext:Button>
                                            <ext:ToolbarSeparator />
                                            <ext:Button ID="btnCurent" runat="server" Text="Hiện tại" Icon="Calendar">
                                                <Listeners>
                                                    <Click Handler="EventClick('curent');"></Click>
                                                </Listeners>
                                            </ext:Button>
                                            <ext:ToolbarSeparator />
                                            <ext:Button ID="btnNext" runat="server" Text="" Icon="BulletRight">
                                                <Listeners>
                                                    <Click Handler="EventClick('next');"></Click>
                                                </Listeners>
                                            </ext:Button>
                                            <ext:ToolbarSpacer />
                                            <ext:ToolbarSpacer />
                                            <ext:ToolbarSpacer />
                                            <ext:Button ID="btnInLich" Hidden="True" runat="server" Text="In lịch" Icon="Printer">
                                                <Listeners>
                                                    <Click Fn="InLich" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:ToolbarFill>
                                            </ext:ToolbarFill>
                                            <ext:Button ID="btnDanhSach" Hidden="True" runat="server" Text="Quản lý danh sách lịch" Icon="Table">
                                                <Listeners>
                                                    <Click Fn="DanhSach" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnLichNgay" Hidden="true" runat="server" Text="Ngày">
                                                <Listeners>
                                                    <Click Fn="LichNgay" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnLichTuan" Hidden="false" Cls="active" runat="server" Text="Tuần" Icon="CalendarViewWeek">
                                                <Listeners>
                                                    <Click Fn="LichTuan" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnLichThang" Hidden="false" runat="server" Text="Tháng" Icon="CalendarViewMonth">
                                                <Listeners>
                                                    <Click Fn="LichThang" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnLichNam" Hidden="false" runat="server" Text="Năm" Icon="CalendarViewDay">
                                                <Listeners>
                                                    <Click Fn="LichThang" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnRoom" Hidden="True" runat="server" Text="Hiển thị theo phòng" Icon="House">
                                                <Listeners>
                                                    <Click Fn="LichRoom" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:FieldContainer ID="fcLanhDao" runat="server" LabelAlign="Left" HideLabel="False" Width="200px" FieldLabel="Lãnh đạo">
                                                <Items>
                                                    <ext:Container PaddingSpec="0" ID="Container1" runat="server">
                                                        <Content>
                                                            <div id="txtLanhDaoToChuc">
                                                            </div>
                                                        </Content>
                                                    </ext:Container>
                                                </Items>
                                            </ext:FieldContainer>

                                            <ext:TextField FieldLabel="" LabelAlign="Right" Hidden="True" EmptyText="Nhập từ khóa tìm kiếm" LabelWidth="50" ID="txtKeyWord" runat="server">
                                            </ext:TextField>
                                            <ext:Button ID="Button1" Hidden="True" runat="server" Icon="Zoom">
                                                <Listeners>
                                                    <Click Handler="Search();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnClear" Hidden="True" runat="server" Icon="ArrowRefresh">
                                                <Listeners>
                                                    <Click Fn="Unsearch" />
                                                </Listeners>
                                            </ext:Button>
                                            <%--tim kiem va in lich--%>
                                            <ext:FieldContainer ID="FieldContainer3" runat="server" LabelAlign="Right">
                                                <Content>
                                                    <div id="txtCoporateEmp" style="width: 350px; margin-left: 20px;">
                                                    </div>
                                                </Content>
                                            </ext:FieldContainer>
                                            <ext:Button ID="btnSearchEm" runat="server" Text="Tim kiem" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="setDataForm();Search();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:ToolbarSeparator />
                                            <ext:SplitButton ID="btnInground" runat="server" Icon="Printer" Text="In lịch">
                                                <%--<Listeners>
                                                        <Click Fn="showMenu" />
                                                    </Listeners>--%>
                                                <Menu>
                                                    <ext:Menu ID="menu3" runat="server">
                                                        <Items>
                                                            <ext:Button ID="Button2" runat="server" Text="In lịch" Icon="Printer">
                                                                <Listeners>
                                                                    <Click Handler="setDataForm();Export();" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnExportExcel" runat="server" AutoPostBack="true" Text="In lịch tháng" Icon="ReportWord"
                                                                Cls="button-default-medium" OnClick="btnExportExcelFlowMonth_Click">
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Menu>
                                                </Menu>
                                            </ext:SplitButton>

                                        </div>


                                        <div id="calcontent" class="">
                                            <div id="sropt"></div>
                                            <div id="ntowner"></div>
                                            <div id="vr-nav">
                                                <div class="applogo"><span onclick="backVportal();" onmousedown="_SR_backToCalendar();return false;" id="mainlogo" title="Cổng thông tin điện tử nội bộ - TCT Hàng Không Việt Nam">VPORTAL</span></div>
                                                <div id="mainnav">
                                                    <div id="topnav-container">
                                                        <div id="topLeftNavigation">
                                                            <div id="t1">
                                                                <div class="noprint">
                                                                    <div class="-nav">
                                                                        <div class="date-controls">
                                                                            <table class="nav-table" cellpadding="0" cellspacing="0" border="0">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>

                                                                                            <%--<div class="goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right" role="button" aria-pressed="false" tabindex="0" style="user-select: none;">
                                                                                                <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                                                    <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                                                        <div class="goog-imageless-button-pos">
                                                                                                            <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                                            <div class="goog-imageless-button-content"><a onclick="ThemMoi();">Thêm mới</a></div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>--%>

                                                                                            <div class="qnb-container" style="padding-right: 16px;">
                                                                                                <div class="goog-inline-block goog-imageless-button" role="button" tabindex="0" style="user-select: none;">
                                                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                                                            <div class="goog-imageless-button-pos">
                                                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                                                <div class="goog-imageless-button-content"><a onclick="ThemMoi();" style="color: white !important;">Thêm mới</a></div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>

                                                                                        </td>
                                                                                        <td class="date-nav-today">
                                                                                            <div id="todayButton:2">
                                                                                                <div onclick="EventClick('curent');" class="goog-inline-block goog-imageless-button" role="button"  style="user-select: none;">
                                                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                                                            <div class="goog-imageless-button-pos">
                                                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                                                <div class="goog-imageless-button-content">Hôm nay</div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="date-nav-prev">
                                                                                            <div onclick="EventClick('last');" id="navBack:2" tabindex="0" role="button" title="Khoảng thời gian trước đó" class="navbuttonouter navBackOuter goog-inline-block">
                                                                                                <div class="navbutton navBack goog-inline-block"></div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="date-nav-next">
                                                                                            <div onclick="EventClick('next');" id="navForward:2" tabindex="0" role="button" title="Khoảng thời gian tiếp theo" class="navbuttonouter navForwardOuter goog-inline-block">
                                                                                                <div class="navbutton navForward goog-inline-block"></div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td id="dateBox:2" class="date-picker-off">
                                                                                            <div id="currentDate:2" class="date-top">
                                                                                                <%--25 thg 9 – 1 thg 10, 2017--%>
                                                                                                <ext:Label ID="lblNgayChon" runat="server" Text="">
                                                                                                </ext:Label>

                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div id="topRightNavigation">
                                                            <div class="button-strip goog-inline-block">
                                                                <div class="trans-strip goog-inline-block"></div>
                                                                <%--<div onclick="changeCalendarView('week');" id="btnWeekView" class="goog-inline-block goog-imageless-button goog-imageless-button-collapse-right" role="button" aria-pressed="false" tabindex="0" style="user-select: none;">
                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                            <div class="goog-imageless-button-pos">
                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                <div class="goog-imageless-button-content">Tuần</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>--%>
                                                                <div onclick="changeCalendarView('month');" id="btnMonthView" class="goog-inline-block goog-imageless-button goog-imageless-button-checked goog-imageless-button-collapse-left goog-imageless-button-collapse-right" role="button" aria-pressed="true" tabindex="0" style="user-select: none;">
                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                            <div class="goog-imageless-button-pos">
                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                <div class="goog-imageless-button-content">Tháng</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                               <%-- <div onclick="changeCalendarView('quater');" id="btnQuaterView" class="goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right" role="button" aria-pressed="false" tabindex="0" style="user-select: none;">
                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                            <div class="goog-imageless-button-pos">
                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                <div class="goog-imageless-button-content">Quý</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>--%>
                                                                <div onclick="changeCalendarView('year');" id="btnYearView" class="goog-inline-block goog-imageless-button goog-imageless-button-collapse-left goog-imageless-button-collapse-right" role="button" aria-pressed="false" tabindex="0" style="user-select: none;">
                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                            <div class="goog-imageless-button-pos">
                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                <div class="goog-imageless-button-content">Năm</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div id="btnPrintCalendar" class="goog-inline-block goog-imageless-button goog-imageless-button-collapse-left" role="button" aria-pressed="false" tabindex="0" style="user-select: none;">
                                                                    <div class="goog-inline-block goog-imageless-button-outer-box">
                                                                        <div class="goog-inline-block goog-imageless-button-inner-box">
                                                                            <div class="goog-imageless-button-pos">
                                                                                <div class="goog-imageless-button-top-shadow">&nbsp;</div>
                                                                                <div class="goog-imageless-button-content">In lịch biểu</div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div id="searchNavigation" style="display: none;"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="LichContent" style="margin-top: 2px;">

                                                <%--<div style="width: 100%;float: left;position: fixed;margin-top: -1px;">
                                                <table id="header-month-cal-style" style="
                                                width: calc(100% - 1em) !important;
                                                "><tbody><tr>
                                                                                              <th class="p14" colspan="3">Chủ nhật</th>
                                                                                                  <th class="p14" colspan="3">Thứ hai</th>
                                                                                                  <th class="p14" colspan="3">Thứ ba</th>
                                                                                                  <th class="p14" colspan="3">Thứ tư</th>
                                                                                                  <th class="p14" colspan="3">Thứ năm</th>
                                                                                                  <th class="p14" colspan="3">Thứ sáu</th>
                                                                                                  <th class="p14" colspan="3">Thứ bảy</th></tr><tr><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td><td class="ClsRowHeader">CTHĐQT</td><td class="ClsRowHeader">BT/TGĐ</td><td class="ClsRowHeader">các PTGĐ</td></tr> </tbody></table>
                                                </div>--%>




                                                <ext:Label runat="server" ID="lblHeader"></ext:Label>

                                                <div id="NoiDungLich" style="width: 100%; float: left; position: absolute; height: 100%; overflow: auto; margin-top: 65px;">
                                                    <ext:Label runat="server" ID="lblWeekCal">
                                                    </ext:Label>
                                                    <ext:Label runat="server" ID="lblPaging" Visible="false" Hidden="true">
                                                    </ext:Label>
                                                </div>

                                                <div id="NoiDungLichNam" style="width: 100%; float: left; position: absolute; height: 92%; overflow: auto; margin-top: 0px;display:none;">
                                                    <ext:Label runat="server" ID="lblYearCal">
                                                    </ext:Label>
                                                </div>
                                            </div>


                                        </div>

                                    </Content>
                                </ext:Panel>
                            </Content>
                        </ext:Panel>
                    </Items>
                </ext:Panel>
            </Items>
        </ext:Viewport>

        <asp:Literal ID="lbHeaderViewMonth" runat="server" Visible="false">
            <div style='width: 100%;float: left;position: fixed;margin-top: -1px;'>
                                                <table id='header-month-cal-style' style='width: calc(100% - 1em) !important;'><tbody><tr>
                                                           <th class='p14' colspan='3'>Chủ nhật</th>
                                                           <th class='p14' colspan='3'>Thứ hai</th>
                                                           <th class='p14' colspan='3'>Thứ ba</th>
                                                           <th class='p14' colspan='3'>Thứ tư</th>
                                                           <th class='p14' colspan='3'>Thứ năm</th>
                                                           <th class='p14' colspan='3'>Thứ sáu</th>
                                                           <th class='p14' colspan='3'>Thứ bảy</th></tr><tr><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td><td class='ClsRowHeader'>CTHĐQT</td><td class='ClsRowHeader'>BT/TGĐ</td><td class='ClsRowHeader'>các PTGĐ</td></tr> </tbody></table>
                                                </div>
        </asp:Literal>


        <asp:Literal ID="lbHeaderViewYear" runat="server" Visible="false"> 
            <table id='year-cal-style' style='
                                                width: 2700px !important; overflow-x:scroll;
                                                '><thead><tr>
                                                            <th class='p14'>&nbsp;</th>

                                                           <th class='p14'>Thứ hai</th>
                                                           <th class='p14'>Thứ ba</th>
                                                           <th class='p14'>Thứ tư</th>
                                                           <th class='p14'>Thứ năm</th>
                                                           <th class='p14'>Thứ sáu</th>
                                                           <th class='p14'>Thứ bảy</th>
                                                           <th class='p14'>Chủ nhật</th>

                                                           <th class='p14'>Thứ hai</th>
                                                           <th class='p14'>Thứ ba</th>
                                                           <th class='p14'>Thứ tư</th>
                                                           <th class='p14'>Thứ năm</th>
                                                           <th class='p14'>Thứ sáu</th>
                                                           <th class='p14'>Thứ bảy</th>
                                                           <th class='p14'>Chủ nhật</th>

                                                           <th class='p14'>Thứ hai</th>
                                                           <th class='p14'>Thứ ba</th>
                                                           <th class='p14'>Thứ tư</th>
                                                           <th class='p14'>Thứ năm</th>
                                                           <th class='p14'>Thứ sáu</th>
                                                           <th class='p14'>Thứ bảy</th>
                                                           <th class='p14'>Chủ nhật</th>

                                                           <th class='p14'>Thứ hai</th>
                                                           <th class='p14'>Thứ ba</th>
                                                           <th class='p14'>Thứ tư</th>
                                                           <th class='p14'>Thứ năm</th>
                                                           <th class='p14'>Thứ sáu</th>
                                                           <th class='p14'>Thứ bảy</th>
                                                           <th class='p14'>Chủ nhật</th>

                                                           <th class='p14'>Thứ hai</th>
                                                           <th class='p14'>Thứ ba</th>
                                                           <th class='p14'>Thứ tư</th>
                                                           <th class='p14'>Thứ năm</th>
                                                           <th class='p14'>Thứ sáu</th>
                                                           <th class='p14'>Thứ bảy</th>
                                                           <th class='p14'>Chủ nhật</th>

                                                    <th class='p14'>Thứ hai</th>
                                                    <th class='p14'>Thứ ba</th>
                                                           
                                                         </tr>
                                                    </thead>
        </asp:Literal>

        <%--Chọn lãnh đạo--%>
        <ext:Window runat="server" ID="wdShow" Height="500" Width="950" Layout="FitLayout"
            ExpandOnShow="true" Title=" " Hidden="true" Modal="true" Constrain="true">
            <Loader ID="Loader3" Url="../Lists/HR_Employee_Insite_Select.aspx" Mode="Frame"
                runat="server">
                <Params>
                    <ext:Parameter Name="KindSelect" Value="#{hdfKindSelect}.getValue()" Mode="Raw" />
                    <ext:Parameter Name="UserKey" Value="#{hdfKindType}.getValue()" Mode="Raw" />
                    <ext:Parameter Name="departmentid" Value="#{hdfDepApproveID}.getValue()" Mode="Raw" />
                    <ext:Parameter Name="Leader" Value="#{hdfIsLeader}.getValue()" Mode="Raw" />
                </Params>
                <LoadMask ShowMask="true" UseMsg="true" Msg="Đang load dữ liệu">
                </LoadMask>
            </Loader>
            <BottomBar>
                <ext:Toolbar ID="ToolbarEm" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                    </Items>
                </ext:Toolbar>
            </BottomBar>
        </ext:Window>

        <ext:Window runat="server" ID="wdShowdeparment" Height="500" Width="950" Layout="FitLayout"
            ExpandOnShow="true" Title="Chọn đơn vị" Hidden="true" Modal="true" Constrain="true">
            <Loader ID="Loader2" Url="../Lists/HR_Department_Select.aspx" Mode="Frame" runat="server"
                AutoLoad="true">
                <LoadMask ShowMask="true" UseMsg="true" Msg="Đang load dữ liệu">
                </LoadMask>
            </Loader>
        </ext:Window>
    </form>
</body>
</html>

