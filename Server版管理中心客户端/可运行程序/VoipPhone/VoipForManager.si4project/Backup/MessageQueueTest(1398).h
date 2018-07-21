#ifndef MESSAGEQUEUE_H
#define MESSAGEQUEUE_H

#include <boost/interprocess/ipc/message_queue.hpp>
#include <boost/function.hpp>
#include <pthread.h>
//#include "logging.h"
#include "MessageCommunication.h"
using namespace boost::interprocess;
using namespace std;

class MessageQueue
{
public:

    MessageQueue();
     int startMessageThread();
public:

     typedef boost::function<void (MsgCommunicationStruct)> MsgRecvHandleFunc;

     void setMsgRecvHandleFunc(MsgRecvHandleFunc handleFunc);

     void messageQueueThread();

    void sendData(SipRequestStruct sipMessage);
private:
    pthread_t  m_pThreadIdMessage;
    message_queue *mq_control;
    message_queue *mq_indicate;
    MsgRecvHandleFunc m_recvHandleFunc;

};

#endif // MESSAGEQUEUE_H
