<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery\bs_pagination\en.js"></script>

    <script type="text/javascript">

        $(function () {



            pageList(1, 3);

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //给查询按钮绑定单击
            $("#getActBtn").click(function () {

                $("#hidden-name").val(  $.trim( $("#get-name").val()));
                $("#hidden-ownerName").val(  $.trim( $("#get-ownerName").val()));
                $("#hidden-startDate").val(  $.trim( $("#get-startDate").val()));
                $("#hidden-endDate").val(  $.trim( $("#get-endDate").val()));
                pageList(1, 3)
            })


            //新增按钮绑定单击打开模态窗口
            $("#addBtn").click(function () {


                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    dataType: "json",
                    type: "get",
                    success: function (resp) {
                        // alert(resp);
                        // var html = "<option></option>"
                        $.each(resp, function (i, n) {
                            // alert("n:" + n.name)
                            $("#create-owner").append("<option value='" + n.id + "'>" + n.name + "</option>");
                            $("#create-owner").val("${user.id}")
                            // html += "<option value='"+n.id+"'>"+n.name+"</option>";
                        })
                        // $("#create-owner").html(html);
                    }
                })

                $("#createActivityModal").modal("show");
            })

            //保存按钮绑定单击事件
            $("#saveBtn").click(function () {

                //获取所有用户信息
                $.ajax({
                    url: "workbench/activity/saveActivity.do",
                    data: {
                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-description").val())
                    },
                    // dataType: "text",
                    type: "post",
                    success: function (resp) {

                        if (resp) {
                            alert("添加市场活动成功")
                            //添加成功
                            //重置表单信息
                            $("#activityAddFrom")[0].reset();
                            //局部刷新市场活动列表
                            // pageList();
                            // pageList($("#activityPage").bs_pagination("getOption", "currentPage"),操作后停留当前页
                            //         $("#activityPage").bs_pagination("getOption", "rowsPerPage"));操作后操作后维持pageSize

                            pageList(1, $("#activityPage").bs_pagination("getOption", "rowsPerPage"));

                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("添加市场活动失败")
                        }

                    }
                })

            })

            //修改按钮打开模态窗口
            $("#editBtn").click(function () {

                var $xz = $("input[name=zx]:checked");
                if ($xz.length != 1) {
                    alert("请选择一个市场活动进行修改");
                    return;
                }
                $.ajax({
                    url:"workbench/activity/searchActivity.do",
                    data:{"id":$xz.val()},
                    type:"get",
                    dataType:"json",
                    success:function (resp) {

                        var html = "";
                        $.each(resp.list, function (i, n){
                            html += "<option value="+n.id+">"+n.name+"</option>"
                        })
                        $("#edit-owner").html(html);
                        $("#edit-owner").val(resp.owner)
                        $("#edit-name").val(resp.name)
                        $("#edit-startDate").val(resp.startDate)
                        $("#edit-endDate").val(resp.endDate)
                        $("#edit-cost").val(resp.cost)
                        $("#edit-description").val(resp.description)
                    }
                })
                $("#editActivityModal").modal("show");
                $("#hidden-editId").val($xz.val());
            })

            //更新按钮添加单击事件
            $("#updateBtn").click(function () {

                //更新市场活动
                $.ajax({
                    url:"workbench/activity/updateActivity.do",
                    data:{
                        "id":$("#hidden-editId").val(),
                        "name":$.trim($("#edit-name").val()),
                        "owner":$.trim($("#edit-owner").val()),
                        "startDate":$.trim($("#edit-startDate").val()),
                        "endDate":$.trim($("#edit-endDate").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-description").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (resp) {

                        if (resp.success == true){
                            alert("市场活动更新成功");
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");

                            //刷新市场活动信息
                            // pageList(1, 3);
                            pageList($("#activityPage").bs_pagination("getOption", "currentPage"),
                                $("#activityPage").bs_pagination("getOption", "rowsPerPage"));
                        }else {
                            alert("更新市场活动失败");
                        }

                    }
                })



            })

            //删除按钮添加单击事件
            $("#deleteBtn").click(function () {
                //删除市场活动信息
                var $xz = $("input[name=zx]:checked");
                if ($xz.length == 0) {
                    alert("请选择要删除的记录");
                }else {

                    if (confirm("您确定删除所选择的市场活动吗？")){
                        var param = "";
                        for (var i = 0; i < $xz.length; i++){
                            param += "id=" + $($xz[i]).val() + "&";
                        }

                        $.ajax({
                            url:"workbench/activity/deleteActivity.do?" + param,
                            type:"get",
                            dataType:"json",
                            success:function (resp) {
                                if (resp.success == true){
                                    alert("删除成功");
                                    // pageList(1,3);
                                    pageList(1, $("#activityPage").bs_pagination("getOption", "rowsPerPage"));
                                }else {
                                    alert("删除失败")
                                }
                            }
                        })
                    }


                }


                //刷新市场活动信息
                pageList(1, 3);
            })

            //全选框绑定单击事件
            $("#qx").click(function () {
                $("input[name=zx]").prop("checked", this.checked);
            })

            //复选框绑定单击
            $("#activityInfo").on("click", $("input[name=zx]"), function () {

                var count = 0;
                $.each($("input[name=zx]"), function (i, n) {

                    if (n.checked){
                        count++;
                    }
                })

                $("#qx").prop("checked", count == $("input[name=zx]").length)
            })

        });



        //分页查询市场活动
        function pageList(pageNum, pageSize) {

            $("#qx").prop("checked", false);

            var name = $.trim($("#hidden-name").val());
            var ownerName = $.trim($("#hidden-ownerName").val());
            var startDate = $.trim($("#hidden-startDate").val());
            var endDate = $.trim($("#hidden-endDate").val());
            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "name": name,
                    "ownerName": ownerName,
                    "startDate": startDate,
                    "endDate": endDate
                },
                type: "get",
                dataType: "json",
                success: function (resp) {
                    $("#activityInfo").html("");

                    var html = '';

                    $.each(resp.list, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="zx" value="'+n.id+'"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';

                        html += 'onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
                        html += '<td>'+n.ownerName+'</td>';
                        html += '<td>'+n.startDate+'</td>';
                        html += '<td>'+n.endDate+'</td>';
                        html += '</tr>';
                    })

                    $("#activityInfo").html(html);

                    //展现分页信息
                    $("#activityPage").bs_pagination({
                       currentPage:pageNum,
                       rowsPerPage:pageSize,
                       maxRowsPerPage: 20,
                       totalPages:resp.pages,
                        totalRows:resp.total,

                        visiblePageLinks: 3, //显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }

                    });

                    $("#get-name").val($.trim($("#hidden-name").val()));
                    $("#get-ownerName").val($.trim($("#hidden-ownerName").val()));
                    $("#get-startDate").val($.trim($("#hidden-startDate").val()));
                    $("#get-endDate").val($.trim($("#hidden-endDate").val()));


                }

            })


        }

    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-ownerName"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>
<input type="hidden" id="hidden-editId"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddFrom" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" style="cursor: pointer" id="create-startDate"
                                   readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" style="cursor: pointer" id="create-endDate"
                                   readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;" >*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startDate" value="">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endDate" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="get-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="get-ownerName">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" style="cursor: pointer" type="text" id="get-startDate"
                               readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" style="cursor: pointer" type="text" id="get-endDate" readonly/>
                    </div>
                </div>

                <button type="button" id="getActBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityInfo">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>

        </div>

    </div>

</div>
</body>
</html>