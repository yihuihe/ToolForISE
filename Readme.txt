# Tcl tool For ISE
***************************************************************
** 作者：Muc.hui
** 时间：2016-4-24
** 版本：Version 3.0
***************************************************************
工具说明：
1.本程序设计的目的是通过生成Tcl Command完成ISE工程的综合。
2.本程序通俗易懂，文件夹中的model.tcl为已经完成的tcl命令模板，其中
  设置了将要综合的工程的名字为Sythesize_test,设置了相应的脚本名字为
  Sythesize_test。在model.tcl中主要有以下几个Proc:
  主过程：
  (1)New_project: 主要用来生成一个名为Sythesize_test的工程，并行设置
  相应的工程属性，例如family,device,package等。然后添加源文件和库文件
  (2)run_process: 设置综合，实现等过程中需要指定的参数，并进行综合。
  并且通过删除注释符“#”可以实现Implement Design和Generate Programming File
  (3)rebuild_project: 重新生成工程并执行，相当于一步执行new_project和
  run_process。
  
  辅过程：
  (1)run_task: 设置任务，实现Implement Design和Generate Programming File。
  (2)show_help: 显示帮助，给出各个过程的简短介绍。
  (3)open_project: 打开一个已有的工程。
  (4)set_project_props: 设置工程属性，例如family,device,package等。
  (5)create_libraries: 创建库。
  (6)set_process_props: 设置综合，实现等过程中需要指定的参数。
  (7)add_source_files: 添加源文件，并制定顶层文件。
  (8)map_report: 显示map report

使用说明：
1.使用本工具前需要在E盘根目录下创建一个名为“u”的文件夹，并将源文件放入该文件
  夹中，源文件包括所有的".v"文件,".xco"文件，“.ucf”文件。
2.运行程序，根据提示输入需要设置的顶层文件的名字。需要注意的是，程序的主要功能
  是查找出E盘根目录下"u"文件夹中所有的".v"文件,".xco"文件，如果还想添加其他文件
  ，请适当修改程序。
3.程序运行结束后会生成一个Sythesize_test.tcl的脚本，将这个脚本复制到E盘根目录
  下"u"文件夹中，打开xtclsh.exe,进入E盘根目录下"u"文件夹中，执行命令
  source Sythesize_test.tcl。
  
********************************************************************************
注意事项：
1.源文件的默认路径是E:/u
2.在model.tcl中设置默认路径为E:/u，即全局变量dirpath,但是需要指定顶层文件,
  即收到设置model.tcl中的topFile_name。
3.运行Sythesize_test.tcl后会生成一个map_report.txt文件
