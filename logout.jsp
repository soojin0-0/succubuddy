<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page session="true" %>

<%
    // 현재 세션 무효화 (사용자 로그아웃)
    session.invalidate();

    // 로그아웃 후 main.html로 이동
    response.sendRedirect("main.html");
%>
