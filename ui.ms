macroscript POLYNIMATOR
	category: "polyScripts"
(
	CreateDialog polyUI width:240 height:860
)

	-- GLOBAL VARIABLES --------------------------------
							-- BOOL --
		is_global_shell = false
		is_global_outline = false
		is_global_chamfer = false
		is_global_group = false
		is_global_export = false
		
		is_global_detach_done = false
		is_global_reposition_done = false
		is_global_keying_done = false
		is_global_modifyering_done = false
		is_global_process_done = false
							-- NAME --
		global_object_name_export = "poly"
		global_object_color = orange		
							-- DELTA --
		global_adding_height = 50 -- [0, unlimited]
		global_bias = 10 -- radiobutton
		is_global_bias_random = true
		is_global_bias_relative = false
		is_global_bias_fixed = false
		global_bias_min = 1
		global_bias_max = 10
							-- TIME --
		global_time_animation = 3  -- [0.1, unlimited]
		global_end_key = 30*global_time_animation
		--global_diff_koef_frames_pos = 2 -- 2 is middle of frames [2, 5]
							-- MODS --
		global_shell_value = 0.5 -- [0.1, 1]
		global_chamfer_value = 0.1 -- [0.01, global_shell_outer_value/2]
		global_outline_value = -0.1 -- [-1, -0.01]
							-- OBJ FOR FUNCTIONS --
		arGap = #()
		objInit
		----------------------------------------------------

	---------------------[  UI PART  ]-----------------------------

	rollout polyUI "POLYNIMATOR" width:240 height:860
	(
		label 'lbl1' "POLYNIMATOR 1.1" pos:[72,10] width:99 height:26 enabled:false align:#left
		bitmap 'bmp1' "Bitmap" pos:[7,32] width:225 height:162 fileName:"teapot.jpg" bitmap:"teapot.jpg" align:#left
		GroupBox 'grp1' "--- Export Object Params ----------------------" pos:[8,200] width:224 height:96 enabled:true align:#left
		colorPicker 'cp1' "Object Color " pos:[52,248] width:136 height:19 color:(color 255 125 7) align:#left
		radiobuttons 'rdo1' "Poly Size" pos:[20,429] width:199 height:30 enabled:true labels:#("random", "relative", "fixed") default:1 columns:3 align:#left
		GroupBox 'grp3' "-- Modifiers Functionality ----------------------" pos:[7,304] width:224 height:96 align:#left
		GroupBox 'grp5' "-- Sizing ------------------------------------------" pos:[8,409] width:223 height:163 align:#left
		progressBar 'pb1' "DETACHING..." pos:[88,680] width:135 height:19 value:0 color:(color 255 110 5) orient:#horizontal align:#left
		edittext 'edt1' "Object Name" pos:[20,224] width:200 height:20 align:#left
		checkbox 'chk1' "Chamfer" pos:[24,376] width:64 height:18 align:#left
		checkbox 'chk2' "Outline" pos:[24,328] width:64 height:18 align:#left
		checkbox 'chk3' "Shell" pos:[24,352] width:56 height:18 align:#left
		checkbox 'chk4' "Save To .FBX" pos:[20,272] width:86 height:18 enabled:false align:#left
		checkbox 'chk5' "Save As Group" pos:[124,272] width:96 height:18 enabled:true align:#left
		spinner 'spn1' "Value" pos:[104,330] width:78 height:16 enabled:false range:[-10,10,-0.1] type:#float scale:0.01 align:#left
		spinner 'spn2' "Value" pos:[104,356] width:78 height:16 enabled:false range:[0.1,10,0.5] scale:0.1 align:#left
		spinner 'spn3' "Value" pos:[104,380] width:77 height:16 enabled:false range:[0.01,10,0.1] scale:0.01 align:#left
		slider 'sld1' "Min (1)" pos:[17,469] width:104 height:44 range:[1,100,1] type:#integer orient:#horizontal ticks:5 align:#left
		slider 'sld2' "Max (10)" pos:[121,468] width:104 height:44 range:[1,100,10] type:#integer ticks:5 align:#left
		slider 'sld19' "Height Bias (50)" pos:[16,522] width:208 height:44 range:[0,1000,50] type:#integer orient:#horizontal ticks:25 align:#left
		slider 'sld23' "Total animation time (3 sec)" pos:[16,592] width:208 height:44 range:[0.5,10,4] type:#float orient:#horizontal ticks:10 align:#left
		GroupBox 'grp61' "-- Animation -------------------------------------" pos:[8,576] width:223 height:72 align:#left
		GroupBox 'grp122' "-- Overal Progress -----------------------------" pos:[8,656] width:223 height:123 align:#left
		progressBar 'pb36' "REPOSITION..." pos:[88,704] width:135 height:19 value:0 color:(color 255 110 5) align:#left
		progressBar 'pb37' "KEYING..." pos:[88,728] width:135 height:19 value:0 color:(color 255 110 5) align:#left
		progressBar 'pb38' "MODIFYERING..." pos:[88,752] width:135 height:19 value:0 color:(color 255 110 5) align:#left
		label 'lbl69' "" pos:[8,824] width:224 height:20 align:#left
		button 'btn7' "START / RESTART" pos:[8,784] width:111 height:32 align:#left
		button 'btn2' "REMODIFY" pos:[123,784] width:107 height:32 align:#left
		label 'lbl5' "DETACHING:" pos:[15,680] width:68 height:19 align:#left
		label 'lbl7' "REKEYING:" pos:[15,728] width:68 height:19 align:#left
		label 'lbl8' "REPOSITION:" pos:[15,704] width:68 height:19 align:#left
		label 'lbl9' "MODIFYRING:" pos:[15,752] width:73 height:19 align:#left

		on cp1 changed col do
		(
			global_object_color = col
		)
		on rdo1 changed stat do
		(
			if (rdo1.state == 1) then 
			( 
				is_global_bias_random = true
				is_global_bias_relative = false
				is_global_bias_fixed = false	
				sld1.enabled = true
				sld2.enabled = true
				global_bias_min = sld1.value 
				global_bias_max = sld2.value
			)
			else if (rdo1.state == 2) then 
			(
				is_global_bias_random = false
				is_global_bias_relative = true
				is_global_bias_fixed = false
				sld1.enabled = false
				sld2.enabled = false
			)
			else if (rdo1.state == 3) then 
			(
				is_global_bias_random = false
				is_global_bias_relative = false
				is_global_bias_fixed = true
				sld1.enabled = false
				sld2.enabled = true
				global_bias_max = sld2.value
			)
		)
		on edt1 entered text do
		(
			global_object_name_export = text
		)
		on chk1 changed state do
		(
			if (state == true) then 
			(
				spn3.enabled = true
				is_global_chamfer = true
			)
			else (
				spn3.enabled = false
				is_global_chamfer = false
			)
		)
		on chk2 changed state do
		(
			if (state == true) then (
				spn1.enabled = true
				is_global_outline = true
			)
			else (
				spn1.enabled = false
				is_global_outline = false
			)
		)
		on chk3 changed state do
		(
			if (state == true) then (
				spn2.enabled = true
				is_global_shell = true
			)
			else (
				spn2.enabled = false
				is_global_shell = false
			)
		)
		on chk4 changed state do
		(
			/*
			testObj = teapot()
		   -- fbxexp examples
		   select testObj
		   -- save in text format:
		   FBXExporterSetParam "ASCII" true
		   --to prevent the export of the cameras:
		   FBXExporterSetParam "Cameras" False
		   exportFile @"c:\test.fbx" #noPrompt selectedOnly:true using:FBXEXP
			*/
		)
		on chk5 changed state do
		(
			if (chk5.state == true) then 
			(
				is_global_group = true
			)
			else (
				is_global_group = false
			)
		)
		on spn1 changed val do
		(
			global_outline_value = val
		)
		on spn2 changed val do
		(
			global_shell_value = val
		)
		on spn3 changed val do
		(
			global_chamfer_value = val
		)
		on sld1 changed val do
		(
			sld1.caption = "Min (" + (val as string) + ")"
		)
		on sld2 changed val do
		(
			sld2.caption = "Max (" + (val as string) + ")"
		)
		on sld19 changed val do
		(
			sld19.caption = "Height Bias ("+(sld19.value as string)+")"
			global_adding_height = sld19.value
		)
		on sld23 changed val do
		(
			sld23.caption = "Total animation time ("+(sld23.value as string)+" sec)"
			global_time_animation = sld23.value
			global_end_key = 30*global_time_animation
		)
		on btn7 pressed do
		(
			Polynimate 12
		)
		on btn2 pressed do
		(
			makeArrayByGlobalName arGap global_object_name_export
			applyModifiers arGap is_global_outline is_global_shell is_global_chamfer global_outline_value global_shell_value global_chamfer_value
			if (is_global_group == true) then 
			(
				group arGap name:global_object_name_export ui:off
			)
			select arGap
			meditMaterials[1].base_color = global_object_color
			$.material = meditMaterials[1]
		)
	)

	

	function reactivateUI state = 
	(
		if (state == true) then
		(
			polyUI.chk1.enabled = true;
			polyUI.chk2.enabled = true;
			polyUI.chk3.enabled = true;
			--polyUI.chk4.enabled = true;
			polyUI.chk5.enabled = true;
			polyUI.rdo1.enabled = true;
			polyUI.cp1.enabled = true;
			polyUI.sld19.enabled = true;
			polyUI.sld23.enabled = true;
			--polyUI.sld68.enabled = true;
			polyUI.edt1.enabled = true;
			polyUI.btn2.enabled = true;
			
			if (polyUI.rdo1.state == 1) then 
			( 
				is_global_bias_random = true
				is_global_bias_relative = false
				is_global_bias_fixed = false	
				polyUI.sld1.enabled = true
				polyUI.sld2.enabled = true
				global_bias_min = polyUI.sld1.value 
				global_bias_max = polyUI.sld2.value
			)
			else if (polyUI.rdo1.state == 2) then 
			(
				is_global_bias_random = false
				is_global_bias_relative = true
				is_global_bias_fixed = false
				polyUI.sld1.enabled = false
				polyUI.sld2.enabled = false
			)
			else if (polyUI.rdo1.state == 3) then 
			(
				is_global_bias_random = false
				is_global_bias_relative = false
				is_global_bias_fixed = true
				polyUI.sld1.enabled = false
				polyUI.sld2.enabled = true
				global_bias_max = polyUI.sld2.value
			)
		)
		else
		(
			polyUI.chk1.enabled = false;
			polyUI.chk2.enabled = false;
			polyUI.chk3.enabled = false;
			--polyUI.chk4.enabled = false;
			polyUI.chk5.enabled = false;
			polyUI.rdo1.enabled = false;
			polyUI.cp1.enabled = false;
			polyUI.sld19.enabled = false;
			polyUI.sld23.enabled = false;
			--polyUI.sld68.enabled = false;
			polyUI.edt1.enabled = false;
			polyUI.sld1.enabled = false;
			polyUI.sld2.enabled = false;
			polyUI.btn2.enabled = false;
		)
	)

	-- Function for finding and amassing the objects by global name
	function makeArrayByGlobalName ar nam = 
	(
		for obj in objects do
		(
			good = true
			for i = 1 to nam.count do
			(
				if (obj.name[i] != nam[i] or obj.name[nam.count+1] != "_") then 
				(
					good = false
				)		
			)
			if (good == true) then append ar obj
		)
	)


	-- Function for applying modifiers to polyes
	function applyModifiers arr is1 is2 is3 outlineV shellV chamferV = 
	(
		polyUI.pb38.color = color 255 110 5
		polyUI.lbl69.caption = "REMODIFYING..."
		idx = 0
		i = 0
		
		for obj in arr do
		(
			-- Make a little nice gap between polyes
			if (is1 == true) then 
			(
				obj.EditablePoly.SetSelection #Face #{1}
				obj.outlineAmount = outlineV
				obj.EditablePoly.Outline()
			)
			
			-- Make a weight to polyes
			try (deleteModifier obj obj.modifiers[#Shell]) catch()
			if (is2 == true) then 
			(
				addModifier obj (Shell()) 
				obj.modifiers[#Shell].innerAmount = 0
				obj.modifiers[#Shell].outerAmount = shellV
			)
			
			-- Make a fridge to polyes
			try (deleteModifier obj obj.modifiers[#Chamfer]) catch()
			if (is3 == true) then 
			(
				addModifier obj (Chamfer()) 
				obj.modifiers[#Chamfer].miteringType = 4
				obj.modifiers[#Chamfer].chamfertype = 1
				obj.modifiers[#Chamfer].amount = chamferV
				obj.modifiers[#Chamfer].segments = 0
			)
			
			i = i+1
			idx = i*(100.0/arr.count)
			polyUI.pb38.value = (idx as integer)
		)
		
		polyUI.pb38.color = color 40 165 5
		polyUI.lbl69.caption = "DONE."
	)

	function deleteOld tname = 
	(
		arrOld = #()
		makeArrayByGlobalName arrOld tname
		if (arrOld.count != 0) then
		(
			delete arrOld
		)
	)

	function Polynimate empt = 
	(
		is_global_process_done = false
		reactivateUI is_global_process_done
		
		-- move a little bit a target mesh
		dx = $.max.x-$.min.x
		dy = $.max.y-$.min.y
		$.position = [1.2*dx,1.2*dy,0]
		
		-- delete old version of polyes
		arrOld = #()
		makeArrayByGlobalName arrOld global_object_name_export
		if (arrOld.count != 0) then
		(
			delete arrOld
		)
		-- copy of target mesh
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
		nnl.name = global_object_name_export
		select nnl
		
		---------------------[  DETACH PART  ]-----------------------------------
		
		polyUI.lbl69.caption = "PROCESSING..." 
		
		polyUI.pb1.value = 0
		polyUI.pb36.value = 0
		polyUI.pb37.value = 0
		polyUI.pb38.value = 0
		
		polyUI.pb1.color = color 255 110 5
		polyUI.pb36.color = color 255 110 5
		polyUI.pb37.color = color 255 110 5
		polyUI.pb38.color = color 255 110 5
		
		is_global_detach_done = false
		objInit = $

		-- Set a little nice view
		objInit.wirecolor = color 5 5 5
		meditMaterials[1].base_color = global_object_color
		objInit.material = meditMaterials[1]
		

		-- Align object to [0,0,0]
		objInit.pivot = [objInit.center.x, objInit.center.y, objInit.min.z]
		objInit.position = [0,0,0]

		-- Convert to EP
		select objInit
		macros.run "Modifier Stack" "Convert_to_Poly"
		
		
							-- POS --
		global_min = objInit.min
		global_max = objInit.max
		global_middle = objInit.center
							-- SIZE --
		global_length_pf = objInit.max.y - objInit.min.y
		global_width_pf = objInit.max.x - objInit.min.x
		global_height_pf = objInit.max.z - objInit.min.z
		global_H = (objInit.max.z - objInit.min.z)+global_adding_height
		

		-- Detach to separated polyes
		n_polyes = polyop.getNumFaces objInit
		idx = 1
		for i=n_polyes to 1 by -1 do
		(
			idx = idx+(100./n_polyes)
			newName = uniqueName (global_object_name_export + "_")
			polyOp.detachFaces objInit i asNode:true name:newName
			polyUI.pb1.value = (idx as integer)
		)

		-- Delete dummy
		delete objInit
		
		is_global_detach_done = true
		polyUI.pb1.color = color 40 165 5
	------------------------------------------------------------------------------

		-- Save all polyes
		arr = #()
		makeArrayByGlobalName arr global_object_name_export

		-- Amass all poly's indices & center coords
		mids = #()
		for i=1 to arr.count do
		(
			arr[i].pivot = [arr[i].center.x, arr[i].center.y, arr[i].center.z]
			mid = polyop.getFaceCenter arr[i] 1
			append mids #(i, mid.z)
		) 
		-- Sorting polyes by Z-index
		for i=1 to mids.count do (
			for j=1 to mids.count-1 do (
				if (mids[j][2] > mids[j+1][2]) then 
				(
					temp = #(mids[j][1],mids[j][2])
					mids[j]= mids[j+1]
					mids[j+1] = temp
				)
			)
		)
		-- Rename polyes by Z-index
		for i=1 to mids.count do
		(
			finalName = (global_object_name_export + "_" + i as string)
			arr[mids[i][1]].name = finalname
		)

		-- Reorder polyes by names
		arReor = #()
		for i=1 to arr.count do
		(
			for j=1 to arr.count do
			(
				if (arr[j].name == (global_object_name_export+"_"+(i as string))) then
				(
					append arReor arr[j]
				)
			)
		)
		--------------------------------------------------------------------




		----------------[  RETOPOLOGY PART  ]----------------------------------

		-- clear bad polyes ---------------------------------------------
		/*for i=1 to arReor.count do
		(
			if (classOf arReor[i] != Editable_Poly) then
			(
				delete toDel[i]
				deleteItem arReor i
				
			)
		)
		*/

		-- clear non-rect polyes ---------------------------------------------
		toDel = #()
		del_idx = #()
		for i=1 to arReor.count do
		(
			n = polyOp.getNumVerts arReor[i]
			if (n != 4) then 
			(
				append toDel arReor[i]
				append del_idx i
			)
		)
		for i=1 to toDel.count do 
		(
			delete toDel[i]
			
		)

		for i = del_idx.count to 1 by -1 do 
		(
			deleteItem arReor del_idx[i]
		)
		-------------------------------------------------------------

		-- Reorder polyes by names
		arNamedAfterRemove = #()
		for i=1 to arReor.count do
		(
			newName = global_object_name_export + "_" + (i as string)
			arReor[i].name = newName
			append arNamedAfterRemove arReor[i]
		)
		-------------------------------------------------------------

		is_global_reposition_done = false
		idx = 0
		ix = 1
		set animate on -- START ANIM
		
		for obj in arNamedAfterRemove do
		(
			hide obj
			idx = ix*(100.0/arNamedAfterRemove.count)
			ix = ix+1
			polyUI.pb36.value = (idx as integer)
			
			-- key anim 0 -----------------------------------------------
			sliderTime = 0
			-------------------------------------------------------------
			
			
			-- clear pivot point ----------------------------------------
			obj.pivot = [obj.center.x, obj.center.y, obj.center.z]
			-------------------------------------------------------------
			
			
			-- find vertex sequence -------------------------------------
			e1 = polyop.getVertsUsingEdge obj 1 		-- edge 1 vertices
			e2 = polyop.getVertsUsingEdge obj 2 		-- edge 2 vertices
			e3 = polyop.getVertsUsingEdge obj 3 		-- edge 3 vertices
			e4 = polyop.getVertsUsingEdge obj 4 		-- edge 4 vertices
			e_ar = #(e1, e2, e3, e4) 					-- array of edges
			ready = #(0,0,0,0) 							-- init ready new position's array
			
			-- second and third vertices
			first_two_verts = #()
			for i=1 to e1.count do 
			(
				if (e1[i] == true) then 
				(
					append first_two_verts i
				)
			)
			ready[2] = first_two_verts[1]
			ready[3] = first_two_verts[2]
			
			-- first vertex
			for i=2 to e_ar.count do
			(
				if (e_ar[i][ready[2]] == true) then
				(
					for k=1 to e_ar[i].count do
					(
						if ((e_ar[i][k] == true) and (ready[2] != k)) then
						(
							ready[1] = k
						)
					)
				)
			)

			-- fourth vertex
			ready[4] = (10-(ready[1]+ready[2]+ready[3]))
			-------------------------------------------------------------	
			
				
			-- prepare new position --------------------------------------
			-- coords of center
			mid = polyop.getFaceCenter obj 1 
				
			-- get vertices coords
			v1 = polyop.getVert obj ready[1]
			v2 = polyop.getVert obj ready[2]
			v3 = polyop.getVert obj ready[3]
			v4 = polyop.getVert obj ready[4]
				
			-- get side of area-equal square
			S = polyop.getFaceArea obj 1
			side = sqrt S
			
			-- check bias version 3
			if (is_global_bias_relative == true) then 
			(
				global_bias = side/2
			)
			else if (is_global_bias_random == true) then 
			(
				global_bias = (random global_bias_min global_bias_max)
			)
			else if (is_global_bias_fixed == true) then 
			(
				global_bias = global_bias_max
			)
				
			new_v1 = [mid.x+global_bias, mid.y+global_bias, mid.z] 	-- quad 1
			new_v2 = [mid.x+global_bias, mid.y-global_bias, mid.z] 	-- quad 2
			new_v3 = [mid.x-global_bias, mid.y-global_bias, mid.z] 	-- quad 3
			new_v4 = [mid.x-global_bias, mid.y+global_bias, mid.z] 	-- quad 4
			-------------------------------------------------------------
				
			
			-- key anim end ----------------------------------------------
			sliderTime = global_end_key-20 -- it'll be the first point in animation
			-------------------------------------------------------------
			
				
			-- set into new position ------------------------------------
			polyop.setVert obj ready[1] new_v1 -- quad 1
			polyop.setVert obj ready[2] new_v2 -- quad 2
			polyop.setVert obj ready[3] new_v3 -- quad 3
			polyop.setVert obj ready[4] new_v4 -- quad 4
			-------------------------------------------------------------
		)
		unhide arNamedAfterRemove
		set animate off -- FINISH ANIM
		is_global_reposition_done = true
		polyUI.pb36.color = color 40 165 5
		
		---------------------------[  ANIMATION PART  ]------------------------------------


		-- If you want to make cube-animation ---------------------------
		--cube_size = ceil (pow ar.count (1/3 as double)) as integer
		--total_count = (cube_size*cube_size*cube_size)
		-----------------------------------------------------------------

		-- Actual size of polyes ----------------------------------------
		-- Reorder polyes by names

		arRenam = #()
		for i=1 to arNamedAfterRemove.count do
		(
			for j=1 to arNamedAfterRemove.count do
			(
				if (arNamedAfterRemove[j].name == (global_object_name_export+"_"+(i as string))) then
				(
					append arRenam arNamedAfterRemove[j]
				)
			)
		)

		-- move keys of final state to the end of animation time ----
		for obj in arRenam do
		(
			moveKey obj.vertex1.controller 1 global_end_key
			moveKey obj.vertex2.controller 1 global_end_key
			moveKey obj.vertex3.controller 1 global_end_key
			moveKey obj.vertex4.controller 1 global_end_key
		)

		-- move keys of final state to the end of animation time ----
		arUpdate = #()
		ar_pos = #()
		poly_H = #()

		for i=1 to arRenam.count do
		(
			for j=1 to arRenam.count do
			(
				if (arRenam[j].name == (global_object_name_export+"_"+(i as string))) then
				(
					append arUpdate arRenam[j]
					append ar_pos arRenam[j].position
				)
			)
		)

		global_count_obj = arUpdate.count
		global_end_frame = global_end_key
		global_frames_per_poly = global_end_frame/global_count_obj as float

		is_global_keying_done = false
		
		hide arUpdate
		set animate on
		sliderTime = 0
		for i=1 to global_count_obj do
		(
			h = abs (global_H - ar_pos[i].z)
			append poly_H (h)
			arUpdate[i].position.x = ar_pos[i].x
			arUpdate[i].position.y = ar_pos[i].y
			arUpdate[i].position.z = global_H
		)

		idx = 0
		for i=1 to global_count_obj do
		(
			startTime = (i-1)*global_frames_per_poly+1
			endTime = (i)*global_frames_per_poly+1
			sliderTime = startTime
			arUpdate[i].position.x = ar_pos[i].x
			arUpdate[i].position.y = ar_pos[i].y
			arUpdate[i].position.z = global_H
			sliderTime = endTime
			arUpdate[i].position.z = global_H-poly_H[i]
			
			idx = i*(100.0/global_count_obj)
			polyUI.pb37.value = (idx as integer)
		)
		set animate off

		is_global_keying_done = true
		polyUI.pb37.color = color 40 165 5

		---------------------------[  KEYING PART  ]----------------------------------------
		
		-- Correcting position of animation keys for more nice prepresenting
		for obj in arUpdate do
		(
			f1 = 0f
			f2 = global_end_key
			try 
			(
				f2 = getKeyTime obj.position.controller 3
				f1 = getKeyTime obj.position.controller 2
			)
			catch 
			(
				f2 = getKeyTime obj.position.controller 2
				f1 = getKeyTime obj.position.controller 1
			)
			
			print "f1"
			print f1
			print "f2"
			print f2
			fv1 = getKeyTime obj.vertex1.controller 1
			fv2 = getKeyTime obj.vertex1.controller 2
			
			delta1 = abs (fv1-f1)
			delta2 = abs (fv2-f2)
			if (fv1 < f1) then 
			(
				delta1 = -delta1
			)
			
			moveKey obj.vertex1.controller 1 (-delta1)
			moveKey obj.vertex2.controller 1 (-delta1)
			moveKey obj.vertex3.controller 1 (-delta1)
			moveKey obj.vertex4.controller 1 (-delta1)
			
			if (fv2 < f2) then 
			(
				delta2 = -delta2
				deleteKey obj.position.controller 2
			)
			
			moveKey obj.vertex1.controller 2 (-delta2)
			moveKey obj.vertex2.controller 2 (-delta2)
			moveKey obj.vertex3.controller 2 (-delta2)
			moveKey obj.vertex4.controller 2 (-delta2)
			
			unhide obj
		)
		---------------------------[  SHELL POLY PART  ]------------------------------------

		unhide arUpdate
		-- Make global arr
		makeArrayByGlobalName arUpdate global_object_name_export
		
		-- Apply modifiers
		applyModifiers arUpdate is_global_outline is_global_shell is_global_chamfer global_outline_value global_shell_value global_chamfer_value
		
		is_global_modifyering_done = false
		
		-- Little final test
		animationRange = interval 0 (global_end_key+1)
		sliderTime = 0f
		idx = 0
		for i=1 to (global_end_key+1) do
		(
			sliderTime += 1
			idx = i*(100.0/global_end_key)
			polyUI.pb38.value = (idx as integer)
		)
		
		is_global_modifyering_done = true
		polyUI.pb38.color = color 40 165 5
		
		
		if (is_global_group == true) then 
		(
			group arUpdate name:global_object_name_export ui:off
		)
		
		polyUI.lbl69.caption = "DONE." 
		is_global_process_done = true
		reactivateUI is_global_process_done
	)