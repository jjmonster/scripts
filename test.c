/*************************************************************************
    > File Name: test.c
    > Author: jjia
    > Mail: junjie.jia@cienet.com.cn
    > Created Time: Fri 21 Sep 2018 02:04:08 PM CST
 ************************************************************************/

#include <stdio.h>
#include <errno.h>
#include <sys/resource.h>

int enableCoreDump(int iFlag)
{
    int iRes = RLIMIT_CORE;
    struct rlimit stRlim;

    /* 允许生成core文件 */
    stRlim.rlim_cur = stRlim.rlim_max = iFlag ? RLIM_INFINITY : 0;
    if (0 != setrlimit(iRes, &stRlim))
    {
        printf("Error: setrlimit failed, %s\n", strerror(errno));
        return 1;
    }
    else
    {
        /* 设置core文件生成的路径 */
        system("echo /exa_data/core > /proc/sys/kernel/core_pattern");
        printf("Set coredump file size to %lu, path = /exa_data/core\n", stRlim.rlim_cur);
        return 0;
    }

    return 1;
}


int main()
{
	int i;
	char a[1];
	char *p= NULL;

	printf("test.....\n");
	enableCoreDump(1);

	for(i=0; i < 1; i++)
	{
		sleep(1);
	}
	printf("generate error...\n");
	//printf("%c", a[1]);
	//scanf("%d", 0);
	*p = 'x';
	printf("%c", *p);
	printf("not run to here!\n");
	return 0;
}
