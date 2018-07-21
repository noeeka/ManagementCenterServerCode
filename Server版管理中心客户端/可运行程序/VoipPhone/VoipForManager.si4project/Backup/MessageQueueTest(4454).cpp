#include "MessageQueueTest.h"


void* messageThread(void* obj)
{
        MessageQueue* pMessageQueue = (MessageQueue *)obj;
        pMessageQueue->messageQueueThread();
        return NULL;
}


MessageQueue::MessageQueue()
{
      mq_control = new message_queue(open_or_create,"sip_control_message_queue",10,sizeof(SipRequestStruct));
      mq_indicate = new message_queue(open_or_create,"multi_process_message_queue",10,sizeof(MsgCommunicationStruct));
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

 void MessageQueue::messageQueueThread()
 {
     MsgCommunicationStruct msgRequest;
     unsigned int priority;
     std::size_t recvd_size;


     while(1)
     {
         try
         {

             mq_indicate->receive(&msgRequest, sizeof(MsgCommunicationStruct), recvd_size, priority);
             cout<<"msgRequest.msgModuleType :"<<msgRequest.msgModuleType <<endl;
             if (msgRequest.msgModuleType == MSG_SIP)
             {
                 if (msgRequest.CommunicationUnion.sipResponse.messageType == IPC_SIP_STATUS_CALL)
                 {
                     cout << "msgRequest.CommunicationUnion.sipResponse.messageType :" << msgRequest.CommunicationUnion.sipResponse.messageType;

                     cout << "callID :" << msgRequest.CommunicationUnion.sipResponse.MessageUnion.statusCallRes.callID << endl;
                 }

                 if (msgRequest.CommunicationUnion.sipResponse.messageType == IPC_SIP_STATUS_MWI)
                 {
                     cout << "mwi type :" << msgRequest.CommunicationUnion.sipResponse.messageType;

                     cout << "accAddr :" << msgRequest.CommunicationUnion.sipResponse.MessageUnion.statusMwiRes.accAddr << endl;
                 }


    
                      
             }
             


//             m_recvHandleFunc(msgRequest);

//             cout<<"sip state:"<<msgRequest.messageType<<endl;


         }
         catch(interprocess_exception &ex){
             cout << ex.what() << std::endl;
             return ;
          }


     }


 }
 void MessageQueue::setMsgRecvHandleFunc(MsgRecvHandleFunc handleFunc)
 {
         m_recvHandleFunc = handleFunc;
 }


 void MessageQueue::sendData(SipRequestStruct msgCom)
 {

 //    try
 //    {

         //LOG("stateType = %d\n",msgCom.MessageUnion.sipData.stateType);
         mq_control->try_send(&msgCom, sizeof(SipRequestStruct),0);


 //    }
 //    catch(interprocess_exception &ex){
 //        message_queue::remove("multi_process_message_queue");
 //        std::cout << ex.what() << std::endl;
 //        return ;
 //     }

 }


