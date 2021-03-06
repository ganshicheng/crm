<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

	List<DicValue> stageList = (List<DicValue>) application.getAttribute("stageList");
	Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> set = pMap.keySet();

	int point = 0;
	for (int i = 0; i < stageList.size(); i++){
		DicValue dv = stageList.get(i);
		String possibility = pMap.get(dv.getValue());
		if ("0".equals(possibility)){
			point = i;
			break;
		}
	}

%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//页面加载完显示备注列表
		getRemarkList();
		$("#remarkBody").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		})

		//页面加载完显示交易历史
		getHistoryList();

		//保存备注
		$("#saveRemarkBtn").click(function () {

			$.ajax({
				url:"workbench/transaction/saveRemark.do",
				data:{
					"tranId":"${tran.id}",
					"noteContent":$.trim($("#remark").val())
				},
				type:"post",
				dataType:"json",
				success:function (flag) {
					if (flag){
						$("#remark").val("")
						getRemarkList();
					}else {
						alert("备注保存失败")
					}
				}
			})
		})

		//更新备注按钮
		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val();
			$.ajax({
				url:"workbench/transaction/updateRemark.do",
				data:{
					"id":id,
					"noteContent":$.trim($("#noteContent").val())
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					if (data.success){

						$("#" + id).html(data.remark.noteContent);
						$("#s" + id).html(data.remark.editTime+' 由'+data.remark.editBy);
						$("#editRemarkModal").modal("hide");
					}else {
						alert("更新失败")
					}
				}
			})
		})

		//删除按钮
		$("#deleteBtn").click(function () {
			alert("123")
			if (window.confirm("您确定删除该交易吗？")){

				window.location="workbench/transaction/deleteTran.do?id=${tran.id}";
			}
		})

	});

	function getHistoryList(){
		$.ajax({
			url:"workbench/transaction/getHistoryList.do",
			data:{"tranId":"${tran.id}"},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$("#hisBody").html(html);
				$.each(data, function (i, n) {
					html += '<tr>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.money+'</td>';
					html += '<td>'+n.possibility+'</td>';
					html += '<td>'+n.expectedDate+'</td>';
					html += '<td>'+n.createTime+'</td>';
					html += '<td>'+n.createBy+'</td>';
					html += '</tr>';
				})
				$("#hisBody").html(html);
			}
		})
	}

	function getRemarkList(){

		$.ajax({
			url:"workbench/transaction/getRemarkList.do",
			data:{"tranId":"${tran.id}"},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$(".remarkDiv").remove();
				$.each(data, function (i, n) {
					html += '<div class="remarkDiv" style="height: 60px;">';
					html += '<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="'+n.id+'">'+n.noteContent+'</h5>';
					html += '<font color="gray">交易</font> <font color="gray">-</font> <b>'+n.tranId+'</b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag == 0 ? n.createTime : n.editTime)+' 由'+(n.editFlag == 0 ? n.createBy : n.editBy)+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #3e8f3e;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				})
				$("#remarkDiv").before(html);
			}
		})
	}

	function editRemark(id){
		$("#remarkId").val(id);
		$("#editRemarkModal").modal("show");
	}


	function removeRemark(id){
		if (window.confirm("您确定删除该备注吗？")){
			$.ajax({
				url:"workbench/transaction/removeRemark.do",
				data:{"id":id},
				type:"get",
				dataType:"json",
				success:function (flag) {
					if (flag){
						getRemarkList();
					}else {
						alert("删除失败")
					}
				}
			})
		}
	}

	//改变交易阶段
	function changeStage(stage, i) {

		$.ajax({
			url:"workbench/transaction/changeStage.do",
			data:{
				"id":"${tran.id}",
				"stage":stage,
				"money":"${tran.money}",
				"expectedDate":"${tran.expectedDate}"
			},
			type:"get",
			dataType:"json",
			success:function (data) {

				if (data.success){

					$("#stage").html(data.t.stage);
					$("#possibility").html(data.t.possibility);
					$("#editBy").html(data.t.editBy + "&nbsp;&nbsp;");
					$("#editTime").html(data.t.editTime);
					getHistoryList();
					changeIcon(stage, i);

				}else {
					alert("改变阶段失败");
				}

			}
		})

	}

	function changeIcon(stage, index1) {

		//当前阶段
		var currentStage = stage;
		//当前阶段的可能性
		var currentPossibility = $("#possibility").html();
		//当前阶段的下标
		var index = index1;
		//正常阶段和丢失阶段的下标
		var point = "<%=point%>";

		/*alert("当前阶段" + currentStage);
		alert("当前阶段的可能性" + currentPossibility);
		alert("当前阶段的下标" + index);
		alert("正常阶段和丢失阶段的下标" +point );*/

		//如果当前阶段的可能性为0，前7个一定是黑圈
		if(currentPossibility == "0"){

			//对正常阶段进行遍历,为黑圈
			for (var i = 0; i < point; i++){
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-record mystage");
				//为新样式赋予颜色
				$("#"+i).css("color", "#000000");
			}

			//对后两个遍历
			for (var i = point; i < "<%=stageList.size()%>"; i++){

				//如果是当前阶段，为红叉
				if (i == index){

					//移除原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					//为新样式赋予颜色
					$("#"+i).css("color", "#FF0000");

					//如果不是当前阶段，为黑叉
				}else {

					//移除原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					//为新样式赋予颜色
					$("#"+i).css("color", "#000000");

				}

			}


			//如果当前阶段的可能性不为0,后两个一定是黑叉
		}else {

			//对正常阶段进行遍历
			for (var i = 0; i < point; i++){

				//如果遍历阶段下标小于当前阶段下标，为绿勾
				if (i < index){

					//移除原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
					//为新样式赋予颜色
					$("#"+i).css("color", "#90F790");

					//如果遍历阶段下标等于当前阶段下标，为绿色标记
				}else if (i == index){

					//移除原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
					//为新样式赋予颜色
					$("#"+i).css("color", "#90F790");

					//如果遍历阶段下标大于当前阶段下标，为黑圈
				}else {
					//移除原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					//为新样式赋予颜色
					$("#"+i).css("color", "#000000");
				}

			}

			//对后两个进行遍历，为黑叉
			for (var i = point; i < "<%=stageList.size()%>"; i++){
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				//为新样式赋予颜色
				$("#"+i).css("color", "#000000");
			}

		}

	}
	
	
</script>

</head>
<body>

	<!--修改备注的模态窗口-->
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
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus" ></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

		<%
			//取得当前阶段
			Tran tran = (Tran) request.getAttribute("tran");
			String currentStage = tran.getStage();

			//取得当前阶段的可能性
			String currentPossibility = pMap.get(currentStage);

			//判断当前阶段
			//如果当前阶段的可能性为0
			if ("0".equals(currentPossibility)){

				for (int i = 0; i < stageList.size(); i++){

					DicValue dv = stageList.get(i);
					String listStage = dv.getValue();
					String listPossibility = pMap.get(listStage);

					//如果遍历的阶段可能性为0
					if ("0".equals(listPossibility)){

						//如果当前的阶段等于遍历的阶段，为红叉
						if (listStage.equals(currentStage)){
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #FF0000;">
		</span>
		-----------

		<%
							//否则为黑叉
						}else {
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;">
		</span>
		-----------

		<%
						}

						//如果遍历的阶段可能性不为0,为黑圈
					}else {
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-record mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;">
		</span>
		-----------

		<%

					}

				}

			//如果当前阶段的可能性不为0
			}else {

				//准备当前阶段的下标
				int index = 0;
				for (int i = 0; i < stageList.size(); i++){

					DicValue dv = stageList.get(i);
					String stage = dv.getValue();
//					String possibility = pMap.get(stage);

					//如果遍历的阶段为当前阶段
					if (stage.equals(currentStage)){
						index = i;
						break;
					}
				}

				for (int i = 0; i < stageList.size(); i++) {

					DicValue dv = stageList.get(i);
					String listStage = dv.getValue();
					String listPossibility = pMap.get(listStage);

					//如果遍历出来的可能性为0，为黑叉
					if ("0".equals(listPossibility)){

		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;">
		</span>
		-----------

		<%


						//如果遍历出来的可能性不为0
					}else{

						//如果是当前阶段：绿色标记
						if (i == index){

		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-map-marker mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #90F790;">
		</span>
		-----------

		<%

							//如果小于当前阶段：绿勾
						}else if (i < index){

		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-ok-circle mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #90F790;">
		</span>
		-----------

		<%

							//如果大于当前阶段：黑圈
						}else {
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>', '<%=i%>')"
			  class="glyphicon glyphicon-record mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;">
		</span>
		-----------

		<%
						}


					}


				}

			}


		%>

		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
		-----------
		<span class="closingDate">${tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${tran.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${tran.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="hisBody">
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>