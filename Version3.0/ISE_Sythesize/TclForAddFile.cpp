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
	LPCTSTR lpFileName = "E:\\u\\*.v";	//ָ������Ŀ¼���ļ����ͣ�������d�̵���Ƶ�ļ�������"D:\\*.mp3"
	WIN32_FIND_DATA pNextInfo;	//�����õ����ļ���Ϣ��������pNextInfo��;

	hFile = FindFirstFile(lpFileName,&pNextInfo);//��ע���� &pNextInfo , ���� pNextInfo;
	fprintf(p,"  xfile add \"%s\" \n",pNextInfo.cFileName); //���ǵ�һ��.v�ļ�

	if(hFile == INVALID_HANDLE_VALUE)
	{
		//����ʧ��
		exit(-1);
	}

	while(FindNextFile(hFile,&pNextInfo))
	{
		if(pNextInfo.cFileName[0] == '.')//����.��..
		   continue;

        fprintf(p,"  xfile add \"%s\" \n",pNextInfo.cFileName);
	}


	LPCTSTR lpFileName1 = "E:\\u\\*.xco";	//ָ������Ŀ¼���ļ����ͣ�������d�̵���Ƶ�ļ�������"D:\\*.mp3"
	WIN32_FIND_DATA pNextInfo1;	//�����õ����ļ���Ϣ��������pNextInfo��;

	hFile1 = FindFirstFile(lpFileName1,&pNextInfo1);//��ע���� &pNextInfo , ���� pNextInfo;
	fprintf(p,"  xfile add \"%s\" \n",pNextInfo1.cFileName); //���ǵ�һ��.xco�ļ�

	if(hFile1 == INVALID_HANDLE_VALUE)
	{
		//����ʧ��
		exit(-1);
	}

	while(FindNextFile(hFile1,&pNextInfo1))
	{
		if(pNextInfo1.cFileName[0] == '.')//����.��..
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
