-- dGame3D 导出插件 v2.0
global g_strExePath = ""
function existFile fname =
(
	t = getfiles fname
	t.count != 0
)
function DumpMaterial m file=
(
	--只对Standard类型的材质处理
	--获得diffuse and diffuse map
	ismat=iskindof m material 
	if ismat then
	(
		class_of_mat=classof m
		if (class_of_mat )==Standardmaterial then
		(
			format "MaterialName\n%\n" (m.name) to: file
			format "MaterialType\n%\n" (m.shaderByName) to: file
			format "MaterialAmbientValue\n%\n" (m.ambient) to:file
			format "MaterialDiffuseValue\n%\n" (m.diffuse) to:file
			format "MaterialSpecularValue\n%\n" (m.specular) to:file
			format "MaterialSpecularLevelValue\n%\n" (m.specularLevel) to:file
			format "MaterialGlossinessValue\n%\n" (m.Glossiness) to:file
			format "MaterialSelfIllumColorValue\n%\n" (m.selfIllumColor) to:file
			format "MaterialSelfIllumAmountValue\n%\n" (m.selfIllumAmount) to:file
			if m.diffusemap != undefined then
			(
				format "MaterialDiffuseMapPath\n%\n" (m.diffusemap.filename) to:file
			)
			format "MaterialEnd\n" to:file
		)
	)
)

Function PrepareMaxForSkinOps _pNode = 
( 
	-- Select @_pNode if needed.
	if not _pNode.IsSelected do 
	(
		Select _pNode
	)
)

function ExportObj obj out_file=
(
	--if ClassOf obj == Editable_mesh then
	if Classof obj == BoneGeometry or Classof obj == Bone or Classof obj == Biped_Object then
	(
		format "BONE\n" to:out_file
		format "%\n" obj.name to:out_file
		if obj.parent != undefined then
		(
			format "FATHER\n" to:out_file
			format "%\n" obj.parent.name to:out_file
		)
		
		animate on
		(
			for t = animationRange.start to animationRange.end do
			(
				at time t
				(
					format "FRAME\n" to:out_file
					format "%\n" t to:out_file
					local m = scaleMatrix [-1,1,1] 
					trans = obj.transform * m
					if obj.parent != undefined then
						trans = obj.transform * ( inverse( obj.parent.transform ) );
					pos = trans.pos
					format "% % %\n" pos.x pos.y pos.z to:out_file
					rot = trans.rotation
					format "% % % %\n" rot.x rot.y rot.z rot.w to:out_file
					sca = trans.scale
					format "% % %\n" sca.x sca.y sca.z to:out_file
					row1=trans.row1
					row2=trans.row2
					row3=trans.row3
					row4=trans.row4
					format "% % % 0.0\n" row1[1] row1[2] row1[3] to: out_file
					format "% % % 0.0\n" row2[1] row2[2] row2[3] to: out_file
					format "% % % 0.0\n" row3[1] row3[2] row3[3] to: out_file
					format "% % % 1.0\n" row4[1] row4[2] row4[3] to: out_file
				)
			)
		)
		format "BONE_END\n" to:out_file	
	)
	else if SuperClassOf obj == GeometryClass then
	(
		--******************************************************
		-- material info
		node_material=obj.material
		if node_material != undefined then
		(
			num_sub_material=getNumSubMtls node_material
			DumpMaterial node_material out_file
			for y=1 to num_sub_material do
			(
				sub_mat=getSubMtl node_material y
				DumpMaterial sub_mat out_file
			)
		)
		
		--format "	- Class of: %\n" (classof obj as string) to: out_file
		tmesh = snapshotAsMesh obj

		num_verts = tmesh.numverts 
		num_faces = tmesh.numfaces 

		-- 导出Name
		obj_name = obj.name
		format "MESH\n" to:out_file
		format "%\n" obj_name to:out_file
		
		row1=obj.transform.row1
		row2=obj.transform.row2
		row3=obj.transform.row3
		row4=obj.transform.row4
		format "NodeTM\n" to:out_file
		format "% % % 0.0\n" row1[1] row1[2] row1[3] to: out_file
		format "% % % 0.0\n" row2[1] row2[2] row2[3] to: out_file
		format "% % % 0.0\n" row3[1] row3[2] row3[3] to: out_file
		format "% % % 1.0\n" row4[1] row4[2] row4[3] to: out_file

		-- 导出Vertex
		format "VERTEX\n" to:out_file
		format "%\n" num_verts to:out_file
		for v = 1 to num_verts do
		( 
			vert = getVert tmesh v 
			format "% % %\n" vert[1] vert[2] vert[3] to:out_file
		) 

		-- 导出face
		format "FACE\n" to:out_file
		format "%\n" num_faces to:out_file
		for f = 1 to num_faces do
		( 
			face = getFace tmesh f 
			format "% % %\n" (face[1]-1) (face[2]-1) (face[3]-1) to:out_file
		)

		-- 导出normal
		format "NORMAL\n" to:out_file
		format "%\n" num_verts to:out_file
		for n = 1 to num_verts do
		( 
			normal = getNormal tmesh n 
			format "% % %\n" normal[1] normal[2] normal[3] to:out_file
		)

		-- 导出Color
		--format "COLOR %\n" num_verts to:out_file
		--for v = 1 to num_verts do
		--( 
		--	vert = getVertColor tmesh v 
		--	format "% % %\n" vert[1] vert[2] vert[3] to:out_file
		--) 

		-- 导出uv
		if(getNumTVerts tmesh) != 0 then
		(
			format "UV\n" to:out_file
			format "%\n" (num_faces*3) to:out_file
			for j = 1 to num_faces do
			(
				tri_vertices = getFace tmesh j    -- only index
				tri_uvws     = getTVFace tmesh j
				if tri_uvws != undefined then
				(
					for i = 1 to 3 do
					(
						uv = getTVert tmesh tri_uvws[i]
						format "% %\n" uv[1] uv[2] to:out_file
					)
				)
			)
		)
		-- 导出skin
		--if hasSkinModifier obj == true then
		(
			PrepareMaxForSkinOps obj
			skinMod = obj.modifiers["skin"]
			if skinMod != undefined then
			(
				modPanel.setCurrentObject skinMod
				numSkinVerts = skinOps.getNumberVertices skinMod
				if numSkinVerts > 0 then
				(
					format "SKIN\n" to:out_file
					format "%\n" numSkinVerts to:out_file
					numVerts = skinOps.getNumberVertices skinMod
					for i = 1 to numVerts do
					(
						numBoneAffectVert = skinOps.GetVertexWeightCount skinMod i

						for boneNum = 1 to numBoneAffectVert do
						(
							sysBoneID = skinOps.GetVertexWeightBoneID skinMod i boneNum
							boneName = skinOps.getBoneName skinMod sysBoneID 0
							weight = skinOps.getVertexWeight skinMod i boneNum
							format "\"%\" % " boneName weight to:out_file
						)
						format "\n" to:out_file
					)
				)
			)
		)
		
		-- material id
		materialClass = classof obj.material
		if(materialClass == Standardmaterial) then
		(
			format "FaceMaterial\n" to:out_file
			format "%\n" num_faces to:out_file
			for i = 1 to num_faces do
			(
				matname = obj.material
				format "%\n" matname.name to:out_file
			)
		)
		else if (materialClass != UndefinedClass) then
		(
			format "FaceMaterial\n" to:out_file
			format "%\n" num_faces to:out_file
			for i = 1 to num_faces do
			(
				matid = getFaceMatId tmesh i
				matname = obj.material[matid]
				format "%\n" matname.name to:out_file
			)
		)

		--******************************************************
		--uv info
		channel=meshop.getnummaps tmesh --number of texture
		--format "\n" to: out_file
		--format "Channel Number:%\n" channel to:out_file
		--for i=1 to (channel-1) do
		--(
			
			-- channel的计数从0开始
			--channel 0 is vertex color so do not export it
			--IsSupport=meshop.getMapSupport tmesh i
			--if IsSupport==true then
			--(
			--	if obj.material != undefined then
			--	(
			--		format "Channel ID:%\n" i to:out_file
			--		if classof obj.material.maps[i+1]==Bitmaptexture then
			--			format "Map File Path->%\n" obj.material.maps[i+1].filename to: out_file
			--		else
			--			format "Map File Path->Null\n" to: out_file
			--	)
			--)
		--)
		
		--******************************************************
		--m = tmesh.material
		--if m != undefined then
		--(
		--bm = getSubTexmap m 2
		--if bm == undefined then return undefined

		--format "tex: %\n" bm.filename to:out_file
		--)
		format "MESH_END\n" to:out_file
	)
)
function Export type=
(
	setCommandPanelTaskMode mode:#modify
	if type == 2 and selection.count < 1 then
	(
		Messagebox "未选中任何物体"
		return ()
	)
	--tmesh = snapshotAsMesh selection[1] 
	--convertToMesh $
	--out_name = ((GetDir #defaults)+"\\testmesh.dat")
	if type == 1 or type == 2 then
		out_name = getSaveFileName types:"Data(*.DG3D)|*.DG3D"
	else if type == 3 then
		out_name = getSaveFileName types:"Data(*.DG3K)|*.DG3K"
	if out_name == undefined then return()
	out_name += ".txt"

	out_file = createfile out_name 

	exportArray = #()
	format "ANIMATION\n" to:out_file
	format "% %\n" animationRange.start animationRange.end to:out_file
	if type == 1 or type == 3 then
	(
		for obj in geometry do
		(
			if not obj.ishidden then
				append exportarray obj
		)
	)
	else if type == 2 then
	(
		for obj in selection do
		(
			if not obj.ishidden then
				append exportarray obj
		)
	)
	for obj in exportarray do
	(
		ExportObj obj out_file
	)
	close out_file 
	--cmd = "\""+g_strExePath+"\" "
	param = "|"+(type as string)+"|"+out_name+"|"+maxFilePath
	for i = 0 to param.count do
	(
		if param[i] == " " then
			param[i] = "?"
	)
	cmd = "\""+g_strExePath+"\""
	--MessageBox (cmd+" "+param)
	ShellLaunch cmd param
	--if HiddenDOSCommand == undefined then
	--	DOSCommand (cmd+" "+param)
	--else
	--	HiddenDOSCommand (cmd+" "+param)
	--ShellLaunch g_strExePath "a b c"
	--edit out_name 
	--DeleteFile out_name
)
-- main ---------------------------------------------

rollout RolloutExporter "dGame导出插件" width:140 height:300
(
	--multilistBox LISTBOX_Nodes "Meshes" pos:[8,16] width:144 height:7
	label lbl1 "dGame导出插件 v2.0" pos:[16,20] width:128 height:16

	button BTN_export1 "导出DG3D" pos:[20,41] width:100 height:24
	button BTN_export2 "导出选中DG3D" pos:[20,77] width:100 height:24
	button BTN_export3 "导出DG3K" pos:[20,113] width:100 height:24
	--button BTN_Delete "delete" pos:[86,141] width:64 height:24

	on BTN_export1 pressed do
	(
		Export 1
	)
	on BTN_export2 pressed do
	(
		Export 2
	)
	on BTN_export3 pressed do
	(
		Export 3
	)
)
strPath = ""
if getThisScriptFilename != undefined then
(
strPath = getThisScriptFilename()
--for i = strPath.count to 1 by -1 do
first = 1
for i = strPath.count to 1 by -1 do
(
	if strPath[i] == "\\" then
	(
		strPath = substring strPath 1 i
		exit
	)
)
strPath += "ExportConv.exe"
)
else strPath = "ExportConv.exe"

if not existFile strPath then
	strPath = (GetDir #maxroot) + "\\ExportConv.exe"
if not existFile strPath then
	MessageBox "ExportConv.exe未找到"

g_strExePath = strPath
if existFile strPath then
(
	
	if getThisScriptFilename == undefined then
		g_strExePath = sysinfo.currentdir + "\\ExportConv.exe"

	createDialog RolloutExporter
)
