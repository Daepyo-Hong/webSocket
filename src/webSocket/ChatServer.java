package webSocket;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

//채팅서버 구현

//ws://localhost:8080/webSocket/chat-server
//서버이름으로 요청하게 되면 해당 클래스가 요청처리함
@ServerEndpoint("/chat-server")
public class ChatServer {

    //접속자 정보:세션, Collections.synchronizedSet 이용해서 멀티프로세스 상에서도 안전하게 처리 가능
    //클라이언트들이 동시에 접속하더라도 문제가 생기지 않도록 동기화
    //static final : 하나만 사용할거에요
    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());

    //클라이언트가 접속되면 실행
    @OnOpen
    public void onOpen(Session session){
        clients.add(session);
        System.out.println("웹소켓 접속: "+session.getId());
    }

    //클라이언트와 연결이 종료되면 실행
    @OnClose
    public void onClose(Session session) throws IOException {
        synchronized (clients){
            for(Session client : clients){      //모든클라이언트에게 메세지전달
                if(client.equals(session))continue; //보낸사람은 제외
                client.getBasicRemote().sendText(session.getId()+"님이 방에서 나갔습니다.");
            }
        }
        clients.remove(session);
        System.out.println("웹소켓 종료: "+session.getId());
    }

    //접속유저의 메시지를 전달 받으면 실행
    @OnMessage
    public void onMessage(Session session, String message) throws IOException {
        System.out.println("메세지 전송[ "+session.getId()+" ] : "+message);
        synchronized (clients){     //동기화블럭
            for (Session client : clients){ //모든 클라이언트에게 메시지 전달
                if(client.equals(session))continue; //보낸사람은 제외
                client.getBasicRemote().sendText(message);

            }
        }
    }

    //에러가 발생시 실행
    @OnError
    public void onError(Throwable e){
        System.out.println("예외발생");
        e.printStackTrace();

    }

}
