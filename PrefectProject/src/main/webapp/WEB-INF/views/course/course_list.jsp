<%@page import="com.pcwk.ehr.cmn.StringUtil"%>
<%@page import="com.pcwk.ehr.course.domain.CourseVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="CP" value="${pageContext.request.contextPath}" scope="page" />
<!DOCTYPE html>
<html>
<head>
<link href="${CP}/resources/css/layout.css" rel="stylesheet"
    type="text/css">
<jsp:include page="/WEB-INF/cmn/header.jsp"></jsp:include>
<script>
document.addEventListener("DOMContentLoaded", function() {
    console.log("DOMContentLoaded");
    

});//--DOMContentLoaded
</script>
<style>

</style>
</head>
<body>
    <input type="hidden" id="sessionEmail"
        value="${sessionScope.user.email}" />

    <br>
    <br>
    <br>
    <br>
    <br>
    
    <div class="row">
        <div class="container col-md-12">
            
            <!-- Title -->
            <div class="col-lg-12">
                <h2 class="title" style="text-align: left;"> ${ courseList[0].academyName } 코스 조회 </h2>
            </div>
            
            <!-- Courses List -->
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col" class="text-center col-lg-1">NO</th>
                        <th scope="col" class="text-center col-lg-3">코스 이름</th>
                        <th scope="col" class="text-center col-lg-3">회차</th>
                        <th scope="col" class="text-center col-lg-5">코스 설명</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty courseList}">
                            <!-- 반복문 -->
                            <c:forEach var="course" items="${courseList}" varStatus="status">
                                <tr>
                                    <td class="text-center">${status.count}</td>
                                    <td class="text-center">${course.courseName}</td>
                                    <td class="text-center">${course.numberOfTimes}회차</td>
                                    <td class="text-center">${course.courseInfo}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="text-center">등록된 코스가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table> 
        </div>
    </div>
    
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>

    <jsp:include page="/WEB-INF/cmn/footer.jsp"></jsp:include>

</body>
</html>