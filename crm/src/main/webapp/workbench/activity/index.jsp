<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath %>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">
        //时间选择器插件
        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#addBtn").click(function () {

                    $(".time").datetimepicker({
                        minView: "month",
                        language: 'zh-CN',
                        format: 'yyyy-mm-dd',
                        autoclose: true,
                        todayBtn: true,
                        pickerPosition: "bottom-left"
                    });

                    $.ajax({
                        url: "workbench/activity/getUserList.do",
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>";
                            })
                            $("#create-marketActivityOwner").html(html);
                            var id = "${user.id}";
                            $("#create-marketActivityOwner").val(id);
                            $("#createActivityModal").modal("show");
                        }
                    })
                }
            )
            //为保存按钮添加事件
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/save.do",
                    data: {
                        "owner": $.trim($("#create-marketActivityOwner").val()),
                        "name": $.trim($("#create-marketActivityName").val()),
                        "startDate": $.trim($("#create-startTime").val()),
                        "endDate": $.trim($("#create-endTime").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-describe").val())
                    },
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        if (data.success) {
                            //添加成功后
                            //pageList(1,2);
                            /*

                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                $("#activityPage").bs_pagination('getOption', 'currentPage'):操作后停留在当前页
                                $("#activityPage").bs_pagination('getOption', 'rowsPerPage')：操作后维持设置好的每页展示的记录数
                            */
                            //添加完成后应该回到第一页，维持每页展示的记录数
                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            //清空模态窗口中添加过的数据
                            $("#ActivityForm")[0].reset();

                            //列表刷新，关闭模态窗口

                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("添加市场活动失败")
                        }
                    }

                })
            })

            //页面加载完毕后触发一个方法
            pageList(1, 2);
            
            
            $("#searchBtn").click(function () {

                    //点击查询时，我们应将搜索框中的信息保存下来保存到隐藏域中
                    $("#hidden-name").val($.trim($("#search-name").val())),
                    $("#hidden-owner").val($.trim($("#search-owner").val())),
                    $("#hidden-startDate").val($.trim($("#search-startDate").val())),
                    $("#hidden-endDate").val($.trim($("#search-endDate").val())),
                    pageList(1, 2);
            })

            
            //为全选的复选框绑定事件,触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked)
            })

            // $("input[name=xz]").click(function () {
            //     alert(123 )
            // })
            //**********以上的操作是不行的，因为动态生成的元素，是不能通过普通绑定的形式来进行操作的
            /*
            动态生成的元素，我们要以on方法的形式来触发事件

            语法：
                 $(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的JQuery对象，回调函数)
             */

            //有效的外层元素是没有参与动态生成的元素
            $("#ActivityBody").on("click",$("input[name=xz]"),function () {
               // $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]：checked").length)
                $("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);

            })

            //为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {
                //找到复选框中所有打勾的JQuery对象
                var $xz = $("input[name=xz]:checked");

                //如果$xz为零，说明没有选择要删除的记录
                if ($xz.length==0){
                    alert("请选择需要删除的记录")

                }else {

                    if (confirm("确定删除所选的记录吗？")){
                        //此处说明选择了要删除的记录，可能是一条记录，也可能是多条记录

                        //拼接参数
                        // url:workbench/activity/delete.do
                        var param = "";
                        for (var i=0;i<$xz.length;i++){
                            param += "id="+$($xz[i]).val();
                            if (i<$xz.length-1){
                                param +="&";
                            }
                        }
                        $.ajax({
                            url : "workbench/activity/delete.do",
                            data : param,
                            dataType : "json",
                            type : "POST",
                            success : function (data) {
                                /*
                                data:{"success":true/false}

                                 */
                                if (data.success){
                                    //删除成功后，刷新列表
                                   // pageList(1,2);


                                    /*

                                     pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                              ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                          $("#activityPage").bs_pagination('getOption', 'currentPage'):操作后停留在当前页
                                          $("#activityPage").bs_pagination('getOption', 'rowsPerPage')：操作后维持设置好的每页展示的记录数
                                   */
                                    //删除完成后应该回到第一页，维持每页展示的记录数
                                    pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                                }else {
                                    alert("删除市场活动失败")
                                }
                            }
                        })

                    }
                }
            })

            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {

                var $xz = $("input[name=xz]:checked");
                if ($xz.length==0) {
                    alert("请选择需要修改的记录");
                }else if ($xz.length>1) {
                    alert("只能选择一条记录进行修改");
                }else {
                    var id = $xz.val();
                    $.ajax({
                        url : "workbench/activity/getUserListAndActivity.do",
                        data : {
                            "id" : id
                        },
                        dataType : "json",
                        type : "get",
                        success : function (data) {
                            /*
                            data
                            用户列表
                            市场活动对象
                            {"uList":[{用户1}，{2}，{3}...],"a":{市场活动}}
                             */

                            var html = "";
                            $.each(data.uList, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>";

                            })
                            $("#edit-marketActivityOwner").html(html);
                            //处理单条activity
                            $("#edit-id").val(data.a.id);
                            $("#edit-marketActivityOwner").val(data.a.owner);
                            $("#edit-marketActivityName").val(data.a.name);
                            $("#edit-startTime").val(data.a.startDate);
                            $("#edit-endTime").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-describe").val(data.a.description);
                            //打开模态窗口
                            $("#editActivityModal").modal("show");

                        }
                    })
                }

            })

            //为更新按钮绑定事件，执行市场活动的修改操作
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-marketActivityOwner").val()),
                        "name": $.trim($("#edit-marketActivityName").val()),
                        "startDate": $.trim($("#edit-startTime").val()),
                        "endDate": $.trim($("#edit-endTime").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-describe").val())
                    },
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        if (data.success) {
                            //修改成功后
                            //pageList(1,2);


                            /*

                           pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                               ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                               $("#activityPage").bs_pagination('getOption', 'currentPage'):操作后停留在当前页
                               $("#activityPage").bs_pagination('getOption', 'rowsPerPage')：操作后维持设置好的每页展示的记录数
                           */
                            //修改完成后应该回到当前页，维持每页展示的记录数
                           pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                            //列表刷新，关闭模态窗口
                            $("#editActivityModal").modal("hide");
                        } else {
                            alert("修改市场活动失败")
                        }
                    }

                })
            })

        });

        /*
            做前端分页操作的基础组件
            pageNo和pageSize
            pageNo：页码
            pageSize：每页展示的记录数
         */
        function pageList(pageNo, pageSize) {

            //将全选的复选框的勾干掉
            $("#qx").prop("checked",false);

            //查询前将隐藏域中保存的信息取出来放入搜索框中
            $("#search-name").val($.trim($("#hidden-name").val())),
            $("#search-owner").val($.trim($("#hidden-owner").val())),
            $("#search-startDate").val($.trim($("#hidden-startDate").val())),
            $("#search-endDate").val($.trim($("#hidden-endDate").val())),


            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val())
                },
                dataType: "json",
                type: "get",
                success: function (data) {
                    /*
                    data:
                    [{市场活动1}，{2}，{3}... ]    List<Activity> aList
                    分页查询需要：
                    总记录数
                    {“total”：100}      int total

                    我们需要从后台拿到的信息：{“total”：100 ，“dataList”：[{市场活动1}，{2}，{3}... ]}
                     */
                    var html = "";
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';
                    })
                    $("#ActivityBody").html(html);



                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total % pageSize) + 1;

                    //数据处理完毕后，结合分页插件，展示分页信息
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages,     // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        //该回调函数是在点击分页组件时触发的
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
<%--隐藏域--%>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">


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

                    <input type="hidden" id="edit-id">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label time">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" >
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label time">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <%--
                                     关于文本域textarea
                                     1.一定是要以标签对的形式呈现，正常情况下标签对要紧挨在一起 (不要有空格之类的)
                                     2.textarea虽然是以标签对的形式呈现的，但是它也是属于表单元素范畴
                                           我们所有的对于textarea的取值赋值操作，应统一使用val()方法
                                               --%>
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
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

                <form class="form-horizontal" role="form" id="ActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: #ff0c07;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: #ff0000;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startTime" READONLY>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime" READONLY>
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
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate" readonly/>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" id="addBtn" class="btn btn-primary" data-toggle="modal">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
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
                <tbody id="ActivityBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <%--  在该div中画分页主件  --%>
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>