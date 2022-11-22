<%--
  Created by IntelliJ IDEA.
  User: tree1
  Date: 2022-11-22
  Time: 오후 2:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
      function openChat(){
        var id = $("#chatId");
        if(id.val().trim()==""){
          alert("대화명을 입력하세요")
          id.focus();
          return;
        }
        //window.open 에서 window는 생략 가능합니다.
        open("chatting.jsp?chatId="+id.val(), "", "width=350, height=450");
        id.val(""); //안에 있는 값 비워놓을게요
      }
    </script>
  </head>
  <body>
    <h1>채팅을 이용하실 수 있습니다.</h1>
    <div>
      대화명: <input type="text" id="chatId" >
      <button type="button" onclick="openChat()">입장</button>
    </div>
  </body>
</html>
