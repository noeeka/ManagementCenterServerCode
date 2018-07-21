#ifndef MESSAGEQUEUE_H
#define MESSAGEQUEUE_H

#include <boost/function.hpp>
#include <pthread.h>
#include <iostream>
#include "MessageCommunication.h"
//#include "logging.h"
#include "SipArg.h"
#include <sys/stat.h>
//#include<sys/socket.h> 
#include <winsock.h>


using namespace std;

class MessageQueue
{
public:

    MessageQueue();
     int startMessageThread();
public:

     typedef boost::function<void (SipRequestStruct)> MsgRecvHandleFunc;

     void setMsgRecvHandleFunc(MsgRecvHandleFunc handleFunc);

    void sendData(SipResponseStruct sipMessage);
    
    void startTcpServerThread();   

    void initSocket(int port);

    void startListen();
    
    int updateMaxfd(fd_set fds, int maxfd);
    
private:
    pthread_t  m_pThreadIdMessage;

    int mSocket;

    MsgRecvHandleFunc m_recvHandleFunc;

};

#endif // MESSAGEQUEUE_H
