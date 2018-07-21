/* $Id: main.c 4752 2014-02-19 08:57:22Z ming $ */
/* 
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */

#include "MessageQueueTest.h"
//#include "SipBase.h"
#define THIS_FILE   "pjsua_test.cpp"



static bool simple_input(const char *title, char *buf, int len)
{
    char *p;

    printf("%s (empty to cancel): ", title); fflush(stdout);
    if (fgets(buf, (int)len, stdin) == NULL)
        return 0;

    /* Remove trailing newlines. */
    for (p = buf; ; ++p) {
        if (*p == '\r' || *p == '\n') *p = '\0';
        else if (!*p) break;
    }

    if (!*buf)
        return 0;

    return 1;
}


 /*
 * Show a bit of help.
 */
static void keystroke_help()
{
    //pjsua_acc_id acc_ids[16];
    //unsigned count = PJ_ARRAY_SIZE(acc_ids);
    //int i;

    printf(">>>>\n");

    //pjsua_enum_accs(acc_ids, &count);

    //printf("Account list:\n");
    //for (i = 0; i<(int)count; ++i)
        //print_acc_status(acc_ids[i]);

    //print_buddy_list();

    //puts("Commands:");
    puts("+=============================================================================+");
    puts("|       Call Commands:         |   Buddy, IM & Presence:  |     Account:      |");
    puts("|                              |                          |                   |");
    puts("|  m  Make new call            | +b  Add new buddy       .| +a  Add new accnt |");
    puts("|  M  Make multiple calls      | -b  Delete buddy         | -a  Delete accnt. |");
    puts("|  a  Answer call              |  i  Send IM              | !a  Modify accnt. |");
    puts("|  h  Hangup call  (ha=all)    |  s  Subscribe presence   | rr  (Re-)register |");
    puts("|  H  Hold call                |  u  Unsubscribe presence | ru  Unregister    |");
    puts("|  v  re-inVite (release hold) |  t  ToGgle Online status |  >  Cycle next ac.|");
    puts("|  U  send UPDATE              |  T  Set online status    |  <  Cycle prev ac.|");
    puts("| ],[ Select next/prev call    +--------------------------+-------------------+");
    puts("|  x  Xfer call                |      Media Commands:     |  Status & Config: |");
    puts("|  X  Xfer with Replaces       |                          |                   |");
    puts("|  #  Send RFC 2833 DTMF       | cl  List ports           |  d  Dump status   |");
    puts("|  *  Send DTMF with INFO      | cc  Connect port         | dd  Dump detailed |");
    puts("| dq  Dump curr. call quality  | cd  Disconnect port      | dc  Dump config   |");
    puts("|                              |  V  Adjust audio Volume  |  f  Save config   |");
    puts("|  S  Send arbitrary REQUEST   | Cp  Codec priorities     |                   |");
    puts("+-----------------------------------------------------------------------------+");
#if 1
    puts("| Video: \"vid help\" for more info                                             |");
    puts("+-----------------------------------------------------------------------------+");
#endif
    puts("|  q  QUIT   L  ReLoad   sleep MS   echo [0|1|txt]     n: detect NAT type     |");
    puts("+=============================================================================+");

    //i = pjsua_call_get_count();
//  printf("You have %d active call%s\n", i, (i>1 ? "s" : ""));

    //if (current_call != PJSUA_INVALID_ID) {
    //  pjsua_call_info ci;
    //  if (pjsua_call_get_info(current_call, &ci) == PJ_SUCCESS)
    //      printf("Current call id=%d to %.*s [%.*s]\n", current_call,
    //      (int)ci.remote_info.slen, ci.remote_info.ptr,
    //          (int)ci.state_text.slen, ci.state_text.ptr);
    //}

}

/* Help screen for video */
#if 1
static void vid_show_help()
{
    //pj_bool_t vid_enabled = (app_config.vid.vid_cnt > 0);

    puts("+=============================================================================+");
    puts("|                            Video commands:                                  |");
    puts("|                                                                             |");
    puts("| vid help                  Show this help screen                             |");
    puts("| vid enable|disable        Enable or disable video in next offer/answer      |");
    puts("| vid acc show              Show current account video settings               |");
    puts("| vid acc autorx on|off     Automatically show incoming video on/off          |");
    puts("| vid acc autotx on|off     Automatically offer video on/off                  |");
    puts("| vid acc cap ID            Set default capture device for current acc        |");
    puts("| vid acc rend ID           Set default renderer device for current acc       |");
    puts("| vid call rx on|off N      Enable/disable video RX for stream N in curr call |");
    puts("| vid call tx on|off N      Enable/disable video TX for stream N in curr call |");
    puts("| vid call add              Add video stream for current call                 |");
    puts("| vid call enable|disable N Enable/disable stream #N in current call          |");
    puts("| vid call cap N ID         Set capture dev ID for stream #N in current call  |");
    puts("| vid dev list              List all video devices                            |");
    puts("| vid dev refresh           Refresh video device list                         |");
    puts("| vid dev prev on|off ID    Enable/disable preview for specified device ID    |");
    puts("| vid codec list            List video codecs                                 |");
    puts("| vid codec prio ID PRIO    Set codec ID priority to PRIO                     |");
    puts("| vid codec fps ID NUM DEN  Set codec ID framerate to (NUM/DEN) fps           |");
    puts("| vid codec bw ID AVG MAX   Set codec ID bitrate to AVG & MAX kbps            |");
    puts("| vid codec size ID W H     Set codec ID size/resolution to W x H             |");
    puts("| vid win list              List all active video windows                     |");
    puts("| vid win arrange           Auto arrange windows                              |");
    puts("| vid win show|hide ID      Show/hide the specified video window ID           |");
    puts("| vid win move ID X Y       Move window ID to position X,Y                    |");
    puts("| vid win resize ID w h     Resize window ID to the specified width, height   |");
    puts("+=============================================================================+");
//  printf("| Video will be %s in the next offer/answer %s                            |\n",
//      (vid_enabled ? "enabled" : "disabled"), (vid_enabled ? " " : ""));
    puts("+=============================================================================+");
}

#endif


static void vid_handle_menu(char *menuin)
{
    char *argv[8];
    int argc = 0;

    /* Tokenize */
    argv[argc] = strtok(menuin, " \t\r\n");
    while (argv[argc] && *argv[argc]) {
        argc++;
        argv[argc] = strtok(NULL, " \t\r\n");
    }

    if (argc == 1 || strcmp(argv[1], "help") == 0) {
        vid_show_help();
    }
    else if (argc == 2 && (strcmp(argv[1], "enable") == 0 ||
        strcmp(argv[1], "disable") == 0))
    {
        //pj_bool_t enabled = (strcmp(argv[1], "enable") == 0);
        //app_config.vid.vid_cnt = (enabled ? 1 : 0);
    //  PJ_LOG(3, (THIS_FILE, "Video will be %s in next offer/answer",
        //  (enabled ? "enabled" : "disabled")));
    }
}

 /*
 * Main "user interface" loop.
 */
void legacy_main(MessageQueue &mQueue)
{
    char menuin[80];
    char buf[128];

    keystroke_help();

    for (;;) {

        printf(">>> ");
        fflush(stdout);

        if (fgets(menuin, sizeof(menuin), stdin) == NULL) {
            /*
            * Be friendly to users who redirect commands into
            * program, when file ends, resume with kbd.
            * If exit is desired end script with q for quit
            */
            /* Reopen stdin/stdout/stderr to /dev/console */
#if ((defined(PJ_WIN32) && PJ_WIN32!=0) || \
     (defined(PJ_WIN64) && PJ_WIN64!=0)) && \
  (!defined(PJ_WIN32_WINCE) || PJ_WIN32_WINCE==0)
            if (freopen("CONIN$", "r", stdin) == NULL) {
#else
            if (1) {
#endif
                puts("Cannot switch back to console from file redirection");
                menuin[0] = 'q';
                menuin[1] = '\0';
            }
            else {
                puts("Switched back to console from file redirection");
                continue;
            }
            }

    //  if (cmd_echo) {
        //  printf("%s", menuin);
        //}

        /* Update call setting */
        //pjsua_call_setting_default(&call_opt);
    //  call_opt.aud_cnt = app_config.aud_cnt;
    //  call_opt.vid_cnt = app_config.vid.vid_cnt;

        SipRequestStruct sipReq;
        memset(&sipReq, 0, sizeof(SipRequestStruct));

        switch (menuin[0]) {

        case 'm':
            /* Make call! : */
            
            if (!simple_input("acc_id is", buf, sizeof(buf)))
                return;

            if (!simple_input("account is", sipReq.MessageUnion.makeCallReq.account, sizeof(sipReq.MessageUnion.makeCallReq.account)))
                return;
            if (!simple_input("sip_url", sipReq.MessageUnion.makeCallReq.sip_url, sizeof(sipReq.MessageUnion.makeCallReq.sip_url)))
                return;
            sipReq.messageType = IPC_SIP_MAKE_CALL;
            
            sipReq.MessageUnion.makeCallReq.acc_id = atoi(buf);

            mQueue.sendData(sipReq);

            break;

        case 'M':
            /* Make multiple calls! : */
            //ui_make_multi_call();
            break;

        case 'n':
            //ui_detect_nat_type();
            break;

        case 'i':
            /* Send instant messaeg */
            //ui_send_instant_message();
            break;

        case 'a':
            //ui_answer_call();
            
            if (!simple_input("call id is", buf, sizeof(buf)))
                return;
            sipReq.messageType = IPC_SIP_ANSWER;

            sipReq.MessageUnion.answerReq.callID = atoi(buf);
            mQueue.sendData(sipReq);
            break;

        case 'h':
            //ui_hangup_call(menuin);
            
            if (!simple_input("call id is", buf, sizeof(buf)))
                return;
            sipReq.messageType = IPC_SIP_HANGUP;

            sipReq.MessageUnion.answerReq.callID = atoi(buf);
            mQueue.sendData(sipReq);
            break;

        case ']':
            sipReq.messageType = IPC_SIP_NEXT_CALL;

            mQueue.sendData(sipReq);
            break;
        case '[':
            /*
            * Cycle next/prev dialog.
            */
            //ui_cycle_dialog(menuin);
            sipReq.messageType = IPC_SIP_PREV_CALL;

            mQueue.sendData(sipReq);
            break;

        case '>':
        case '<':
            //ui_cycle_account();
            break;

        case '+':
            if (menuin[1] == 'b') {
                //ui_add_buddy();
            }
            else if (menuin[1] == 'a') {
                //ui_add_account(&app_config.rtp_cfg);
                
                sipReq.messageType = IPC_SIP_ACCOUNT_ADD;
                if (!simple_input("account is", sipReq.MessageUnion.accountReq.user_id, sizeof(sipReq.MessageUnion.accountReq.user_id)))
                    return;
                if (!simple_input("passwd is", sipReq.MessageUnion.accountReq.passwd, sizeof(sipReq.MessageUnion.accountReq.passwd)))
                    return;
                if (!simple_input("sip server is", sipReq.MessageUnion.accountReq.sip_server, sizeof(sipReq.MessageUnion.accountReq.sip_server)))
                    return;
                if (!simple_input("alias is", sipReq.MessageUnion.accountReq.alias, sizeof(sipReq.MessageUnion.accountReq.alias)))
                    return;
//              strcpy(sipReq.MessageUnion.accountReq.user_id, "6000");
//              strcpy(sipReq.MessageUnion.accountReq.passwd, "6000");
//              strcpy(sipReq.MessageUnion.accountReq.sip_server, "192.168.1.229");
                mQueue.sendData(sipReq);
            }
            else {
                printf("Invalid input %s\n", menuin);
            }
            break;

        case '-':
            if (menuin[1] == 'b') {
                //ui_delete_buddy();
            }
            else if (menuin[1] == 'a') {

                if (!simple_input("account id is", buf, sizeof(buf)))
                    return;
                sipReq.messageType = IPC_SIP_ACCOUNT_DEL;

                sipReq.MessageUnion.delAccountReq.accId = atoi(buf);

            
            
                mQueue.sendData(sipReq);
                

                //ui_delete_account();
            }
            else {
                printf("Invalid input %s\n", menuin);
            }
            break;

        case 'H':
            /*
            * Hold call.
            */
            //ui_call_hold();

            sipReq.messageType = IPC_SIP_HOLD;
        
            mQueue.sendData(sipReq);


            break;

        case 'v':
#if 1
            if (menuin[1] == 'i' && menuin[2] == 'd' && menuin[3] == ' ') {
                vid_handle_menu(menuin);
            }
            else
#endif
            //  if (current_call != -1) {
                    /*
                    * re-INVITE
                    */
                    //ui_call_reinvite();
            //  }
            //  else {
                //  PJ_LOG(3, (THIS_FILE, "No current call"));
            //  }

                
                sipReq.messageType = IPC_SIP_REINVITE;

            
            mQueue.sendData(sipReq);

                break;

        case 'U':
            /*
            * Send UPDATE
            */
            //ui_send_update();
            break;

        case 'C':
            if (menuin[1] == 'p') {
                //ui_manage_codec_prio();
            }
            break;

        case 'x':
            /*
            * Transfer call.
            */
            //ui_call_transfer(app_config.no_refersub);

            if (!simple_input("account is", sipReq.MessageUnion.makeCallReq.account, sizeof(sipReq.MessageUnion.makeCallReq.account)))
                return;
            if (!simple_input("sip_url", sipReq.MessageUnion.makeCallReq.sip_url, sizeof(sipReq.MessageUnion.makeCallReq.sip_url)))
                return;
            sipReq.messageType = IPC_SIP_XFER;

            mQueue.sendData(sipReq);

            
            break;

        case 'X':
            /*
            * Transfer call with replaces.
            */
        //  ui_call_transfer_replaces(app_config.no_refersub);
            break;

        case '#':
            /*
            * Send DTMF strings.
            */
            //ui_send_dtmf_2833();

            sipReq.messageType = IPC_DTMF_2833;
            if (!simple_input("DTMF strings to send (0-9*#A-B)", sipReq.MessageUnion.dmtfReq.buf, sizeof(sipReq.MessageUnion.dmtfReq.buf)))
                return;

            mQueue.sendData(sipReq);
            
            break;

        case '*':
            sipReq.messageType = IPC_DTMF_INFO;
            if (!simple_input("DTMF strings to send (0-9*#A-B)", sipReq.MessageUnion.dmtfReq.buf, sizeof(sipReq.MessageUnion.dmtfReq.buf)))
                return;

            mQueue.sendData(sipReq);

            /* Send DTMF with INFO */
            //ui_send_dtmf_info();
            break;

        case 'S':
            /*
            * Send arbitrary request
            */
            sipReq.messageType = IPC_SIP_START_RECORD;
            if (!simple_input("record file is", sipReq.MessageUnion.recordCallReq.rec_file, sizeof(sipReq.MessageUnion.recordCallReq.rec_file)))
                return; 
                    
            if (!simple_input("account id is", buf, sizeof(buf)))
                    return;
        
            sipReq.MessageUnion.recordCallReq.callID = atoi(buf);
            mQueue.sendData(sipReq);
            //ui_send_arbitrary_request();
            break;

        case 'e':
            
            sipReq.messageType = IPC_SIP_END_RECORD;
    
            mQueue.sendData(sipReq);
            
        //  ui_echo(menuin);
            break;

        case 's':
            //if (pj_ansi_strnicmp(menuin, "sleep", 5) == 0) {
                //ui_sleep(menuin);
                break;
        //  }
            /* Continue below */

        case 'u':
            /*
            * Subscribe/unsubscribe presence.
            */
            //ui_subscribe(menuin);
            break;

        case 'r':
            sipReq.messageType = IPC_SIP_RE_REGISTER;

            mQueue.sendData(sipReq);
            break;

        case 't':
            //ui_toggle_state();
            break;

        case 'T':
            //ui_change_online_status();
            break;

        case 'c':
            switch (menuin[1]) {
            case 'l':
                //ui_conf_list();
                break;
            case 'c':
            case 'd':
                //ui_conf_connect(menuin);
                break;
            }
            break;

        case 'V':
            /* Adjust audio volume */
            //ui_adjust_volume();
            sipReq.messageType = IPC_SPEAKER_VOLUME;

        {
            char *err;
            if (!simple_input("Adjust speaker level",buf,sizeof(buf))) 
            return;
            
            if (!simple_input("Call id",menuin,sizeof(menuin))) 
            return;
        
        
        sipReq.MessageUnion.speakerVolumeReq.volumeLevel = (float)strtod(buf, &err);
        sipReq.MessageUnion.speakerVolumeReq.callID = atoi(menuin);
            }
            mQueue.sendData(sipReq);
            break;

        case 'd':

            sipReq.messageType = IPC_STOP_PLAYER_WAV;
            //strcpy(sipReq.MessageUnion.playerWavReq.wav_file, "/sound/ok.wav");
            mQueue.sendData(sipReq);
            
            break;

        case 'f':
            sipReq.messageType = IPC_PLAYER_WAV;
            if (!simple_input("input wav file path", sipReq.MessageUnion.playerWavReq.wav_file, sizeof(sipReq.MessageUnion.playerWavReq.wav_file)))
                return;
            //strcpy(sipReq.MessageUnion.playerWavReq.wav_file, "/sound/ok.wav");
            mQueue.sendData(sipReq);
            break;

        case 'L':   /* Restart */
            
            sipReq.messageType = IPC_SIP_CONTROL_VOICE;
            if (!simple_input("call id is", buf, sizeof(buf)))
                return;
            
            sipReq.MessageUnion.controlVoiceReq.callID = atoi(buf);

            if (!simple_input("speaker flag is", buf, sizeof(buf)))
                return;

            sipReq.MessageUnion.controlVoiceReq.speakerFlag = atoi(buf);

            if (!simple_input("disable flag is", buf, sizeof(buf)))
                return;

            sipReq.MessageUnion.controlVoiceReq.disable = atoi(buf);
            mQueue.sendData(sipReq);
            break;
        case 'q':
            //legacy_on_stopped(menuin[0] == 'L');
            goto on_exit;

        case 'R':           
                
            sipReq.messageType = IPC_SIP_CONFERENCE;
            
            if (!simple_input("conference flag is", buf, sizeof(buf)))
                return;

            sipReq.MessageUnion.confReq.conferenceFlag = atoi(buf);
            mQueue.sendData(sipReq);
            break;

        default:
            if (menuin[0] != '\n' && menuin[0] != '\r') {
                printf("Invalid input %s", menuin);
            }
            keystroke_help();
            break;
        }
        }

on_exit:
    ;
    }



int main(int argc, char *argv[])
{
    MessageQueue mQueue;
//  SipBase mSipBase(mQueue);
    mQueue.startMessageThread();

    SipRequestStruct sipReq;
    memset(&sipReq, 0, sizeof(SipRequestStruct));
    sipReq.messageType = IPC_SIP_ACCOUNT_ADD;

            
    strcpy(sipReq.MessageUnion.accountReq.user_id, "00A0101");
            
    strcpy(sipReq.MessageUnion.accountReq.passwd, "1010A00");
    
    strcpy(sipReq.MessageUnion.accountReq.sip_server, "115.28.157.161");

    strcpy(sipReq.MessageUnion.accountReq.alias, "tianyh");

    mQueue.sendData(sipReq);


#if 0

    sleep(15);

    sipReq.messageType = IPC_SIP_ANSWER;

    sipReq.MessageUnion.answerReq.callID = 0;
    mQueue.sendData(sipReq);




    while (1)
    {
        memset(&sipReq, 0, sizeof(SipRequestStruct));
        sipReq.messageType = IPC_BT_CONTROL;
        sipReq.MessageUnion.btControlReq.btFlag = true;

        mQueue.sendData(sipReq);

        sleep(3);

        memset(&sipReq, 0, sizeof(SipRequestStruct));
        sipReq.messageType = IPC_BT_CONTROL;
        sipReq.MessageUnion.btControlReq.btFlag = false;

        mQueue.sendData(sipReq);

        sleep(2);

    }
    
#endif
#if 0
    strcpy(sipReq.MessageUnion.accountReq.user_id, "6004");

    strcpy(sipReq.MessageUnion.accountReq.passwd, "6004");

    strcpy(sipReq.MessageUnion.accountReq.sip_server, "192.168.1.18");

    strcpy(sipReq.MessageUnion.accountReq.alias, "tianyh");

    mQueue.sendData(sipReq);
#endif

    legacy_main(mQueue);
#if 0
    while(1)
    {

    sleep(1);
    }
#endif
    return 1;
}
