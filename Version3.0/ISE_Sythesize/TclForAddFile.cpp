#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include "Function.h"

#define MAX_LINE 1024
#define LINE 1024


int AddSourceFile()
{
    char topFile_name[100];
    char buf[MAX_LINE+1];
    int  len ;


///////////////////////////////////////////////////////////////////////////////
    //copy model.tcl  to Sythesize_test.tcl
/////////////////////////////////////////////////////////////////////////////////
    FILE *fileR, *fileW;
    fileR = fopen("model.tcl","r");
    fileW = fopen("Sythesize_test.tcl","w");
    while ((fgets(buf,MAX_LINE,fileR))!=NULL)
    {
        fputs(buf,fileW);
    }
    fclose(fileR);
    fclose(fileW);


////////////////////////////////////////////////////////////////////////////

    //add source files
////////////////////////////////////////////////////////////////////////////
    FILE  *p;
    p = fopen("Sythesize_test.tcl","a");
    fprintf(p," proc add_source_files {} {\n\n");
    fprintf(p,"   global myScript\n\n");
    fprintf(p,"   if { ! [ open_project ] } {\n");
    fprintf(p,"    puts  \"No project was opend.\"\n");
    fprintf(p,"    return false }\n\n");
    fprintf(p," puts \"$myScript: Adding sources to project...\" \n");


    HANDLE hFile;
    HANDLE hFile1;
	LPCTSTR lpFileName = "E:\\u\\*.v";	//指定搜索目录和文件类型，如搜索d盘的音频文件可以是"D:\\*.mp3"
	WIN32_FIND_DATA pNextInfo;	//搜索得到的文件信息将储存在pNextInfo中;

	hFile = FindFirstFile(lpFileName,&pNextInfo);//请注意是 &pNextInfo , 不是 pNextInfo;
	fprintf(p,"  xfile add \"%s\" \n",pNextInfo.cFileName); //这是第一个.v文件

	if(hFile == INVALID_HANDLE_VALUE)
	{
		//搜索失败
		exit(-1);
	}

	while(FindNextFile(hFile,&pNextInfo))
	{
		if(pNextInfo.cFileName[0] == '.')//过滤.和..
		   continue;

        fprintf(p,"  xfile add \"%s\" \n",pNextInfo.cFileName);
	}


	LPCTSTR lpFileName1 = "E:\\u\\*.xco";	//指定搜索目录和文件类型，如搜索d盘的音频文件可以是"D:\\*.mp3"
	WIN32_FIND_DATA pNextInfo1;	//搜索得到的文件信息将储存在pNextInfo中;

	hFile1 = FindFirstFile(lpFileName1,&pNextInfo1);//请注意是 &pNextInfo , 不是 pNextInfo;
	fprintf(p,"  xfile add \"%s\" \n",pNextInfo1.cFileName); //这是第一个.xco文件

	if(hFile1 == INVALID_HANDLE_VALUE)
	{
		//搜索失败
		exit(-1);
	}

	while(FindNextFile(hFile1,&pNextInfo1))
	{
		if(pNextInfo1.cFileName[0] == '.')//过滤.和..
		   continue;

        fprintf(p,"  xfile add \"%s\" \n",pNextInfo1.cFileName);
	}

//////////////////////////////////////////////////////////////////////////////////////
   // set top file
///////////////////////////////////////////////////////////////////////////////////////
    printf("Please input the top file name:\n");
	scanf("%s",topFile_name);
	printf("Get top file name, continue .....\n");


    fprintf(p,"#  Set the Top Module as well... \n");
    fprintf(p,"   project set top \"%s\" \n\n",topFile_name);

    fprintf(p,"   puts \"$myScript: project sources reloaded.\" \n\n");
    fprintf(p,"  }\n");

    fclose(p);

    printf("Create Sythesize_test.tcl.\n");
    return 0;
}
