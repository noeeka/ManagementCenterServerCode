#ifndef NETWORKSERVICE_H
#define NETWORKSERVICE_H

#include <boost/asio.hpp>

#include <boost/function.hpp>
#define BOOST_ALL_NO_LIB
#include <boost/thread.hpp>
#include <boost/array.hpp>
#include <string>
#include <boost/asio/error.hpp>
#include <boost/bind.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/enable_shared_from_this.hpp>

#include "logging.h"
using namespace std;

using namespace boost::asio;

using boost::asio::ip::tcp;




#define  BUFFERSIZE  256

class NetworkService  {
public:
    NetworkService(unsigned short local_port = 0);
    ~NetworkService();

    void setServerIP(const std::string& ip);

    void run_service();


    typedef boost::function<void (boost::shared_ptr<vector<char> > str)> NetworkRecvHandleFunc;

     void setNetworkServiceHandleFunc(NetworkRecvHandleFunc handleFunc);



private:
    boost::asio::io_service io_service;
    tcp::acceptor acceptor; 
    typedef boost::shared_ptr<ip::tcp::socket> sock_pt;
    boost::thread service_thread;
    NetworkRecvHandleFunc m_recvHandleFunc;


    void startAccept();
    void handleAccept(const boost::system::error_code& error, sock_pt sock);
    void handleRead(const boost::system::error_code& error, boost::shared_ptr<vector<char> > str);
    


};
#endif

