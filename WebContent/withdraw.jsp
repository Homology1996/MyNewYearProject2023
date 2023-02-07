<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %><!-- JSP時間轉換格式 -->
<%@ page import="java.lang.Math" %><!-- 處理long類型計算的套件 -->
<!-- 引入JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>退租</title>
	<!-- 引用Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
	<!-- 引用外部css -->
	<link rel="stylesheet" href="css/BodyDefault.css">
	<!-- 引用外部javascript -->
	<script src="scripts/GetCookie.js"></script>
	<script src="scripts/SetCookie.js"></script>
	<!-- 引用jQuery -->
	<script src="scripts/jquery.min.js"></script>
	<script src="scripts/jquery.cookie.js"></script>
	<!-- 下拉式選單需要的腳本 -->
	<script src="scripts/popper.min.js"></script>
	<!-- Bootstrap時間挑選器 -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker3.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
	<style>
		body{
            background-image:url("images/back.png");
            background-size:cover;
        }
	</style>
</head>
<body>
	<!-- 讀取訂單與商品編號 -->
	<c:set var="order_item"/>
	<%
	Cookie[] cookies=request.getCookies();
	for(int i=0;i<cookies.length;i++){
		if(cookies[i].getName().contains("after")){   
			pageContext.setAttribute("order_item",cookies[i].getValue());
		}
	}
	%>
	<c:set var="array" value="${fn:split(order_item,'_')}"/>
	<c:set var="order_name" value="${array[0]}"/>
	<c:set var="item_index" value="${array[1]}"/>
	<!-- 設置修改資訊 -->
	<c:set var="start"/>
	<c:set var="end"/>
	<c:set var="imageID"/>
	<c:set var="EndID"/>
	<!-- 讀取資料庫 -->
	<c:set var="DataBaseName" value="newyear"/>
	<c:set var="DataBaseUserAccount" value="newyear"/>
	<c:set var="DataBaseUserPassword" value="newyear"/>
	<c:set var="DataBaseURL"/>
	<%
	String name=(String)pageContext.getAttribute("DataBaseName");
	String url="jdbc:mysql://localhost:3306/"+name;
	pageContext.setAttribute("DataBaseURL",url);
	%>
	<sql:setDataSource var="DataBase" driver="com.mysql.cj.jdbc.Driver"
	url="${DataBaseURL}" user="${DataBaseUserAccount}" password="${DataBaseUserPassword}"/>
	<!-- 讀取訂單資料庫 -->
	<sql:query dataSource="${DataBase}" var="orderlist">
    	SELECT * from orderlist;
	</sql:query>
	<!-- 標題按鈕 -->
	<br>
	<div class="container">
		<div class="row">
			<div class="col-1"></div><!-- col-2 -->
			<div class="col-2">
				<button class="btn btn-outline-dark" onclick="javascript:Login();">
					<script>
						function Login(){
							window.location.assign("login.jsp");
						}
					</script>
					會員中心
				</button>
			</div><!-- col-2 -->
			<div class="col-6"></div>
			<div class="col-3">
				<button type="button" class="btn btn-outline-dark" onclick="javascript:Return();">
					<script>
						function Return(){
							window.location.assign("index.html");
						}
					</script>
					返回首頁
				</button>
			</div><!-- col-2 -->
		</div><!-- row -->
	</div><!-- container -->
	<br>
	<div class="container">
		<div class="row">
			<table class="table">
				<tr>
					<th>訂單編號</th>
					<th>商品編號</th>
					<th>出租時間</th>
					<th>起始時間</th>
					<th>結束時間</th>
					<th>出租金額</th>
				</tr>
				<c:forEach var="row" items="${orderlist.rows}">
					<c:if test="${(row.order_name==order_name)&&(row.item_index==item_index)}">
						<c:set var="ThisStart" value="${row.start}"/>
						<c:set var="ThisEnd" value="${row.end}"/>
						<%
						String item_index=(String)pageContext.getAttribute("item_index");
						String thisstart=(String)pageContext.getAttribute("ThisStart");
						String thisend=(String)pageContext.getAttribute("ThisEnd");
						String ImageID="images/pic"+item_index+".jpg";
						pageContext.setAttribute("start",thisstart);
						pageContext.setAttribute("end",thisend);
						pageContext.setAttribute("imageID",ImageID);
						%>
						<tr>
							<td><c:out value="${row.order_name}"/></td>
							<td><c:out value="${row.item_index}"/></td>
							<td><c:out value="${row.item_rent_time}"/>個月</td>
							<td><c:out value="${row.start}"/></td>
							<td><c:out value="${row.end}"/></td>
							<td><c:out value="${row.price}"/>元</td>
						</tr>
					</c:if>
				</c:forEach>
			</table>
		</div><!-- row -->
	</div><!-- container -->
	<!-- 決定退租的起始時間 -->
	<c:set var="now" value="<%=new java.util.Date()%>" />                   
	<fmt:formatDate var="DefaultDate" pattern="yyyy-MM-dd" value="${now}" />
	<c:set var="AlterStart"/>
	<%
	String today=(String)pageContext.getAttribute("DefaultDate");
	String orderstart=(String)pageContext.getAttribute("start");
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");/*格式化物件*/
	try {
        java.util.Date parsed_today=formatter.parse(today);
        java.util.Date parsed_orderstart=formatter.parse(orderstart);
        long today_millisecond=parsed_today.getTime();
        long orderstart_millisecond=parsed_orderstart.getTime();
        if(today_millisecond>=orderstart_millisecond){
			pageContext.setAttribute("AlterStart",today);
		}
		else{
			pageContext.setAttribute("AlterStart",orderstart);
		}
    } 
	catch (java.text.ParseException e) {
        e.printStackTrace();
    }
	%>
	<form action="withdraw_receive.jsp" method="get">
		<div class="container">
			<div class="row">
				<div class="col-6">
					<img src="${imageID}" width="95%" height="95%">
				</div><!-- 對應到picID -->
				<div class="col-6">
					<h3 align="center">選擇退租時間</h3>
					<br>
    				<div class="input-group has-validation">
      					<input type="text" class="form-control datepicker" name="AlterEnd" id="validationCustomUsername" value="${AlterStart}"
      					readonly="readonly" placeholder="點擊選擇日期" aria-describedby="inputGroupPrepend" required>
      					<!-- 設置readonly屬性，使用者就不能在狀態列輸入日期，避免使用者亂打導致程式無法判斷 -->
      					<button type="button" name="check" id="check">送出</button>
						<input type="reset" id="cancel" value="重設">
						<input type="submit" name="submit" id="submit" value="確認">
    				</div>
				</div><!-- 對應到picID -->
			</div><!-- row -->
		</div><!-- container -->
		<input type="hidden" name="Order_name" value="${order_name}">
		<input type="hidden" name="Item_index" value="${item_index}">
	</form>
	<script>
		$(document).ready(function(){
			$('.datepicker').datepicker({
				format:'yyyy-mm-dd',             
				autoclose:true,                  
				weekStart:1,                     
				startDate:"${AlterStart}",          
				endDate:"${end}"            
			});
			$("#cancel").hide();          
			$("#submit").hide();
			$("#check").click(function(){ 
				$("#cancel").toggle(500);
				$("#submit").toggle(500);
			});
		});
	</script>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>