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
	<title>折舊公式</title>
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
</head>
<body>
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
	<!-- ------------------------------------------------------------------------------ -->
	<sql:query dataSource="${DataBase}" var="orderlist">
    	SELECT * FROM orderlist;
	</sql:query>
	<sql:query dataSource="${DataBase}" var="commodity">
    	SELECT * FROM commodity;
	</sql:query>
	<!-- 指定要挑選的訂單與商品 -->
	<c:set var="selected_order_name" value="order5"/>
	<c:set var="selected_item_index" value="${12}"/>
	<table class="table" border="1">
		<tr>
			<th>item_rent_time</th>
			<th>start</th>
			<th>end</th>
			<th>cost</th>
			<th>purchasetime</th>
			<th>life_month</th>
		</tr>
		<tr>
			<c:forEach var="orderlist_row" items="${orderlist.rows}">
				<c:if test="${(orderlist_row.order_name==selected_order_name)&&(orderlist_row.item_index==selected_item_index)}">
					<!-- 取出函數要用的參數 -->
					<c:set var="selected_item_rent_time" value="${orderlist_row.item_rent_time}"/>
					<c:set var="selected_start" value="${orderlist_row.start}"/>
					<c:set var="selected_end" value="${orderlist_row.end}"/>
					<td><c:out value="${selected_item_rent_time}"/></td>
					<td><c:out value="${selected_start}"/></td>
					<td><c:out value="${selected_end}"/></td>
				</c:if>
			</c:forEach>
			<c:forEach var="commodity_row" items="${commodity.rows}">
				<c:if test="${commodity_row.item_index==selected_item_index}">
					<!-- 取出函數要用的參數 -->
					<c:set var="selected_cost" value="${commodity_row.cost}"/>
					<c:set var="selected_purchasetime" value="${commodity_row.purchasetime}"/>
					<c:set var="selected_life_month" value="${commodity_row.life_month}"/>
					<td><c:out value="${selected_cost}"/></td>
					<td><c:out value="${selected_purchasetime}"/></td>
					<td><c:out value="${selected_life_month}"/></td>
				</c:if>
			</c:forEach>
		<tr>
	</table>
	<!-- 時間減法，以算出目前時間是壽命的第幾個月 -->
	<c:set var="month" value="${1000*60*60*24*30}"/><!-- 30天總共幾微秒 -->
	<c:set var="start" value="2020-12-31"/>
	<c:set var="now" value="2021-01-01"/>
	<%
	/*遇到超過2^31-1的數字，記得要在後面加上L，不然會被預設為int*/
	long month=1000*60*60*24*30L;
	long day=1000*60*60*24L;
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");//產生格式化物件
	///////////////////////////////////////////////////////////////////////////////
	String starttime=(String)pageContext.getAttribute("start");
	String nowtime=(String)pageContext.getAttribute("now");
	/*java.util跟java.sql都有Date，要指定使用的類型，不然系統不知道要用哪個*/
    java.util.Date startdate = formatter.parse(starttime);
    java.util.Date nowdate = formatter.parse(nowtime);
    long startmillisec = startdate.getTime();
    long nowmillisec = nowdate.getTime();
    /*把微秒轉換成日期*/
    java.util.Date milli_to_date = new java.util.Date(nowmillisec);  
    String date_to_str=formatter.format(milli_to_date);
	out.println("<p>"+startmillisec+"</p>");
	out.println("<p>"+nowmillisec+"</p>");
	out.println("<p>"+date_to_str+"</p>");
	out.println("<p>"+(double)(nowmillisec-startmillisec)/(1000*60*60*24*30L)+" 個月</p>"); /*除法要注意*/
	%>
	<%!/*如果要寫函數，記得要在前面加上驚嘆號*/
	/*費率公式*/
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
            //double Now_Pur_Diff_month=Math.floorDiv(Now_Pur_Diff_milli, month); /*利用函數做完除法，並取floor*/
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
	double sum(){
		return 0.0;
	}
	%>
	<%
		double New=1.5;
		double Old=0.7;
		int Life_month=5;
		String Purchasetime="2022-12-12";
		String Now="2023-01-12";
		double myrate=rate(New,Old,Life_month,Purchasetime,Now);
		out.println("<p>折舊="+myrate+"</p>");
	%>
	<%!
		/*總價格*/
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
	<%
		double sumNew=1.5;
		double sumOld=0.7;
		int sumCost=70000;
		int sumLife_month=90;
		int sumitem_rent_time=12;
		String sumPurchasetime="2022-10-10";
		String sumStart="2023-01-31";
		double mysum=Summation(sumNew,sumOld,sumCost,sumLife_month,sumitem_rent_time,sumPurchasetime,sumStart);
		out.println("<p>折舊="+mysum+"</p>");
	%>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>