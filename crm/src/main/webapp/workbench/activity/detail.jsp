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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            //时间插件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //编辑绑定单击
            $("#editBtn").click(function () {

                //
                // <option>lisi</option>
                // <option>wangwu</option>

                $.ajax({
                    url: "workbench/activity/searchActivity.do",
                    data: {"id": "${param.id}"},
                    type: "get",
                    dataType: "json",
                    success: function (resp) {

                        var html = "";
                        $.each(resp.list, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#edit-owner").html(html);
                        $("#edit-owner").val(resp.owner);
                        $("#edit-name").val(resp.name);
                        $("#edit-startDate").val(resp.startDate);
                        $("#edit-endDate").val(resp.endDate);
                        $("#edit-cost").val(resp.cost);
                        $("#edit-description").val(resp.description);
                    }
                })

                $("#editActivityModal").modal("show");
            })

            //更新按钮
            $("#updateBtn").click(function () {

                $.ajax({
                    url: "workbench/activity/updateDetail.do",
                    data: {
                        "id": "${param.id}",
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {

                        if (resp == true) {
                            alert("更新成功");
                            $("#editActivityModal").modal("hide");
                            window.location = "workbench/activity/detail.do?id=${param.id}";
                        } else {
                            alert("更新失败");
                        }

                    }
                })
            })

            //页面加载完毕，刷新备注信息
            showRemarkList();
            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            //保存备注信息
            $("#saveRemarkBtn").click(function () {

                if ($.trim($("#remark").val()) == "") {
                    alert("请填写备注信息");
                }else {
                    $.ajax({
                        url:"workbench/activity/saveRemark.do",
                        data:{
                            "noteContent":$.trim($("#remark").val()),
                            "activityId":"${vo.id}"
                        },
                        type:"get",
                        dataType:"json",
                        success:function (resp) {
                            if (resp.success == true){
                                alert("备注添加成功");
                                var html = '';
                                html += '<div id="'+resp.remark.id+'" class="remarkDiv" style="height: 60px;">';
                                html += '<img title="' + resp.remark.createBy + '" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                                html += '<div style="position: relative; top: -40px; left: 40px;" >';
                                html += '<h5>' + resp.remark.noteContent + '</h5>';
                                html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${vo.name}</b> <small style="color: gray;"> ' + (resp.remark.editFlag == 0 ? resp.remark.createTime : resp.remark.editTime) + ' 由' + (resp.remark.editFlag == 0 ? resp.remark.createBy : resp.remark.editBy) + '</small>';
                                html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                                html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #00B83F;"></span></a>';
                                html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                                html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+resp.remark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                                html += '</div>';
                                html += '</div>';
                                html += '</div>';
                                $("#remarkDiv").before(html);
                                $("#remark").val("");

                            } else {
                                alert("备注添加失败");
                            }
                        }
                    })
                }


            })

        });

        //刷新备注信息
        function showRemarkList() {

            $.ajax({
                url: "workbench/activity/getRemarkListByAid.do",
                data: {"activityId": "${vo.id}"},
                type: "get",
                dataType: "json",
                success: function (resp) {
                    var html = '';
                    $.each(resp, function (i, n) {
                        html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="' + n.createBy + '" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="h'+n.id+'">' + n.noteContent + '</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${vo.name}</b> <small style="color: gray;" id="s'+n.id+'"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\', \''+n.noteContent+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #00B83F;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    $("#remarkDiv").before(html);

                }
            })

            //更新按钮
            $("#updateRemarkBtn").click(function () {
                var id = $("#remarkId").val();
                $.ajax({
                    url:"workbench/activity/updateRemark.do",
                    data:{
                        "id":id,
                        "noteContent":$.trim($("#noteContent").val())
                    },
                    type:"get",
                    dataType:"json",
                    success:function (resp) {
                        if (resp.success){

                            //更新备注
                            $("#h" + resp.remark.id).html(resp.remark.noteContent);
                            $("#s" + resp.remark.id).html(resp.remark.editTime+ ' 由' +resp.remark.editBy);

                            $("#noteContent").val("");
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                        }else {
                            alert("备注更新失败")
                        }
                    }
                })
            })
        }

        //修改备注
        function editRemark(id, noteContent) {
            $("#remarkId").val(id);
            $("#noteContent").val(noteContent);
            $("#editRemarkModal").modal("show");
        }

        //删除备注
        function removeRemark(id) {

            if(window.confirm("您确定删除该备注吗？")){
                $.ajax({
                    url:"workbench/activity/removeRemark.do",
                    data:{"id":id},
                    type:"get",
                    dataType:"json",
                    success:function (resp) {
                        if (resp == true){
                            alert("删除成功");
                            $("#"+ id).remove();
                            showRemarkList();
                        }else {
                            alert("删除失败");
                        }
                    }
                })
            }
        }

    </script>

</head>
<body>
<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
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
                            <input type="text" class="form-control time" style="cursor:pointer" id="edit-startDate"
                                   value="" readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" style="cursor: pointer" id="edit-endDate"
                                   value="" readonly>
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
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-发传单 <small>${vo.startDate} ~ ${vo.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="ownerName">${vo.ownerName}</b>
        </div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="name">${vo.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="startDate">${vo.startDate}</b>
        </div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="endDate">${vo.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="cost">${vo.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createByName">${vo.createByName}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${vo.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editByName">${vo.editByName}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${vo.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="description">${vo.description}</b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5 id="">哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>