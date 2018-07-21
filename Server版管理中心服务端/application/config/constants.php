<?php

/*
|--------------------------------------------------------------------------
| Display Debug backtrace
|--------------------------------------------------------------------------
|
| If set to TRUE, a backtrace will be displayed along with php errors. If
| error_reporting is disabled, the backtrace will not display, regardless
| of this setting
|
*/
defined('SHOW_DEBUG_BACKTRACE') OR define('SHOW_DEBUG_BACKTRACE', TRUE);

/*
|--------------------------------------------------------------------------
| File and Directory Modes
|--------------------------------------------------------------------------
|
| These prefs are used when checking and setting modes when working
| with the file system.  The defaults are fine on servers with proper
| security, but you may wish (or even need) to change the values in
| certain environments (Apache running a separate process for each
| user, PHP under CGI with Apache suEXEC, etc.).  Octal values should
| always be used to set the mode correctly.
|
*/
defined('FILE_READ_MODE')  OR define('FILE_READ_MODE', 0644);
defined('FILE_WRITE_MODE') OR define('FILE_WRITE_MODE', 0666);
defined('DIR_READ_MODE')   OR define('DIR_READ_MODE', 0755);
defined('DIR_WRITE_MODE')  OR define('DIR_WRITE_MODE', 0755);

/*
|--------------------------------------------------------------------------
| File Stream Modes
|--------------------------------------------------------------------------
|
| These modes are used when working with fopen()/popen()
|
*/
defined('FOPEN_READ')                           OR define('FOPEN_READ', 'rb');
defined('FOPEN_READ_WRITE')                     OR define('FOPEN_READ_WRITE', 'r+b');
defined('FOPEN_WRITE_CREATE_DESTRUCTIVE')       OR define('FOPEN_WRITE_CREATE_DESTRUCTIVE', 'wb'); // truncates existing file data, use with care
defined('FOPEN_READ_WRITE_CREATE_DESTRUCTIVE')  OR define('FOPEN_READ_WRITE_CREATE_DESTRUCTIVE', 'w+b'); // truncates existing file data, use with care
defined('FOPEN_WRITE_CREATE')                   OR define('FOPEN_WRITE_CREATE', 'ab');
defined('FOPEN_READ_WRITE_CREATE')              OR define('FOPEN_READ_WRITE_CREATE', 'a+b');
defined('FOPEN_WRITE_CREATE_STRICT')            OR define('FOPEN_WRITE_CREATE_STRICT', 'xb');
defined('FOPEN_READ_WRITE_CREATE_STRICT')       OR define('FOPEN_READ_WRITE_CREATE_STRICT', 'x+b');

/*
|--------------------------------------------------------------------------
| Exit Status Codes
|--------------------------------------------------------------------------
|
| Used to indicate the conditions under which the script is exit()ing.
| While there is no universal standard for error codes, there are some
| broad conventions.  Three such conventions are mentioned below, for
| those who wish to make use of them.  The CodeIgniter defaults were
| chosen for the least overlap with these conventions, while still
| leaving room for others to be defined in future versions and user
| applications.
|
| The three main conventions used for determining exit status codes
| are as follows:
|
|    Standard C/C++ Library (stdlibc):
|       http://www.gnu.org/software/libc/manual/html_node/Exit-Status.html
|       (This link also contains other GNU-specific conventions)
|    BSD sysexits.h:
|       http://www.gsp.com/cgi-bin/man.cgi?section=3&topic=sysexits
|    Bash scripting:
|       http://tldp.org/LDP/abs/html/exitcodes.html
|
*/
defined('EXIT_SUCCESS')        OR define('EXIT_SUCCESS', 0); // no errors
defined('EXIT_ERROR')          OR define('EXIT_ERROR', 1); // generic error
defined('EXIT_CONFIG')         OR define('EXIT_CONFIG', 3); // configuration error
defined('EXIT_UNKNOWN_FILE')   OR define('EXIT_UNKNOWN_FILE', 4); // file not found
defined('EXIT_UNKNOWN_CLASS')  OR define('EXIT_UNKNOWN_CLASS', 5); // unknown class
defined('EXIT_UNKNOWN_METHOD') OR define('EXIT_UNKNOWN_METHOD', 6); // unknown class member
defined('EXIT_USER_INPUT')     OR define('EXIT_USER_INPUT', 7); // invalid user input
defined('EXIT_DATABASE')       OR define('EXIT_DATABASE', 8); // database error
defined('EXIT__AUTO_MIN')      OR define('EXIT__AUTO_MIN', 9); // lowest automatically-assigned error code
defined('EXIT__AUTO_MAX')      OR define('EXIT__AUTO_MAX', 125); // highest automatically-assigned error code
defined('SALT')                OR define('SALT', 'woaidalianmao'); //Define Token salt
defined('TRAFFIC_APK')         OR define('TRAFFIC_APK', '54c3e5a0-9b73-0135-3385-0242c0a80006'); //Define traffic API APPKey


define("SUPER","SUPERADMIN");
define("PASSWORD","2d17efbcd61215b017b53b1fe1d28098");

define("ADMIN","ADMIN");
define("ADMIN_PASSWORD","21232f297a57a5a743894a0e4a801fc3");

//RETURN ERROR
defined('TOKEN_ERROR')         OR define('TOKEN_ERROR', 'Access Token Error'); //Define Token salt

// 预订
define('RES_MONOMER', 1); //单体资源
define('RES_SHARE', 2);   //共享资源

define('BOOKING_FREE', 0);   // 空闲
define('BOOKING_CLOSED', 1);   // 关闭
define('BOOKING_FULL', 3);   // 爆满
define('BOOKING_NOT_FULL', 2);   // 有预订但未满
define('BOOKING_BOOKED', 2);   // 已预定（单体用) 
define('BOOKING_CHOSE', 99); //自己已预订
define('BOOKING_MIN_TIME', 5); // 预订最小时段分钟数

//消息推送
define('EMQTTD_IP', '127.0.0.1'); // 消息服务器地址
define('EMQTTD_PORT', 1883); // 消息服务器地址
define('EMQTTD_API_PORT', 18083); // 消息服务器地址
define('EMQTTD_ID', 'Notice_management'); // 消息发送端ID
define('EMQTTD_USER', 'admin'); // API用户名
define('EMQTTD_PWD', 'public'); // API密码

define('DATABASE_USER', 'root'); // API用户名
define('DATABASE_PWD', 'root'); // API密码

define("TOKEN",'systec_20180330');//jwt验证认证

define("RPP",20);//默认分页记录数

define("MASTER","192.168.1.149");//主服务器地址
define("SLAVER","192.168.1.149");//从服务器地址