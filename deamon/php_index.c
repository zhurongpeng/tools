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

void main(int argc, char *argv[])
{
    char str[1024] = {0};
    /* char * cmd = "/usr/local/php/bin/php /usr/local/tools/deamon/test.php"; */
    char * cmd = argv[1];
    FILE * stream = NULL;

    if ((stream = popen(cmd, "r")) == NULL){ //通过popen执行PHP代码
        printf("hehe!\n");
        return;
    }

    char ret[1024] = "";

    while((fgets(str, 1024, stream)) != NULL){ //通过fgets获取PHP中echo输出的字符串
        strcat(ret, str);
    }

    pclose(stream);

    printf(str);
    return;
}

void main()
{
    FILE *fp;
    time_t t;
    init_daemon();
    while(1)
    {
        sleep(1); //等待一秒钟再写入
        fp=fopen("test.log","a");
        if(fp>=0)
        {
            time(&t);
            fprintf(fp,"current time is:%s\n",asctime(localtime(&t)));  //转换为本地时间输出
            fclose(fp);
        }
    }
    return;
}
