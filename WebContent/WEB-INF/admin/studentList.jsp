<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>学生列表</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		
	    $('#dataList').datagrid({ 
	        title:'学生列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible:false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"AdminServlet?method=studentList",
	        idField:'sno', 
	        singleSelect:false,//是否单选 
	        pagination:true,//分页控件 
	        rownumbers:true,//行号 
	        sortName:'sno',
	        sortOrder:'ASC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},		       
 		        {field:'sno',title:'学号',width:150,sortable: true},    
 		        {field:'sname',title:'姓名',width:100},
 		        {field:'ssex',title:'性别',width:50},
		        {field:'sage',title:'年龄',width:50},  
		        {field:'syear',title:'入学年份',width:100,sortable: true},
 		        {field:'scredit',title:'学分',width:50},
 		        {field:'saddress',title:'地址',width:250},
 		        {field:'clno',title:'班级编号',width:50},
 		        {field:'clname',title:'班级',width:100},
 		        {field:'mno',title:'专业编号',width:50},
 		        {field:'mname',title:'专业',width:200},
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	     
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//每页显示的记录条数，默认为10 
	        pageList: [10,20,30,50,100],//可以设置每页记录条数的列表 
	        beforePageText: '第',//页数文本框前显示的汉字 
	        afterPageText: '页    共 {pages} 页', 
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
	    });
	    //添加
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    //修改
	    $("#edit").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    //删除
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var sno = selectRow.sno;
            	$.messager.confirm("消息提醒", "将删除与课程相关的所有数据，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "AdminServlet?method=deleteStudent",
							data: {sno: sno},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("消息提醒","删除失败!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	//设置添加学生窗口
	    $("#addDialog").dialog({
	    	title: "添加学生",
	    	width: 650,
	    	height: 460,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "AdminServlet?method=addStudent",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_sno").textbox('setValue', "");
										$("#add_sname").textbox('setValue', "");
										$("#add_sex").textbox('setValue', "男");
										$("#add_sage").textbox('setValue', "");
										$("#add_syear").textbox('setValue', "");	
										$("#add_scredit").textbox('setValue', "");
										$("#add_saddress").textbox('setValue', "");
										$("#add_clno").textbox('setValue', "");
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");	
									} else{
										$.messager.alert("消息提醒","添加失败!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#add_sno").textbox('setValue', "");
						$("#add_sname").textbox('setValue', "");
						$("#add_sex").textbox('setValue', "男");
						$("#add_sage").textbox('setValue', "");
						$("#add_syear").textbox('setValue', "");	
						$("#add_scredit").textbox('setValue', "");
						$("#add_saddress").textbox('setValue', "");
						$("#add_clno").textbox('setValue', "");
					}
				},
			]
	    });

	  
		//设置编辑学生窗口
	    $("#editDialog").dialog({
	    	title: "修改学生信息",
	    	width: 650,
	    	height: 460,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'提交',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "AdminServlet?method=editStudent",
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","更新成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//刷新表格
										$("#dataList").datagrid("reload");
										$("#dataList").datagrid("uncheckAll");						  			
									} else{
										$.messager.alert("消息提醒","更新失败!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						//清空表单
						$("#edit_sno").textbox('setValue', selectRow.sno);
						$("#edit_sname").textbox('setValue', selectRow.sname);
						$("#edit_sex").textbox('setValue', selectRow.ssex);
						$("#edit_sage").textbox('setValue', selectRow.sage);
						$("#edit_syear").textbox('setValue', selectRow.syear);	
						$("#edit_scredit").textbox('setValue', selectRow.scredit);
						$("#edit_saddress").textbox('setValue', selectRow.saddress);
						$("#edit_clno").textbox('setValue', selectRow.clno);
					}
				}
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_sno").textbox('setValue', selectRow.sno);
				$("#edit_sname").textbox('setValue', selectRow.sname);
				$("#edit_sex").textbox('setValue', selectRow.ssex);
				$("#edit_sage").textbox('setValue', selectRow.sage);
				$("#edit_syear").textbox('setValue', selectRow.syear);	
				$("#edit_scredit").textbox('setValue', selectRow.scredit);
				$("#edit_saddress").textbox('setValue', selectRow.saddress);
				$("#edit_clno").textbox('setValue', selectRow.clno);
			}
	    });
	});
	</script>
</head>
<body>
	<!-- 学生列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- 工具栏 -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a></div>
	</div>
	<div id="addDialog" style="padding: 10px">
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>学号:</td>
	    			<td><input id="add_sno" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="sno"  data-options="required:true,missingMessage:'请输入学号'" /></td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="add_sname" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="sname" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="add_ssex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="ssex"><option value="M">男</option><option value="F">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>年龄:</td>
	    			<td><input id="add_sage" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="sage" /></td>
	    		</tr>
	    		<tr>
	    			<td>入学年份:</td>
	    			<td><input id="add_syear" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="syear"/></td>
	    		</tr>
	    		<tr>
	    			<td>学分:</td>
	    			<td><input id="add_scredit" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="scredit"/></td>
	    		</tr>
	    		<tr>
	    			<td>地址:</td>
	    			<td><input id="add_saddress" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="saddress"/></td>
	    		</tr>
	    		<tr>
	    			<td>班级编号:</td>
	    			<td><input id="add_clno" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="clno"/></td>
	    		</tr>
	    	</table>
	    </form>
	</div>	
	<!-- 修改学生窗口 -->
	<div id="editDialog" style="padding: 10px">
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>学号:</td>
	    			<td><input id="edit_sno" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="sno" readonly="readonly" data-options="required:true,missingMessage:'请输入学号'" /></td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="edit_sname" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="sname" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="edit_ssex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="ssex"><option value="M">男</option><option value="F">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>年龄:</td>
	    			<td><input id="edit_sage" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="sage" /></td>
	    		</tr>
	    		<tr>
	    			<td>入学年份:</td>
	    			<td><input id="edit_syear" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="syear"/></td>
	    		</tr>
	    		<tr>
	    			<td>学分:</td>
	    			<td><input id="edit_scredit" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="scredit"/></td>
	    		</tr>
	    		<tr>
	    			<td>地址:</td>
	    			<td><input id="edit_saddress" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="saddress"/></td>
	    		</tr>
	    		<tr>
	    			<td>班级编号:</td>
	    			<td><input id="edit_clno" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="clno"/></td>
	    		</tr>
	    	</table>
	    </form>
	</div>	
</body>
</html>