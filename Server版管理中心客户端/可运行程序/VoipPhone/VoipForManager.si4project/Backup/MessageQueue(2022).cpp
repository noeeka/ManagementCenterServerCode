#include "MessageQueue.h"
#include "logging.h"

void* messageThread(void* obj)
{
        MessageQueue* pMessageQueue = (MessageQueue *)obj;
        pMessageQueue->startTcpServerThread();
        return NULL;
}


MessageQueue::MessageQueue()
{
    //message_queue::remove("multi_process_message_queue");
    //message_queue::remove("sip_control_message_queue");
  //    mq_control = new message_queue(open_or_create,"sip_control_message_queue",10,sizeof(SipRequestStruct));
   //   mq_indicate = new message_queue(open_or_create,"multi_process_message_queue",10,sizeof(MsgCommunicationStruct));
}




 int MessageQueue::startMessageThread()
 {
         if(pthread_create(&m_pThreadIdMessage, NULL, messageThread, this))
         {
                 //LOG("messageThread failed\n");
                 return -1;
         }
         return 0;
 }

 void MessageQueue::startTcpServerThread()
 {
     SipRequestStruct msgRequest;


     while(1)
     {
  
            // mq_control->receive(&msgRequest, sizeof(SipRequestStruct), recvd_size, priority);


             m_recvHandleFunc(msgRequest);

             //cout<<"sip state:"<<msgRequest.messageType<<endl;





     }


 }
 void MessageQueue::setMsgRecvHandleFunc(MsgRecvHandleFunc handleFunc)
 {
         m_recvHandleFunc = handleFunc;
 }

 

 //函数：更新maxfd
 int MessageQueue::updateMaxfd(fd_set fds, int maxfd) 
 {
     int i;
     
     int new_maxfd = 0;
     
     for (i = 0; i <= maxfd; i++)
     {       
         if (FD_ISSET(i, &fds) && i > new_maxfd) 
         {
             new_maxfd = i;
         }
     }
     return new_maxfd;
 }


 
 //初始化socket 
 void MessageQueue::initSocket(int port)
 {    
    struct sockaddr_in addr;

    LOG("Server init\n");


    mSocket=socket(AF_INET,SOCK_STREAM,0);
    if(mSocket==-1)
    {
        LOG("socket fail");
        return;
    }

    ///设置可以重复绑定
    int optval=1;

    setsockopt(mSocket,SOL_SOCKET,SO_REUSEADDR,&optval,sizeof(optval));


    ///初始化地址结构

    bzero(&addr,sizeof(addr));
    addr.sin_family=AF_INET;
    addr.sin_port = htons (port);
    addr.sin_addr.s_addr = htonl (INADDR_ANY);


    int ret=::bind(mSocket,(struct sockaddr*)&addr,sizeof(addr));
    if(ret==-1)
    {
        LOG("bind fail");
        return;
    }
    if (listen (mSocket, 20) < 0)
    {
       LOG ("listener failed");
       exit (EXIT_FAILURE);
    }
 }
 
 //开始监听
 
 void MessageQueue::startListen()
 {
        fd_set readfds;
         fd_set readfds_bak; //由于每次select之后会更新readfds，因此需要backup
     
         struct timeval timeout;
     
         int maxfd;
         maxfd = mSocket;
     
         FD_ZERO(&readfds);
     
         FD_ZERO(&readfds_bak);
     
         FD_SET(mSocket, &readfds_bak);
         int new_sock;
     
         struct sockaddr_in client_addr;
     
         socklen_t client_addr_len;
     
         char client_ip_str[INET_ADDRSTRLEN];
     
         int res;
     
         int i;
     
         while (1) {
     
             //注意select之后readfds和timeout的值都会被修改，因此每次都进行重置
             readfds = readfds_bak;
             maxfd = updateMaxfd(readfds, maxfd);        //更新maxfd
             timeout.tv_sec = SELECT_TIMEOUT;
             timeout.tv_usec = 0;
             //select(这里没有设置writefds和errorfds，如有需要可以设置)
             res = select(maxfd + 1, &readfds, NULL, NULL, &timeout);
             if (res == -1) {
                LOG("select failed");
                 exit(EXIT_FAILURE);
             } else if (res == 0) {
                 //LOG("no socket, ready for read within %d secs\n", SELECT_TIMEOUT);
                 continue;
             }
             //检查每个socket，并进行读(如果是mSocket则accept)
             for (i = 0; i <= maxfd; i++)
             {
                 if (!FD_ISSET(i, &readfds))
                 {
                     continue;
                 }
                 //可读的socket
                 if ( i == mSocket) 
                 {
                     //当前是server的socket，不进行读写而是accept新连接
                     client_addr_len = sizeof(client_addr);
                     new_sock = accept(mSocket, (struct sockaddr *) &client_addr, &client_addr_len);
                     if(new_sock == -1)
                     {
                         LOG("accept failed");
                         exit(EXIT_FAILURE);
                     }
                     if(!inet_ntop(AF_INET, &(client_addr.sin_addr), client_ip_str, sizeof(client_ip_str))) 
                     {
                         LOG("inet_ntop failed");
                         exit(EXIT_FAILURE);
                     }
                     LOG("accept a client from: %s\n", client_ip_str);
                     if (new_sock > maxfd) 
                     {
                         maxfd = new_sock;  //把new_sock添加到select的侦听中 ，不能将新的sock设成non-     blocking，否则图片发送不全
                     }
                     FD_SET(new_sock, &readfds_bak);
                 } 
                 else 
                 {
                   //  clientHttp(i);
                     FD_CLR(i, &readfds_bak);//将当前的socket从select的侦听中移除
                 }
             }   
         }

}

 void MessageQueue::sendData(SipResponseStruct sipRes)
 {
     MsgCommunicationStruct msgComm;
     msgComm.msgModuleType = MSG_SIP;
     msgComm.CommunicationUnion.sipResponse = sipRes;


 }


