<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery\bs_pagination\en.js"></script>

<script type="text/javascript">

	$(function(){
		
		pageList(1,3);

		//全选
		$("#qx").change(function () {

			$("input[name=xz]").prop("checked", $("#qx").prop("checked"));
		})

		//单选
		$("#tranBody").on("click", $("input[name=xz]"), function () {
			$("#qx").prop("checked", $("input[name=xz]:checked").length == $("input[name=xz]").length)
		})

		//查询按钮
		$("#searchBtn").click(function () {

			$("#hide-owner").val($.trim($("#get-owner").val()));
			$("#hide-name").val($.trim($("#get-name").val()));
			$("#hide-customerName").val($.trim($("#get-customerName").val()));
			$("#hide-stage").val($.trim($("#get-stage").val()));
			$("#hide-type").val($.trim($("#get-type").val()));
			$("#hide-source").val($.trim($("#get-source").val()));
			$("#hide-contactsName").val($.trim($("#get-contactsName").val()));

			pageList(1,$("#tranPage").bs_pagination("getOption", "rowsPerPage"));
		})
		
	});

	function pageList(pageNum, pageSize){

		$("#get-owner").val($.trim($("#hide-owner").val()));
		$("#get-name").val($.trim($("#hide-name").val()));
		$("#get-customerName").val($.trim($("#hide-customerName").val()));
		$("#get-stage").val($.trim($("#hide-stage").val()));
		$("#get-type").val($.trim($("#hide-type").val()));
		$("#get-source").val($.trim($("#hide-source").val()));
		$("#get-contactsName").val($.trim($("#hide-contactsName").val()));

		$.ajax({
			url:"workbench/transaction/getPageList.do",
			data:{
				"pageNum":pageNum,
				"pageSize":pageSize,
				"owner":$("#hide-owner").val(),
				"name":$("#hide-name").val(),
				"customerId":$("#hide-customerId").val(),
				"stage":$("#hide-stage").val(),
				"type":$("#hide-type").val(),
				"source":$("#hide-source").val(),
				"contactsId":$("#hide-contactsName").val(),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$("#tranBody").html(html);
				$.each(data.list, function (i, n) {
					html += '<tr>';
					html += '<td><input value="'+n.id+'" type="checkbox" name="xz" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';
				})
				$("#tranBody").html(html);

				//展现分页信息
				$("#tranPage").bs_pagination({
					currentPage:pageNum,
					rowsPerPage:pageSize,
					maxRowsPerPage: 20,
					totalPages:data.pages,
					totalRows:data.total,

					visiblePageLinks: 3, //显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage: function (event, data) {
						pageList(data.currentPage, data.rowsPerPage);
					}
				});
			}
		})

	}
	
</script>
</head>
<body>

	<input type="hidden" id="hide-owner" >
	<input type="hidden" id="hide-name" >
	<input type="hidden" id="hide-customerName" >
	<input type="hidden" id="hide-stage" >
	<input type="hidden" id="hide-type" >
	<input type="hidden" id="hide-source" >
	<input type="hidden" id="hide-contactsName" >

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="get-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="get-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="get-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="get-stage">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stage">
							<option value="${stage.value}">${stage.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="get-type">
					  	<option></option>
					  	<c:forEach items="${transactionTypeList}" var="type">
							<option value="${type.value}">${type.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="get-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="get-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.jsp';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.jsp';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage">
				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>