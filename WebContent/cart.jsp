<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.Math" %>
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
	<title>購物車</title>
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
            background-repeat: repeat no-repeat;
        }
		#div_all{
        	width:100%;
        	height:80%;
        	margin:0 auto;
        	text-align:center;
        }
	</style>
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
	<c:set var="ItemID_list"/>
	<%
	Cookie[] cookies=request.getCookies();
	/*
	如果cookie名稱裡面有特殊字元，例如@，那麼系統在讀取時有可能會顯示invalid cookie就跳過不讀取
	所以說帳號密碼，或是建立cookie時，裡面不要設置特殊字元
	*/
	List<String> itemID_list=new ArrayList<String>(); //Java物件。在這裡只是拿來示範，並沒有實際使用
	for(int i=0;i<cookies.length;i++){
		String list=(String)pageContext.getAttribute("ItemID_list");//在scriptlet裡面讀取JSTL變數
		if(cookies[i].getName().contains("order")){   //contains:字串的內建方法。用來檢查特定子字串是否在該字串內
			itemID_list.add(cookies[i].getValue());   //Java物件。在這裡只是拿來示範，並沒有實際使用
			if(list.length()==0){
				list=cookies[i].getValue();
				pageContext.setAttribute("ItemID_list",list);//在scriptlet裡面設置JSTL變數的內容
			}
			else{
				list=list+","+cookies[i].getValue();
				pageContext.setAttribute("ItemID_list",list);
			}
		}
	}
	%>
	<br>
	<form action="payment.jsp" method="get"><!-- 把form標籤放在最外面，裡面的selection標籤就會變成其中一個項目，送出時就能一次送完 -->
		<div class="container" id="div_all">
			<div class="row">
				<c:forTokens var="ID" delims="," items="${ItemID_list}"><!-- delims=把字串拆成list的方法 -->
					<c:set var="picID"/>
					<c:set var="imageID"/>
					<c:set var="infoID"/>
					<c:set var="nameID"/>
					<c:set var="deleteID"/>
					<c:set var="StartID"/>
					<%
					String id=(String)pageContext.getAttribute("ID");
					String PicID="pic"+id;
					String ImageID="images/pic"+id+".jpg";
					String InfoID="info"+id;
					String NameID="item_"+id;
					String DeleteID="delete"+id;
					String startID="start"+id;
					pageContext.setAttribute("picID",PicID);
					pageContext.setAttribute("imageID",ImageID);
					pageContext.setAttribute("infoID",InfoID);
					pageContext.setAttribute("nameID",NameID);
					pageContext.setAttribute("deleteID",DeleteID);
					pageContext.setAttribute("StartID",startID);
					%>
					<div class="col-6" id="${picID}">
						<img src="${imageID}" width="95%" height="95%">
					</div><!-- 對應到picID -->
					<div class="col-6" id="${infoID}">
						<div class="container"><!-- 商品編號與租期選擇 -->
							<div class="row page-section justify-content-center align-items-center">
						 		<div class="col-8">
									<h3><span> 商品編號 : <c:out value="${ID}"/></span></h3>
									<select class="form-select" name="${nameID}">
										<option selected value="0" class="noselect">選擇租期</option>
										<option value="1">一個月</option>
										<option value="6">六個月</option>
										<option value="12">一年</option>
									</select>
								</div>
							</div>
							<br>
							<div class="row page-section justify-content-center align-items-center">
						  		 <div class="col-8">
									<!-- 要用cookie來記錄，不然後面的頁面接收資料時會讀太多資料而打亂結構 -->
									<label for="validationCustomUsername" class="form-label"><h4>請選擇起始日期</h4></label>
									<!-- 設定預設日期:如果已經還有未結束的訂單，那麼日期就不能是今天 -->
    								<c:set var="now" value="<%=new java.util.Date()%>" />                   <!-- 獲取今天的日期 -->
									<fmt:formatDate var="today" pattern="yyyy-MM-dd" value="${now}" />      <!-- 設定預設日期，避免出現沒有填寫日期的情況 -->
									<c:set var="MaxEnd"/>                                                   <!-- 找出訂單中最晚的日期 -->
									<sql:query dataSource="${DataBase}" var="orderlist">
    									SELECT * FROM orderlist;
									</sql:query>
									<c:forEach var="orderlist_row" items="${orderlist.rows}">
										<c:if test="${orderlist_row.item_index==ID}">
											<c:set var="ThisEnd" value="${orderlist_row.end}"/>
											<%
											String MaxEnd=(String)pageContext.getAttribute("MaxEnd");
											String ThisEnd=(String)pageContext.getAttribute("ThisEnd");
											SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
											if(MaxEnd.length()<1){
												pageContext.setAttribute("MaxEnd",ThisEnd);
											}
											else{
												try{
													java.util.Date parsedMaxEnd=formatter.parse(MaxEnd);
					            					java.util.Date parsedThisEnd=formatter.parse(ThisEnd);
					            					long MaxEnd_millisecond=parsedMaxEnd.getTime();
					            					long ThisEnd_millisecond=parsedThisEnd.getTime();
					            					if(ThisEnd_millisecond>MaxEnd_millisecond){
					            						pageContext.setAttribute("MaxEnd",ThisEnd);
					            					}
					           						else{
					           						
					            					}
												}
												catch (java.text.ParseException e) {
					            					e.printStackTrace();
					        					}
											}
											%>
										</c:if>
									</c:forEach>
									<c:set var="DefaultDate"/>
									<c:if test="${fn:length(MaxEnd)==0}">
										<%
										pageContext.setAttribute("MaxEnd","1970-01-01");
										%>
									</c:if>
									<%
									String MaxEnd=(String)pageContext.getAttribute("MaxEnd");
									String today=(String)pageContext.getAttribute("today");
									SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
									try{
										java.util.Date parsedMaxEnd=formatter.parse(MaxEnd);
		            					java.util.Date parsedtoday=formatter.parse(today);
		            					long MaxEnd_millisecond=parsedMaxEnd.getTime();
		            					long today_millisecond=parsedtoday.getTime();
		            					if(today_millisecond>MaxEnd_millisecond){
		            						pageContext.setAttribute("DefaultDate",today);
		            					}
		            					else{
		            						pageContext.setAttribute("DefaultDate",MaxEnd);
		            						}
										}
									catch(java.text.ParseException e){
										e.printStackTrace();
									}
									%>
									<c:set var="MonthAfter"/>
									<%
									String DefaultDate=(String)pageContext.getAttribute("DefaultDate");
									SimpleDateFormat Mformatter=new SimpleDateFormat("yyyy-MM-dd");
									try{
										java.util.Date parsedDefaultDate=Mformatter.parse(DefaultDate);
		            					long DefaultDate_millisecond=parsedDefaultDate.getTime();
		         						long MonthAfter_millisecond=DefaultDate_millisecond+1000*60*60*24*30L;
		         						String MonthAfter=Mformatter.format(MonthAfter_millisecond);
		         						pageContext.setAttribute("MonthAfter",MonthAfter);
									}
									catch(java.text.ParseException e){
										e.printStackTrace();
									}
									%>
    								<div class="input-group has-validation">
      									<input type="text" class="form-control datepicker" name="${StartID}" id="validationCustomUsername" value="${DefaultDate}"
      									readonly="readonly" placeholder="點擊選擇日期" aria-describedby="inputGroupPrepend" required>
      									<!-- 設置readonly屬性，使用者就不能在狀態列輸入日期，避免使用者亂打導致程式無法判斷 -->
      									<script>
											$(document).ready(function(){
												$("input[name='${StartID}']").datepicker({/*選擇器選擇了所有input元素中名稱等於特定字串的input*/
													format:'yyyy-mm-dd',             /*設定時間篩選器的格式*/
													autoclose:true,                  /*選完日期之後，畫面自動關閉*/
													weekStart:1,                     /*周一當作第一天*/
													startDate:"${DefaultDate}",      /*以預設日期作為起點，並且不能再往回選*/
													endDate:"${MonthAfter}"          /*最多可以往後選一個月*/
												});
											});
										</script>
    								</div>
    							</div>
							</div>
						</div><!-- 對應到container -->
						<br>
						<div class="container"><!-- 價格試算 -->
    						<sql:query dataSource="${DataBase}" var="result">
    							SELECT * FROM commodity;
							</sql:query>
							<c:forEach var="row" items="${result.rows}">
								<c:if test="${row.item_index==ID}">
									<h4> 全新價格 : <c:out value="${row.cost}"/>元</h4>
									<h4> 使用壽命 : <c:out value="${row.life_month}"/>個月</h4>
									<h4> 每月平均價格 : <fmt:formatNumber value="${row.cost/row.life_month}" minFractionDigits="0" maxFractionDigits="0"/>元</h4>
								</c:if>
							</c:forEach>
						</div><!-- 對應到container -->
						<div class="container"><!-- 按鈕設定 -->
							<br>
							<div class="row">
								<div class="col-12">
									<button type="button" class="btn btn-warning" id="${deleteID}">移除此項目</button>
								</div><!-- 對應到col-12 -->
							</div><!-- 對應到row -->
						</div><!-- 對應到container -->
					</div><!-- 對應到infoID -->
					<!-- 
					控制移除按鈕的jQuery
					1:清除項目的cookie
					2:使用fadeOut功能
					第一個參數用來控制畫面消失的時間
					第二個參數是附帶的功能，作用為移除相對應id的物件。這樣在送出表單時，就不會送出該項目
					-->
					<script>
						$(document).ready(function(){
							$("#"+"${deleteID}").click(function(){
								$.removeCookie("order"+"${ID}");                        /*使用jQuery的功能來移除cookie*/
								$("#"+"${picID}").fadeOut(500,function(){$("#"+"${picID}").remove();});   /*移除物件*/
								$("#"+"${infoID}").fadeOut(500,function(){$("#"+"${infoID}").remove();}); /*移除物件*/
							});
						});
					</script>
					<!-- 移除使用完的JSTL變數 -->
					<c:remove var="picID"/>
					<c:remove var="imageID"/>
					<c:remove var="infoID"/>
					<c:remove var="nameID"/>
					<c:remove var="deleteID"/>
					<c:remove var="StartID"/>
					<c:remove var="ThisEnd"/>
					<c:remove var="DefaultDate"/>
					<c:remove var="MonthAfter"/>
				</c:forTokens>
			</div><!-- 對應到row -->
		</div><!-- 對應到container -->
		<div class="container" id="div_all">
		    <br>
		    <div class="row"> 
				<div class="col-12"></div><!-- 空白部分 -->
			</div>	
		</div>
		<div class="container" id="div_all">
			<div class="row">			   
				<div class="col-6"></div>
				<div class="col-6">
					<button type="button" class="btn btn-success" onclick="javascript:login();">
						<script>
						   function login(){
							   window.location.assign("login.jsp");}
						</script>
						會員登入
					</button>
					<button type="button" class="btn btn-success" onclick="javascript:shopping();">
						<script>
							function shopping(){
								window.location.assign("commodity.jsp");
							}
						</script>
						繼續購物
					</button>
					<button type="submit" class="btn btn-success" id="submit">
						前往付款
					</button>
				</div><!-- 對應到col-6 -->
			</div><!-- 對應到row -->
		</div><!-- 對應到div_all -->
	</form>
	<br>
	<script>
		$(document).ready(function(){
			$("#submit").hide();
			$('.noselect').attr('disabled', true);/*停用相同class的功能，這裡用來停止選項的功能*/
		});
	</script>
    <sql:query dataSource="${DataBase}" var="result">
    	SELECT account FROM member;
	</sql:query>
	<c:forEach var="row" items="${result.rows}"> 
		<c:set var="row_account" value="${row.account}"/>    
		<script>  
			var Row_account=String("${row_account}");/*把JSTL的變數傳送到Javascript*/
			if(LoginCheck(Row_account)){             /*檢查登入狀態*/
				$(document).ready(function(){
					$("#submit").show();             /*有登入才會顯示送出*/
				});
			}
		</script>
	</c:forEach>
    <div class="container" id="div_all">
		<br>
		<div class="row">
			<div class="col-12"></div>
		</div>
	</div>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>