<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script src="echarts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>

    <script>
        $(function () {
            //页面加载完成后，绘制图表
            getCharts();
        })

        function getCharts() {

            $.ajax({

                url : "workbench/transaction/getCharts.do",
                dataType : "json",
                data : "get",
                success : function (data) {

                    /*

                    data ：需要从后台返回的数据
                    {"total":100,"dataList":[{ value: 60, name: '交易5' }, { value: 40, name: '交易3' },...]}

                    */


                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext : '统计交易阶段数量的图'
                        },
                        series: [
                            {
                                name: '交易漏斗图',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                bottom: 60,
                                width: '80%',
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                /*

                                    插件需要的数据格式：
                                    [{ value: 60, name: '交易5' },
                                    { value: 40, name: '交易3' },
                                    { value: 20, name: '交易2' },
                                    { value: 80, name: '交易4' },
                                    { value: 100, name: '交易1' }]

                                 */
                            }
                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

        }
    </script>
</head>
<body>

  <!-- 为 ECharts 准备一个定义了宽高的 DOM -->
  <div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
