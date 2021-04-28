<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>"/>

<%--    时间插件--%>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%--分页按钮插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery\bs_pagination\en.js"></script>

    <script type="text/javascript">

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


        })

        function pageList(pageNum, pageSize){

            // pageList($("#xxxPage").bs_pagination("getOption", "currentPage"),操作后停留当前页
            //         $("#xxxPage").bs_pagination("getOption", "rowsPerPage"));操作后操作后维持pageSize

            $.ajax({


                success:function (data) {

                    //展现分页信息
                    $("#xxxPage").bs_pagination({
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

</body>
</html>
