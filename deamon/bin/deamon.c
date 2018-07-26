#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

void init_daemon()
{
    int pid;
    int i;

    pid=fork();

    // 目的是为了摆脱父进程, 使进程可以在后台运行
    if (pid>0) { // 为避免挂起控制终端将Daemon放入后台执行。方法是在进程中调用fork使父进程终止，让Daemon在子进程中后台执行
        exit(EXIT_SUCCESS); //结束父进程,子进程继续
    }

    if (pid<0) {  // 创建错误，退出
        exit(EXIT_FAILURE);
    }

    /*
     * 当进程是会话组长时setsid()调用失败。但第一点已经保证进程不是会话组长
     * setsid()调用成功后，进程成为新的会话组长和新的进程组长，并与原来的登录会话和进程组脱离
     * 由于会话过程对控制终端的独占性，进程同时与控制终端脱离。
     * */
    setsid(); // 使子进程成为组长

    pid=fork();

    // 禁止进程重新打开控制终端 现在子进程已经成为无终端的会话组长。
    // 但它可以重新申请打开一个控制终端。可以通过使进程不再成为会话组长来禁止进程重新打开控制终端
    if (pid>0) {
        exit(EXIT_SUCCESS); //结束第一子进程，第二子进程继续（第二子进程不再是会话组长）这样进程就不会打开控制终端
    }

    if (pid<0) {
        exit(EXIT_FAILURE);
    }

    // 关闭进程打开的文件句柄 进程从创建它的父进程那里继承了打开的文件描述符
    // 如不关闭，将会浪费系统资源，造成进程所在的文件系统无法卸下以及引起无法预料的错误
    for (i=0;i<NOFILE;i++) {
        close(i);
    }

    chdir("/tmp");  // 改变当前工作目录

    umask(0); // 重设文件创建的掩码
    signal(SIGCHLD,SIG_IGN); 

    return;
}

void main(int argc, char *argv[])
{
    char str[1024] = {0};
    /* char * cmd = "/usr/local/php/bin/php /usr/local/tools/deamon/test.php"; */
    char * cmd = argv[1]; // 输入要执行的PHP命令
    FILE * stream = NULL;
    FILE *fp;

    init_daemon();

    while(1)
    {
        /* sleep(1); //等待一秒钟再写入 */

        fp=fopen("test.log","a");

        if ((stream = popen(cmd, "r")) == NULL){ //通过popen执行PHP代码
            printf("hehe!\n");
            return;
        }

        char ret[1024] = "";

        while((fgets(str, 1024, stream)) != NULL){ //通过fgets获取PHP中echo输出的字符串
            strcat(ret, str);
            fprintf(fp,ret);  //转换为本地时间输出
            fclose(fp);
        }

        pclose(stream);

        fprintf(fp,"str%si$d\n");  //转换为本地时间输出
        printf(str);
    }

    return;
}

