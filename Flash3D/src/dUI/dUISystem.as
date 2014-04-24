//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import dcom.*;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dUISystem
	{
		public static var DELETE_WINDOW:int;
		/// 创建控件，
		/// 参数id为指定父对象，如果id为0则从根窗口创建；
		/// 参数nParam1为指定ID，如果nParam1为0则自动生成一个唯一ID
		/// 参数nParam4为父对象的页索引
		public static var CREATE_WINDOW:int;
		public static var CREATE_BUTTON:int;
		public static var CREATE_IMAGEBUTTON:int;
		public static var CREATE_EDITBOX:int;
		public static var CREATE_SUPPERTEXT:int;
		public static var CREATE_IMAGEBOX:int;
		public static var CREATE_DRAGICON:int;
		public static var CREATE_LISTBOX:int;
		public static var CREATE_PROGRESS:int;
		public static var CREATE_TABCONTROL:int;
		public static var CREATE_GROUP:int;
		public static var CREATE_CHECKBOX:int;
		public static var CREATE_RADIOBOX:int;
		public static var CREATE_TREE:int;
		public static var CREATE_SCROLL:int;
		public static var CREATE_SLIDER:int;
		public static var CREATE_MENU:int;
		public static var CREATE_SPLITER:int;
		public static var CREATE_STACK:int;
		public static var CREATE_ANIIMAGEBOX:int;
		/// 创建右键菜单( x , y , 0 , 0 , "内容1,内容2,内容3" )
		public static var CREATE_RIGHT_MENU:int;
		/// 创建MessageBox( x=0, y=0(xy均为0则居中), 倒计时=0, TabIndex , "消息标题|消息内容|是|否|取消" )
		public static var CREATE_MESSAGEBOX:int;
		/// 设置坐标( x, y )
		public static var C_SET_POS:int;
		/// 获得X坐标()
		public static var C_GET_POSX:int;
		/// 获得Y坐标()
		public static var C_GET_POSY:int;
		/// 设置旋转( angle 0-360 )
		public static var C_SET_ROTATION:int;
		/// 获得旋转
		public static var C_GET_ROTATION:int;
		public static var C_GET_ROTATION_MIRRORX:int;
		public static var C_GET_ROTATION_MIRRORY:int;
		/// 设置边距坐标( type 0左 1上 2右 3下 , 坐标值 )
		public static var C_SET_MARGIN:int;
		/// 设置宽高( width, height )
		public static var C_SET_SIZE:int;
		/// 获得宽()
		public static var C_GET_WIDTH:int;
		/// 获得高()
		public static var C_GET_HEIGHT:int;
		/// 设置控件ID( newID )
		public static var C_SET_ID:int;
		/// 设置文字( 0 , 0 , 0 , 0 , text )
		public static var C_SET_TEXT:int;
		/// 获得文字()
		public static var C_GET_TEXT:int;
		/// 获得文字不包含控制符
		public static var C_GET_TEXT_WITHOUT_SIGN:int;
		/// 设置控件名称( 0 , 0 , 0 , 0 , name )
		public static var C_SET_CONTROL_NAME:int;
		/// 获得控件名称
		public static var C_GET_CONTROL_NAME:int;
		/// 从imageSet载入( 0 , 0 , 0 , 0 , imageSetName )
		public static var C_LOAD_FROM_IMAGESET:int;
		/// 从文件载入( 0 , 0 , 0 , 0 , fileName )
		public static var C_LOAD_FROM_FILE:int;
		/// 从模板载入( 0 , idOffset , 0 , TabIndex , "" , byteArray )
		public static var C_LOAD_FROM_TEMPLATE:int;
		/// 从ByteArray中载入
		public static var C_LOAD_FROM_BIN:int;
		public static var C_LOAD_FROM_BITMAPDATA:int;
		public static var C_COPY_CREATE:int;
		/// 获得ImageSet名
		public static var C_GET_IMAGE_SET_NAME:int;
		/// 获得控件上的相对鼠标坐标
		public static var C_GET_MOUSEX:int;
		public static var C_GET_MOUSEY:int;
		/// 设置样式( bSet , 0 , 0 , 0 , styleName )
		/// styleName根据控件类型不同，styleName可以是以下值：
		/// <GUIOBJ_TYPE_BUTTON> <GUIOBJ_TYPE_IMAGE_BUTTON>
		///		"AlwaysPushDown"		始终按下
		///		"AutoSetSize"			根据文字自动设置大小
		///	<GUIOBJ_TYPE_SUPPERTEXT>
		///		"AutoEnterLine"			自动换行
		///		"CanEdit"				可以编辑
		///		"PassWord"				密码显示
		///		"AutoLimitTextLength"	窗口大小受限制
		///		"AutoSetSize"			随文字长度自动改变
		///		"CanEnterLine"			可以回车换行
		///		"NumberOnly"			只接收数字
		///		"CanInputAND"			可以输入“&”
		///	<GUIOBJ_TYPE_EDITBOX>
		///		"ShowVScroll"			显示纵向滚动条
		///		"ShowHScroll"			显示横向滚动条
		///		"AutoEnterLine"			自动换行
		///		"CanEdit"				是否可以编辑
		///		"PassWord"				密码显示
		///		"AutoLimitTextLength"	窗口大小受限制
		///		"DownListButton"		是否有下拉列表按钮
		///		"NumberOnly"			只接收数字
		///		"CanEnterLine"			可以回车换行
		///		"CanInputAND"			可以输入“&”
		///	<GUIOBJ_TYPE_IMAGEBOX>
		///		"CanDrag"				可以托拽
		///	<GUIOBJ_TYPE_DRAGICON>
		///		"CopyDrag"				拖拽后是否仍然显示原来的图标
		///		"ShowBackImage"			显示图标底纹
		///		"CanDrag"				是否可以托拽
		///		"Select"				选中状态
		///	<GUIOBJ_TYPE_LISTBOX>
		///		"ShowVScroll"			显示纵向滚动条
		///		"ShowHScroll"			显示横向滚动条
		///		"AutoEnterLine"			自动换行
		///		"ShowTitle"
		///		"ShowSelection"
		///	<GUIOBJ_TYPE_PROGRESS> <GUIOBJ_TYPE_SLIDER>
		///		"Vertical"				纵向显示
		///		"AutoTextPersent"		自动显示百分比文字
		///		"AutoTextDiv"			自动显示0/100文字
		///	<GUIOBJ_TYPE_TABCONTROL>
		///		"Vertical" 				纵向显示选项卡
		///		"ButtonMirror"			镜向按钮
		/// <GUIOBJ_TYPE_TREE>
		///		"ShowHScroll"			显示横向滚动条
		///		"ShowVScroll"			显示纵向滚动条
		///		"ShowSelection"			显示选择框
		///		"ShowLine"				显示文字左边的线
		///		"AlwaysShowHScroll"		总是显示横向滚动条
		///		"AlwaysShowVScroll"		总是显示纵向滚动条
		///		"FatherNoSelection"		带加号的节点不可以选择
		///		"ExpandOnlyOne"			设置只能展开一个树子
		/// <GUIOBJ_TYPE_WINDOW>
		///		"ShowCloseButton"
		public static var C_SET_STYLE:int;
		/// 获得样式( 0 , 0 , 0 , 0 , styleName )
		public static var C_GET_STYLE:int;
		/// 设置是否可见( bShow )
		public static var C_SET_SHOW:int;
		/// 获得是否可见()
		public static var C_GET_SHOW:int;
		/// 设置对象里的所有子是否可见
		public static var C_SET_SHOW_CLIENT:int;
		/// 获得对象里的所有子是否可见
		public static var C_GET_SHOW_CLIENT:int;
		/// 设置显示等待模式
		public static var C_SET_WAIT:int;
		/// 获得是否显示等待模式
		public static var C_GET_WAIT:int;
		/// 控件是否有效( bEnable )
		public static var C_ENABLE_WINDOW:int;
		/// 获得控件是否有效
		public static var C_IS_WINDOW_ENABLE:int;
		/// 控件是否接受鼠标( bHandle )
		public static var C_SET_HANDLE_MOUSE:int;
		/// 获得控件是否接受鼠标
		public static var C_IS_HANDLE_MOUSE:int;
		/// 设置激活输入焦点( bool是否激活 )
		public static var C_SET_FOCUS:int;
		public static var C_GET_FOCUS:int;
		/// 设置坐标自动贴靠方式( dUISystem.GUI_AUTOPOS_CENTER , dUISystem.GUI_AUTOPOS_CENTER )
		public static var C_SET_AUTO_POS:int;
		public static var C_GET_AUTO_POSX:int;
		public static var C_GET_AUTO_POSY:int;
		public static var C_SET_AUTO_POS_PANNEL:int;
		public static var C_SET_AUTO_BRING_TOP_PANNEL:int;
		/// 设置透明度( 0-255 )
		public static var C_SET_ALPHA:int;
		/// 获得透明度
		public static var C_GET_ALPHA:int;
		/// 设置变灰( bGray )
		public static var C_SET_GRAY:int;
		/// 获得是否变灰
		public static var C_GET_GRAY:int;
		/// 设置高亮( bGray )
		public static var C_SET_HIGHTLIGHT:int;
		/// 获得是否高亮
		public static var C_GET_HIGHTLIGHT:int;
		/// 设置自动与父同大小
		public static var C_SET_AUTO_SIZE_AS_FATHER:int;
		/// 获得是否自动同父大小
		public static var C_GET_AUTO_SIZE_AS_FATHER:int;
		/// 设置自动与子同大小
		public static var C_SET_AUTO_SIZE_AS_CHILD:int;
		/// 获得是否与子同大小
		public static var C_GET_AUTO_SIZE_AS_CHILD:int;
		/// 获得世界坐标
		public static var C_GET_POSX_WORLD:int;
		public static var C_GET_POSY_WORLD:int;
		/// 添加自定义控件( 0 , 0 , 0 , 0 , "" , 控件 ),控件必须继承自DisplayObject
		public static var C_ADD_DISPLAY_OBJ:int;
		/// 移除自定义控件( 0 , 0 , 0 , 0 , "" , 控件 )
		public static var C_REMOVE_DISPLAY_OBJ:int;
		public static var C_ADD_SPRITE:int;
		public static var C_REMOVE_SPRITE:int;
		/// 获得父对象ID
		public static var C_GET_FATHER_ID:int;
		/// 将控件坐标设置到居中父窗口
		public static var C_SET_TO_CENTER:int;
		/// 将控件显示在最前面( 指定在对象ID之上，默认为0 )
		public static var C_BRING_TO_TOP:int;
		/// 将控件显示在最后面
		public static var C_BRING_TO_BOTTOM:int;
		/// 控件闪烁( 闪烁次数 , 闪烁速度 , nTabIndex , nLine )
		public static var C_FLASH_WINDOW:int;
		/// 取消闪烁( 0 , 0 , nTabIndex , nLine )
		public static var C_FLASH_WINDOW_DISABLE:int;
		/// 获得控件类型，返回值为GUIOBJ_TYPE_XXX
		public static var C_GET_OBJ_TYPE:int;
		/// 设置控件自定义数据( 0 , 0 , 0 , 0 , "treeObjName" , userData )
		public static var C_SET_USER_DATA:int;
		/// 获得控件自定义数据()
		public static var C_GET_USER_DATA:int;
		/// 设置ToolTip文字( line , Tab , 0 , 0 , "" , oTooltipData )
		public static var C_SET_TOOLTIP:int;
		/// 获得ToolTip文字
		public static var C_GET_TOOLTIP:int;
		/// 设置居中方式( type = 默认为dUISystem.GUI_ALIGN_MIDDLE , index )
		public static var C_SET_ALIGN:int;
		/// 获得居中方式( index )
		public static var C_GET_ALIGN:int;
		/// 获得用户区大小
		public static var C_GET_CLIENT_WIDTH:int;
		public static var C_GET_CLIENT_HEIGHT:int;
		/// 设置控件自动隐藏( bReg )
		public static var C_REG_MOUSE_FADING:int;
		/// 获得控件是否自动隐藏
		public static var C_IS_REG_MOUSE_FADING:int;
		/// 设置控件颜色变换( 亮度-100至100 , 对比度-100至100 , 饱和度-100至100 , 色相-180至180 )
		public static var C_SET_COLOR_TRANSFORM:int;
		/// 设置鼠标指针样式( 默认为dUISystem.GUI_MOUSESTYLE_ARROW )
		public static var C_SET_MOUSE_STYLE:int;
		/// 获得鼠标指针样式
		public static var C_GET_MOUSE_STYLE:int;
		/// 获得鼠标是否在控件内
		public static var C_IS_MOUSE_IN:int;
		/// 设置边距
		public static var C_SET_EDGE_RECT:int;
		/// 按钮专用，设置始终按下( bSet )
		public static var BUTTON_SET_PUSH_DOWN:int;
		/// 按钮专用，获得始终按下
		public static var BUTTON_GET_PUSH_DOWN:int;
		/// 按钮专用，设置选择图片( 0 , 0 , 0 , 0 , imageSetName )
		public static var BUTTON_SET_SEL_IMAGE_FROM_IMAGESET:int;
		/// 编辑框，设置文字长度限制( num )
		public static var TEXT_SET_LIMIT_TEXT_LENGTH:int;
		/// 编辑框，获得文字长度限制()
		public static var TEXT_GET_LIMIT_TEXT_LENGTH:int;
		/// 编辑框，设置文字最大数字( num 默认为0x7FFFFFFF )
		public static var TEXT_SET_LIMIT_NUMBER:int;
		/// 编辑框，获得文字最大数字()
		public static var TEXT_GET_LIMIT_NUMBER:int;
		/// 编辑框，设置文字最小数字( num 默认为0x80000000 )
		public static var TEXT_SET_LIMIT_NUMBER_MIN:int;
		/// 编辑框，获得文字最小数字()
		public static var TEXT_GET_LIMIT_NUMBER_MIN:int;
		/// 编辑框，设置当前选择( 起始个数 , 结束个数 )
		public static var TEXT_SET_SELECTION:int;
		/// 编辑框，获得当前选择起始
		public static var TEXT_GET_SELECTION_BEGIN:int;
		/// 编辑框，获得当前选择结束
		public static var TEXT_GET_SELECTION_END:int;
		/// 文字和编辑框，插入文字( 位置-1表示在当前光标插入 , 0 , 0 , 0 , "内容" )
		public static var TEXT_INSERT_STRING:int
		/// 编辑框专用，设置下拉列表文字( 0 , 限制高度(0为不限制) , 0 , 0 , "内容1,内容2|内容2的子内容" )
		public static var EDITBOX_SET_COMBOBOX_STRING:int;
		/// 编辑框专用，获得下拉列表文字
		public static var EDITBOX_GET_COMBOBOX_STRING:int;
		/// 编辑框专用，显示或隐藏下拉列表文字( bShow )
		public static var EDITBOX_SET_COMBOBOX_SHOW:int;
		/// 编辑框专用，获得下拉列表文字是否显示
		public static var EDITBOX_GET_COMBOBOX_SHOW:int;
		/// 图标专用，交换状态( other_icon_id )
		public static var ICON_SWAP_STATUS:int;
		/// 图标专用，复制状态( other_icon_id )
		public static var ICON_COPY_STATUS:int;
		/// 图标专用，清除状态
		public static var ICON_CLEAR_STATUS:int;
		/// 图标专用，设置冷却时间毫秒( curTime , maxTime=-1 )
		public static var ICON_SET_COOL_TIME:int;
		/// 图标专用，获得当前时间毫秒
		public static var ICON_GET_COOL_TIME:int;
		/// 图标专用，设置最大时间毫秒
		public static var ICON_SET_MAX_TIME:int;
		/// 图标专用，获得最大时间毫秒
		public static var ICON_GET_MAX_TIME:int;
		/// 图标专用，设置图标小图片
		public static var ICON_SET_PIC_NAME:int;
		/// 图标专用，设置图标动画
		public static var ICON_SET_ANI_NAME:int;
		/// 图标专用，调协图标动画当前帧( nFrame )
		public static var ICON_SET_ANI_CUR_FRAME:int;
		/// 图标专用，设置图标冷却动画
		public static var ICON_SET_COOL_IMAGE_NAME:int;
		/// 图标专用，获得图标冷却动画名
		public static var ICON_GET_COOL_IMAGE_NAME:int;
		/// 图标专用，设置图标动画颜色变换( 亮度-100至100 , 对比度-100至100 , 饱和度-100至100 , 色相-180至180 )
		public static var ICON_SET_ANI_COLOR_TRANSFORM:int;
		/// 列表专用，添加文字( nLine=-1 , nTab , bSetToBottom , bInCmdAdd , strText )
		public static var LB_ADD_STRING:int;
		/// 列表专用，插入文字( nLine , nTab , 0 , 0 , strText )
		public static var LB_INSERT_STRING:int;
		/// 列表专用，获得文字( nLine , ntab )
		public static var LB_GET_STRING:int;
		/// 列表专用，删除一行( nLine )
		public static var LB_DELETE_LIST:int;
		/// 列表专用，删除指定Obj，如果Obj所在行为空，则删除这一行
		public static var LB_DELETE_LIST_OBJ:int;
		/// 列表专用，清除所有
		public static var LB_CLEAR_LIST:int;
		/// 列表专用，获得行数
		public static var LB_GET_LIST_COUNT:int;
		/// 列表专用，设置行数( nLineNum )
		public static var LB_SET_LIST_COUNT:int;
		/// 列表专用，设置列数( count )
		public static var LB_SET_TAB_COUNT:int;
		/// 列表专用，获得列数
		public static var LB_GET_TAB_COUNT:int;
		/// 列表专用，设置列宽( nTab , nWidth )
		public static var LB_SET_TAB_WIDTH:int;
		/// 列表专用，获得列宽( nTab )
		public static var LB_GET_TAB_WIDTH:int;
		/// 列表专用，设置列名( nTab , 0 , 0 , 0 , name )
		public static var LB_SET_TAB_NAME:int;
		/// 列表专用，获得列名( nTab )
		public static var LB_GET_TAB_NAME:int;
		/// 列表专用，设置最大行数，超出则删除最上一行，0为无限制( num )
		public static var LB_SET_MAX_LIST_NUM:int;
		/// 列表专用，获得最大行数
		public static var LB_GET_MAX_LIST_NUM:int;
		/// 列表专用，设置当前选择行( nLine )
		public static var LB_SET_CUR_SEL:int;
		/// 列表专用，获得当前选择行
		public static var LB_GET_CUR_SEL:int;
		/// 列表专用，添加对象( nLine=-1 , nTab , bNoBottom , 要添加的对象ID )
		public static var LB_ADD_LIST:int;
		/// 列表专用，添加对象( nLine=-1 , nTab )
		public static var LB_REMOVE_LIST:int;
		/// 列表专用，插入对象( nLine , nTab , 0 , 要添加的对象ID )
		public static var LB_INSERT_LIST:int;
		/// 列表专用，获得对象ID( nLine , ntab )
		public static var LB_GET_LIST:int;
		/// 列表专用，设置列可以排序( nTab , bCanSort )
		public static var LB_SET_TAB_CAN_SORT:int;
		/// 列表专用，获得列是否可以排序( nTab )
		public static var LB_GET_TAB_CAN_SORT:int;
		/// 列表专用，设置列显示排序图标
		public static var LB_SET_TAB_SHOW_SORT_ICON:int;
		/// 列表专用，获得列是否显示排序图标
		public static var LB_GET_TAB_SHOW_SORT_ICON:int;
		/// 列表专用，立即排序某列( nTab , bool从小到大 )
		public static var LB_SORT_TAB:int;
		/// 列表专用，设置排序函数( nTab , 0 , 0 , 0 , "" , Function ) 函数格式为：Function( nLine1:int , nLine2:int ):int
		public static var LB_SET_SORT_METHOD_FUNCTION:int;
		/// 列表设置行高度( nHeight )
		public static var LB_SET_FORCE_PER_LINE_HEIGHT:int
		/// 列表获得行高度
		public static var LB_GET_FORCE_PER_LINE_HEIGHT:int
		/// 列表设置行间距( nHeight )
		public static var LB_SET_PER_LINE_SPACE:int;
		/// 列表获得行间距
		public static var LB_GET_PER_LINE_SPACE:int;
		/// 进度条与滑杆，设置最大值( max )
		public static var PROGRESS_SET_MAX_VALUE:int;
		/// 进度条与滑杆，获得最大值
		public static var PROGRESS_GET_MAX_VALUE:int;
		/// 进度条与滑杆，设置最小值( min )
		public static var PROGRESS_SET_MIN_VALUE:int;
		/// 进度条与滑杆，获得最小值
		public static var PROGRESS_GET_MIN_VALUE:int;
		/// 进度条与滑杆，设置当前值( num )
		public static var PROGRESS_SET_VALUE:int;
		/// 进度条与滑杆，获得当前值
		public static var PROGRESS_GET_VALUE:int;
		/// 进度条，获得6帧图片名
		public static var PROGRESS_GET_IMAGESET_NAME:int;
		/// 进度条，开始自动增长( 总时间 )
		public static var PROGRESS_BEGIN_ADD:int;
		/// 进度条，停止自动增长
		public static var PROGRESS_STOP:int;
		/// 选项卡专用，设置选项卡数量( num )
		public static var TB_SET_TAB_NUM:int;
		/// 选项卡专用，获得选项卡数量
		public static var TB_GET_TAB_NUM:int;
		/// 选项卡专用，设置选项卡名( nTab , 0 , 0 , 0 , name )
		public static var TB_SET_TAB_NAME:int;
		/// 选项卡专用，获得选项卡名( nTab )
		public static var TB_GET_TAB_NAME:int;
		/// 选项卡专用，设置当前选项( nTabSet )
		public static var TB_SET_SELECT_TAB:int;
		/// 选项卡专用，获得当前选项
		public static var TB_GET_SELECT_TAB:int;
		/// 选项卡专用，显示选项卡按钮( nTabIndex , bShow )
		public static var TB_SET_TAB_SHOW:int;
		/// 选项卡专用，获得选项卡按钮是否显示( nTabIndex )
		public static var TB_GET_TAB_SHOW:int;
		/// 选项卡专用，设置选项卡按钮是否有效( nTabIndex , bEnable )
		public static var TB_ENABLE_TAB:int;
		/// 选项卡专用，获得选项卡按钮是否有效( nTabIndex )
		public static var TB_IS_TAB_ENABLE:int;
		/// 选项卡专用，获得选项卡按钮坐标( nTabIndex )
		public static var TB_GET_TAB_BOUNDING_RECT:int;
		/// 单选框和多选框，设置选中( bSet )
		public static var CHECKBOX_SET_CHECK:int;
		/// 单选框和多选框，获得是否选中
		public static var CHECKBOX_GET_CHECK:int;
		/// 树专用，展开或合并指定分支( bExpand , 0 , 0 , 0 , treeObjName|child )
		public static var TREE_EXPAND:int;
		/// 树专用，获得是否展开( 0 , 0 , 0 , 0 , treeObjName|child )
		public static var TREE_IS_EXPAND:int;
		/// 树专用，展开或合并全部( bExpand )
		public static var TREE_EXPAND_ALL:int;
		/// 树专用，添加分支( 0 , 0 , 0 , 0 , treeObjName|child );
		public static var TREE_ADD_OBJ:int;
		/// 树专用，添加分支到指定行( nLine , 0 , 0 , 0 , treeObjName|Child );
		public static var TREE_ADD_OBJ_TO_FIRST:int;
		/// 树专用，删除分支( 0 , 0 , 0 , 0 , treeObjName|child );
		public static var TREE_DEL_OBJ:int;
		/// 树专用，删除全部
		public static var TREE_CLEAR_OBJ:int;
		/// 树专用，设置当前选择( 0 , 0 , 0 , 0 , treeObjName|child );
		public static var TREE_SET_CUR_SEL:int;
		/// 树专用，获得当前选择
		public static var TREE_GET_CUR_SEL:int;
		/// 树专用，更改分支字符( 0 , 0 , 0 , 0 , "treeObjName|child||newChildName" )
		public static var TREE_SET_OBJ:int;
		/// 树专用，获得所有树字符，返回的每个树文字用逗号分开( 0 , 0 , 0 , 0 , treeObjName = "" )
		public static var TREE_GET_ALL:int;
		/// 树专用，清除选择
		public static var TREE_CLEAR_CUR_SEL:int;
		/// 树专用，清除父对象所在的所有子( 0 , 0 , 0 , 0 , "treeObjFatherName" );
		public static var TREE_CLEAR_CHILD:int;
		/// 树专用，通过UserData查找树子，返回树子名，未找到返回"" ( 0 , 0 , 0 , 0 , "" , userData )
		public static var TREE_FIND_OBJ_BY_USER_DATA:int;
		/// 树专用，强制显示展开按钮( bShow , 0 , 0 , 0 , "treeObjName|child" )
		public static var TREE_FORCE_SHOW_EXPAND_BUTTON:int;
		/// 树专用，获得是否强制显示展开按钮( 0 , 0 , 0 , 0 , "treeObjName|child" )
		public static var TREE_IS_FROCE_SHOW_EXPAND_BUTTON:int;
		/// 树专用，设置树子段落缩进宽度( width )，返回dUIImageRect
		public static var TREE_SET_CHILD_STEP_OFFSET_X:int;
		/// 树专用，获得树子文字绑定范围( 文字索引 , 0 , 0 , 0 , "treeObjName|child" )
		public static var TREE_GET_CHILD_TEXT_BOUNDING_RECT:int;
		/// 菜单专用，添加菜单( 0 , 0 , 0 , 0 , "Menu,sub" )
		public static var MENU_ADD:int;
		/// 菜单专用，替换菜单( 0 , 0 , 0 , 0 , "Menu,sub,,newSub" )
		public static var MENU_REPLACE:int;
		/// 菜单专用，删除菜单( 0 , 0 , 0 , 0 , "Menu,sub1,sub2|child" )
		public static var MENU_DEL:int;
		/// 窗口拆分器设置横向滚动百分比( 0-100 )
		public static var SPLITER_SET_VALUE_H:int;
		/// 窗口拆分器设置纵向滚动百分比( 0-100 )
		public static var SPLITER_SET_VALUE_V:int;
		/// 窗口拆分器设置视区为固定大小 0不固定 1左边固定 2上边固定 3右边固定 4下边固定
		public static var SPLITER_SET_STATIC_SCROLL_TYPE:int;
		public static var SPLITER_GET_STATIC_SCROLL_TYPE:int;
		/// 滚动条设置用户区域大小
		public static var SCROLL_SET_CLIENT_SIZE:int;
		/// 滚动条获得用户区域宽
		public static var SCROLL_GET_CLIENT_WIDTH:int;
		/// 滚动条获得用户区域高
		public static var SCROLL_GET_CLIENT_HEIGHT:int;
		/// 滚动条设置用户区坐标
		public static var SCROLL_SET_CLIENT_POS:int;
		/// 滚动条获得用户区坐标
		public static var SCROLL_GET_CLIENT_POSX:int;
		public static var SCROLL_GET_CLIENT_POSY:int;
		/// 滚动条滚动到顶端
		public static var SCROLL_SCROLL_TO_TOP:int;
		/// 滚动条滚动到底端
		public static var SCROLL_SCROLL_TO_BOTTOM:int;
		/// 背景图片，填充颜色( colorARGB )
		public static var IMAGE_BOX_FILL_COLOR:int;
		/// 背景图片，将窗口及其子控件画到背景图片上
		public static var IMAGE_BOX_DRAW_WINDOW:int;
		/// 背景图片，注册鼠标移动事件( bReg )
		public static var IMAGE_BOX_REG_MOUSE_MOVE:int;
		/// 背景图片，注册按键事件( bReg )
		public static var IMAGE_BOX_HANDLE_KEY:int;
		/// 背景图片，获得颜色数据，返回为Vector<uint>
		public static var IMAGE_BOX_GET_COLOR_DATA:int;
		/// 背景图片，设置透明通道为圆形
		public static var IMAGE_BOX_DRAW_MASK_CIRCAL:int;
		/// 背景按钮，获得4帧图片名( frame0-3 ) 0正常 1发亮 2按下 3无效
		public static var IMAGEBUTTON_GET_IMAGESET_NAME:int;
		/// 动画专用，设置最大帧数( maxFrame )
		public static var ANIIMAGEBOX_SET_MAX_FRAME:int;
		/// 动画专用，获得最大帧数
		public static var ANIIMAGEBOX_GET_MAX_FRAME:int;
		/// 动画专用，设置当前帧数
		public static var ANIIMAGEBOX_SET_CUR_FRAME:int;
		/// 动画专用，获得当前帧数
		public static var ANIIMAGEBOX_GET_CUR_FRAME:int;
		/// 动画专用，停止播放
		public static var ANIIMAGEBOX_STOP:int;
		/// 动画专用，开始播放
		public static var ANIIMAGEBOX_PLAY:int;
		/// 动画专用，设置播放速度( 间隔毫秒,默认为100 )
		public static var ANIIMAGEBOX_SET_SPEED:int;

		public static const GUIOBJ_TYPE_BASEOBJ:int = 0;		///< 基础控件类型
		public static const GUIOBJ_TYPE_WINDOW:int = 2;			///< 窗口控件类型
		public static const GUIOBJ_TYPE_BUTTON:int = 3;			///< 按钮控件类型
		public static const GUIOBJ_TYPE_IMAGEBUTTON:int = 4;	///< 贴图按钮控件类型
		public static const GUIOBJ_TYPE_EDITBOX:int = 5;		///< 编辑框（输入框）控件类型
		public static const GUIOBJ_TYPE_SUPPERTEXT:int = 6;		///< 文本控件类型
		public static const GUIOBJ_TYPE_IMAGEBOX:int = 7;		///< 贴图控件类型
		public static const GUIOBJ_TYPE_MESSAGEBOX:int = 8;		///< 消息框控件类型
		public static const GUIOBJ_TYPE_DRAGICON:int = 9;		///< 图标控件类型
		public static const GUIOBJ_TYPE_LISTBOX:int = 10;		///< 列表控件类型
		public static const GUIOBJ_TYPE_PROGRESS:int = 11;		///< 进度条控件类型
		public static const GUIOBJ_TYPE_TABCONTROL:int = 12;	///< 多栏列表控件类型
		public static const GUIOBJ_TYPE_GROUP:int = 13;			///< 组控件类型
		public static const GUIOBJ_TYPE_CHECKBOX:int = 14;		///< 单选框控件类型
		public static const GUIOBJ_TYPE_RADIOBOX:int = 15;		///< 多选框控件类型
		public static const GUIOBJ_TYPE_WINDOW_TITLE:int = 16;	///< 窗口标题
		public static const GUIOBJ_TYPE_TREE:int = 17;			///< 树控件
		public static const GUIOBJ_TYPE_TREEOBJ:int = 18;		///< 树子控件
		public static const GUIOBJ_TYPE_SCROLL:int = 19;		///< 滚动条控件
		public static const GUIOBJ_TYPE_TABCONTROL_BUTTON:int = 20; ///< 多栏列表控件的按钮
		public static const GUIOBJ_TYPE_SLIDER:int = 21;		///< 滑杆控件
		public static const GUIOBJ_TYPE_UIROOT:int = 22;		///< UI根
		public static const GUIOBJ_TYPE_MENU:int = 23;			///< 菜单
		public static const GUIOBJ_TYPE_SPLITER:int = 24;		///< 多视图拆分器
		public static const GUIOBJ_TYPE_STACK:int = 25;			///< 堆容器
		public static const GUIOBJ_TYPE_ANIIMAGEBOX:int = 26;	///< 动画图片
		public static const GUIOBJ_TYPE_MENUCOMBOBOX:int = 27;	///< 右键菜单或目录菜单
		public static const GUIOBJ_TYPE_LISTBOXOBJ:int = 28;
		public static const GUIOBJ_TYPE_SUPERTEXTLINEOBJ:int = 29;
		public static const GUIOBJ_TYPE_WAITPANNEL:int = 30;
		public static const GUIOBJ_TYPE_USER:int = 128;			///< 用户自定义控件类型

		public static const GUIEVENT_TYPE_BUTTON_UP:int = 0;				///< 按钮抬起事件
		public static const GUIEVENT_TYPE_BUTTON_UP_OUT:int = 1;			///< 按钮在对像之外抬起
		public static const GUIEVENT_TYPE_BUTTON_DOWN:int = 2;				///< 按钮按下事件
		public static const GUIEVENT_TYPE_MESSAGE_BOX_SELECTED:int = 3;		///< 消息框选择事件
		public static const GUIEVENT_TYPE_CLOSE_WINDOW:int = 4;				///< 关闭窗口事件
		public static const GUIEVENT_TYPE_LIST_BOX_SELECTED:int = 5;		///< 列表被点击事件
		public static const GUIEVENT_TYPE_LIST_BOX_SELECTION:int = 6;		///< 列表鼠标移入
		public static const GUIEVENT_TYPE_LIST_BOX_DBL_CLK:int = 7;			///< 列表被双击事件
		public static const GUIEVENT_TYPE_LIST_BOX_RIGHTCLK:int = 8;		///< 列表右键单击
		public static const GUIEVENT_TYPE_LIST_BOX_TITLE_CLICK:int = 9;	///< 列表框的标题被点击
		public static const GUIEVENT_TYPE_ICON_CLK:int = 10;				///< 图标单击事件
		public static const GUIEVENT_TYPE_ICON_CLK_STONING:int = 11;		///< 图标单击事件(正在冷却)
		public static const GUIEVENT_TYPE_ICON_CLK_EMPTY:int = 12;			///< 图标单击事件(空图标)
		public static const GUIEVENT_TYPE_ICON_RIGHTCLK:int = 13;			///< 图标右键单击
		public static const GUIEVENT_TYPE_ICON_RIGHTCLK_STONING:int = 14;	///< 图标右键单击(正在冷却)
		public static const GUIEVENT_TYPE_ICON_RIGHTCLK_EMPTY:int = 15;		///< 图标右键单击(空图标)
		public static const GUIEVENT_TYPE_ICON_DBL_CLK:int = 16;			///< 图标双击事件
		public static const GUIEVENT_TYPE_ICON_DBL_CLK_STONING:int = 17;	///< 图标双击事件(正在冷却)
		public static const GUIEVENT_TYPE_ICON_LBUTTON_DOWN:int = 18;		///< 图标左键按下
		public static const GUIEVENT_TYPE_ICON_LBUTTON_DOWN_STONING:int = 19; ///< 图标左键按下（正在冷却）
		public static const GUIEVENT_TYPE_ICON_LBUTTON_DOWN_EMPTY:int = 20;	///< 图标左键按下（空图标）
		public static const GUIEVENT_TYPE_ICON_DRAG_START:int = 21;			///< 图标开始拖拽
		public static const GUIEVENT_TYPE_ICON_DRAG_DOWN:int = 22;			///< 图标拖放至事件
		public static const GUIEVENT_TYPE_ICON_DRAG_DOWN_SELF:int = 23;		///< 图标拖放到自身上
		//public static const GUIEVENT_TYPE_EDITBOX_ON_CHAR:int = 23;			///< 编辑框或文本被输入事件
		public static const GUIEVENT_TYPE_EDITBOX_ON_ENTER:int = 24;		///< 编辑框或文本被输入回车事件
		public static const GUIEVENT_TYPE_TAB_SELECTED:int = 25;			///< 多栏列表或选项卡被选择事件
		public static const GUIEVENT_TYPE_SUPPER_TEXT_CLICK_DOWN_LINE:int = 26;///< 左键点击了文字的下划线事件
		public static const GUIEVENT_TYPE_SUPPER_TEXT_CLICK_DOWN_LINE_UP:int = 27;///< 左键抬起了文字的下划线事件
		public static const GUIEVENT_TYPE_SUPPER_TEXT_RIGHT_CLICK_DOWN_LINE:int = 28;///< 右键点击了文字的下划线事件
		public static const GUIEVENT_TYPE_CHECK:int = 29;					///< 鼠标点击了CheckBox或RadioBox,param1的值为是否check
		public static const GUIEVENT_TYPE_TREE_LBUTTON_DOWN:int = 30;		///< 树子左键单击
		public static const GUIEVENT_TYPE_TREE_RBUTTON_DOWN:int = 31;		///< 树子右键单击
		public static const GUIEVENT_TYPE_TREE_EXPANT:int = 73;				///< 树被展开和合闭
		public static const GUIEVENT_TYPE_TREE_OBJ_MOUSE_IN:int = 74;		///< 树子鼠标移入
		public static const GUIEVENT_TYPE_TREE_OBJ_MOUSE_OUT:int = 75;		///< 树子鼠标移出
		public static const GUIEVENT_TYPE_MOUSE_IN:int = 32;				///< 鼠标移入控件
		public static const GUIEVENT_TYPE_MOUSE_OUT:int = 33;				///< 鼠标移出控件
		public static const GUIEVENT_TYPE_LBUTTON_DOWN:int = 34;			///< 鼠标左键按下
		public static const GUIEVENT_TYPE_LBUTTON_UP:int = 35;				///< 鼠标左键抬起
		public static const GUIEVENT_TYPE_LBUTTON_DRAG:int = 36;			///< 鼠标左键拖拽
		public static const GUIEVENT_TYPE_LBUTTON_CLICK:int = 37;			///< 鼠标左键点击
		public static const GUIEVENT_TYPE_LBUTTON_DBL_CLICK:int = 38;		///< 鼠标左键双击
		public static const GUIEVENT_TYPE_RBUTTON_DOWN:int = 39;			///< 鼠标右键按下
		public static const GUIEVENT_TYPE_RBUTTON_UP:int = 40;				///< 鼠标右键抬起
		public static const GUIEVENT_TYPE_RBUTTON_DRAG:int = 41;			///< 鼠标右键拖拽
		public static const GUIEVENT_TYPE_RBUTTON_CLICK:int = 42;			///< 鼠标右键点击
		public static const GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED:int = 43;///< 右键菜单选择
		public static const GUIEVENT_TYPE_TREE_DBL_CLK:int = 44;			///< 树子左键双击
		public static const GUIEVENT_TYPE_ON_ACTIVE_WINDOW:int = 45;		///< 控件被激活
		public static const GUIEVENT_TYPE_SLIDER_VALUE_CHANGED:int = 46;	///< 滑杆被拖拽 param1 = value ; param2 = max_value
		public static const GUIEVENT_TYPE_SLIDER_VALUE_CHANGE_DONE:int = 47; ///< 滑杆拖拽完成（鼠标抬起）param1 = value ; param2 = max_value
		public static const GUIEVENT_TYPE_BUTTON_DRAG:int = 48;				///< 按钮拖拽
		public static const GUIEVENT_TYPE_SCROLL_DRAG:int = 49;				///< 滚动条拖拽
		public static const GUIEVENT_TYPE_SUPPERTEXT_CHANGED:int = 50;		///< 文本输入完成
		public static const GUIEVENT_TYPE_SUPPERTEXT_SCROLL_CHANGED:int = 51;///< 文本滚动条移动
		public static const GUIEVENT_TYPE_TAB_SELECTED_SHOW_VIEW:int = 52;	///< 多栏列表或选项卡被选择事件完成
		public static const GUIEVENT_TYPE_ON_FOCUS:int = 53;				///< 编辑框或文本被激活输入焦点
		public static const GUIEVENT_TYPE_ON_SHOW_TOOLTIP:int = 54;			///< 需要显示或隐藏Tooltip
		public static const GUIEVENT_TYPE_MENU_SELECT:int = 55;				///< 菜单选择
		//public static const GUIEVENT_TYPE_EDITBOX_ON_KEY:int = 56;			///< 编辑框或文本键盘按下事件
		public static const GUIEVENT_TYPE_ON_RESIZE:int = 57;				///< 控件大小改变
		public static const GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED:int = 58;	///< 背景图片载入完成
		public static const GUIEVENT_TYPE_ON_FOCUS_LOST:int = 59;			///< 编辑框或文本被失去输入焦点
		public static const GUIEVENT_TYPE_LIST_BOX_LBUTTONUP:int = 60;		///< 列表选择后鼠标抬起
		public static const GUIEVENT_TYPE_IMAGEBOX_MOUSE_MOVE:int = 61;		///< 背景图片上的鼠标移动事件
		public static const GUIEVENT_TYPE_COMBO_BOX_SELECTED:int = 62;		///< 下拉列表被点击
		public static const GUIEVENT_TYPE_COMBO_BOX_UNSELECTED:int = 76;	///< 下拉列表取消选择
		public static const GUIEVENT_TYPE_IMAGEBOX_ON_DRAG:int = 63;		///< 背景图片被拖拽
		public static const GUIEVENT_TYPE_MOUSE_WHEEL:int = 64;				///< 鼠标滚轮滚动
		public static const GUIEVENT_TYPE_COMBO_BOX_ON_SHOW:int = 65;		///< 需要显示下拉列表事件
		public static const GUIEVENT_TYPE_PROGRESS_STOP_ADD:int = 66;		///< 进度条增长完毕
		public static const GUIEVENT_TYPE_KEYDOWN:int = 67;					///< 按键按下，需要先注册这个事件
		public static const GUIEVENT_TYPE_KEYUP:int = 72;					///< 按键抬起
		public static const GUIEVENT_TYPE_ANIPLAYEND:int = 68;				///< 动画播放完成
		public static const GUIEVENT_TYPE_WINDOW_BRING_ON_TOP:int = 69;		///< 窗口被置顶
		public static const GUIEVENT_TYPE_WINDOW_BRING_ON_BOTTOM:int = 70;	///< 窗口被置底
		public static const GUIEVENT_TYPE_ON_SETSHOW:int = 71;				///< 控件显示或隐藏状态切换
		
		public static const GUI_AUTOPOS_CENTER:int = 0;
		public static const GUI_AUTOPOS_LEFT_TOP:int = 1;
		public static const GUI_AUTOPOS_RIGHT_BOTTOM:int = 2;
		
		public static const GUI_SPLITER_STATIC_SCROLL_TYPE_LEFT:int = 1;
		public static const GUI_SPLITER_STATIC_SCROLL_TYPE_TOP:int = 2;
		public static const GUI_SPLITER_STATIC_SCROLL_TYPE_RIGHT:int = 3;
		public static const GUI_SPLITER_STATIC_SCROLL_TYPE_BOTTOM:int = 4;
		
		public static const GUI_MOUSESTYLE_ARROW:int = 0;
		public static const GUI_MOUSESTYLE_HAND:int = 1;
		public static const GUI_MOUSESTYLE_LOCATE:int = 2;
		
		public static const GUI_ALIGN_MIDDLE:int = 0;
		public static const GUI_ALIGN_LEFT:int = 1;
		public static const GUI_ALIGN_RIGHT:int = 2;
		public static const GUI_ALIGN_TOP:int = 4;
		public static const GUI_ALIGN_BOTTOM:int = 8;
		
		protected var m_arrImage:Array = new Array();
		protected var m_nViewWidth:int;
		protected var m_nViewHeight:int;
		
		protected var m_imageSet:dUIImageSet = new dUIImageSet();
		protected var m_root:dUIImageRoot;
		protected var m_mapControlNameToID:Array = new Array();
		public var m_nDebugMode:int = 1;

		public function dUISystem( stageWidth:int , stageHeight:int , imageSet:String , pLoadImageFunction:Function = null , pFatherUISystem:dUISystem = null , nFatherUISystemID:int = 0 ) 
		{
			InitFunction();
			m_nViewWidth = stageWidth;
			m_nViewHeight = stageHeight;
			m_imageSet.Load( imageSet );
			m_root = new dUIImageRoot( this , pLoadImageFunction );
			m_root._DeleteWindow = _DeleteWindow;
			m_root.SetSize( stageWidth , stageHeight );
			m_root.SetUIEventFunction( OnUIEvent );
			m_root.SetFather( null );
			//mouseEnabled = false;
			if ( pFatherUISystem )
			{
				if ( pFatherUISystem.m_arrImage[ nFatherUISystemID ] )
					m_root.SetFather( ( pFatherUISystem.m_arrImage[ nFatherUISystemID ] as dUIImage ).GetClient() );
			}
		}
		public function GetImageSet():dUIImageSet
		{
			return m_imageSet;
		}
		/*private function _DeleteWindow( pObj:dUIImage ):void
		{
			var vecChild:Vector.<dUIImage> = pObj.GetChild();
			for ( var i:int = 0 , n:int = vecChild.length ; i < n ; i ++ )
			{
				var p:dUIImage = vecChild[i];
				var id:int = p.GetID();
				if ( id )
				{
					if ( m_arrEventListener[id] )
						m_arrEventListener[id] = null;
					if ( m_arrOnDeleteCallback[id] )
					{
						m_arrOnDeleteCallback[id]( id );
						m_arrOnDeleteCallback[id] = null;
					}
					m_arrImage[id] = null;
				}
				//p.Release();
				_DeleteWindow( p );
			}
		}
		public function DeleteWindow( id:int ):void
		{
			if ( m_arrImage[id] )
			{
				var pObj:dUIImage = m_arrImage[id] as dUIImage;
				_DeleteWindow( pObj );
				if ( m_arrEventListener[id] )
					m_arrEventListener[id] = null;
				if ( m_arrOnDeleteCallback[id] )
				{
					m_arrOnDeleteCallback[id]( id );
					m_arrOnDeleteCallback[id] = null;
				}
				m_arrImage[id] = null;
				var bNeedCheckTopWindow:Boolean = pObj.GetFather() == m_root.GetTopWindow();
				var bNeedCheckComboBoard:Boolean = pObj.GetFather() == m_root.GetComboListBoxBoard();
				if ( pObj.GetObjType() == dUISystem.GUIOBJ_TYPE_MENUCOMBOBOX )
					m_root.DeleteRightMenu( pObj as dUIMenuComboBox );
				if ( m_root.GetComboListBoxBoard().isShow() )
					m_root.CheckComboBox( pObj );
				pObj.Release();
				if ( bNeedCheckTopWindow )
					m_root.CheckTopWindow();
				if ( bNeedCheckComboBoard )
					m_root.CheckComboListBoxBoard();
			}
		}*/
		private function _DeleteWindow( pObj:dUIImage ):void
		{
			var id:int = pObj.GetID();
			if ( id )
			{
				var bNeedCheckTopWindow:Boolean = pObj.GetFather() == m_root.GetTopWindow();
				var bNeedCheckComboBoard:Boolean = pObj.GetFather() == m_root.GetComboListBoxBoard();
				if ( pObj.GetObjType() == dUISystem.GUIOBJ_TYPE_MENUCOMBOBOX )
					m_root.DeleteRightMenu( pObj as dUIMenuComboBox );
				if ( m_root.GetComboListBoxBoard().isShow() )
					m_root.CheckComboBox( pObj );
				if ( bNeedCheckTopWindow )
					m_root.CheckTopWindow();
				if ( bNeedCheckComboBoard )
					m_root.CheckComboListBoxBoard();
					
				if ( m_arrEventListener[id] )
					m_arrEventListener[id] = null;
				if ( m_root.GetConfig().OnDeleteCallbackGlobal != null )
					m_root.GetConfig().OnDeleteCallbackGlobal( id );
				m_arrImage[id] = null;
			}
		}
		public function DeleteWindow( id:int ):void
		{
			if ( m_arrImage[id] )
			{
				var pObj:dUIImage = m_arrImage[id] as dUIImage;
				pObj.Release();
			}
		}
		protected function FindEmptyArray( arr:Array , nStart:int = 1 ):int
		{
			if ( m_nDebugMode == 1 )
			{
				if ( arr.length < nStart ) return nStart;
				return arr.length;
			}
			for ( var i:int = nStart ; i < arr.length + nStart+1 ; i ++ )
			{
				if ( arr[i] == null )
					return i;
			}
			return 0;
		}
		protected function FindFather( id:int , TabIndex:int ):dUIImage
		{
			if ( id == -1 ) return m_root.GetTopWindow().GetClient();
			if ( id == 0 ) return m_root.GetClient();
			if ( id == -3 ) return m_root.GetPageTop();
			var p:dUIImage = m_arrImage[ id ];
			if ( p != null )
			{
				if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
					return ( p as dUITabControl ).GetView( TabIndex );
				if ( p.GetObjType() == GUIOBJ_TYPE_SPLITER )
					return ( p as dUISpliter ).GetView( TabIndex );
				return p.GetClient();
			}
			if ( m_nDebugMode == 1 && id != 0 )
				throw new Error( "无效的控件ID" + id );
			return m_root.GetClient();
		}
		protected function CreateControl( p:dUIImage , nID:int ):int
		{
			if ( nID == 0 || m_arrImage[ nID ] ) nID = FindEmptyArray( m_arrImage );
			m_arrImage[ nID ] = p;
			p.SetID( nID );
			m_root.CheckTopWindow();
			return nID;
		}
		private function SetGetStyleData( p:dUIImage , bSet:Boolean , data:int ):int
		{
			switch( p.GetObjType() )
			{
				case GUIOBJ_TYPE_WINDOW:
					if ( bSet ) p.SetStyleData( "ShowCloseButton" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "ShowCloseButton" ) ) << 0;
					if ( bSet ) p.SetStyleData( "CanDrag" , !Boolean(data & (1 << 1)) );
					else data |= int( !p.isStyleData( "CanDrag" ) ) << 1;
					break;
				case GUIOBJ_TYPE_BUTTON:
				case GUIOBJ_TYPE_IMAGEBUTTON:
					if ( bSet ) p.SetStyleData( "AlwaysPushDown" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "AlwaysPushDown" ) ) << 0;
					if ( bSet ) p.SetStyleData( "AutoSetSize" , Boolean(data & (1 << 2)) );
					else data |= int( p.isStyleData( "AutoSetSize" ) ) << 2;
					if ( bSet ) p.SetStyleData( "AnimateLight" , Boolean(data & (1 << 4)) );
					else data |= int( p.isStyleData( "AnimateLight" ) ) << 4;
					break;
				case GUIOBJ_TYPE_SUPPERTEXT:
					if ( bSet ) p.SetStyleData( "AutoEnterLine" , Boolean(data & (1 << 0 )) );
					else data |= int( p.isStyleData( "AutoEnterLine" ) ) << 0;
					//if ( bSet ) p.SetStyleData( "CanEdit" , Boolean(data & (1 << 1 )) );
					//else data |= int( p.isStyleData( "CanEdit" ) ) << 1;
					if ( bSet ) p.SetStyleData( "PassWord" , Boolean(data & (1 << 2 )) );
					else data |= int( p.isStyleData( "PassWord" ) ) << 2;
					if ( bSet ) p.SetStyleData( "AutoLimitTextLength" , Boolean(data & (1 << 3 )) );
					else data |= int( p.isStyleData( "AutoLimitTextLength" ) ) << 3;
					if ( bSet ) p.SetStyleData( "AutoSetSize" , Boolean(data & (1 << 4) ) );
					else data |= int( p.isStyleData( "AutoSetSize" ) ) << 4;
					if ( bSet ) p.SetStyleData( "CanEnterLine" , Boolean(data & (1 << 5) ) );
					else data |= int( p.isStyleData( "CanEnterLine" ) ) << 5;
					if ( bSet ) p.SetStyleData( "NumberOnly" , Boolean(data & (1 << 6) ) );
					else data |= int( p.isStyleData( "NumberOnly" ) ) << 6;
					if ( bSet ) p.SetStyleData( "CanInputAND" , Boolean(data & (1 << 7) ) );
					else data |= int( p.isStyleData( "CanInputAND" ) ) << 7;
					break;
				case GUIOBJ_TYPE_EDITBOX:
					if ( bSet ) p.SetStyleData( "ShowVScroll" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "ShowVScroll" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ShowHScroll" , Boolean(data & (1 << 1)) );
					else data |= int( p.isStyleData( "ShowHScroll" ) ) << 1;
					if ( bSet ) p.SetStyleData( "AutoEnterLine" , Boolean(data & (1 << 2)) );
					else data |= int( p.isStyleData( "AutoEnterLine" ) ) << 2;
					if ( bSet ) p.SetStyleData( "CanEdit" , Boolean(data & (1 << 3)) );
					else data |= int( p.isStyleData( "CanEdit" ) ) << 3;
					if ( bSet ) p.SetStyleData( "PassWord" , Boolean(data & (1 << 4)) );
					else data |= int( p.isStyleData( "PassWord" ) ) << 4;
					if ( bSet ) p.SetStyleData( "AutoLimitTextLength" , Boolean(data & (1 << 5)) );
					else data |= int( p.isStyleData( "AutoLimitTextLength" ) ) << 5;
					if ( bSet ) p.SetStyleData( "DownListButton" , Boolean(data & (1 << 6 )) );
					else data |= int( p.isStyleData( "DownListButton" ) ) << 6;
					if ( bSet ) p.SetStyleData( "NumberOnly" , Boolean(data & (1 << 7)) );
					else data |= int( p.isStyleData( "NumberOnly" ) ) << 7;
					if ( bSet ) p.SetStyleData( "CanEnterLine" , Boolean(data & (1 << 8)) );
					else data |= int( p.isStyleData( "CanEnterLine" ) ) << 8;
					if ( bSet ) p.SetStyleData( "AlwaysShowVScroll" , Boolean( data & (1 << 9)) );
					else data |= int( p.isStyleData( "AlwaysShowVScroll" ) ) << 9;
					if ( bSet ) p.SetStyleData( "AlwaysShowHScroll" , Boolean( data & (1 << 10)) );
					else data |= int( p.isStyleData( "AlwaysShowHScroll" ) ) << 10;
					if ( bSet ) p.SetStyleData( "VScrollMirror" , Boolean( data & (1 << 11)) );
					else data |= int( p.isStyleData( "VScrollMirror" ) ) << 11;
					if ( bSet ) p.SetStyleData( "HScrollMirror" , Boolean( data & (1 << 12)) );
					else data |= int( p.isStyleData( "HScrollMirror" ) ) << 12;
					break;
				case GUIOBJ_TYPE_IMAGEBOX:
					if ( bSet ) p.SetStyleData( "CanDrag" , Boolean(data & (1 << 4 )) );
					else data |= int( p.isStyleData( "CanDrag" ) ) << 4;
					if ( bSet ) p.SetStyleData( "CircalMask" , Boolean(data & (1 << 3)) );
					else data |= int( p.isStyleData( "CircalMask" ) ) << 3;
					break;
				case GUIOBJ_TYPE_DRAGICON:
					if ( bSet ) p.SetStyleData( "CopyDrag" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "CopyDrag" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ShowBackImage" , Boolean(data & (1 << 1)) );
					else data |= int( p.isStyleData( "ShowBackImage" ) ) << 1;
					if ( bSet ) p.SetStyleData( "CanDrag" , Boolean(data & (1 << 2)) );
					else data |= int( p.isStyleData( "CanDrag" ) ) << 2;
					break;
				case GUIOBJ_TYPE_LISTBOX:
					if ( bSet ) p.SetStyleData( "ShowVScroll" , Boolean(data & (1 << 0 )) );
					else data |= int( p.isStyleData( "ShowVScroll" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ShowHScroll" , Boolean(data & (1 << 1)) );
					else data |= int( p.isStyleData( "ShowHScroll" ) ) << 1;
					if ( bSet ) p.SetStyleData( "AutoEnterLine" , Boolean(data & (1 << 2)) );
					else data |= int( p.isStyleData( "AutoEnterLine" ) ) << 2;
					if ( bSet ) p.SetStyleData( "ShowTitle" , Boolean(data & (1 << 30)) );
					else data |= int( p.isStyleData( "ShowTitle" ) ) << 30;
					if ( bSet ) p.SetStyleData( "ShowBackImage" , !Boolean(data & (1 << 3)) );
					else data |= int( !p.isStyleData( "ShowBackImage") ) << 3;
					if ( bSet ) p.SetStyleData( "AlwaysShowVScroll" , Boolean( data & (1 << 4)) );
					else data |= int( p.isStyleData( "AlwaysShowVScroll" ) ) << 4;
					if ( bSet ) p.SetStyleData( "AlwaysShowHScroll" , Boolean( data & (1 << 5)) );
					else data |= int( p.isStyleData( "AlwaysShowHScroll" ) ) << 5;
					if ( bSet ) p.SetStyleData( "TitleCanDrag" , Boolean( data & (1 << 6)) );
					else data |= int( p.isStyleData( "TitleCanDrag" ) ) << 6;
					if ( bSet ) p.SetStyleData( "VScrollMirror" , Boolean( data & (1 << 7)) );
					else data |= int( p.isStyleData( "VScrollMirror" ) ) << 7;
					if ( bSet ) p.SetStyleData( "HScrollMirror" , Boolean( data & (1 << 8)) );
					else data |= int( p.isStyleData( "HScrollMirror" ) ) << 8;
					if ( bSet ) p.SetStyleData( "CanDrag" , Boolean( data & (1 << 9)) );
					else data |= int( p.isStyleData( "CanDrag" ) ) << 9;
					break;
				case GUIOBJ_TYPE_PROGRESS:
					if ( bSet ) p.SetStyleData( "Vertical" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "Vertical" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ImageProgress" , Boolean(data & (1 << 1)) );
					else data |= int( p.isStyleData( "ImageProgress" ) ) << 1;
					if ( bSet ) p.SetStyleData( "Mirror" , Boolean(data & (1 << 2)) );
					else data |= int( p.isStyleData( "Mirror" ) ) << 2;
					break;
				case GUIOBJ_TYPE_TABCONTROL:
					if ( bSet ) p.SetStyleData( "Vertical" , Boolean(data & (1 << 0)) );
					else data |= int( p.isStyleData( "Vertical" ) ) << 0;
					if ( bSet ) p.SetStyleData( "MirrorButton" , Boolean(data & (1 << 1)) );
					else data |= int( p.isStyleData( "MirrorButton" ) ) << 1;
					break;
				case GUIOBJ_TYPE_TREE:
					if ( bSet ) p.SetStyleData( "ShowVScroll" , !Boolean(data & (1 << 0 )) );
					else data |= int( !p.isStyleData( "ShowVScroll" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ShowHScroll" , !Boolean(data & (1 << 1 )) );
					else data |= int( !p.isStyleData( "ShowHScroll" ) ) << 1;
					if ( bSet ) p.SetStyleData( "AlwaysShowVScroll" , Boolean(data & (1 << 2 )) );
					else data |= int( p.isStyleData( "AlwaysShowVScroll" ) ) << 2;
					if ( bSet ) p.SetStyleData( "AlwaysShowHScroll" , Boolean(data & (1 << 3 )) );
					else data |= int( p.isStyleData( "AlwaysShowHScroll" ) ) << 3;
					if ( bSet ) p.SetStyleData( "ShowLine" , Boolean(data & (1 << 4 )) );
					else data |= int( p.isStyleData( "ShowLine" ) ) << 4;
					if ( bSet ) p.SetStyleData( "VScrollMirror" , Boolean(data & (1 << 5 )) );
					else data |= int( p.isStyleData( "VScrollMirror" ) ) << 5;
					if ( bSet ) p.SetStyleData( "HScrollMirror" , Boolean(data & (1 << 6 )) );
					else data |= int( p.isStyleData( "HScrollMirror" ) ) << 6;
					if ( bSet ) p.SetStyleData( "ButtonStyle" , Boolean(data & (1 << 7 )) );
					else data |= int( p.isStyleData( "ButtonStyle" ) ) << 7;
					break;
				case GUIOBJ_TYPE_SCROLL:
					if ( bSet ) p.SetStyleData( "ShowVScroll" , !Boolean(data & (1 << 0 )) );
					else data |= int( !p.isStyleData( "ShowVScroll" ) ) << 0;
					if ( bSet ) p.SetStyleData( "ShowHScroll" , !Boolean(data & (1 << 1 )) );
					else data |= int( !p.isStyleData( "ShowHScroll" ) ) << 1;
					if ( bSet ) p.SetStyleData( "AlwaysShowVScroll" , Boolean(data & (1 << 2 )) );
					else data |= int( p.isStyleData( "AlwaysShowVScroll" ) ) << 2;
					if ( bSet ) p.SetStyleData( "AlwaysShowHScroll" , Boolean(data & (1 << 3 )) );
					else data |= int( p.isStyleData( "AlwaysShowHScroll" ) ) << 3;
					if ( bSet ) p.SetStyleData( "VScrollMirror" , Boolean(data & (1 << 4 )) );
					else data |= int( p.isStyleData( "VScrollMirror" ) ) << 4;
					if ( bSet ) p.SetStyleData( "HScrollMirror" , Boolean(data & (1 << 5 )) );
					else data |= int( p.isStyleData( "HScrollMirror" ) ) << 5;
					break;
			}
			return data;
		}
		public function SaveTemplateToBin( nPageID:int ):dByteArray
		{
			if ( !m_arrImage[ nPageID ] ) return null;
			var p:dUIImage = m_arrImage[ nPageID ] as dUIImage;
			var pList:Vector.<dUIImage> = new Vector.<dUIImage>;
			pList.push( p );
			p = p.GetClient();
			for ( var i:int = 0 ; i < p.GetChild().length ; i ++ )
			{
				var pp:dUIImage = p.GetChild()[i];
				if( pp.GetID() && pp.GetObjType() )
					pList.push( pp );
			}
			var sSplit:String = ",";
			var data:dByteArray = new dByteArray();
			data.WriteInt( dStringUtils.FourCC( "D" , "U" , "I" , "B" ) );
			data.WriteInt( pList.length );// control num
			for ( i = 0 ; i < pList.length ; i ++ )
			{
				p = pList[i];
				var strTextCh:String = m_strCurrentLanguage == "ch" ? p.GetText() : p.GetLanguageText( "ch" );
				var strTextVie:String = m_strCurrentLanguage == "vie" ? p.GetText() : p.GetLanguageText( "vie" );
				data.WriteByte( p.GetObjType() );
				data.WriteInt( p.GetID() );
				data.WriteString( p.GetControlName() );
				data.WriteInt( p.GetPosX() );
				data.WriteInt( p.GetPosY() );
				data.WriteInt( p.GetWidth() );
				data.WriteInt( p.GetHeight() );
				data.WriteInt( p.GetAlignType() );
				data.WriteInt( 2 );// text num
				data.WriteString( "ch" );
				data.WriteString( strTextCh );
				data.WriteString( "vie" );
				data.WriteString( strTextVie );
				data.WriteInt( SetGetStyleData( p , false , 0 ) );
				data.WriteInt( p.GetRotation() );
				data.WriteInt( int( p.isRotationMirrorX() ) );
				data.WriteInt( int( p.isRotationMirrorY() ) );
				data.WriteString( p.GetImageSetName() );
				if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				{
					var list:dUIListBox = p as dUIListBox;
					data.WriteInt( list.GetTabCount() );
					data.WriteInt( list.GetForcePerLineHeight() );
					data.WriteInt( list.GetPerLineSpace() );
					for ( var j:int = 0 ; j < list.GetTabCount() ; j ++ )
					{
						data.WriteInt( list.GetTabWidth( j ) );
					}
				}
				else if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
				{
					var tab:dUITabControl = p as dUITabControl;
					data.WriteInt( tab.GetTabCount() );
				}
			}
			return data;
		}
		public function SaveTemplateToString( nPageID:int ):String
		{
			if ( !m_arrImage[ nPageID ] ) return null;
			var p:dUIImage = m_arrImage[ nPageID ] as dUIImage;
			var pList:Vector.<dUIImage> = new Vector.<dUIImage>;
			pList.push( p );
			p = p.GetClient();
			for ( var i:int = 0 ; i < p.GetChild().length ; i ++ )
			{
				var pp:dUIImage = p.GetChild()[i];
				if( pp.GetID() && pp.GetObjType() )
					pList.push( pp );
			}
			var sSplit:String = ",";
			var data:String = new String();
			data += "DGUI,version=1,controlNum=" + String(pList.length) + "\n";
			for ( i = 0 ; i < pList.length ; i ++ )
			{
				p = pList[i];
				var strTextCh:String = m_strCurrentLanguage == "ch" ? p.GetText() : p.GetLanguageText( "ch" );
				var strTextVie:String = m_strCurrentLanguage == "vie" ? p.GetText() : p.GetLanguageText( "vie" );
				data += "type=" + String( p.GetObjType() ) + sSplit +
					"id=" + String( p.GetID() ) + sSplit +
					"$name=" + String( p.GetControlName().length ) + sSplit +
					String( p.GetControlName() ) + sSplit +
					"x=" + String( p.GetPosX() ) + sSplit +
					"y=" + String( p.GetPosY() ) + sSplit +
					"w=" + String( p.GetWidth() ) + sSplit +
					"h=" + String( p.GetHeight() ) + sSplit +
					"align=" + String( p.GetAlignType() ) + sSplit +
					"$text=" + String( strTextCh.length ) + sSplit + strTextCh + sSplit +
					"$text_vie=" + String( strTextVie.length ) + sSplit + strTextVie + sSplit +
					"style=" + String( SetGetStyleData( p , false , 0 ) ) + sSplit;
				if ( p.GetRotation() != 0 )
					data += "rotation=" + p.GetRotation() + sSplit;
				if ( p.isRotationMirrorX() )
					data += "rotation_mirrorx=1" + sSplit;
				if ( p.isRotationMirrorY() )
					data += "rotation_mirrory=1" + sSplit;
				var strSkin:String = p.GetImageSetName();
				if( strSkin != "" )
					data += "$skin=" + String( strSkin.length ) + sSplit + strSkin + sSplit;
				if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				{
					var list:dUIListBox = p as dUIListBox;
					data += "tabCount=" + String( list.GetTabCount() ) + sSplit;
					data += "perLineHeight=" + String( list.GetForcePerLineHeight() ) + sSplit;
					data += "perLineSpace=" + String( list.GetPerLineSpace() ) + sSplit;
					for ( var j:int = 0 ; j < list.GetTabCount() ; j ++ )
					{
						data += "tabWidth" + j + "=" + String( list.GetTabWidth( j ) ) + sSplit;
					}
				}
				else if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
				{
					var tab:dUITabControl = p as dUITabControl;
					data += "tabCount=" + String( tab.GetTabCount() ) + sSplit;
				}
				data += "controlEnd\n";
			}
			return data;
		}
		public function SetCurrentLanguage( strLang:String ):void
		{
			m_strCurrentLanguage = strLang;
		}
		public function GetCurrentLanguage():String
		{
			return m_strCurrentLanguage;
		}
		private function _LoadTemplateCreateObj( data:dUIFileData , idx:int , pFather:dUIImage ):dUIImage
		{
			var nID:int = int( data.GetPropty( idx , "id" ) );
			if ( nID <= 0 || m_arrImage[ nID ] )
				nID = FindEmptyArray( m_arrImage );
			var nObjType:int = int( data.GetPropty( idx , "type" ) );
			var nWidth:int = int( data.GetPropty( idx , "w" ) );
			var nHeight:int = int( data.GetPropty( idx , "h" ) );
			var pObj:dUIImage;
			switch( nObjType )
			{
			case GUIOBJ_TYPE_WINDOW: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_BUTTON: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_IMAGEBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_EDITBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_DRAGICON:pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_GROUP: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_CHECKBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_RADIOBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_TREE: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SLIDER: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SUPPERTEXT: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SCROLL: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_ANIIMAGEBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SPLITER: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_LISTBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_TABCONTROL: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_IMAGEBUTTON: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_PROGRESS: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			}
			if ( nObjType == GUIOBJ_TYPE_LISTBOX )
			{
				pObj.SetSize( nWidth , nHeight );
				var pListBox:dUIListBox = (pObj as dUIListBox);
				var nListBoxTabCount:int = int( data.GetPropty( idx , "tabCount" ) );
				pListBox.SetTabCount( nListBoxTabCount );
				pListBox.SetForcePerLineHeight( int( data.GetPropty( idx , "perLineHeight" ) ) );
				pListBox.SetPerLineSpace( int( data.GetPropty( idx , "perLineSpace" ) ) );
				var bOldVersionText:Boolean;
				for ( var j:int = 0 ; j < pListBox.GetTabCount() ; j ++ )
				{
					if ( data.GetPropty( idx , "tabWidth" + j ) != "" )
					{
						var nTabWidth:int = int( data.GetPropty( idx , "tabWidth" + j ) );
						pListBox.SetTabWidth( j , nTabWidth );
					}
					if ( data.GetPropty( idx , "$tabName" + j ) != "" )
					{
						var strTabName:String = data.GetPropty( idx , "$tabName" + j );
						if ( strTabName == null ) strTabName = "";
						pListBox.SetTabName( j , strTabName );
						bOldVersionText = true;
					}
				}
				if ( bOldVersionText )
				{
					pListBox.SetLanguageText( "ch" , pListBox.GetText() );
					data.SetPropty( idx , "$text" , pListBox.GetText() );
					pListBox.ShowLanguageText( m_strCurrentLanguage );
					pListBox.SetTabCount( nListBoxTabCount );
				}
			}
			else if ( nObjType == GUIOBJ_TYPE_TABCONTROL )
			{
				pObj.SetSize( nWidth , nHeight );
				var pTab:dUITabControl = ( pObj as dUITabControl );
				var nTabCount:int = int( data.GetPropty( idx , "tabCount" ) );
				
				pTab.SetTabCount( nTabCount );
				bOldVersionText = false;
				for ( j = 0 ; j < nTabCount ; j ++ )
				{
					if ( data.GetPropty( idx , "$tabName" + j ) != "" )
					{
						strTabName = data.GetPropty( idx , "$tabName" + j );
						if ( strTabName == null ) strTabName = "";
						pTab.SetTabName( strTabName , j );
						bOldVersionText = true;
					}
				}
				if ( bOldVersionText )
				{
					pTab.SetLanguageText( "ch" , pTab.GetText() );
					data.SetPropty( idx , "$text" , pTab.GetText() );
					pTab.ShowLanguageText( m_strCurrentLanguage );
					pTab.SetTabCount( nTabCount );
				}
			}
			if ( pObj )
			{
				CreateControl( pObj , nID );
				pObj.SetAlignType( int( data.GetPropty( idx , "align" ) ) );
				SetGetStyleData( pObj , true , int( data.GetPropty( idx , "style" ) ) );
				//pObj.SetText( data.GetPropty( idx , "$text" ) );
				pObj.SetLanguageText( "ch" , data.GetPropty( idx , "$text" ) );
				pObj.SetLanguageText( "vie" , data.GetPropty( idx , "$text_vie" ) );
				pObj.ShowLanguageText( m_strCurrentLanguage );
				pObj.SetControlName( data.GetPropty( idx , "$name" ) );
				if ( data.GetPropty( idx , "$skin" ) != "" )
					pObj.LoadFromImageSet( data.GetPropty( idx , "$skin" ) );
				var bMirrorX:Boolean = Boolean( data.GetPropty( idx , "rotation_mirrorx" ) );
				var bMirrorY:Boolean = Boolean( data.GetPropty( idx , "rotation_mirrory" ) );
				if ( data.GetPropty( idx , "rotation" ) != "" || bMirrorX || bMirrorY )
					pObj.SetRotation( int( data.GetPropty( idx , "rotation" ) ) , bMirrorX , bMirrorY );
				//if ( pObj.GetObjType() == GUIOBJ_TYPE_IMAGEBOX )
				//	pObj.LoadFromImageSet( strName );
				pObj.SetPos( int( data.GetPropty( idx , "x" ) ) , int( data.GetPropty( idx , "y" ) ) );
				pObj.SetSize( nWidth , nHeight );
			}
			return pObj;
		}
		protected var m_strCurrentLanguage:String = "ch";
		private function LoadTemplateFromString( pFather:dUIImage , x:int , y:int , toTabIndex:int , offset_ui_id:int , data:String ,
			idList:Vector.<int> = null , bAsync:Boolean = false , onLoadComplete:Function = null , strPageFileName:String = null ):int
		{
			var pFileData:dUIFileData = new dUIFileData();
			pFileData.LoadFromString( data );
			var nControlNum:int = pFileData.GetControlNum();
			var pMainControl:dUIImage = pFather.GetClient();
			var arrControlName:Array = new Array();
			if ( bAsync == false )
			{
				for ( var i:int = 0 ; i < nControlNum ; i ++ )
				{
					var pObj:dUIImage = _LoadTemplateCreateObj( pFileData , i , pMainControl );
					if ( i == 0 )
					{
						pMainControl = pObj;
						pMainControl.SetPos( x , y );
					}
					var strControlName:String = pFileData.GetPropty( i , "$name" );
					if ( strControlName != "" )
					{
						arrControlName[ strControlName ] = pObj.GetID();
					}
					if ( idList ) idList.push( pObj.GetID() );
				}
				pMainControl.SetShow( false );
				m_mapControlNameToID[ pMainControl.GetID() ] = arrControlName;
				if ( pFather.isAutoSizeAsChild() ) pFather.SetSizeAsChild();
				if ( onLoadComplete != null ) onLoadComplete( pMainControl.GetID() , idList );
			}
			else
			{
				pMainControl = _LoadTemplateCreateObj( pFileData , 0 , pMainControl );
				pMainControl.SetPos( x , y );
				strControlName = pFileData.GetPropty( 0 , "$name" );
				if ( strControlName != "" )
					arrControlName[ strControlName ] = pMainControl.GetID();
				if ( idList ) idList.push( pMainControl.GetID() );
				pMainControl.SetShow( false );
				var pThreadFor:dTimer = new dTimer();
				pThreadFor.IntervalFor( 1 , nControlNum , 1 , function( p:dTimer , i:int ):void
				{
					var pObj:dUIImage = _LoadTemplateCreateObj( pFileData , i , pMainControl );
					var strControlName:String = pFileData.GetPropty( i , "$name" );
					if ( strControlName != "" )
						arrControlName[ strControlName ] = pObj.GetID();
					if ( idList ) idList.push( pObj.GetID() );
				} , function( p:dTimer , i:int ):void
				{
					m_mapControlNameToID[ pMainControl.GetID() ] = arrControlName;
					if ( pFather.isAutoSizeAsChild() ) pFather.SetSizeAsChild();
					if ( onLoadComplete != null ) onLoadComplete( pMainControl.GetID() , idList );
				});
			}
			return pMainControl.GetID();
		}
		private function _LoadTemplateCreateObjFromBin( data:dByteArray , idx:int , pFather:dUIImage ):dUIImage
		{
			var nObjType:int = data.ReadByte();
			var nID:int = data.ReadInt();
			if ( nID <= 0 || m_arrImage[ nID ] )
				nID = FindEmptyArray( m_arrImage );
			var strControlName:String = data.ReadString();
			var x:int = data.ReadInt();
			var y:int = data.ReadInt();
			var width:int = data.ReadInt();
			var height:int = data.ReadInt();
			var alignType:int = data.ReadInt();
			var nTextNum:int = data.ReadInt();
			for ( var i:int = 0 ; i < nTextNum ; i ++ )
			{
				var strLang:String = data.ReadString();
				if ( strLang == "ch" )
					var strTextCh:String = data.ReadString();
				else if ( strLang == "vie" )
					var strTextVie:String = data.ReadString();
				else
					data.ReadString();
			}
			var nStyleData:int = data.ReadInt();
			var nRotation:int = data.ReadInt();
			var bRotationMirrorX:Boolean = data.ReadInt() != 0;
			var bRotationMirrorY:Boolean = data.ReadInt() != 0;
			var strImageSetName:String = data.ReadString();
	
			var pObj:dUIImage;
			switch( nObjType )
			{
			case GUIOBJ_TYPE_WINDOW: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_BUTTON: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_IMAGEBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_EDITBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_DRAGICON:pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_GROUP: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_CHECKBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_RADIOBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_TREE: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SLIDER: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SUPPERTEXT: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SCROLL: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_ANIIMAGEBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_SPLITER: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_LISTBOX: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_TABCONTROL: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_IMAGEBUTTON: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			case GUIOBJ_TYPE_PROGRESS: pObj = m_root.NewObj( nObjType , pFather.GetClient() , false ); break;
			}
			if ( nObjType == GUIOBJ_TYPE_LISTBOX )
			{
				pObj.SetSize( width , height );
				var pListBox:dUIListBox = (pObj as dUIListBox);
				var nListBoxTabCount:int = data.ReadInt();
				pListBox.SetTabCount( nListBoxTabCount );
				pListBox.SetForcePerLineHeight( data.ReadInt() );
				pListBox.SetPerLineSpace( data.ReadInt() );
				for ( var j:int = 0 ; j < pListBox.GetTabCount() ; j ++ )
				{
					var nTabWidth:int = data.ReadInt();
					pListBox.SetTabWidth( j , nTabWidth );
				}
			}
			else if ( nObjType == GUIOBJ_TYPE_TABCONTROL )
			{
				pObj.SetSize( width , height );
				var pTab:dUITabControl = ( pObj as dUITabControl );
				var nTabCount:int = data.ReadInt();
				pTab.SetTabCount( nTabCount );
			}
			if ( pObj )
			{
				CreateControl( pObj , nID );
				pObj.SetAlignType( alignType );
				SetGetStyleData( pObj , true , nStyleData );
				//pObj.SetText( data.GetPropty( idx , "$text" ) );
				pObj.SetLanguageText( "ch" , strTextCh );
				pObj.SetLanguageText( "vie" , strTextVie );
				pObj.ShowLanguageText( m_strCurrentLanguage );
				pObj.SetControlName( strControlName );
				if ( strImageSetName != "" )
					pObj.LoadFromImageSet( strImageSetName );
				var bMirrorX:Boolean = bRotationMirrorX;
				var bMirrorY:Boolean = bRotationMirrorY;
				if ( nRotation != 0 || bMirrorX || bMirrorY )
					pObj.SetRotation( nRotation , bMirrorX , bMirrorY );
				//if ( pObj.GetObjType() == GUIOBJ_TYPE_IMAGEBOX )
				//	pObj.LoadFromImageSet( strName );
				pObj.SetPos( x , y );
				pObj.SetSize( width , height );
			}
			return pObj;
		}
		private function LoadTemplateFromBin( pFather:dUIImage , x:int , y:int , toTabIndex:int , offset_ui_id:int , data:dByteArray ,
			idList:Vector.<int> = null , bAsync:Boolean = false , onLoadComplete:Function = null , strPageFileName:String = null ):int
		{
			var magic:int = data.ReadInt();
			var nControlNum:int = data.ReadInt();
			var pMainControl:dUIImage = pFather.GetClient();
			var arrControlName:Array = new Array();
			if ( bAsync == false )
			{
				for ( var i:int = 0 ; i < nControlNum ; i ++ )
				{
					var pObj:dUIImage = _LoadTemplateCreateObjFromBin( data , i , pMainControl );
					if ( i == 0 )
					{
						pMainControl = pObj;
						pMainControl.SetPos( x , y );
					}
					var strControlName:String = pObj.GetControlName();
					if ( strControlName != "" )
					{
						arrControlName[ strControlName ] = pObj.GetID();
					}
					if ( idList ) idList.push( pObj.GetID() );
				}
				pMainControl.SetShow( false );
				m_mapControlNameToID[ pMainControl.GetID() ] = arrControlName;
				if ( pFather.isAutoSizeAsChild() ) pFather.SetSizeAsChild();
				if ( onLoadComplete != null ) onLoadComplete( pMainControl.GetID() , idList );
			}
			else
			{
				data.SetPosition( 0 );
				var data2:dByteArray = data.ReadBin();
				data.SetPosition( 0 );
				data2.SetPosition( 8 );
				pMainControl = _LoadTemplateCreateObjFromBin( data2 , 0 , pMainControl );
				pMainControl.SetPos( x , y );
				strControlName = pMainControl.GetControlName();
				if ( strControlName != "" )
					arrControlName[ strControlName ] = pMainControl.GetID();
				if ( idList ) idList.push( pMainControl.GetID() );
				pMainControl.SetShow( false );
				var pThreadFor:dTimer = new dTimer();
				pThreadFor.IntervalFor( 1 , nControlNum , 1 , function( p:dTimer , i:int ):void
				{
					var pObj:dUIImage = _LoadTemplateCreateObjFromBin( data2 , i , pMainControl );
					var strControlName:String = pObj.GetControlName();
					if ( strControlName != "" )
						arrControlName[ strControlName ] = pObj.GetID();
					if ( idList ) idList.push( pObj.GetID() );
				} , function( p:dTimer , i:int ):void
				{
					m_mapControlNameToID[ pMainControl.GetID() ] = arrControlName;
					if ( pFather.isAutoSizeAsChild() ) pFather.SetSizeAsChild();
					if ( onLoadComplete != null ) onLoadComplete( pMainControl.GetID() , idList );
				});
			}
			return pMainControl.GetID();
		}
		public function GetRoot():dSprite
		{
			return m_root;
		}
		public function _OnFrameMove():void
		{
		}
		public function isCtrlKey():Boolean
		{
			return m_root.dSpriteIsKeyDown( dSprite.VK_CONTROL );
		}
		public function isShiftKey():Boolean
		{
			return m_root.dSpriteIsKeyDown( dSprite.VK_SHIFT );
		}
		public function ShowDefaultTooltip( x:int , y:int , str:String , bShow:Boolean ):void
		{
			m_root.ShowDefaultTooltip( x , y , str , bShow );
		}
		protected var m_arrEventListener:Array = new Array();
		public function dUIEventListener( controlID:int , eventType:int , callFun:Function ):void
		{
			if ( controlID <= 0 ) return;
			if ( m_arrEventListener[ controlID ] )
			{
				var p:Array = m_arrEventListener[ controlID ] as Array;
				p[ eventType ] = callFun;
			}
			else
			{
				p = new Array();
				p[ eventType ] = callFun;
				m_arrEventListener[ controlID ] = p;
			}
			if ( m_arrImage[ controlID ] )
			{
				if ( eventType == dUISystem.GUIEVENT_TYPE_MOUSE_WHEEL )
					( m_arrImage[ controlID ] as dUIImage ).SetHandleMouseWheel( true );
				else if ( eventType == dUISystem.GUIEVENT_TYPE_LBUTTON_DBL_CLICK )
					( m_arrImage[ controlID ] as dUIImage ).RegCanDoubleClick( true );
				else if ( eventType == dUISystem.GUIEVENT_TYPE_ANIPLAYEND ||
						  eventType == dUISystem.GUIEVENT_TYPE_MOUSE_IN ||
						  eventType == dUISystem.GUIEVENT_TYPE_MOUSE_OUT ||
						  eventType == dUISystem.GUIEVENT_TYPE_TREE_OBJ_MOUSE_IN ||
						  eventType == dUISystem.GUIEVENT_TYPE_TREE_OBJ_MOUSE_OUT )
					( m_arrImage[ controlID ] as dUIImage ).RegMouseLowEvent( true );
				else if ( eventType == dUISystem.GUIEVENT_TYPE_ON_SETSHOW )
					( m_arrImage[ controlID ] as dUIImage ).RegOnSetShowEvent( true );
			}
		}
		public function dUIEventListeners( vecIDList:Array , eventType:int , callFun:Function ):void
		{
			for ( var i:int = 0 ; i < vecIDList.length ; i ++ )
				dUIEventListener( vecIDList[i] , eventType , callFun );
		}
		public function dUIEventListenerRemove( controlID:int , eventType:int ):void
		{
			if ( controlID <= 0 ) return;
			if ( m_arrEventListener[ controlID ] )
			{
				if ( eventType == -1 )
				{
					delete m_arrEventListener[ controlID ];
				}
				else
				{
					var p:Array = m_arrEventListener[ controlID ] as Array;
					delete p[ eventType ];
					if ( p.length == 0 )
						delete m_arrEventListener[ controlID ];
				}
			}
		}
		protected function CopyCreate( pFather:dUIImage , pSource:dUIImage ):int
		{
			var nObjType:int = pSource.GetObjType();
			var nID:int;
			switch( nObjType )
			{
				case dUISystem.GUIOBJ_TYPE_WINDOW: nID = CreateControl( new dUIWindow( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_BUTTON: nID = CreateControl( new dUIButton( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_IMAGEBUTTON: nID = CreateControl( new dUIImageButton( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_EDITBOX: nID = CreateControl( new dUIEditBox( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_SUPPERTEXT: nID = CreateControl( new dUISuperText( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_IMAGEBOX: nID = CreateControl( new dUIImageBox( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_DRAGICON: nID = CreateControl( new dUIDragIcon( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_LISTBOX: nID = CreateControl( new dUIListBox( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_PROGRESS: nID = CreateControl( new dUIProgress( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_TABCONTROL: nID = CreateControl( new dUITabControl( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_GROUP: nID = CreateControl( new dUIGroup( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_CHECKBOX: nID = CreateControl( new dUICheckBox( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_RADIOBOX: nID = CreateControl( new dUIRadioBox( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_TREE: nID = CreateControl( new dUITree( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_SCROLL: nID = CreateControl( new dUIScroll( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_SLIDER: nID = CreateControl( new dUISlider( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_MENU: nID = CreateControl( new dUIMenu( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_STACK: nID = CreateControl( new dUIStack( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_SPLITER: nID = CreateControl( new dUISpliter( pFather ) , 0 ); break;
				case dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX: nID = CreateControl( new dUIAniImageBox( pFather ) , 0 ); break;
			}
			if ( nID )
			{
				var pNew:dUIImage = m_arrImage[ nID ];
				var style:int = SetGetStyleData( pSource , false , 0 );
				SetGetStyleData( pNew , true , style );
				pNew.LoadFromImageSet( pSource.GetImageSetName() );
				pNew.SetPos( pSource.GetPosX() , pSource.GetPosY() );
				pNew.SetSize( pSource.GetWidth() , pSource.GetHeight() );
				pNew.SetText( pSource.GetText() );
				pNew.SetControlName( pSource.GetControlName() );
				pNew.SetAlignType( pSource.GetAlignType() );
				pNew.SetRotation( pSource.GetRotation() , pSource.isRotationMirrorX() , pSource.isRotationMirrorY() );
				
				if ( nObjType == dUISystem.GUIOBJ_TYPE_TABCONTROL )
				{
					var count:int = (pSource as dUITabControl).GetTabCount();
					(pNew as dUITabControl).SetTabCount( count );
					for ( var i:int = 0 ; i < count ; i ++ )
					{
						(pNew as dUITabControl).SetTabName( (pSource as dUITabControl).GetTabName( i ) , i );
					}
				}
				else if ( nObjType == dUISystem.GUIOBJ_TYPE_LISTBOX )
				{
					count = (pSource as dUIListBox).GetTabCount();
					(pNew as dUIListBox).SetTabCount( count );
					for ( i = 0 ; i < count ; i ++ )
					{
						(pNew as dUIListBox).SetTabWidth( i , (pSource as dUIListBox).GetTabWidth( i ) );
						(pNew as dUIListBox).SetTabName( i , (pSource as dUIListBox).GetTabName( i ) );
					}
				}
				else if ( nObjType == dUISystem.GUIOBJ_TYPE_IMAGEBUTTON )
				{
					var str1:String = (pSource as dUIImageButton).GetImageSetName_Normal();
					var str2:String = (pSource as dUIImageButton).GetImageSetName_Light();
					var str3:String = (pSource as dUIImageButton).GetImageSetName_Down();
					var str4:String = (pSource as dUIImageButton).GetImageSetName_Invalid();
					pNew.LoadFromImageSet( str1 + "," + str2 + "," + str3 + "," + str4 );
				}
				else if ( nObjType == dUISystem.GUIOBJ_TYPE_PROGRESS )
				{
					str1 = (pSource as dUIProgress).GetProgressImageSetName( 0 );
					str2 = (pSource as dUIProgress).GetProgressImageSetName( 1 );
					str3 = (pSource as dUIProgress).GetProgressImageSetName( 2 );
					str4 = (pSource as dUIProgress).GetProgressImageSetName( 3 );
					var str5:String = (pSource as dUIProgress).GetProgressImageSetName( 4 );
					var str6:String = (pSource as dUIProgress).GetProgressImageSetName( 5 );
					pNew.LoadFromImageSet( str1 + "," + str2 + "," + str3 + "," + str4 + "," + str5 + "," + str6 );
				}
				if ( nObjType == dUISystem.GUIOBJ_TYPE_IMAGEBOX || nObjType == dUISystem.GUIOBJ_TYPE_IMAGEBUTTON )
				{
					if ( pSource.GetWidth() != 0 && pSource.GetHeight() != 0 )
						pNew.SetSize( pSource.GetWidth() , pSource.GetHeight() );
				}
			}
			return nID;
		}
		protected var m_arrFun:Array = new Array();
		private function InitFunction():void
		{
			var fun_id:int = 1;
			m_arrFun[(CREATE_WINDOW = fun_id++)] = _CREATE_WINDOW;
			m_arrFun[(CREATE_BUTTON = fun_id++)] = _CREATE_BUTTON;
			m_arrFun[(CREATE_IMAGEBUTTON = fun_id++)] = _CREATE_IMAGEBUTTON;
			m_arrFun[(CREATE_EDITBOX = fun_id++)] = _CREATE_EDITBOX;
			m_arrFun[(CREATE_SUPPERTEXT = fun_id++)] = _CREATE_SUPPERTEXT;
			m_arrFun[(CREATE_IMAGEBOX = fun_id++)] = _CREATE_IMAGEBOX;
			m_arrFun[(CREATE_DRAGICON = fun_id++)] = _CREATE_DRAGICON;
			m_arrFun[(CREATE_LISTBOX = fun_id++)] = _CREATE_LISTBOX;
			m_arrFun[(CREATE_PROGRESS = fun_id++)] = _CREATE_PROGRESS;
			m_arrFun[(CREATE_TABCONTROL = fun_id++)] = _CREATE_TABCONTROL;
			m_arrFun[(CREATE_GROUP = fun_id++)] = _CREATE_GROUP;
			m_arrFun[(CREATE_CHECKBOX = fun_id++)] = _CREATE_CHECKBOX;
			m_arrFun[(CREATE_RADIOBOX = fun_id++)] = _CREATE_RADIOBOX;
			m_arrFun[(CREATE_TREE = fun_id++)] = _CREATE_TREE;
			m_arrFun[(CREATE_SCROLL = fun_id++)] = _CREATE_SCROLL;
			m_arrFun[(CREATE_SLIDER = fun_id++)] = _CREATE_SLIDER;
			m_arrFun[(CREATE_RIGHT_MENU = fun_id++)] = _CREATE_RIGHT_MENU;
			m_arrFun[(CREATE_ANIIMAGEBOX = fun_id++)] = _CREATE_ANIIMAGEBOX;
			m_arrFun[(CREATE_MESSAGEBOX = fun_id++)] = _CREATE_MESSAGEBOX;
			m_arrFun[(CREATE_MENU = fun_id++)] = _CREATE_MENU;
			m_arrFun[(CREATE_SPLITER = fun_id++)] = _CREATE_SPLITER;
			m_arrFun[(CREATE_STACK = fun_id++)] = _CREATE_STACK;
			m_arrFun[(C_GET_FOCUS = fun_id++)] = _C_GET_FOCUS;
			m_arrFun[(C_LOAD_FROM_TEMPLATE = fun_id++)] = _C_LOAD_FROM_TEMPLATE;
			m_arrFun[(DELETE_WINDOW = fun_id++)] = _DELETE_WINDOW;
			m_arrFun[(C_SET_POS = fun_id++)] = _C_SET_POS;
			m_arrFun[(C_GET_POSX = fun_id++)] = _C_GET_POSX;
			m_arrFun[(C_GET_POSY = fun_id++)] = _C_GET_POSY;
			m_arrFun[(C_SET_MARGIN = fun_id++)] = _C_SET_MARGIN;
			m_arrFun[(C_SET_SIZE = fun_id++)] = _C_SET_SIZE;
			m_arrFun[(C_GET_WIDTH = fun_id++)] = _C_GET_WIDTH;
			m_arrFun[(C_GET_HEIGHT = fun_id++)] = _C_GET_HEIGHT;
			m_arrFun[(C_SET_ID = fun_id++)] = _C_SET_ID;
			m_arrFun[(C_SET_TEXT = fun_id++)] = _C_SET_TEXT;
			m_arrFun[(C_GET_TEXT = fun_id++)] = _C_GET_TEXT;
			m_arrFun[(C_GET_TEXT_WITHOUT_SIGN = fun_id++)] = _C_GET_TEXT_WITHOUT_SIGN;
			m_arrFun[(C_SET_CONTROL_NAME = fun_id++)] = _C_SET_CONTROL_NAME;
			m_arrFun[(C_GET_CONTROL_NAME = fun_id++)] = _C_GET_CONTROL_NAME;
			m_arrFun[(C_LOAD_FROM_IMAGESET = fun_id++)] = _C_LOAD_FROM_IMAGESET;
			m_arrFun[(C_LOAD_FROM_FILE = fun_id++)] = _C_LOAD_FROM_FILE;
			m_arrFun[(C_LOAD_FROM_BIN = fun_id++)] = _C_LOAD_FROM_BIN;
			m_arrFun[(C_LOAD_FROM_BITMAPDATA = fun_id++)] = _C_LOAD_FROM_BITMAPDATA;
			m_arrFun[(C_COPY_CREATE = fun_id++)] = _C_COPY_CREATE;
			m_arrFun[(C_GET_IMAGE_SET_NAME = fun_id++)] = _C_GET_IMAGE_SET_NAME;
			m_arrFun[(C_SET_STYLE = fun_id++)] = _C_SET_STYLE;
			m_arrFun[(C_GET_STYLE = fun_id++)] = _C_GET_STYLE;
			m_arrFun[(C_SET_SHOW = fun_id++)] = _C_SET_SHOW;
			m_arrFun[(C_GET_SHOW = fun_id++)] = _C_GET_SHOW;
			m_arrFun[(C_SET_SHOW_CLIENT = fun_id++)] = _C_SET_SHOW_CLIENT;
			m_arrFun[(C_GET_SHOW_CLIENT = fun_id++)] = _C_GET_SHOW_CLIENT;
			m_arrFun[(C_SET_WAIT = fun_id++)] = _C_SET_WAIT;
			m_arrFun[(C_GET_WAIT = fun_id++)] = _C_GET_WAIT;
			m_arrFun[(C_ENABLE_WINDOW = fun_id++)] = _C_ENABLE_WINDOW;
			m_arrFun[(C_IS_WINDOW_ENABLE = fun_id++)] = _C_IS_WINDOW_ENABLE;
			m_arrFun[(C_SET_HANDLE_MOUSE = fun_id++)] = _C_SET_HANDLE_MOUSE;
			m_arrFun[(C_IS_HANDLE_MOUSE = fun_id++)] = _C_IS_HANDLE_MOUSE;
			m_arrFun[(C_GET_OBJ_TYPE = fun_id++)] = _C_GET_OBJ_TYPE;
			m_arrFun[(C_SET_USER_DATA = fun_id++)] = _C_SET_USER_DATA;
			m_arrFun[(C_GET_USER_DATA = fun_id++)] = _C_GET_USER_DATA;
			m_arrFun[(C_SET_TOOLTIP = fun_id++)] = _C_SET_TOOLTIP;
			m_arrFun[(C_GET_TOOLTIP = fun_id++)] = _C_GET_TOOLTIP;
			m_arrFun[(C_SET_ALIGN = fun_id++)] = _C_SET_ALIGN;
			m_arrFun[(C_GET_ALIGN = fun_id++)] = _C_GET_ALIGN;
			m_arrFun[(C_GET_CLIENT_WIDTH = fun_id++)] = _C_GET_CLIENT_WIDTH;
			m_arrFun[(C_GET_CLIENT_HEIGHT = fun_id++)] = _C_GET_CLIENT_HEIGHT;
			m_arrFun[(C_SET_FOCUS = fun_id++)] = _C_SET_FOCUS;
			m_arrFun[(C_SET_AUTO_POS = fun_id++)] = _C_SET_AUTO_POS;
			m_arrFun[(C_GET_AUTO_POSX = fun_id++)] = _C_GET_AUTO_POSX;
			m_arrFun[(C_GET_AUTO_POSY = fun_id++)] = _C_GET_AUTO_POSY;
			m_arrFun[(C_SET_AUTO_POS_PANNEL = fun_id++)] = _C_SET_AUTO_POS_PANNEL;
			m_arrFun[(C_SET_AUTO_BRING_TOP_PANNEL = fun_id++)] = _C_SET_AUTO_BRING_TOP_PANNEL;
			m_arrFun[(C_SET_ALPHA = fun_id++)] = _C_SET_ALPHA;
			m_arrFun[(C_GET_ALPHA = fun_id++)] = _C_GET_ALPHA;
			m_arrFun[(C_SET_GRAY = fun_id++)] = _C_SET_GRAY;
			m_arrFun[(C_GET_GRAY = fun_id++)] = _C_GET_GRAY;
			m_arrFun[(C_SET_HIGHTLIGHT = fun_id++)] = _C_SET_HIGHTLIGHT;
			m_arrFun[(C_GET_HIGHTLIGHT = fun_id++)] = _C_GET_HIGHTLIGHT;
			m_arrFun[(C_SET_AUTO_SIZE_AS_FATHER = fun_id++)] = _C_SET_AUTO_SIZE_AS_FATHER;
			m_arrFun[(C_GET_AUTO_SIZE_AS_FATHER = fun_id++)] = _C_GET_AUTO_SIZE_AS_FATHER;
			m_arrFun[(C_SET_AUTO_SIZE_AS_CHILD = fun_id++)] = _C_SET_AUTO_SIZE_AS_CHILD;
			m_arrFun[(C_GET_AUTO_SIZE_AS_CHILD = fun_id++)] = _C_GET_AUTO_SIZE_AS_CHILD;
			m_arrFun[(C_GET_POSX_WORLD = fun_id++)] = _C_GET_POSX_WORLD;
			m_arrFun[(C_GET_POSY_WORLD = fun_id++)] = _C_GET_POSY_WORLD;
			m_arrFun[(C_ADD_DISPLAY_OBJ = fun_id++)] = _C_ADD_DISPLAY_OBJ;
			m_arrFun[(C_REMOVE_DISPLAY_OBJ = fun_id++)] = _C_REMOVE_DISPLAY_OBJ;
			m_arrFun[(C_ADD_SPRITE = fun_id++)] = _C_ADD_SPRITE;
			m_arrFun[(C_REMOVE_SPRITE = fun_id++)] = _C_REMOVE_SPRITE;
			m_arrFun[(C_GET_FATHER_ID = fun_id++)] = _C_GET_FATHER_ID;
			m_arrFun[(C_SET_TO_CENTER = fun_id++)] = _C_SET_TO_CENTER;
			m_arrFun[(C_BRING_TO_TOP = fun_id++)] = _C_BRING_TO_TOP;
			m_arrFun[(C_BRING_TO_BOTTOM = fun_id++)] = _C_BRING_TO_BOTTOM;
			m_arrFun[(C_FLASH_WINDOW = fun_id++)] = _C_FLASH_WINDOW;
			m_arrFun[(C_FLASH_WINDOW_DISABLE = fun_id++)] = _C_FLASH_WINDOW_DISABLE;
			m_arrFun[(C_GET_MOUSEX = fun_id++)] = _C_GET_MOUSEX;
			m_arrFun[(C_GET_MOUSEY = fun_id++)] = _C_GET_MOUSEY;
			m_arrFun[(C_REG_MOUSE_FADING = fun_id++)] = _C_REG_MOUSE_FADING;
			m_arrFun[(C_IS_REG_MOUSE_FADING = fun_id++)] = _C_IS_REG_MOUSE_FADING;
			m_arrFun[(C_SET_ROTATION = fun_id++)] = _C_SET_ROTATION;
			m_arrFun[(C_GET_ROTATION = fun_id++)] = _C_GET_ROTATION;
			m_arrFun[(C_GET_ROTATION_MIRRORX = fun_id++)] = _C_GET_ROTATION_MIRRORX;
			m_arrFun[(C_GET_ROTATION_MIRRORY = fun_id++)] = _C_GET_ROTATION_MIRRORY;
			m_arrFun[(C_SET_COLOR_TRANSFORM = fun_id++)] = _C_SET_COLOR_TRANSFORM;
			m_arrFun[(C_SET_MOUSE_STYLE = fun_id++)] = _C_SET_MOUSE_STYLE;
			m_arrFun[(C_GET_MOUSE_STYLE = fun_id++)] = _C_GET_MOUSE_STYLE;
			m_arrFun[(C_IS_MOUSE_IN = fun_id++)] = _C_IS_MOUSE_IN;
			m_arrFun[(C_SET_EDGE_RECT = fun_id++)] = _C_SET_EDGE_RECT;
			m_arrFun[(BUTTON_SET_PUSH_DOWN = fun_id++)] = _BUTTON_SET_PUSH_DOWN;
			m_arrFun[(BUTTON_GET_PUSH_DOWN = fun_id++)] = _BUTTON_GET_PUSH_DOWN;
			m_arrFun[(TEXT_SET_LIMIT_TEXT_LENGTH = fun_id++)] = _TEXT_SET_LIMIT_TEXT_LENGTH;
			m_arrFun[(TEXT_GET_LIMIT_TEXT_LENGTH = fun_id++)] = _TEXT_GET_LIMIT_TEXT_LENGTH;
			m_arrFun[(TEXT_SET_LIMIT_NUMBER = fun_id++)] = _TEXT_SET_LIMIT_NUMBER;
			m_arrFun[(TEXT_GET_LIMIT_NUMBER = fun_id++)] = _TEXT_GET_LIMIT_NUMBER;
			m_arrFun[(TEXT_SET_LIMIT_NUMBER_MIN = fun_id++)] = _TEXT_SET_LIMIT_NUMBER_MIN;
			m_arrFun[(TEXT_GET_LIMIT_NUMBER_MIN = fun_id++)] = _TEXT_GET_LIMIT_NUMBER_MIN;
			m_arrFun[(TEXT_SET_SELECTION = fun_id++)] = _TEXT_SET_SELECTION;
			m_arrFun[(TEXT_GET_SELECTION_BEGIN = fun_id++)] = _TEXT_GET_SELECTION_BEGIN;
			m_arrFun[(TEXT_GET_SELECTION_END = fun_id++)] = _TEXT_GET_SELECTION_END;
			m_arrFun[(TEXT_INSERT_STRING = fun_id++)] = _TEXT_INSERT_STRING;
			m_arrFun[(EDITBOX_SET_COMBOBOX_STRING = fun_id++)] = _EDITBOX_SET_COMBOBOX_STRING;
			m_arrFun[(EDITBOX_GET_COMBOBOX_STRING = fun_id++)] = _EDITBOX_GET_COMBOBOX_STRING;
			m_arrFun[(EDITBOX_SET_COMBOBOX_SHOW = fun_id++)] = _EDITBOX_SET_COMBOBOX_SHOW;
			m_arrFun[(EDITBOX_GET_COMBOBOX_SHOW = fun_id++)] = _EDITBOX_GET_COMBOBOX_SHOW;
			m_arrFun[(ICON_SWAP_STATUS = fun_id++)] = _ICON_SWAP_STATUS;
			m_arrFun[(ICON_COPY_STATUS = fun_id++)] = _ICON_COPY_STATUS;
			m_arrFun[(ICON_CLEAR_STATUS = fun_id++)] = _ICON_CLEAR_STATUS;
			m_arrFun[(ICON_SET_COOL_TIME = fun_id++)] = _ICON_SET_COOL_TIME;
			m_arrFun[(ICON_GET_COOL_TIME = fun_id++)] = _ICON_GET_COOL_TIME;
			m_arrFun[(ICON_SET_MAX_TIME = fun_id++)] = _ICON_SET_MAX_TIME;
			m_arrFun[(ICON_GET_MAX_TIME = fun_id++)] = _ICON_GET_MAX_TIME;
			m_arrFun[(ICON_SET_PIC_NAME = fun_id++)] = _ICON_SET_PIC_NAME;
			m_arrFun[(ICON_SET_ANI_NAME = fun_id++)] = _ICON_SET_ANI_NAME;
			m_arrFun[(ICON_SET_ANI_CUR_FRAME = fun_id++)] = _ICON_SET_ANI_CUR_FRAME;
			m_arrFun[(ICON_SET_COOL_IMAGE_NAME = fun_id++)] = _ICON_SET_COOL_IMAGE_NAME;
			m_arrFun[(ICON_GET_COOL_IMAGE_NAME = fun_id++)] = _ICON_GET_COOL_IMAGE_NAME;
			m_arrFun[(ICON_SET_ANI_COLOR_TRANSFORM = fun_id++)] = _ICON_SET_ANI_COLOR_TRANSFORM;
			m_arrFun[(LB_ADD_STRING = fun_id++)] = _LB_ADD_STRING;
			m_arrFun[(LB_INSERT_STRING = fun_id++)] = _LB_INSERT_STRING;
			m_arrFun[(LB_DELETE_LIST = fun_id++)] = _LB_DELETE_LIST;
			m_arrFun[(LB_DELETE_LIST_OBJ = fun_id++)] = _LB_DELETE_LIST_OBJ;
			m_arrFun[(LB_CLEAR_LIST = fun_id++)] = _LB_CLEAR_LIST;
			m_arrFun[(LB_ADD_LIST = fun_id++)] = _LB_ADD_LIST;
			m_arrFun[(LB_REMOVE_LIST = fun_id++)] = _LB_REMOVE_LIST;
			m_arrFun[(LB_INSERT_LIST = fun_id++)] = _LB_INSERT_LIST;
			m_arrFun[(LB_GET_LIST = fun_id++)] = _LB_GET_LIST;
			m_arrFun[(LB_GET_STRING = fun_id++)] = _LB_GET_STRING;
			m_arrFun[(LB_GET_LIST_COUNT = fun_id++)] = _LB_GET_LIST_COUNT;
			m_arrFun[(LB_SET_LIST_COUNT = fun_id++)] = _LB_SET_LIST_COUNT;
			m_arrFun[(LB_SET_TAB_COUNT = fun_id++)] = _LB_SET_TAB_COUNT;
			m_arrFun[(LB_GET_TAB_COUNT = fun_id++)] = _LB_GET_TAB_COUNT;
			m_arrFun[(LB_SET_TAB_WIDTH = fun_id++)] = _LB_SET_TAB_WIDTH;
			m_arrFun[(LB_GET_TAB_WIDTH = fun_id++)] = _LB_GET_TAB_WIDTH;
			m_arrFun[(LB_SET_TAB_NAME = fun_id++)] = _LB_SET_TAB_NAME;
			m_arrFun[(LB_GET_TAB_NAME = fun_id++)] = _LB_GET_TAB_NAME;
			m_arrFun[(LB_SET_MAX_LIST_NUM = fun_id++)] = _LB_SET_MAX_LIST_NUM;
			m_arrFun[(LB_GET_MAX_LIST_NUM = fun_id++)] = _LB_GET_MAX_LIST_NUM;
			m_arrFun[(LB_SET_CUR_SEL = fun_id++)] = _LB_SET_CUR_SEL;
			m_arrFun[(LB_GET_CUR_SEL = fun_id++)] = _LB_GET_CUR_SEL;
			m_arrFun[(LB_SET_TAB_CAN_SORT = fun_id++)] = _LB_SET_TAB_CAN_SORT;
			m_arrFun[(LB_GET_TAB_CAN_SORT = fun_id++)] = _LB_GET_TAB_CAN_SORT;
			m_arrFun[(LB_SET_TAB_SHOW_SORT_ICON = fun_id++)] = _LB_SET_TAB_SHOW_SORT_ICON;
			m_arrFun[(LB_GET_TAB_SHOW_SORT_ICON = fun_id++)] = _LB_GET_TAB_SHOW_SORT_ICON;
			m_arrFun[(LB_SORT_TAB = fun_id++)] = _LB_SORT_TAB;
			m_arrFun[(LB_SET_SORT_METHOD_FUNCTION = fun_id++)] = _LB_SET_SORT_METHOD_FUNCTION;
			m_arrFun[(LB_SET_FORCE_PER_LINE_HEIGHT = fun_id++)] = _LB_SET_FORCE_PER_LINE_HEIGHT;
			m_arrFun[(LB_GET_FORCE_PER_LINE_HEIGHT = fun_id++)] = _LB_GET_FORCE_PER_LINE_HEIGHT;
			m_arrFun[(LB_SET_PER_LINE_SPACE = fun_id++)] = _LB_SET_PER_LINE_SPACE;
			m_arrFun[(LB_GET_PER_LINE_SPACE = fun_id++)] = _LB_GET_PER_LINE_SPACE;
			m_arrFun[(PROGRESS_SET_MAX_VALUE = fun_id++)] = _PROGRESS_SET_MAX_VALUE;
			m_arrFun[(PROGRESS_GET_MAX_VALUE = fun_id++)] = _PROGRESS_GET_MAX_VALUE;
			m_arrFun[(PROGRESS_SET_MIN_VALUE = fun_id++)] = _PROGRESS_SET_MIN_VALUE;
			m_arrFun[(PROGRESS_GET_MIN_VALUE = fun_id++)] = _PROGRESS_GET_MIN_VALUE;
			m_arrFun[(PROGRESS_SET_VALUE = fun_id++)] = _PROGRESS_SET_VALUE;
			m_arrFun[(PROGRESS_GET_VALUE = fun_id++)] = _PROGRESS_GET_VALUE;
			m_arrFun[(PROGRESS_GET_IMAGESET_NAME = fun_id++)] = _PROGRESS_GET_IMAGESET_NAME;
			m_arrFun[(PROGRESS_BEGIN_ADD = fun_id++)] = _PROGRESS_BEGIN_ADD;
			m_arrFun[(PROGRESS_STOP = fun_id++)] = _PROGRESS_STOP;
			m_arrFun[(TB_SET_TAB_NUM = fun_id++)] = _TB_SET_TAB_NUM;
			m_arrFun[(TB_GET_TAB_NUM = fun_id++)] = _TB_GET_TAB_NUM;
			m_arrFun[(TB_SET_TAB_NAME = fun_id++)] = _TB_SET_TAB_NAME;
			m_arrFun[(TB_GET_TAB_NAME = fun_id++)] = _TB_GET_TAB_NAME;
			m_arrFun[(TB_SET_SELECT_TAB = fun_id++)] = _TB_SET_SELECT_TAB;
			m_arrFun[(TB_GET_SELECT_TAB = fun_id++)] = _TB_GET_SELECT_TAB;
			m_arrFun[(TB_SET_TAB_SHOW = fun_id++)] = _TB_SET_TAB_SHOW;
			m_arrFun[(TB_GET_TAB_SHOW = fun_id++)] = _TB_GET_TAB_SHOW;
			m_arrFun[(TB_ENABLE_TAB = fun_id++)] = _TB_ENABLE_TAB;
			m_arrFun[(TB_IS_TAB_ENABLE = fun_id++)] = _TB_IS_TAB_ENABLE;
			m_arrFun[(TB_GET_TAB_BOUNDING_RECT = fun_id++)] = _TB_GET_TAB_BOUNDING_RECT;
			m_arrFun[(CHECKBOX_SET_CHECK = fun_id++)] = _CHECKBOX_SET_CHECK;
			m_arrFun[(CHECKBOX_GET_CHECK = fun_id++)] = _CHECKBOX_GET_CHECK;
			m_arrFun[(TREE_EXPAND = fun_id++)] = _TREE_EXPAND;
			m_arrFun[(TREE_IS_EXPAND = fun_id++)] = _TREE_IS_EXPAND;
			m_arrFun[(TREE_EXPAND_ALL = fun_id++)] = _TREE_EXPAND_ALL;
			m_arrFun[(TREE_ADD_OBJ = fun_id++)] = _TREE_ADD_OBJ;
			m_arrFun[(TREE_ADD_OBJ_TO_FIRST = fun_id++)] = _TREE_ADD_OBJ_TO_FIRST;
			m_arrFun[(TREE_DEL_OBJ = fun_id++)] = _TREE_DEL_OBJ;
			m_arrFun[(TREE_SET_OBJ = fun_id++)] = _TREE_SET_OBJ;
			m_arrFun[(TREE_GET_ALL = fun_id++)] = _TREE_GET_ALL;
			m_arrFun[(TREE_CLEAR_OBJ = fun_id++)] = _TREE_CLEAR_OBJ;
			m_arrFun[(TREE_SET_CUR_SEL = fun_id++)] = _TREE_SET_CUR_SEL;
			m_arrFun[(TREE_CLEAR_CUR_SEL = fun_id++)] = _TREE_CLEAR_CUR_SEL;
			m_arrFun[(TREE_CLEAR_CHILD = fun_id++)] = _TREE_CLEAR_CHILD;
			m_arrFun[(TREE_GET_CUR_SEL = fun_id++)] = _TREE_GET_CUR_SEL;
			m_arrFun[(TREE_FIND_OBJ_BY_USER_DATA = fun_id++)] = _TREE_FIND_OBJ_BY_USER_DATA;
			m_arrFun[(TREE_FORCE_SHOW_EXPAND_BUTTON = fun_id++)] = _TREE_FORCE_SHOW_EXPAND_BUTTON;
			m_arrFun[(TREE_IS_FROCE_SHOW_EXPAND_BUTTON = fun_id++)] = _TREE_IS_FORCE_SHOW_EXPAND_BUTTON;
			m_arrFun[(TREE_SET_CHILD_STEP_OFFSET_X = fun_id++)] = _TREE_SET_CHILD_STEP_OFFSET_X;
			m_arrFun[(TREE_GET_CHILD_TEXT_BOUNDING_RECT = fun_id++)] = _TREE_GET_CHILD_TEXT_BOUNDING_RECT;
			m_arrFun[(MENU_ADD = fun_id++)] = _MENU_ADD;
			m_arrFun[(MENU_REPLACE = fun_id++)] = _MENU_REPLACE;
			m_arrFun[(MENU_DEL = fun_id++)] = _MENU_DEL;
			m_arrFun[(SPLITER_SET_VALUE_H = fun_id++)] = _SPLITER_SET_VALUE_H;
			m_arrFun[(SPLITER_SET_VALUE_V = fun_id++)] = _SPLITER_SET_VALUE_V;
			m_arrFun[(SPLITER_SET_STATIC_SCROLL_TYPE = fun_id++)] = _SPLITER_SET_STATIC_SCROLL_TYPE;
			m_arrFun[(SPLITER_GET_STATIC_SCROLL_TYPE = fun_id++)] = _SPLITER_GET_STATIC_SCROLL_TYPE;
			m_arrFun[(SCROLL_SET_CLIENT_SIZE = fun_id++)] = _SCROLL_SET_CLIENT_SIZE;
			m_arrFun[(SCROLL_GET_CLIENT_WIDTH = fun_id++)] = _SCROLL_GET_CLIENT_WIDTH;
			m_arrFun[(SCROLL_GET_CLIENT_HEIGHT = fun_id++)] = _SCROLL_GET_CLIENT_HEIGHT;
			m_arrFun[(SCROLL_SET_CLIENT_POS = fun_id++)] = _SCROLL_SET_CLIENT_POS;
			m_arrFun[(SCROLL_GET_CLIENT_POSX = fun_id++)] = _SCROLL_GET_CLIENT_POSX;
			m_arrFun[(SCROLL_GET_CLIENT_POSY = fun_id++)] = _SCROLL_GET_CLIENT_POSY;
			m_arrFun[(SCROLL_SCROLL_TO_TOP = fun_id++)] = _SCROLL_SCROLL_TO_TOP;
			m_arrFun[(SCROLL_SCROLL_TO_BOTTOM = fun_id++)] = _SCROLL_SCROLL_TO_BOTTOM;
			m_arrFun[(IMAGE_BOX_FILL_COLOR = fun_id++)] = _IMAGE_BOX_FILL_COLOR;
			m_arrFun[(IMAGE_BOX_DRAW_WINDOW = fun_id++)] = _IMAGE_BOX_DRAW_WINDOW;
			m_arrFun[(IMAGE_BOX_REG_MOUSE_MOVE = fun_id++)] = _IMAGE_BOX_REG_MOUSE_MOVE;
			m_arrFun[(IMAGE_BOX_HANDLE_KEY = fun_id++)] = _IMAGE_BOX_HANDLE_KEY;
			m_arrFun[(IMAGE_BOX_GET_COLOR_DATA = fun_id++)] = _IMAGE_BOX_GET_COLOR_DATA;
			m_arrFun[(IMAGE_BOX_DRAW_MASK_CIRCAL = fun_id++)] = _IMAGE_BOX_DRAW_MASK_CIRCAL;
			m_arrFun[(IMAGEBUTTON_GET_IMAGESET_NAME = fun_id++)] = _IMAGEBUTTON_GET_IMAGESET_NAME;
			m_arrFun[(ANIIMAGEBOX_SET_MAX_FRAME = fun_id++)] = _ANIIMAGEBOX_SET_MAX_FRAME;
			m_arrFun[(ANIIMAGEBOX_GET_MAX_FRAME = fun_id++)] = _ANIIMAGEBOX_GET_MAX_FRAME;
			m_arrFun[(ANIIMAGEBOX_SET_CUR_FRAME = fun_id++)] = _ANIIMAGEBOX_SET_CUR_FRAME;
			m_arrFun[(ANIIMAGEBOX_GET_CUR_FRAME = fun_id++)] = _ANIIMAGEBOX_GET_CUR_FRAME;
			m_arrFun[(ANIIMAGEBOX_STOP = fun_id++)] = _ANIIMAGEBOX_STOP;
			m_arrFun[(ANIIMAGEBOX_PLAY = fun_id++)] = _ANIIMAGEBOX_PLAY;
			m_arrFun[(ANIIMAGEBOX_SET_SPEED = fun_id++)] = _ANIIMAGEBOX_SET_SPEED;
		}
		public function dUISendMessage( msgType:int , id:int = 0 , nParam1:int = 0 , nParam2:int = 0 , nParam3:int = 0 , nParam4:int = 0 , sParam:String = "" , oParam:Object = null ):int
		{
			if ( msgType <= C_LOAD_FROM_TEMPLATE )
			{
				return m_arrFun[msgType]( null , id , nParam1 , nParam2 , nParam3 , nParam4 , sParam , oParam );
			}
			var p:dUIImage;
			if ( msgType == C_ADD_DISPLAY_OBJ || msgType == C_REMOVE_DISPLAY_OBJ )
				p = FindFather( id , nParam4 );
			else
				p = m_arrImage[id] as dUIImage;
			if ( !p )
			{
				if ( m_nDebugMode == 1 && id != 0 )
					throw new Error( "无效的控件ID" + id );
				return 0;
			}
			return m_arrFun[msgType]( p , id , nParam1 , nParam2 , nParam3 , nParam4 , sParam , oParam );
		}
		private function _CREATE_WINDOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIWindow( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_BUTTON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIButton( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_IMAGEBUTTON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIImageButton( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_EDITBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIEditBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_SUPPERTEXT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUISuperText( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_IMAGEBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIImageBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_DRAGICON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIDragIcon( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_LISTBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIListBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_PROGRESS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIProgress( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_TABCONTROL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUITabControl( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_GROUP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIGroup( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_CHECKBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUICheckBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_RADIOBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIRadioBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_TREE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUITree( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_SCROLL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIScroll( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_SLIDER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUISlider( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_RIGHT_MENU( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var pMenu:dUIMenuComboBox = new dUIMenuComboBox( m_root.GetComboListBoxBoard() );
			CreateControl( pMenu , nParam1 ) as dUIMenuComboBox;
			if ( nParam1 == 0 && nParam2 == 0 )
			{
				nParam1 = GetMouseX();
				nParam2 = GetMouseY();
			}
			pMenu.AddString( sParam );
			pMenu.SetShow( true );
			pMenu.SetPos( nParam1 , nParam2 );
			pMenu.m_pAttachFather = FindFather( id , nParam4 );
			return m_root.CreateRightMenu( pMenu );
		}
		private function _CREATE_ANIIMAGEBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIAniImageBox( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_MESSAGEBOX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var pMessageBox:dUIMessageBox = new dUIMessageBox( FindFather( id , nParam4 ) , nParam3 , sParam );
			if ( nParam1 == 0 && nParam2 == 0 )
				pMessageBox.SetPos( ( m_root.GetWidth() - pMessageBox.GetWidth() ) / 2 , ( m_root.GetHeight() - pMessageBox.GetHeight() ) / 2 );
			else
				pMessageBox.SetPos( nParam1 , nParam2 );
			var ret:int = CreateControl( pMessageBox , 0 );
			if ( id == -1 ) m_root.CheckTopWindow();
			return ret;
		}
		private function _CREATE_MENU( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIMenu( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_SPLITER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUISpliter( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _CREATE_STACK( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return CreateControl( new dUIStack( FindFather( id , nParam4 ) ) , nParam1 );
		}
		private function _C_LOAD_FROM_TEMPLATE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			m_root.m_bLoadingPage++;
			var pFather:dUIImage;
			pFather = FindFather( id , nParam4 );
			if ( !pFather ) return -1;
			var ret:int = LoadTemplateFromString( pFather , 0 , 0 , 0 , nParam2 , sParam , oParam.idList );
			if ( id == -1 ) m_root.CheckTopWindow();
			m_root.m_bLoadingPage--;
			return ret;
		}
		private function _DELETE_WINDOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			DeleteWindow( id );
			return 1;
		}
		private function _C_SET_POS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetPos( nParam1 , nParam2 ); return 1;
		}
		private function _C_GET_POSX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetPosX();
		}
		private function _C_GET_POSY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetPosY();
		}
		private function _C_SET_MARGIN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetMargin( nParam1 , nParam2 ); return 1;
		}
		private function _C_SET_SIZE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetSize( nParam1 , nParam2 ); return 1;
		}
		private function _C_GET_WIDTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetWidth();
		}
		private function _C_GET_HEIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetHeight();
		}
		private function _C_SET_ID( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( nParam1 == 0 ) return 0;
			if ( m_arrImage[ nParam1 ] ) return 0;// ID已被占用
			p.SetID( nParam1 );
			m_arrImage[ nParam1 ] = p;
			m_arrImage[ id ] = null;
			return nParam1;
		}
		private function _C_SET_TEXT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetText( sParam ); return 1;
		}
		private function _C_GET_TEXT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			oParam.str = p.GetText(); return 1;
		}
		private function _C_GET_TEXT_WITHOUT_SIGN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			oParam.str = p.GetText();
			oParam.str = dUISuperText.ConvTextWithoutSign( oParam.str );
			return 1;
		}
		private function _C_SET_CONTROL_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetControlName( sParam ); return 1;
		}
		private function _C_GET_CONTROL_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			oParam.str = p.GetControlName(); return 1;
		}
		private function _C_LOAD_FROM_IMAGESET( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			(m_arrImage[id] as dUIImage).LoadFromImageSet( sParam ); return 1;
		}
		private function _C_LOAD_FROM_FILE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.LoadFromFile( sParam ); return 1;
		}
		private function _C_LOAD_FROM_BIN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.LoadFromBin( oParam as dByteArray ); return 1;
		}
		private function _C_LOAD_FROM_BITMAPDATA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX )
			{
				//(p as dUIAniImageBox).LoadFromBitmapDataList( oParam as dBitmapData , nParam1 );
				return 1;
			}
			else
			{
				p.LoadFromBitmapData( oParam as dBitmapData );
				return 1;
			}
			return 0;
		}
		private function _C_COPY_CREATE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( m_arrImage[ nParam1 ] ) return CopyCreate( FindFather( id , nParam4 ) , m_arrImage[ nParam1 ] ); return 0;
		}
		private function _C_GET_IMAGE_SET_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			oParam.str = p.GetImageSetName(); return 1;
		}
		private function _C_SET_STYLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetStyleData( sParam , Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_STYLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isStyleData( sParam ) );
		}
		private function _C_SET_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var bMoveTop:Boolean = p.isShow() != nParam1;
			p.SetShow( Boolean( nParam1 ) );
			if( p.GetFather() == m_root.GetTopWindow() )
				m_root.CheckTopWindow();
			else if ( p.GetFather() == m_root.GetComboListBoxBoard() )
				m_root.CheckComboListBoxBoard();
			if ( bMoveTop && nParam1 && p.GetFather() && p.GetFather().isRegBringTopWhenClickWindow() )
				p.MoveTop();
			return 1;
		}
		private function _C_GET_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isShow() );
		}
		private function _C_SET_SHOW_CLIENT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetShowClient( Boolean( nParam1 ) , nParam4 );
			return 1;
		}
		private function _C_GET_SHOW_CLIENT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isShowClient( nParam4 ) );
		}
		private function _C_SET_WAIT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetWait( Boolean( nParam1 ) , nParam4 );
			return 1;
		}
		private function _C_GET_WAIT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isWait( nParam4 ) );
		}
		private function _C_ENABLE_WINDOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.EnableWindow( Boolean( nParam1 ) ); return 1;
		}
		private function _C_IS_WINDOW_ENABLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isWindowEnable() );
		}
		private function _C_SET_HANDLE_MOUSE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetHandleMouse( Boolean( nParam1 ) ); return 1;
		}
		private function _C_IS_HANDLE_MOUSE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isHandleMouse() );
		}
		private function _C_GET_OBJ_TYPE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetObjType();
		}
		private function _C_SET_USER_DATA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE && sParam.length )
				p = (p as dUITree).FindObjByString( sParam );
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				p = (p as dUIListBox).GetList( nParam2 , nParam1 );
			else if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
				p = (p as dUITabControl).GetView( nParam1 );
			if ( p ) { p.SetUserData( oParam ); return 1; }
			return 0;
		}
		private function _C_GET_USER_DATA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE && sParam.length )
				p = (p as dUITree).FindObjByString( sParam );
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				p = (p as dUIListBox).GetList( nParam2 , nParam1 );
			else if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
				p = (p as dUITabControl).GetView( nParam1 );
			if ( p ) { oParam.ret = p.GetUserData(); return 1; }
			return 0;
		}
		private function _C_SET_TOOLTIP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == dUISystem.GUIOBJ_TYPE_LISTBOX )
			{
				if ( nParam1 == -1 )
					( p as dUIListBox ).SetTooltip( sParam );
				else
				{
					var pObj:dUIImage = ( p as dUIListBox ).GetList( nParam2 , nParam1 );
					if ( pObj ) pObj.SetTooltip( sParam );
				}
			}
			else if ( p.GetObjType() == dUISystem.GUIOBJ_TYPE_TABCONTROL )
			{
				pObj = ( p as dUITabControl ).GetTabButton( nParam2 );
				if ( pObj ) pObj.SetTooltip( sParam );
			}
			else
				p.SetTooltip( sParam );
			return 1;
		}
		private function _C_GET_TOOLTIP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == dUISystem.GUIOBJ_TYPE_LISTBOX )
			{
				var pObj:dUIImage = ( p as dUIListBox ).GetList( nParam2 , nParam1 );
				if ( pObj ) oParam.str = pObj.GetTooltip();
			}
			else if ( p.GetObjType() == dUISystem.GUIOBJ_TYPE_TABCONTROL )
			{
				pObj = ( p as dUITabControl ).GetTabButton( nParam2 );
				if ( pObj ) oParam.str = pObj.GetTooltip();
			}
			else
				oParam.str = p.GetTooltip();
			return 1;
		}
		private function  _C_SET_ALIGN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetAlignType( nParam1 , nParam2 ); return 1;
		}
		private function _C_GET_ALIGN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetAlignType();
		}
		private function _C_GET_CLIENT_WIDTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetClient().GetWidth();
		}
		private function _C_GET_CLIENT_HEIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetClient().GetHeight();
		}
		private function _C_SET_FOCUS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetFocus( Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_FOCUS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p = m_root.GetFocus() ;
			if ( p )
				return p._GetID();
			return 0;
		}
		private function _C_SET_AUTO_POS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetAutoPos( nParam1 , nParam2 ); return 1;
		}
		private function _C_GET_AUTO_POSX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetAutoPosX();
		}
		private function _C_GET_AUTO_POSY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetAutoPosY();
		}
		private function _C_SET_AUTO_POS_PANNEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.RegAutoPosPanel( Boolean( nParam1 ) ); return 1;
		}
		private function _C_SET_AUTO_BRING_TOP_PANNEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.RegBringTopWhenClickWindow( Boolean( nParam1 ) ); return 1;
		}
		private function _C_SET_ALPHA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetAlpha( nParam1 ); return 1;
		}
		private function _C_GET_ALPHA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetAlpha();
		}
		private function _C_SET_GRAY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetGray( Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_GRAY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isGray() );
		}
		private function _C_SET_HIGHTLIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetHightLight( Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_HIGHTLIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isHightLight() );
		}
		
		private function _C_SET_AUTO_SIZE_AS_FATHER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetAutoSizeAsFather( Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_AUTO_SIZE_AS_FATHER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isAutoSizeAsFather() );
		}
		private function _C_SET_AUTO_SIZE_AS_CHILD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetAutoSizeAsChild( Boolean( nParam1 ) ); return 1;
		}
		private function _C_GET_AUTO_SIZE_AS_CHILD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isAutoSizeAsChild() );
		}
		private function _C_GET_POSX_WORLD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetPosX_World();
		}
		private function _C_GET_POSY_WORLD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetPosY_World();
		}
		private function _C_ADD_DISPLAY_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( oParam && oParam is DisplayObject ) ( p.GetClient()._GetBaseObject() as Sprite ).addChild( oParam as DisplayObject ); return 1;
		}
		private function _C_REMOVE_DISPLAY_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var pBase:Sprite = p._GetBaseObject() as Sprite;
			if ( oParam && oParam is DisplayObject && pBase.contains( oParam as DisplayObject ) )
				pBase.removeChild( oParam as DisplayObject ); return 1;
		}
		private function _C_ADD_SPRITE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			( oParam as dSprite ).dSpriteSetFather( p.GetClient() , -1 );
			return 1;
		}
		private function _C_REMOVE_SPRITE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			( oParam as dSprite ).dSpriteRemoveFather();
			return 1;
		}
		private function _C_GET_FATHER_ID( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetFather() ) return p.GetFather()._GetID(); return 0;
		}
		private function _C_SET_TO_CENTER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetFather() )
			{
				var x:int = 0;
				var y:int = 0;
				if ( nParam1 == dUISystem.GUI_AUTOPOS_CENTER ) x = ( p.GetFather().GetWidth() - p.GetWidth() ) / 2;
				else if ( nParam1 == dUISystem.GUI_AUTOPOS_RIGHT_BOTTOM ) x = p.GetFather().GetWidth() - p.GetWidth();
				if ( nParam2 == dUISystem.GUI_AUTOPOS_CENTER ) y = ( p.GetFather().GetHeight() - p.GetHeight() ) / 2;
				else if ( nParam2 == dUISystem.GUI_AUTOPOS_RIGHT_BOTTOM ) y = p.GetFather().GetHeight() - p.GetHeight();
				p.SetPos( x , y ) ;
				return 1;
			}
			return 0;
		}
		private function _C_BRING_TO_TOP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( nParam1 && m_arrImage[ nParam1 ] )
				p.MoveTop( m_arrImage[ nParam1 ] );
			else
				p.MoveTop();
			return 1;
		}
		private function _C_BRING_TO_BOTTOM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.MoveBottom(); return 1;
		}
		private function _C_FLASH_WINDOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.FlashWindow( nParam1 , nParam2 , nParam3 , nParam4 ); return 1;
		}
		private function _C_FLASH_WINDOW_DISABLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.FlashWindowDisable( nParam3 , nParam4 ); return 1;
		}
		private function _C_GET_MOUSEX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetMouseX();
		}
		private function _C_GET_MOUSEY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetMouseY();
		}
		private function _C_REG_MOUSE_FADING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.RegMouseFadeIn( Boolean( nParam1 ) ); return 1;
		}
		private function _C_IS_REG_MOUSE_FADING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isRegMouseFadeIn() );
		}
		private function _C_SET_ROTATION( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetRotation( nParam1 , Boolean( nParam2 ) , Boolean( nParam3 ) ); return 1;
		}
		private function _C_GET_ROTATION( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetRotation();
		}
		private function _C_GET_ROTATION_MIRRORX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isRotationMirrorX() );
		}
		private function _C_GET_ROTATION_MIRRORY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isRotationMirrorY() );
		}
		private function _C_SET_COLOR_TRANSFORM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if( nParam1 || nParam2 || nParam3 || nParam4 )
				p.SetColorTransform( new dUIColorTransform( nParam1 , nParam2 , nParam3 , nParam4 ) );
			else
				p.SetColorTransform( null );
			return 1;
		}
		private function _C_SET_MOUSE_STYLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetMouseStyle( nParam1 );
			return 1;
		}
		private function _C_GET_MOUSE_STYLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return p.GetMouseStyle();
		}
		private function _C_IS_MOUSE_IN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			return int( p.isMouseIn() );
		}
		private function _C_SET_EDGE_RECT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			p.SetEdgeRect( nParam1 , nParam2 , nParam3 , nParam4 );
			return 1;
		}
		private function _BUTTON_SET_PUSH_DOWN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_BUTTON || p.GetObjType() == GUIOBJ_TYPE_IMAGEBUTTON ) {
				(p as dUIButtonBase).SetPushDown( Boolean( nParam1 ) ); return 1; } return 0;
		}
		private function _BUTTON_GET_PUSH_DOWN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_BUTTON || p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX ) {
				return int( (p as dUIButtonBase).GetPushDown() ); } return 0;
		}
		private function _TEXT_SET_LIMIT_TEXT_LENGTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				(p as dUIEditBox).SetLimitTextLength( nParam1 );
				return 1;
			}
			return 0;
		}
		private function _TEXT_GET_LIMIT_TEXT_LENGTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return (p as dUIEditBox).GetLimitTextLength();
			return 0;
		}
		private function _TEXT_SET_LIMIT_NUMBER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				(p as dUIEditBox).SetLimitNumber( nParam1 );
			}
			return 0;
		}
		private function _TEXT_GET_LIMIT_NUMBER( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return (p as dUIEditBox).GetLimitNumber();
			return 0;
		}
		private function _TEXT_SET_LIMIT_NUMBER_MIN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				(p as dUIEditBox).SetLimitNumberMin( nParam1 );
			}
			return 0;
		}
		private function _TEXT_GET_LIMIT_NUMBER_MIN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return (p as dUIEditBox).GetLimitNumberMin();
			return 0;
		}
		private function _TEXT_SET_SELECTION( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				(p as dUIEditBox).SetSelection( nParam1 , nParam2 );
				return 1;
			}
			return 0;
		}
		private function _TEXT_GET_SELECTION_BEGIN( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return (p as dUIEditBox).GetSelectionBegin();
			return 0;
		}
		private function _TEXT_GET_SELECTION_END( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return (p as dUIEditBox).GetSelectionEnd();
			return 0;
		}
		private function _TEXT_INSERT_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				(p as dUIEditBox).InsertString( nParam1 , sParam );
				return 1;
			}
			return 0;
		}
		private function _EDITBOX_SET_COMBOBOX_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX ) {
					(p as dUIEditBox).SetComboBoxString( sParam );
					(p as dUIEditBox).SetComboBoxLimitHeight( nParam2 ); return 1; } return 0;
		}
		private function _EDITBOX_GET_COMBOBOX_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX ) {
				oParam.str = (p as dUIEditBox).GetComboBoxString(); return 1; } return 0;
		}
		private function _EDITBOX_SET_COMBOBOX_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX ) {
				(p as dUIEditBox).SetComboBoxShow( Boolean( nParam1 ) );
				return 1;
			}
			return 0;
		}
		private function _EDITBOX_GET_COMBOBOX_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX ) {
				return int( (p as dUIEditBox).isComboBoxShow() );
			}
			return 0;
		}
		private function _ICON_SWAP_STATUS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var p2:dUIImage = m_arrImage[nParam1] as dUIImage; if ( !p2 ) return 0;
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON && p2.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SwapStatus( p2 as dUIDragIcon ); return 1; } return 0;
		}
		private function _ICON_COPY_STATUS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			var p2:dUIImage = m_arrImage[nParam1] as dUIImage; if ( !p2 ) return 0;
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON && p2.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).CopyStatus( p2 as dUIDragIcon ); return 1; } return 0;
		}
		private function _ICON_CLEAR_STATUS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ){
				(p as dUIDragIcon).ClearStatus(); return 1; } return 0;
		}
		private function _ICON_SET_COOL_TIME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetCoolTimeCur( nParam1 ); return 1; } return 0;
		}
		private function _ICON_GET_COOL_TIME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				return (p as dUIDragIcon).GetCoolTimeCur(); } return 0;
		}
		private function _ICON_SET_MAX_TIME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetCoolTimeMax( nParam1 ); return 1; } return 0;
		}
		private function _ICON_GET_MAX_TIME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				return (p as dUIDragIcon).GetCoolTimeMax(); return 1; } return 0;
		}
		private function _ICON_SET_PIC_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetIconPic( sParam ); return 1; } return 0;
		}
		private function _ICON_SET_ANI_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetIconAni( sParam ); return 1; } return 0;
		}
		private function _ICON_SET_ANI_CUR_FRAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetAniCurFrame( nParam1 ); return 1; } return 0;
		}
		private function _ICON_SET_COOL_IMAGE_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				(p as dUIDragIcon).SetIconCoolImageName( sParam ); return 1; } return 0;
		}
		private function _ICON_GET_COOL_IMAGE_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON ) {
				oParam.str = (p as dUIDragIcon).GetIconCoolImageName(); return 1; } return 0;
		}
		private function _ICON_SET_ANI_COLOR_TRANSFORM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON )
			{
				if( nParam1 || nParam2 || nParam3 || nParam4 )
					(p as dUIDragIcon).SetAniColorTransform( new dUIColorTransform( nParam1 , nParam2 , nParam3 , nParam4 ) );
				else
					(p as dUIDragIcon).SetAniColorTransform( null );
				return 1;
			}
			return 0;
		}
		private function _LB_ADD_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				if( nParam4 == 1 )
					return (p as dUIListBox).AddStringCommand( sParam , nParam2 , nParam1 , Boolean( nParam3 ) );
				else
					return (p as dUIListBox).AddString( sParam , nParam2 , nParam1 , Boolean( nParam3 ) );
			}
			return 0;
		}
		private function _LB_INSERT_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).InsertString( sParam , nParam2 , nParam1 ); return 1; } return 0;
		}
		private function _LB_DELETE_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).DelList( nParam1 ); return 1; } return 0;
		}
		private function _LB_DELETE_LIST_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX && m_arrImage[ nParam1 ] ) {
				(p as dUIListBox).DelListObj( m_arrImage[ nParam1 ] ); return 1; } return 0;
		}
		private function _LB_CLEAR_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).ClearString(); return 1; } return 0;
		}
		private function _LB_ADD_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				if ( m_arrImage[ nParam4 ] )
				{
					return (p as dUIListBox).AddList( m_arrImage[ nParam4 ] , nParam2 , nParam1 );
				}
			}
			return 0;
		}
		private function _LB_REMOVE_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				return (p as dUIListBox).RemoveList( nParam2 , nParam1 );
			}
			return 0;
		}
		private function _LB_INSERT_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				if ( m_arrImage[ nParam4 ] )
				{
					(p as dUIListBox).InsertList( m_arrImage[ nParam4 ] , nParam2 , nParam1 ); return 1;
				}
			}
			return 0;
		}
		private function _LB_GET_LIST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetListID( nParam2 , nParam1 ) }	return 0;
		}
		private function _LB_GET_STRING( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				oParam.str = (p as dUIListBox).GetString( nParam2 , nParam1 ); return 1; } return 0;
		}
		private function _LB_GET_LIST_COUNT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetListCount(); } return 0;
		}
		private function _LB_SET_LIST_COUNT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetListCount( nParam1 ); return 1; } return 0;
		}
		private function _LB_SET_TAB_COUNT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ){
				(p as dUIListBox).SetTabCount( nParam1 ); return 1; } return 0;
		}
		private function _LB_GET_TAB_COUNT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetTabCount(); } return 0;
		}
		private function _LB_SET_TAB_WIDTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetTabWidth( nParam1 , nParam2 ); return 1; } return 0;
		}
		private function _LB_GET_TAB_WIDTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetTabWidth( nParam1 ); } return 0;
		}
		private function _LB_SET_TAB_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ){
				(p as dUIListBox).SetTabName( nParam1 , sParam ); return 1; } return 0;
		}
		private function _LB_GET_TAB_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				oParam.str = (p as dUIListBox).GetTabName( nParam1 ); return 1; } return 0;
		}
		private function _LB_SET_MAX_LIST_NUM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetMaxListNum( nParam1 ); return 1; } return 0;
		}
		private function _LB_GET_MAX_LIST_NUM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetMaxListNum(); } return 0;
		}
		private function _LB_SET_CUR_SEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetCurSel( nParam1 , nParam2 ); return 1; } return 0;
		}
		private function _LB_GET_CUR_SEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return (p as dUIListBox).GetCurSel(); return 1; } return 0;
		}
		private function _LB_SET_TAB_CAN_SORT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetTabCanSort( nParam1 , Boolean( nParam2 ) ); return 1; } return 0;
		}
		private function _LB_GET_TAB_CAN_SORT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return int( (p as dUIListBox).GetTabCanSort( nParam1 ) ); } return 0;
		}
		private function _LB_SET_TAB_SHOW_SORT_ICON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetTabShowSortIcon( nParam1 , Boolean( nParam2 ) ); return 1; } return 0;
		}
		private function _LB_GET_TAB_SHOW_SORT_ICON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				return int( (p as dUIListBox).GetTabShowSortIcon( nParam1 ) ); } return 0;
		}
		private function _LB_SORT_TAB( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SortTab( nParam1 , Boolean( nParam2 ) ); return 1 ; } return 0;
		}
		private function _LB_SET_SORT_METHOD_FUNCTION( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetSortMethodFunction( nParam1 , oParam as Function ); return 1; } return 0;
		}
		private function _LB_SET_FORCE_PER_LINE_HEIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetForcePerLineHeight( nParam1 ) ; return 1; } return 0;
		}
		private function _LB_GET_FORCE_PER_LINE_HEIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) return ( p as dUIListBox ).GetForcePerLineHeight();
			return 0;
		}
		private function _LB_SET_PER_LINE_SPACE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) {
				(p as dUIListBox).SetPerLineSpace( nParam1 ); return 1; } return 0;
		}
		private function _LB_GET_PER_LINE_SPACE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX ) return ( p as dUIListBox ).GetPerLineSpace();
			return 0;
		}
		private function _PROGRESS_SET_MAX_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { (p as dUIProgress).SetMaxValue( nParam1 ); return 1 }
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) { (p as dUISlider).SetMaxValue( nParam1 ); return 1; }
			return 0;
		}
		private function _PROGRESS_GET_MAX_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) return (p as dUIProgress).GetMaxValue();
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) return (p as dUISlider).GetMaxValue() ;
			return 0;
		}
		private function _PROGRESS_SET_MIN_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			//if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { (p as dUIProgress).SetMinValue( nParam1 ); return 1 }
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) { (p as dUISlider).SetMinValue( nParam1 ); return 1; }
			return 0;
		}
		private function _PROGRESS_GET_MIN_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			//if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) return (p as dUIProgress).GetMinValue();
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) return (p as dUISlider).GetMinValue() ;
			return 0;
		}
		private function _PROGRESS_SET_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { (p as dUIProgress).SetValue( nParam1 ); return 1; }
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) { (p as dUISlider).SetValue( nParam1 ); return 1; }
			return 0;
		}
		private function _PROGRESS_GET_VALUE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) return (p as dUIProgress).GetValue();
			if ( p.GetObjType() == GUIOBJ_TYPE_SLIDER ) return (p as dUISlider).GetValue();
			return 0;
		}
		private function _PROGRESS_GET_IMAGESET_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { oParam.str = (p as dUIProgress).GetProgressImageSetName( nParam1 ); return 1; }
			return 0;
		}
		private function _PROGRESS_BEGIN_ADD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { (p as dUIProgress).BeginAdd( nParam1 ); return 1; }
			return 0;
		}
		private function _PROGRESS_STOP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_PROGRESS ) { (p as dUIProgress).Stop(); return 1; }
			return 0;
		}
		private function _TB_SET_TAB_NUM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				(p as dUITabControl).SetTabCount( nParam1 ); return 1; } return 0;
		}
		private function _TB_GET_TAB_NUM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				return (p as dUITabControl).GetTabCount(); } return 0;
		}
		private function _TB_SET_TAB_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				(p as dUITabControl).SetTabName( sParam , nParam1 ); return 1; } return 0;
		}
		private function _TB_GET_TAB_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				oParam.str = (p as dUITabControl).GetTabName( nParam1 ); return 1; } return 0;
		}
		private function _TB_SET_SELECT_TAB( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				(p as dUITabControl).SetSelectTab( nParam1 , false ); return 1; } return 0;
		}
		private function _TB_GET_SELECT_TAB( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				return (p as dUITabControl).GetSelectTab(); } return 0;
		}
		private function _TB_SET_TAB_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				(p as dUITabControl).SetShowTab( nParam1 , Boolean( nParam2 ) ); return 1; } return 0;
		}
		private function _TB_GET_TAB_SHOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				return int( (p as dUITabControl).GetShowTab( nParam1 ) ); } return 0;
		}
		private function _TB_ENABLE_TAB( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				(p as dUITabControl).EnableTab( nParam1 , Boolean( nParam2 ) ); return 1; } return 0;
		}
		private function _TB_IS_TAB_ENABLE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL ) {
				return int( (p as dUITabControl).isTabEnable( nParam1 ) ); } return 0;
		}
		private function _TB_GET_TAB_BOUNDING_RECT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TABCONTROL )
			{
				oParam.ret = ( p as dUITabControl ).GetTabBoundRect( nParam1 );
				return 1;
			}
			return 0;
		}
		private function _CHECKBOX_SET_CHECK( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_CHECKBOX ) { (p as dUICheckBox).SetCheck( Boolean( nParam1 ) ); return 1; }
			if ( p.GetObjType() == GUIOBJ_TYPE_RADIOBOX ) { (p as dUIRadioBox).SetCheck( Boolean( nParam1 ) ); return 1; }
			return 0;
		}
		private function _CHECKBOX_GET_CHECK( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_CHECKBOX ) return int( (p as dUICheckBox).GetCheck() );
			if ( p.GetObjType() == GUIOBJ_TYPE_RADIOBOX ) return int( (p as dUIRadioBox).GetCheck() );
			return 0;
		}
		private function _TREE_EXPAND( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj )
				{
					if ( nParam1 )
					{
						while ( pTreeObj )
						{
							pTreeObj.Expand( Boolean( nParam1 ) );
							pTreeObj = pTreeObj.GetTreeFather();
						}
					}
					else pTreeObj.Expand( Boolean( nParam1 ) );
				}
				return 1;
			} return 0;
		}
		private function _TREE_IS_EXPAND( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj ) return int( pTreeObj.isExpand() ); return 1; } return 0;
		}
		private function _TREE_EXPAND_ALL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				(p as dUITree).ExpandAll( Boolean( nParam1 ) ); return 1; } return 0;
		}
		private function _TREE_ADD_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				(p as dUITree).CreateTreeByString( sParam ); return 1; } return 0;
		}
		private function _TREE_ADD_OBJ_TO_FIRST( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				//if ( (p as dUITree).FindObjByString( sParam ) )
				//	( p as dUITree).DeleteTreeByString( sParam );
				(p as dUITree).CreateTreeByString( sParam , "|" , nParam1 ); return 1; } return 0;
		}
		private function _TREE_DEL_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				(p as dUITree).DeleteTreeByString( sParam ); return 1; } return 0;
		}
		private function _TREE_SET_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var str1:String = new String;
				var str2:String = new String;
				var step:int = 0;
				for ( var i:int = 0 ; i < sParam.length ; i ++ )
				{
					var s:String = sParam.charAt( i );
					if ( i < sParam.length - 1 && s == "|" && sParam.charAt( i+1 ) == "|" )
					{
						step++;
						i++;
					}
					else
					{
						if ( step == 0 ) str1 += s;
						else str2 += s;
					}
				}
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( str1 );
				if ( pTreeObj )
				{
					pTreeObj.SetText( str2 );
					return 1;
				}
			}
			return 0;
		}
		private function _TREE_GET_ALL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				oParam.str = ( p as dUITree ).GetAllObj( sParam ); return 1; } return 0;
		}
		private function _TREE_CLEAR_OBJ( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				(p as dUITree).ClearTree(); return 1; } return 0;
		}
		private function _TREE_SET_CUR_SEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj ) (p as dUITree).SetCurSel( pTreeObj ); return 1; } return 0;
		}
		private function _TREE_CLEAR_CUR_SEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE ) {
				(p as dUITree).ClearCurSel(); return 1; } return 0;
		}
		private function _TREE_CLEAR_CHILD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj )
				{
					(p as dUITree).ClearTreeChild( pTreeObj );
					return 1;
				}
			}
			return 0;
		}
		private function _TREE_GET_CUR_SEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				oParam.str = (p as dUITree).GetCurSel();
				return 1;
			}
			return 0;
		}
		private function _TREE_FIND_OBJ_BY_USER_DATA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				oParam.str = (p as dUITree).FindObjByUserData( oParam.oParam );
				return 1;
			}
			return 0;
		}
		private function _TREE_FORCE_SHOW_EXPAND_BUTTON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj ) pTreeObj.SetForceShowExpandButton( Boolean( nParam1 ) );
				return 1;
			}
			return 0;
		}
		private function _TREE_IS_FORCE_SHOW_EXPAND_BUTTON( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj ) return int( pTreeObj.isForceShowExpandButton() );
			}
			return 0;
		}
		private function _TREE_SET_CHILD_STEP_OFFSET_X( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				( p as dUITree ).SetChildStepOffsetX( nParam1 );
			}
			return 0;
		}
		private function _TREE_GET_CHILD_TEXT_BOUNDING_RECT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				var pTreeObj:dUITreeObj = (p as dUITree).FindObjByString( sParam );
				if ( pTreeObj )
				{
					oParam.ret = pTreeObj.GetTextBoundingRect( nParam1 );
				}
			}
			return 0;
		}
		private function _MENU_ADD( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_MENU ) {
				( p as dUIMenu ).AddMenu( sParam ); return 1; } return 0;
		}
		private function _MENU_REPLACE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_MENU ) {
				( p as dUIMenu ).ReplaceMenu( sParam ); return 1; } return 0;
		}
		private function _MENU_DEL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_MENU ) {
				( p as dUIMenu ).DelMenu( sParam ); return 1; } return 0;
		}
		private function _SPLITER_SET_VALUE_H( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SPLITER ) {
				( p as dUISpliter ).SetValueH( nParam1 ); return 1; } return 0;
		}
		private function _SPLITER_SET_VALUE_V( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SPLITER ) {
				( p as dUISpliter ).SetValueV( nParam1 ); return 1; } return 0;
		}
		private function _SPLITER_SET_STATIC_SCROLL_TYPE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SPLITER ) {
				( p as dUISpliter ).SetStaticScrollType( nParam1 ); return 1; } return 0;
		}
		private function _SPLITER_GET_STATIC_SCROLL_TYPE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SPLITER ) {
				return ( p as dUISpliter ).GetStaticScrollType(); } return 0;
		}
		private function _SCROLL_SET_CLIENT_SIZE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
			{
				( p as dUIScroll ).SetClientSize( nParam1 , nParam2 );
				return 1;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				( p as dUIEditBox ).GetScroll().SetClientSize( nParam1 , nParam2 );
				return 1;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				( p as dUIListBox ).GetScroll().SetClientSize( nParam1 , nParam2 );
				return 1;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				( p as dUITree ).GetScroll().SetClientSize( nParam1 , nParam2 );
				return 1;
			}
			return 0;
		}
		private function _SCROLL_GET_CLIENT_WIDTH( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
				return ( p as dUIScroll ).GetClientWidth();
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return ( p as dUIEditBox ).GetScroll().GetClientWidth();
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				return ( p as dUIListBox ).GetScroll().GetClientWidth();
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
				return ( p as dUITree ).GetScroll().GetClientWidth();
			return 0;
		}
		private function _SCROLL_GET_CLIENT_HEIGHT( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
				return ( p as dUIScroll ).GetClientHeight();
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return ( p as dUIEditBox ).GetScroll().GetClientHeight();
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				return ( p as dUIListBox ).GetScroll().GetClientHeight();
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
				return ( p as dUITree ).GetScroll().GetClientHeight();
			return 0;
		}
		private function _SCROLL_SET_CLIENT_POS( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
			{
				( p as dUIScroll ).SetClientPos( nParam1 , nParam2 );
				return 1 ;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				( p as dUIListBox ).SetClientPos( nParam1 , nParam2 );
				return 1;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				( p as dUIEditBox ).GetScroll().SetClientPos( nParam1 , nParam2 );
				return 1;
			}
			if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				( p as dUITree ).GetScroll().SetClientPos( nParam1 , nParam2 );
				return 1;
			}
			return 0;
		}
		private function _SCROLL_GET_CLIENT_POSX( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
				return ( p as dUIScroll ).GetClient().GetPosX();
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return ( p as dUIEditBox ).GetScrollClientPosX();
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				return ( p as dUIListBox ).GetClient().GetPosX();
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
				return ( p as dUITree ).GetClient().GetPosX();
			return 0;
		}
		private function _SCROLL_GET_CLIENT_POSY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
				return ( p as dUIScroll ).GetClient().GetPosY();
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
				return ( p as dUIEditBox ).GetScrollClientPosY();
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
				return ( p as dUIListBox ).GetClient().GetPosY();
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
				return ( p as dUITree ).GetClient().GetPosY();
			return 0;
		}
		private function _SCROLL_SCROLL_TO_TOP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
			{
				( p as dUIScroll ).SetToTop();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				( p as dUIListBox ).SetToTop();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				( p as dUITree ).SetToTop();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				( p as dUIEditBox ).SetToTop();
				return 1;
			}
			return 0;
		}
		private function _SCROLL_SCROLL_TO_BOTTOM( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if( p.GetObjType() == GUIOBJ_TYPE_SCROLL )
			{
				( p as dUIScroll ).SetToBottom();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_LISTBOX )
			{
				( p as dUIListBox ).SetToBottom();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_TREE )
			{
				( p as dUITree ).SetToBottom();
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_EDITBOX )
			{
				( p as dUIEditBox ).SetToBottom();
				return 1;
			}
			return 0;
		}
		private function _IMAGE_BOX_FILL_COLOR( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX )
			{
				( p as dUIImageBox ).FillColor( uint( nParam1 ) );
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON )
			{
				( p as dUIDragIcon ).FillColor( uint( nParam1 ) );
				return 1;
			}
			return 0;
		}
		private function _IMAGE_BOX_DRAW_WINDOW( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX && m_arrImage[ nParam1 ] ) {
				( p as dUIImageBox ).DrawWindow( m_arrImage[ nParam1 ] );
				return 1;
			}
			return 0;
		}
		private function _IMAGE_BOX_REG_MOUSE_MOVE( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX ) {
				( p as dUIImageBox ).RegMouseMoveEvent( Boolean( nParam1 ) ) ; return 1; } return 0;
		}
		private function _IMAGE_BOX_HANDLE_KEY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX ) {
				( p as dUIImageBox ).SetHandleKey( Boolean( nParam1 ) ) ; return 1; } return 0;
		}
		private function _IMAGE_BOX_GET_COLOR_DATA( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX ) {
				oParam.ret = ( p as dUIImageBox ).GetColorData( nParam1 , nParam2 , nParam3 , nParam4 ); return 1; } return 0;
		}
		private function _IMAGE_BOX_DRAW_MASK_CIRCAL( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBOX ) {
				( p as dUIImageBox ).DrawMaskCircal(); return 1; } return 0;
		}
		private function _IMAGEBUTTON_GET_IMAGESET_NAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_IMAGEBUTTON )
			{
				switch( nParam1 )
				{
					case 0: oParam.str = ( p as dUIImageButton ).GetImageSetName_Normal(); return 1;
					case 1: oParam.str = ( p as dUIImageButton ).GetImageSetName_Light(); return 1;
					case 2: oParam.str = ( p as dUIImageButton ).GetImageSetName_Down(); return 1;
					case 3: oParam.str = ( p as dUIImageButton ).GetImageSetName_Invalid(); return 1;
				}
			}
			return 0; 
		}
		private function _ANIIMAGEBOX_SET_MAX_FRAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				( p as dUIAniImageBox ).SetMaxFrameNum( nParam1 ); return 1; } return 0;
		}
		private function _ANIIMAGEBOX_GET_MAX_FRAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				return ( p as dUIAniImageBox ).GetMaxFrameNum(); } return 0;
		}
		private function _ANIIMAGEBOX_SET_CUR_FRAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				( p as dUIAniImageBox ).SetCurFrame( nParam1 ); return 1; } return 0;
		}
		private function _ANIIMAGEBOX_GET_CUR_FRAME( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				return (p as dUIAniImageBox ).GetCurFrame(); } return 0;
		}
		private function _ANIIMAGEBOX_STOP( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				( p as dUIAniImageBox ).Stop(); return 1; } return 0;
		}
		private function _ANIIMAGEBOX_PLAY( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX ) {
				( p as dUIAniImageBox ).Play(); return 1; } return 0;
		}
		private function _ANIIMAGEBOX_SET_SPEED( p:dUIImage , id:int , nParam1:int , nParam2:int , nParam3:int , nParam4:int , sParam:String , oParam:Object ):int
		{
			if ( p.GetObjType() == GUIOBJ_TYPE_ANIIMAGEBOX )
			{
				( p as dUIAniImageBox ).SetPlaySpeed( nParam1 );
				return 1;
			}
			else if ( p.GetObjType() == GUIOBJ_TYPE_DRAGICON )
			{
				( p as dUIDragIcon ).SetPlaySpeed( nParam1 );
				return 1;
			}
			return 0;
		}
		//--------------------------------------------------------------------
		public function dUISendMessageS( msgType:int , id:int = 0 , nParam1:int = 0 , nParam2:int = 0 , nParam3:int = 0 , nParam4:int = 0 , sParam:String = "" , oParam:Object = null ):String
		{
			var obj:Object = { str:0 , oParam:oParam };			
			dUISendMessage( msgType , id , nParam1 , nParam2 , nParam3 , nParam4 , sParam , obj );
			return obj.str;
		}
		public function dUISendMessageO( msgType:int , id:int = 0 , nParam1:int = 0 , nParam2:int = 0 , nParam3:int = 0 , nParam4:int = 0 , sParam:String = "" , oParam:Object = null ):Object
		{
			var obj:Object = { ret:0 , oParam:oParam };
			dUISendMessage( msgType , id , nParam1 , nParam2 , nParam3 , nParam4 , sParam , obj );
			return obj.ret;
		}
		public function dUILoadTemplate( idFather:int , TabIndex:int , idOffset:int , data:String , idList:Vector.<int> = null , bAsync:Boolean = false , onLoadComplete:Function = null , strPageFileName:String = null ):int
		{
			m_root.m_bLoadingPage++;
			var pFather:dUIImage;
			pFather = FindFather( idFather , TabIndex );
			if ( !pFather ) return -1;
			var ret:int = LoadTemplateFromString( pFather , 0 , 0 , TabIndex , idOffset , data , idList , bAsync , onLoadComplete , strPageFileName );
			if ( idFather == -1 ) m_root.CheckTopWindow();
			m_root.m_bLoadingPage--;
			return ret;
		}
		public function dUILoadTemplateFromBin( idFather:int , TabIndex:int , idOffset:int , data:dByteArray , idList:Vector.<int> = null , bAsync:Boolean = false , onLoadComplete:Function = null , strPageFileName:String = null ):int
		{
			data.SetPosition( 0 );
			m_root.m_bLoadingPage++;
			var pFather:dUIImage;
			pFather = FindFather( idFather , TabIndex );
			if ( !pFather ) return -1;
			var magic:int = data.ReadInt();
			data.SetPosition( data.GetPosition() - 4 );
			if ( magic == dStringUtils.FourCC( "D" , "U" , "I" , "B" ) )
				var ret:int = LoadTemplateFromBin( pFather , 0 , 0 , TabIndex , idOffset , data , idList , bAsync , onLoadComplete , strPageFileName );
			else
				ret = LoadTemplateFromString( pFather , 0 , 0 , TabIndex , idOffset , data.ToStringBuffer() , idList , bAsync , onLoadComplete , strPageFileName );
			if ( idFather == -1 ) m_root.CheckTopWindow();
			m_root.m_bLoadingPage--;
			return ret;
		}
		public function dUIFindDlgItem( nPageID:int , name:String ):int
		{
			if ( m_mapControlNameToID[nPageID] == null ) return 0;
			return m_mapControlNameToID[nPageID][name];
		}
		public function dUIGetChildListID( nPageID:int ):Vector.<int>
		{
			var pFather:dUIImage;
			if ( nPageID == 0 ) pFather = m_root.GetClient();
			else if ( nPageID == -1 ) pFather = m_root.GetTopWindow();
			else if ( nPageID > 0 ) pFather = m_arrImage[ nPageID ];
			else if ( nPageID > 0 ) pFather = m_arrImage[ nPageID ];
			if ( pFather )
			{
				var ret:Vector.<int> = new Vector.<int>;
				var list:Vector.<dUIImage> = pFather.GetChild();
				for ( var i:int = 0 , n:int = list.length ; i < n ; i ++ )
				{
					if ( list[i].GetID() ) ret.push( list[i].GetID() );
				}
				return ret;
			}
			return new Vector.<int>;
		}
		public function SetUIEventFunction( fun:Function ):void
		{
			m_root.GetConfig().onUIEventCallback = fun;
		}
		protected function CallEvent( event:dUIEvent ):Boolean
		{
			if ( m_arrEventListener[ event.id ] )
			{
				var p:Array = m_arrEventListener[ event.id ];
				if ( p[ -1 ] )
				{
					p[ -1 ]( event );
					return true;
				}
				else if ( p[ event.type ] )
				{
					p[ event.type ]( event );
					if ( event.type == dUISystem.GUIEVENT_TYPE_MESSAGE_BOX_SELECTED )
						p[ event.type ] = null;
					return true;
				}
			}
			return false;
		}
		public function OnUIEvent( event:dUIEvent ):void
		{
			if ( !CallEvent( event ) )
			{
				if ( m_root.GetConfig().onUIEventCallback != null )
					m_root.GetConfig().onUIEventCallback( event.id , event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
			}
		}
		public function SetCustomLoadImageFunction( pFunction:Function ):void
		{
			m_root.SetCustomLoadImageFunction( pFunction );
		}
		public function Id2dUI( id:int ):dUIObj
		{
			if ( m_arrImage[ id ] == null ) return null;
			var ret:dUIObj = new dUIObj( id , this );
			return ret;
		}
		//////////////////////////////////////////////////////////////////////////////////////
		// public function
		public function LoadFromImageSet( id:int , strName:String ):int
		{
			return dUISendMessage( C_LOAD_FROM_IMAGESET , id , 0 , 0 , 0 , 0 , strName );
		}
		public function GetImageSetName( id:int ):String
		{
			return dUISendMessageS( C_GET_IMAGE_SET_NAME , id );
		}
		public function SetShow( id:int , bShow:int ):int
		{
			return dUISendMessage( C_SET_SHOW , id , bShow );
		}
		public function isShow( id:int ):int
		{
			return dUISendMessage( C_GET_SHOW , id );
		}
		public function SetSize( id:int , w:int , h:int ):int
		{
			if ( id == 0 )
			{
				m_root.SetSize( w , h );
				m_root._ReleaseComboBox();
				for each( var pImage:dUIImage in m_arrImage )
				{
					if ( pImage && 
						 ( pImage.GetObjType() == dUISystem.GUIOBJ_TYPE_WINDOW || pImage.GetObjType() == dUISystem.GUIOBJ_TYPE_MESSAGEBOX ) &&
						 ( pImage.GetFather() == m_root.GetClient() || pImage.GetFather() == m_root.GetPageTop() || pImage.GetFather() == m_root.GetPageDark() ) &&
						 pImage.isStyleData( "CanDrag" ) )
					{
						var x:int = pImage.GetPosX();
						var y:int = pImage.GetPosY();
						var pw:int = pImage.GetWidth();
						var ph:int = pImage.GetHeight();
						var obj:Object = { x:x , y:y };
						m_root.GetConfig().OnImageDragOutsideWindow( obj , pw , ph , w , h );
						if ( x != obj.x || y != obj.y )
							pImage.SetPos( obj.x , obj.y );
					}
				}
				return 1;
			}
			return dUISendMessage( C_SET_SIZE , id , w , h );
		}
		public function GetObj( id:int ):dUIObj
		{
			if ( m_arrImage[ id ] )
			{
				return new dUIObj( id , this );
			}
			return null;
		}
		public function SetConfig( pConfig:dUIConfig ):void
		{
			m_root.SetConfig( pConfig );
		}
		public function GetConfig():dUIConfig
		{
			return m_root.GetConfig();
		}
		public function get scaleX():Number
		{
			return m_root.m_pBaseObject.scaleX;
		}
		public function get scaleY():Number
		{
			return m_root.m_pBaseObject.scaleY;
		}
		public function set scaleX( n:Number ):void
		{
			m_root.m_pBaseObject.scaleX = n;
		}
		public function set scaleY( n:Number ):void
		{
			m_root.m_pBaseObject.scaleY = n;
		}
		public function CreateWindow(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_WINDOW , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateButton(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_BUTTON , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateImageButton(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_IMAGEBUTTON , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateEditBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_EDITBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateSuperText(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_SUPPERTEXT , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateImageBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_IMAGEBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateDragIcon(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_DRAGICON , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateListBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_LISTBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateProgress(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_PROGRESS , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateTabControl(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_TABCONTROL , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateGroup(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_GROUP , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateCheckBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_CHECKBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateRadioBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_RADIOBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateTree(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_TREE , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateScroll(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_SCROLL , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateSlider(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_SLIDER , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateMenu(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_MENU , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateSpliter(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_SPLITER , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateAniImageBox(nFatherID:int, nTab:int):int
		{
			return dUISendMessage( CREATE_ANIIMAGEBOX , nFatherID , 0 , 0 , 0 , nTab , "" , null );
		}
		public function CreateRightMenu(strText:String, x:int, y:int):int
		{
			return dUISendMessage( CREATE_RIGHT_MENU , 0 , x , y , 0 , 0 , strText , null );
		}
		public function CreateMessageBox(nFatherID:int, strText:String):int
		{
			return CreateMessageBoxEx( nFatherID , strText , 0 , 0 , 0 , 0 );
		}
		public function CreateMessageBoxEx(nFatherID:int, strText:String, x:int, y:int, nTimeRemain:int, nTab:int):int
		{
			return dUISendMessage( CREATE_MESSAGEBOX , nFatherID , x , y , nTimeRemain , nTab , strText , null );
		}
		public function GetWidth(id:int):int
		{
			if( id == 0 ) return m_root.GetWidth();
			return dUISendMessage( C_GET_WIDTH , id );
		}
		public function GetHeight(id:int):int
		{
			if( id == 0 ) return m_root.GetHeight();
			return dUISendMessage( C_GET_HEIGHT , id );
		}
		public function SetPos(id:int, x:int, y:int):int
		{
			return dUISendMessage( C_SET_POS , id , x , y , 0 , 0 , "" , null );
		}
		public function GetPosX(id:int):int
		{
			return dUISendMessage( C_GET_POSX , id );
		}
		public function GetPosY(id:int):int
		{
			return dUISendMessage( C_GET_POSY , id );
		}
		public function SetRotation(id:int, angle:int, bMirrorX:int, bMirrorY:int):int
		{
			return dUISendMessage( C_SET_ROTATION , id , angle , bMirrorX , bMirrorY , 0 , "" , null );
		}
		public function GetRotation(id:int):int
		{
			return dUISendMessage( C_GET_ROTATION , id );
		}
		public function isRotationMirrorX(id:int):int
		{
			return dUISendMessage( C_GET_ROTATION_MIRRORX , id );
		}
		public function isRotationMirrorY(id:int):int
		{
			return dUISendMessage( C_GET_ROTATION_MIRRORY , id );
		}
		public function SetHandleMouse(id:int, bHandle:int):int
		{
			return dUISendMessage( C_SET_HANDLE_MOUSE , id , bHandle , 0 , 0 , 0 , "" , null );
		}
		public function isHandleMouse(id:int):int
		{
			return dUISendMessage( C_IS_HANDLE_MOUSE , id );
		}
		public function SetText(id:int, str:String):int
		{
			return dUISendMessage( C_SET_TEXT , id , 0 , 0 , 0 , 0 , str , null );
		}
		public function GetText(id:int):String
		{
			return dUISendMessageS( C_GET_TEXT , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function GetTextWithoutSign(id:int):String
		{
			return dUISendMessageS( C_GET_TEXT_WITHOUT_SIGN , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function SetStyle(id:int, name:String, bSet:int):int
		{
			return dUISendMessage( C_SET_STYLE , id , bSet , 0 , 0 , 0 , name , null );
		}
		public function GetStyle(id:int, name:String):int
		{
			return dUISendMessage( C_GET_STYLE , id , 0 , 0 , 0 , 0 , name , null );
		}
		public function SetToCenter(id:int, xType:int = dUISystem.GUI_AUTOPOS_CENTER, yType:int = dUISystem.GUI_AUTOPOS_CENTER):int
		{
			return dUISendMessage( C_SET_TO_CENTER , id , xType , yType , 0 , 0 , "" , null );
		}
		public function SetAutoPos(id:int, xType:int, yType:int):int
		{
			return dUISendMessage( C_SET_AUTO_POS , id , xType , yType , 0 , 0 , "" , null );
		}
		public function SetAutoPosPannel(id:int, bSet:int):int
		{
			return dUISendMessage( C_SET_AUTO_POS_PANNEL , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function SetAutoBringTopPannel(id:int, bSet:int):int
		{
			return dUISendMessage( C_SET_AUTO_BRING_TOP_PANNEL , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function SetMargin(id:int, type:int, value:int):int
		{
			return dUISendMessage( C_SET_MARGIN , id , type , value , 0 , 0 , "" , null );
		}
		public function SetID(id:int, newID:int):int
		{
			return dUISendMessage( C_SET_ID , id , newID , 0 , 0 , 0 , "" , null );
		}
		public function SetControlName(id:int, name:String):int
		{
			return dUISendMessage( C_SET_CONTROL_NAME , id , 0 , 0 , 0 , 0 , name , null );
		}
		public function GetControlName(id:int):String
		{
			return dUISendMessageS( C_GET_CONTROL_NAME , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function GetMouseX(id:int = 0):int
		{
			if( id == 0 ) return m_root.GetMouseX();
			return dUISendMessage( C_GET_MOUSEX , id );
		}
		public function GetMouseY(id:int = 0):int
		{
			if( id == 0 ) return m_root.GetMouseY();
			return dUISendMessage( C_GET_MOUSEY , id );
		}
		public function EnableWindow(id:int, bEnable:int):int
		{
			return dUISendMessage( C_ENABLE_WINDOW , id , bEnable , 0 , 0 , 0 , "" , null );
		}
		public function isWindowEnable(id:int):int
		{
			return dUISendMessage( C_IS_WINDOW_ENABLE , id );
		}
		public function SetFocus(id:int, bActive:int):int
		{
			return dUISendMessage( C_SET_FOCUS , id , bActive , 0 , 0 , 0 , "" , null );
		}
		public function GetFocus(id:int):int
		{
			return dUISendMessage( C_GET_FOCUS , id );
		}
		public function GetAutoPosX(id:int):int
		{
			return dUISendMessage( C_GET_AUTO_POSX , id );
		}
		public function GetAutoPosY(id:int):int
		{
			return dUISendMessage( C_GET_AUTO_POSY , id );
		}
		public function SetAlpha(id:int, alpha:int):int
		{
			return dUISendMessage( C_SET_ALPHA , id , alpha , 0 , 0 , 0 , "" , null );
		}
		public function GetAlpha(id:int):int
		{
			return dUISendMessage( C_GET_ALPHA , id );
		}
		public function SetGray(id:int, bGray:int):int
		{
			return dUISendMessage( C_SET_GRAY , id , bGray , 0 , 0 , 0 , "" , null );
		}
		public function SetAutoSizeAsFather(id:int, bSet:int):int
		{
			return dUISendMessage( C_SET_AUTO_SIZE_AS_FATHER , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function GetAutoSizeAsFather(id:int):int
		{
			return dUISendMessage( C_GET_AUTO_SIZE_AS_FATHER , id );
		}
		public function SetAutoSizeAsChild(id:int, bSet:int):int
		{
			return dUISendMessage( C_SET_AUTO_SIZE_AS_CHILD , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function GetAutoSizeAsChild(id:int):int
		{
			return dUISendMessage( C_GET_AUTO_SIZE_AS_CHILD , id );
		}
		public function GetWorldPosX(id:int):int
		{
			return dUISendMessage( C_GET_POSX_WORLD , id );
		}
		public function GetWorldPosY(id:int):int
		{
			return dUISendMessage( C_GET_POSY_WORLD , id );
		}
		public function AddDisplayObj(id:int, obj:Object):int
		{
			return dUISendMessage( C_ADD_DISPLAY_OBJ , id , 0 , 0 , 0 , 0 , "" , obj );
		}
		public function RemoveDisplayObj(id:int, obj:Object):int
		{
			return dUISendMessage( C_REMOVE_DISPLAY_OBJ , id , 0 , 0 , 0 , 0 , "" , obj );
		}
		public function GetFatherID(id:int):int
		{
			return dUISendMessage( C_GET_FATHER_ID , id );
		}
		public function BringToTop(id:int):int
		{
			return dUISendMessage( C_BRING_TO_TOP , id );
		}
		public function BringToBottom(id:int):int
		{
			return dUISendMessage( C_BRING_TO_BOTTOM , id );
		}
		public function FlashWindow(id:int):int
		{
			return FlashWindowEx( id , 0 , 100 , 0 );
		}
		public function FlashWindowEx(id:int, nTimes:int, nSpeed:int, nTabIndex:int):int
		{
			return dUISendMessage( C_FLASH_WINDOW , id , nTimes , nSpeed , nTabIndex , 0 , "" , null );
		}
		public function FlashWindowDisable(id:int):int
		{
			return dUISendMessage( C_FLASH_WINDOW_DISABLE , id );
		}
		public function GetObjType(id:int):int
		{
			return dUISendMessage( C_GET_OBJ_TYPE , id );
		}
		public function SetUserData(id:int, data:Object):int
		{
			return SetUserDataEx( id , data , 0 , 0 , "" );
		}
		public function SetUserDataEx(id:int, data:Object, nListTab:int, nListLine:int, strTreeObj:String):int
		{
			return dUISendMessage( C_SET_USER_DATA , id , nListLine , nListTab , 0 , 0 , strTreeObj , data );
		}
		public function GetUserData(id:int):Object
		{
			return GetUserDataEx( id , 0 , 0 , "" );
		}
		public function GetUserDataEx(id:int, nListTab:int, nListLine:int, strTreeObj:String):Object
		{
			return dUISendMessageO( C_GET_USER_DATA , id , nListLine , nListTab , 0 , 0 , strTreeObj , null );
		}
		public function SetTooltip(id:int, str:String):int
		{
			return dUISendMessage( C_SET_TOOLTIP , id , 0 , 0 , 0 , 0 , str , null );
		}
		public function GetTooltip(id:int):String
		{
			return dUISendMessageS( C_GET_TOOLTIP , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function SetAlign(id:int, type:int):int
		{
			return dUISendMessage( C_SET_ALIGN , id , type , 0 , 0 , 0 , "" , null );
		}
		public function GetAlign(id:int):int
		{
			return dUISendMessage( C_GET_ALPHA , id );
		}
		public function RegMouseFading(id:int, bReg:int):int
		{
			return dUISendMessage( C_REG_MOUSE_FADING , id , bReg , 0 , 0 , 0 , "" , null );
		}
		public function isRegMouseFading(id:int):int
		{
			return dUISendMessage( C_IS_REG_MOUSE_FADING , id );
		}
		public function GetClientWidth(id:int):int
		{
			return dUISendMessage( C_GET_CLIENT_WIDTH , id );
		}
		public function GetClientHeight(id:int):int
		{
			return dUISendMessage( C_GET_CLIENT_HEIGHT , id );
		}
		public function SetColorTransform(id:int, nColorBrightness:int, nColorContrast:int, nColorSaturation:int, nColorHue:int):int
		{
			return dUISendMessage( C_SET_COLOR_TRANSFORM , id , nColorBrightness , nColorContrast , nColorSaturation , nColorHue , "" , null );
		}
		public function SetMouseStyle(id:int, style:int):int
		{
			return dUISendMessage( C_SET_MOUSE_STYLE , id , style , 0 , 0 , 0 , "" , null );
		}
		public function GetMouseStyle(id:int):int
		{
			return dUISendMessage( C_GET_MOUSE_STYLE , id );
		}
		public function isMouseIn(id:int):int
		{
			return dUISendMessage( C_IS_MOUSE_IN , id );
		}
		public function SetEdgeRect(id:int, left:int, top:int, right:int, bottom:int):int
		{
			return dUISendMessage( C_SET_EDGE_RECT , id , left , top , right , bottom , "" , null );
		}
		public function AddSprite(id:int, pSprite:dSprite):int
		{
			return dUISendMessage( C_ADD_SPRITE , id , 0 , 0 , 0 , 0 , "" , pSprite );
		}
		public function RemoveSprite(id:int, pSprite:dSprite):int
		{
			return dUISendMessage( C_REMOVE_SPRITE , id , 0 , 0 , 0 , 0 , "" , pSprite );
		}
		public function Button_SetPushDown(id:int, bSet:int):int
		{
			return dUISendMessage( BUTTON_SET_PUSH_DOWN , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function Button_GetPushDown(id:int):int
		{
			return dUISendMessage( id , BUTTON_GET_PUSH_DOWN );
		}
		public function Button_SetSelImageFromImageset(id:int, strImageSetName:String):int
		{
			return dUISendMessage( BUTTON_SET_SEL_IMAGE_FROM_IMAGESET , id , 0 , 0 , 0 , 0 , strImageSetName , null );
		}
		public function Text_SetLimitTextLength(id:int, length:int):int
		{
			return dUISendMessage( TEXT_SET_LIMIT_TEXT_LENGTH , id , length , 0 , 0 , 0 , "" , null );
		}
		public function Text_GetLimitTextLength(id:int):int
		{
			return dUISendMessage( TEXT_GET_LIMIT_TEXT_LENGTH , id );
		}
		public function Text_SetLimitNumber(id:int, num:int):int
		{
			return dUISendMessage( TEXT_SET_LIMIT_NUMBER , id , num , 0 , 0 , 0 , "" , null );
		}
		public function Text_GetLimitNumber(id:int):int
		{
			return dUISendMessage( TEXT_GET_LIMIT_NUMBER , id );
		}
		public function Text_SetLimitNumberMin(id:int, num:int):int
		{
			return dUISendMessage( TEXT_SET_LIMIT_NUMBER_MIN , id , num , 0 , 0 , 0 , "" , null );
		}
		public function Text_GetLimitNumberMin(id:int):int
		{
			return dUISendMessage( TEXT_GET_LIMIT_NUMBER_MIN , id );
		}
		public function Text_SetSelection(id:int, begin:int, end:int):int
		{
			return dUISendMessage( TEXT_SET_SELECTION , id , begin , end , 0 , 0 , "" , null );
		}
		public function Text_GetSelectionBegin(id:int):int
		{
			return dUISendMessage( TEXT_GET_SELECTION_BEGIN , id );
		}
		public function Text_GetSelectionEnd(id:int):int
		{
			return dUISendMessage( TEXT_GET_SELECTION_END , id );
		}
		public function Text_InsertString(id:int, strText:String, nIndex:int):int
		{
			return dUISendMessage( TEXT_INSERT_STRING , id , nIndex , 0 , 0 , 0 , strText , null );
		}
		public function EditBox_SetComboBoxString(id:int, strText:String, nLimitHeight:int):int
		{
			return dUISendMessage( EDITBOX_SET_COMBOBOX_STRING , id , nLimitHeight , 0 , 0 , 0 , strText , null );
		}
		public function EditBox_GetComboBoxString(id:int):String
		{
			return dUISendMessageS( EDITBOX_GET_COMBOBOX_STRING , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function EditBox_SetComboBoxShow(id:int, bShow:int):int
		{
			return dUISendMessage( EDITBOX_SET_COMBOBOX_SHOW , id , bShow , 0 , 0 , 0 , "" , null );
		}
		public function EditBox_GetComboBoxShow(id:int):int
		{
			return dUISendMessage( EDITBOX_GET_COMBOBOX_SHOW , id );
		}
		public function Icon_SwapStatus(id:int, other_icon_id:int):int
		{
			return dUISendMessage( ICON_SWAP_STATUS , id , other_icon_id , 0 , 0 , 0 , "" , null );
		}
		public function Icon_CopyStatus(id:int, other_icon_id:int):int
		{
			return dUISendMessage( ICON_COPY_STATUS , id , other_icon_id , 0 , 0 , 0 , "" , null );
		}
		public function Icon_ClearStatus(id:int):int
		{
			return dUISendMessage( ICON_CLEAR_STATUS , id );
		}
		public function Icon_SetCoolTime(id:int, nCurTime:int):int
		{
			return dUISendMessage( ICON_SET_COOL_TIME , id , nCurTime , 0 , 0 , 0 , "" , null );
		}
		public function Icon_GetCoolTime(id:int):int
		{
			return dUISendMessage( ICON_GET_COOL_TIME , id );
		}
		public function Icon_SetMaxTime(id:int, max:int):int
		{
			return dUISendMessage( ICON_SET_MAX_TIME , id , max , 0 , 0 , 0 , "" , null );
		}
		public function Icon_GetMaxTime(id:int):int
		{
			return dUISendMessage( ICON_GET_MAX_TIME , id );
		}
		public function Icon_SetPicName(id:int, strName:String):int
		{
			return dUISendMessage( ICON_SET_PIC_NAME , id , 0 , 0 , 0 , 0 , strName , null );
		}
		public function Icon_SetAniName(id:int, strName:String):int
		{
			return dUISendMessage( ICON_SET_ANI_NAME , id , 0 , 0 , 0 , 0 , strName , null );
		}
		public function Icon_SetCoolImageName(id:int, strName:String):int
		{
			return dUISendMessage( ICON_SET_COOL_IMAGE_NAME , id , 0 , 0 , 0 , 0 , strName , null );
		}
		public function Icon_GetCoolImageName(id:int):String
		{
			return dUISendMessageS( ICON_GET_COOL_IMAGE_NAME , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function Icon_SetAniColorTransform(id:int, nColorBrightness:int, nColorContrast:int, nColorSaturation:int, nColorHue:int):int
		{
			return dUISendMessage( ICON_SET_ANI_COLOR_TRANSFORM , id , nColorBrightness , nColorContrast , nColorSaturation , nColorHue , "" , null );
		}
		public function ListBox_AddString(id:int, nLine:int, nTab:int, strText:String):int
		{
			return dUISendMessage( LB_ADD_STRING , id , nLine , nTab , 0 , 0 , strText , null );
		}
		public function ListBox_InsertString(id:int, nLine:int, nTab:int, strText:String):int
		{
			return dUISendMessage( LB_INSERT_STRING , id , nLine , nTab , 0 , 0 , strText , null );
		}
		public function ListBox_GetString(id:int, nLine:int, nTab:int):String
		{
			return dUISendMessageS( LB_GET_STRING , id , nLine , nTab , 0 , 0 , "" , null );
		}
		public function ListBox_DeleteList(id:int, nLine:int):int
		{
			return dUISendMessage( LB_DELETE_LIST , id , nLine , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_DeleteListObj(id:int, nLine:int, nTab:int):int
		{
			return dUISendMessage( LB_DELETE_LIST_OBJ , id , nLine , nTab , 0 , 0 , "" , null );
		}
		public function ListBox_ClearList(id:int):int
		{
			return dUISendMessage( LB_CLEAR_LIST , id );
		}
		public function ListBox_GetListCount(id:int):int
		{
			return dUISendMessage( LB_GET_LIST_COUNT , id );
		}
		public function ListBox_SetListCount(id:int, nLineNum:int):int
		{
			return dUISendMessage( LB_SET_LIST_COUNT , id , nLineNum , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_SetTabCount(id:int, nTabCount:int):int
		{
			return dUISendMessage( LB_SET_TAB_COUNT , id , nTabCount , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_GetTabCount(id:int):int
		{
			return dUISendMessage( LB_GET_TAB_COUNT , id );
		}
		public function ListBox_SetTabWidth(id:int, nTab:int, nWidth:int):int
		{
			return dUISendMessage( LB_SET_TAB_WIDTH , id , nTab , nWidth , 0 , 0 , "" , null );
		}
		public function ListBox_GetTabWidth(id:int, nTab:int):int
		{
			return dUISendMessage( LB_GET_TAB_WIDTH , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_SetTabName(id:int, nTab:int, strName:String):int
		{
			return dUISendMessage( LB_SET_TAB_NAME , id , nTab , 0 , 0 , 0 , strName , null );
		}
		public function ListBox_GetTabName(id:int, nTab:int):String
		{
			return dUISendMessageS( LB_GET_TAB_NAME , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_SetMaxListNum(id:int, num:int):int
		{
			return dUISendMessage( LB_SET_MAX_LIST_NUM , id , num , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_GetMaxListNum(id:int):int
		{
			return dUISendMessage( LB_GET_MAX_LIST_NUM , id );
		}
		public function ListBox_SetCurSel(id:int, nLine:int, nTab:int):int
		{
			return dUISendMessage( LB_SET_CUR_SEL , id , nLine , nTab , 0 , 0 , "" , null );
		}
		public function ListBox_GetCurSel(id:int):int
		{
			return dUISendMessage( LB_GET_CUR_SEL , id );
		}
		public function ListBox_AddList(id:int, nLine:int, nTab:int, nControlID:int):int
		{
			return dUISendMessage( LB_ADD_LIST , id , nLine , nTab , 0 , nControlID , "" , null );
		}
		public function ListBox_RemoveList(id:int, nLine:int, nTab:int):int
		{
			return dUISendMessage( LB_REMOVE_LIST , id , nLine , nTab , 0 , 0 , "" , null );
		}
		public function ListBox_InsertList(id:int, nLine:int, nTab:int, nControlID:int):int
		{
			return dUISendMessage( LB_INSERT_LIST , id , nLine , nTab , 0 , nControlID , "" , null );
		}
		public function ListBox_GetList(id:int, nLine:int, nTab:int):int
		{
			return dUISendMessage( LB_GET_LIST , id , nLine , nTab , 0 , 0 , "" , null );
		}
		public function ListBox_SetTabCanSort(id:int, nTab:int, bCanSort:int):int
		{
			return dUISendMessage( LB_SET_TAB_CAN_SORT , id , nTab , bCanSort , 0 , 0 , "" , null );
		}
		public function ListBox_GetTabCanSort(id:int, nTab:int):int
		{
			return dUISendMessage( LB_GET_TAB_CAN_SORT , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_SortTab(id:int, nTab:int, bSmallToBig:int):int
		{
			return dUISendMessage( LB_SORT_TAB , id , nTab , bSmallToBig , 0 , 0 , "" , null );
		}
		public function ListBox_SetForcePerLineHeight(id:int, nHeight:int):int
		{
			return dUISendMessage( LB_SET_FORCE_PER_LINE_HEIGHT , id , nHeight , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_GetForcePerLineHeight(id:int):int
		{
			return dUISendMessage( LB_GET_FORCE_PER_LINE_HEIGHT , id );
		}
		public function ListBox_SetPerLineSpace(id:int, nHeight:int):int
		{
			return dUISendMessage( LB_SET_PER_LINE_SPACE , id , nHeight , 0 , 0 , 0 , "" , null );
		}
		public function ListBox_GetPerLineSpace(id:int):int
		{
			return dUISendMessage( LB_GET_PER_LINE_SPACE , id );
		}
		public function Progress_SetMaxValue(id:int, max:int):int
		{
			return dUISendMessage( PROGRESS_SET_MAX_VALUE , id , max , 0 , 0 , 0 , "" , null );
		}
		public function Progress_GetMaxValue(id:int):int
		{
			return dUISendMessage( PROGRESS_GET_MAX_VALUE , id );
		}
		public function Progress_SetMinValue(id:int, min:int):int
		{
			return dUISendMessage( PROGRESS_SET_MIN_VALUE , id , min , 0 , 0 , 0 , "" , null );
		}
		public function Progress_GetMinValue(id:int):int
		{
			return dUISendMessage( PROGRESS_GET_MIN_VALUE , id );
		}
		public function Progress_SetValue(id:int, num:int):int
		{
			return dUISendMessage( PROGRESS_SET_VALUE , id , num , 0 , 0 , 0 , "" , null );
		}
		public function Progress_GetValue(id:int):int
		{
			return dUISendMessage( PROGRESS_GET_VALUE , id );
		}
		public function Progress_BeginAdd(id:int, nTime:int):int
		{
			return dUISendMessage( PROGRESS_BEGIN_ADD , id , nTime , 0 , 0 , 0 , "" , null );
		}
		public function Progress_Stop(id:int):int
		{
			return dUISendMessage( PROGRESS_STOP , id );
		}
		public function Tab_SetTabNum(id:int, num:int):int
		{
			return dUISendMessage( TB_SET_TAB_NUM , id , num , 0 , 0 , 0 , "" , null );
		}
		public function Tab_GetTabNum(id:int):int
		{
			return dUISendMessage( TB_GET_TAB_NUM , id );
		}
		public function Tab_SetTabName(id:int, nTab:int, name:String):int
		{
			return dUISendMessage( TB_SET_TAB_NAME , id , nTab , 0 , 0 , 0 , name , null );
		}
		public function Tab_GetTabName(id:int, nTab:int):String
		{
			return dUISendMessageS( TB_GET_TAB_NAME , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function Tab_SetCurSel(id:int, nTab:int):int
		{
			return dUISendMessage( TB_SET_SELECT_TAB , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function Tab_GetCurSel(id:int):int
		{
			return dUISendMessage( TB_GET_SELECT_TAB , id );
		}
		public function Tab_SetTabShow(id:int, nTab:int, bShow:int):int
		{
			return dUISendMessage( TB_SET_TAB_SHOW , id , nTab , bShow , 0 , 0 , "" , null );
		}
		public function Tab_GetTabShow(id:int, nTab:int):int
		{
			return dUISendMessage( TB_GET_TAB_SHOW , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function Tab_EnableTab(id:int, nTab:int, bEnable:int):int
		{
			return dUISendMessage( TB_ENABLE_TAB , id , nTab , bEnable , 0 , 0 , "" , null );
		}
		public function Tab_IsTabEnable(id:int, nTab:int):int
		{
			return dUISendMessage( TB_IS_TAB_ENABLE , id , nTab , 0 , 0 , 0 , "" , null );
		}
		public function Tab_GetTabBoundingRect(id:int, nTab:int):dRect
		{
			return (dUISendMessageO( TB_GET_TAB_BOUNDING_RECT , id , nTab , 0 , 0 , 0 , "" , null ) as dRect);
		}
		public function CheckBox_SetCheck(id:int, bSet:int):int
		{
			return dUISendMessage( CHECKBOX_SET_CHECK , id , bSet , 0 , 0 , 0 , "" , null );
		}
		public function CheckBox_GetCheck(id:int):int
		{
			return dUISendMessage( CHECKBOX_GET_CHECK , id );
		}
		public function Tree_Expand(id:int, strTreeNode:String, bExpand:int):int
		{
			return dUISendMessage( TREE_EXPAND , id , bExpand , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_IsExpand(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_IS_EXPAND , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_ExpandAll(id:int, bExpand:int):int
		{
			return dUISendMessage( TREE_EXPAND_ALL , id , bExpand , 0 , 0 , 0 , "" , null );
		}
		public function Tree_AddObj(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_ADD_OBJ , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_AddObjAt(id:int, strTreeNode:String, at:int):int
		{
			return dUISendMessage( TREE_ADD_OBJ_TO_FIRST , id , at , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_DelObj(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_DEL_OBJ , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_Clear(id:int):int
		{
			return dUISendMessage( TREE_CLEAR_OBJ , id );
		}
		public function Tree_SetCurSel(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_SET_CUR_SEL , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_GetCurSel(id:int):String
		{
			return dUISendMessageS( TREE_GET_CUR_SEL , id , 0 , 0 , 0 , 0 , "" , null );
		}
		public function Tree_GetAll(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_GET_ALL , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function TreeClearCurSel(id:int):int
		{
			return dUISendMessage( TREE_CLEAR_CUR_SEL , id );
		}
		public function Tree_ClearChild(id:int, strTreeNode:String):int
		{
			return dUISendMessage( TREE_CLEAR_CHILD , id , 0 , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_FindObjByUserData(id:int, pUserData:Object):String
		{
			return dUISendMessageS( TREE_FIND_OBJ_BY_USER_DATA , id , 0 , 0 , 0 , 0 , "" , pUserData );
		}
		public function Tree_ForceShowExpandButton(id:int, strTreeNode:String, bShow:int):int
		{
			return dUISendMessage( TREE_FORCE_SHOW_EXPAND_BUTTON , id , bShow , 0 , 0 , 0 , strTreeNode , null );
		}
		public function Tree_SetChildStepOffsetX(id:int, nWidth:int):int
		{
			return dUISendMessage( TREE_SET_CHILD_STEP_OFFSET_X , id , nWidth , 0 , 0 , 0 , "" , null );
		}
		public function Tree_GetChildTextBoundingRect(id:int, strTreeNode:String, nTextIndex:int):dRect
		{
			return (dUISendMessageO( TREE_GET_CHILD_TEXT_BOUNDING_RECT , id , nTextIndex , 0 , 0 , 0 , strTreeNode , null ) as dRect);
		}
		public function Menu_Add(id:int, strMenuText:String):int
		{
			return dUISendMessage( MENU_ADD , id , 0 , 0 , 0 , 0 , strMenuText , null );
		}
		public function Menu_Replace(id:int, strMenuText:String):int
		{
			return dUISendMessage( MENU_REPLACE , id , 0 , 0 , 0 , 0 , strMenuText , null );
		}
		public function Menu_Del(id:int, strMenuText:String):int
		{
			return dUISendMessage( MENU_DEL , id , 0 , 0 , 0 , 0 , strMenuText , null );
		}
		public function Spliter_SetValueH(id:int, v:int):int
		{
			return dUISendMessage( SPLITER_SET_VALUE_H , id , v , 0 , 0 , 0 , "" , null );
		}
		public function Spliter_SetValueV(id:int, v:int):int
		{
			return dUISendMessage( SPLITER_SET_VALUE_V , id , v , 0 , 0 , 0 , "" , null );
		}
		public function Spliter_SetStaticScrollType(id:int, type:int):int
		{
			return dUISendMessage( SPLITER_SET_STATIC_SCROLL_TYPE , id , type , 0 , 0 , 0 , "" , null );
		}
		public function Spliter_GetStatic_ScrollType(id:int):int
		{
			return dUISendMessage( SPLITER_GET_STATIC_SCROLL_TYPE , id );
		}
		public function Scroll_SetClientSize(id:int, nWidth:int, nHeight:int):int
		{
			return dUISendMessage( SCROLL_SET_CLIENT_SIZE , id , nWidth , nHeight , 0 , 0 , "" , null );
		}
		public function Scroll_SetClientPos(id:int, x:int, y:int):int
		{
			return dUISendMessage( SCROLL_SET_CLIENT_POS , id , x , y , 0 , 0 , "" , null );
		}
		public function Scroll_GetClientPosX(id:int):int
		{
			return dUISendMessage( SCROLL_GET_CLIENT_POSX , id );
		}
		public function Scroll_GetClientPosY(id:int):int
		{
			return dUISendMessage( SCROLL_GET_CLIENT_POSY , id );
		}
		public function Scroll_ScrollToTop(id:int):int
		{
			return dUISendMessage( SCROLL_SCROLL_TO_TOP , id );
		}
		public function Scroll_ScrollToBottom(id:int):int
		{
			return dUISendMessage( SCROLL_SCROLL_TO_BOTTOM , id );
		}
		public function ImageBox_FillColor(id:int, nColorARGB:int):int
		{
			return dUISendMessage( IMAGE_BOX_FILL_COLOR , id , nColorARGB , 0 , 0 , 0 , "" , null );
		}
		public function ImageBox_DrawWindow(id:int, nImageBox:int):int
		{
			return dUISendMessage( IMAGE_BOX_DRAW_WINDOW , id , nImageBox , 0 , 0 , 0 , "" , null );
		}
		public function ImageBox_RegMouseMove(id:int, bReg:int):int
		{
			return dUISendMessage( IMAGE_BOX_REG_MOUSE_MOVE , id , bReg , 0 , 0 , 0 , "" , null );
		}
		public function ImageBox_DrawMaskCircal(id:int):int
		{
			return dUISendMessage( IMAGE_BOX_DRAW_MASK_CIRCAL , id );
		}
		public function Ani_SetMaxFrame(id:int, nMaxFrame:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_SET_MAX_FRAME , id , nMaxFrame , 0 , 0 , 0 , "" , null );
		}
		public function Ani_GetMaxFrame(id:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_GET_MAX_FRAME , id );
		}
		public function Ani_SetCurFrame(id:int, nCurFrame:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_SET_CUR_FRAME , id , nCurFrame , 0 , 0 , 0 , "" , null );
		}
		public function Ani_GetCurFrame(id:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_GET_CUR_FRAME , id );
		}
		public function Ani_Stop(id:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_STOP , id );
		}
		public function Ani_Play(id:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_PLAY , id );
		}
		public function Ani_SetSpeed(id:int, nSpeed:int):int
		{
			return dUISendMessage( ANIIMAGEBOX_SET_SPEED , id , nSpeed , 0 , 0 , 0 , "" , null );
		}
		public function GetMousePassID():int
		{
			if( dUIImage.s_pCapture != null ) return dUIImage.s_pCapture._GetID();
			if( dUIImage.s_pMouseInControl != null ) return dUIImage.s_pMouseInControl._GetID();
			return 0;
		}
		public function GetObjByPos(x:int, y:int):dUIEvent
		{
			var pHit:dUIImage = m_root.GetObjByPos( x , y , 1 );
			if( pHit == null ) return null;
			var ret:dUIEvent = new dUIEvent();
			ret.id = pHit._GetID();
			ret.type = pHit.GetObjType();
			if( ret.type == dUISystem.GUIOBJ_TYPE_TABCONTROL_BUTTON ) ret.nParam1 = ( (pHit as dUITabButton) ).GetTabID() + 1;
			return ret;
		}
		public function SetIconCoolTime(id:int, nItemID:int, time:int):int
		{
			if( id != 0 ) return dUISendMessage( dUISystem.ICON_SET_COOL_TIME , id , time , 0 , 0 , 0 , "" , null );
			return m_root.SetIconCoolTime( nItemID , time );
		}
		public function GetIconCoolTime(id:int, nItemID:int):int
		{
			if( id != 0 ) return dUISendMessage( dUISystem.ICON_GET_COOL_TIME , id );
			return m_root.GetIconCoolTime( nItemID );
		}
		public function EmurateLButtonClick(x:int, y:int):void
		{
			var pImage:dUIImage = m_root.GetObjByPos( x , y , 1 );
			if( pImage != null )
			{
				pImage.OnLButtonDown( x - pImage.GetPosX_World() , y - pImage.GetPosY_World() );
				pImage.OnLButtonUp( x - pImage.GetPosX_World() , y - pImage.GetPosY_World() );
			}
		}
		public function GetUsingResourceName():Array
		{
			return m_root.RootGetUsingResourceName();
		}
		public function GetScaleX(id:int):Number
		{
			return 1.0;
		}
		public function GetScaleY(id:int):Number
		{
			return 1.0;
		}
		public function SetScaleX(id:int, scale:Number):void
		{
		}
		public function SetScaleY(id:int, scale:Number):void
		{
		}
	}
}
