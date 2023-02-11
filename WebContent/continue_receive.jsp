<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%><!-- JSP時間轉換格式 -->
<%@ page import="java.lang.Math"%><!-- 處理long類型計算的套件 -->
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
	<title>付款資訊</title>
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
	<c:set var="order_name" value="${param['Order_name']}"/>
	<c:set var="item_index" value="${param['Item_index']}"/>
	<c:set var="extend" value="${param['Extend']}"/> <!-- 選擇的延長時間 -->
	<c:set var="item_rent_time" value="${extend}"/>  <!-- 選擇的延長時間 -->
	<!-- 設置使用參數 -->
	<c:set var="ID_Value_list"/>
	<c:set var="imageID"/>
	<c:set var="OriginalEnd"/>
	<c:set var="StartID"/>
	<%
	String id=(String)pageContext.getAttribute("item_index");
	String value=(String)pageContext.getAttribute("extend");
	String id_value=id+"="+value;
	pageContext.setAttribute("ID_Value_list",id_value);
	%>
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
	<!-- 讀取商品資料庫並設置價格參數 -->
	<c:set var="New" value="${1.5}"/>
	<c:set var="Old" value="${0.7}"/>
	<sql:query dataSource="${DataBase}" var="commodity">
    	SELECT * from commodity;
	</sql:query>
	<c:forEach var="row" items="${commodity.rows}">
		<c:if test="${row.item_index==item_index}">
			<c:set var="Cost" value="${row.cost}"/>
			<c:set var="Life_month" value="${row.Life_month}"/>
			<c:set var="Purchasetime" value="${row.purchasetime}"/>
		</c:if>
	</c:forEach>
	<!-- 讀取訂單資料庫 -->
	<sql:query dataSource="${DataBase}" var="orderlist">
    	SELECT * from orderlist;
	</sql:query>
	<c:forEach var="row" items="${orderlist.rows}">
		<c:if test="${(row.order_name==order_name)&&(row.item_index==item_index)}">
		<c:set var="ThisEnd" value="${row.end}"/>
		<%
		String item_index=(String)pageContext.getAttribute("item_index");
		String thisend=(String)pageContext.getAttribute("ThisEnd");
		String ImageID="images/pic"+item_index+".jpg";
		String startid="Start"+item_index;
		pageContext.setAttribute("imageID",ImageID);
		pageContext.setAttribute("OriginalEnd",thisend);
		pageContext.setAttribute("StartID",startid);
		%>
		<c:set var="Start" value="${row.end}"/>
		</c:if>
	</c:forEach>
	<!-- 結束時間 -->
	<c:set var="month" value="${1000*60*60*24*30}"/>
	<fmt:parseDate type="both" value="${OriginalEnd}" var="parsedOriginal" pattern="yyyy-MM-dd"/>
	<c:set var="Endex" value="${parsedOriginal}"/>
	<c:set target="${Endex}" property="time" value="${Endex.time+month*extend}"/>
	<fmt:formatDate var="ExtendedEnd" value="${Endex}" pattern="yyyy-MM-dd" />
	<!-- 計算價格 -->
	<%!/*寫函數時記得加上!*/
	double rate(double New, double Old, int Life_month, String Purchasetime, String Now){
		long day=1000*60*60*24L;
		long month=day*30L;
		SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");/*格式化物件*/
		double rate=0.0;
		/*寫成函數時，要使用try,catch來處理字串轉換成時間時可能會出現的exception*/
		try {
			java.util.Date parsedPurchasetime=formatter.parse(Purchasetime);
			java.util.Date parsedNow=formatter.parse(Now);
			/*算出特定日期距離1970-01-01有幾微秒*/
			long Purchasetime_millisecond=parsedPurchasetime.getTime();
			long Now_millisecond=parsedNow.getTime();
			long Now_Pur_Diff_milli=Now_millisecond-Purchasetime_millisecond;
			/*把上面的微秒換成月*/
			double Now_Pur_Diff_month=(Now_Pur_Diff_milli/month);
			if(Now_millisecond<Purchasetime_millisecond){
				/*對應到現在的時間比購買時間還早，也就是錯誤的時間*/
				rate=0.0;
			}
			else if(Now_millisecond<Purchasetime_millisecond+Life_month*month){
				/*對應到現在的時間落在起始與結束時間之內*/
				rate=New-((New-Old)*Now_Pur_Diff_month)/Life_month;
			}
			else{
				/*對應到現在的時間比預期壽命還大，那就直接回傳最舊的費率*/
				rate=Old;
			}
		} 
		catch (java.text.ParseException e) {
			e.printStackTrace();
		}
		return rate;
	}
	double Summation(double New, double Old, int Cost, int Life_month, int item_rent_time, String Purchasetime, String Start){
		long month=1000*60*60*24*30L;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		double average=Cost/Life_month;
		double sum=0.0;
		try{
			java.util.Date purchasetime = formatter.parse(Purchasetime);
			java.util.Date start = formatter.parse(Start);
			long purchasemillisec = purchasetime.getTime();
			long startmillisec = start.getTime();
			for(int i=0;i<item_rent_time;i++){
				long nowmillisec=startmillisec+i*month;
				java.util.Date milli_to_date = new java.util.Date(nowmillisec);  
				String Now=formatter.format(milli_to_date);
				double rate_this_month=rate(New, Old, Life_month, Purchasetime, Now);
				sum=sum+average*rate_this_month;
			}
		}
		catch (java.text.ParseException e) {
			e.printStackTrace();
		}
		return sum;
	}
	%>
	<c:set var="ThisRent"/>
	<%
	double New=(double)pageContext.getAttribute("New");
	double Old=(double)pageContext.getAttribute("Old");
	int Cost=(int)pageContext.getAttribute("Cost");
	int Life_month=(int)pageContext.getAttribute("Life_month");
	String STRitem_rent_time=(String)pageContext.getAttribute("item_rent_time");
	int item_rent_time=Integer.parseInt(STRitem_rent_time);
	String Purchasetime=(String)pageContext.getAttribute("Purchasetime");
	String Start=(String)pageContext.getAttribute("OriginalEnd");/*原本的結束時間變成新的起始時間*/
	double money=Summation(New,Old,Cost,Life_month,item_rent_time,Purchasetime,Start);
	pageContext.setAttribute("ThisRent",money);
	%>
	<fmt:formatNumber var="ThisRentFinal" value="${ThisRent}" groupingUsed="false" minFractionDigits="0" maxFractionDigits="0"/>
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
	<form action="bill.jsp" method="get">
		<br>
		<br>
		<div class="container">
			<div class="row">
				<div class="col-6">
					<img src="${imageID}" width="95%" height="95%">
				</div><!-- 對應到col-6 -->
				<div class="col-6">
					<h3>商品編號 : ${item_index}</h3>
					<h4>租期 : ${item_rent_time} 個月</h4>
					<h5>起始時間 : ${OriginalEnd}</h5>
					<h5>結束時間 : ${ExtendedEnd}</h5>
					<h4>商品價格 : ${ThisRentFinal}元</h4>
					<h3>
						請選擇付款方式
						<select class="form-select" name="pay">
							<option value="mobile_payment">行動支付</option>
							<option value="credit_card">信用卡</option>
							<option value="store">超商繳費</option>
						</select>
					</h3>
					<button type="button" class="btn btn-warning" onclick="javascript:Return();">
						<script>
							function Return(){
								window.location.assign("continue_order.jsp");
							}
						</script>
						重新選擇
					</button>
					<button type="submit" class="btn btn-success">付款</button>
				</div><!-- col-6 -->
			</div><!-- row -->
		</div><!-- container -->
		<input type="hidden" name="${StartID}" value="${OriginalEnd}">
		<input type="hidden" name="ID_Value_list" value="${ID_Value_list}">
		<input type="hidden" name="price" value="${ThisRentFinal}">
	</form>
	<script>
		$(document).ready(function(){
			$('#noselect').attr('disabled',true);/*停用相同class的功能，這裡用來停止選項的功能*/
		});
	</script>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>