<%--
  Created by IntelliJ IDEA.
  User: tree1
  Date: 2022-11-22
  Time: 오후 3:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        #chat-id {
            width: 158px;
            height: 24px;
            border: 1px solid #a9a9a9;
            background-color: #e9e9e9;
        }

        #btn-close {
            position: relative;
            top: 2px;
            left: -2px;
            margin-bottom: 3px;
        }

        #chat-display {
            border: 1px solid #a9a9a9;
            width: 250px;
            height: 310px;
            overflow: scroll;
            padding: 5px;
        }

        .myMsg {
            text-align: right;
        }

        .sender {
            font-size: 0.75em;
            color: #999;
        }

        .msg {
            border: 1px solid #a9a9a9;
            background-color: #a9a9a9;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        var url = "ws://localhost:8080/webSocket/chat-server";
        var webSocket = new WebSocket(url);
        var message, chatWin, chatId;

        webSocket.onerror = (event) => { }

        webSocket.onclose = (event) => {
            console.log(chatId + "종료");
        }

        //서버에 연결되면 실행
        webSocket.onopen = (event) => {
            var text = chatWin.html() + "채팅에 참가하였습니다.<br/>";
            chatWin.html(text); //현재 내 화면에 표기
        };
        //서버에서 메시지가 전달되면 실행 JSON으로 받은 것을 문자열로 파싱해야함!
        webSocket.onmessage = (event) => {
            console.log(event.data);
            var msg = JSON.parse(event.data);
            var sender = msg.sender;
            var content = msg.content;

            var text = chatWin.html() + "<div><p class='sender'>" + sender + "</p><span class='msg'>" + content + "</span></div>";

            chatWin.html(text); //현재 내 화면에 표기
            chatWin.scrollTop(chatWin.scrollHeight()); //스크롤을 대화창 아래쪽으로 배치할거에요!
        };

        $(function () {
            chatWin = $("#chat-display");  //div태그
            message = $("#chat-message");  //input태그
            chatId = $("#chat-id").val();  //id값
        });

        function disconnect() {
            webSocket.close();  //소켓이 종료
            close();            //윈도우창 종료
        }

        function sendMessage() {
            var text = chatWin.html() + "<div class='myMsg'><span class='msg'>" + message.val() + "</span></div>";
            chatWin.html(text); //현재 내 화면에 표기
            var msg = {
                sender: chatId,
                content: message.val()
            };  //JSON형식을 string형식으로 변환해서
            webSocket.send(JSON.stringify(msg));   //서버로 전송
            message.val("");  // input 메세지 초기화
            chatWin.scrollTop(chatWin.scrollHeight()); //스크롤을 대화창 아래쪽으로 배치할거에요!
        }

        function enterKey() {
            if (event.keyCode == 13) {
                sendMessage();
            }
        }
    </script>
</head>
<body>
<div>
    대화명 : <input type="text" id="chat-id" value="${param.chatId}" readonly="readonly">
    <button type="button" id="btn-close" onclick="disconnect()">종료</button>
    <div id="chat-display"></div>
    <div>
        <input type="text" id="chat-message" onkeyup="enterKey()">
        <button id="btn-send" onclick="sendMessage()">전송</button>
    </div>
</div>
</body>
</html>
