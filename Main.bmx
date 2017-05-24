


SuperStrict

' Imports

	Framework BRL.GLMax2D
	Import BRL.OpenALAudio
	Import BRL.Timer
	Import BRL.Random
	Import BRL.RamStream
	Import BRL.FreeTypeFont
	Import BRL.PNGLoader
	Import BRL.WAVLoader
	Import BRL.Retro

	

	


	
' Grafik

	SetGraphicsDriver GLMax2DDriver()
	SetAudioDriver("OpenAL" )
	Global GW:Int = 1024, GH:Int = 600
	Graphics GW, GH
	SetBlend ALPHABLEND
	MoveMouse(GW/2, GH/2)



' Includes

	Include "MF_Functions.bmx"
	Include "Resources.bmx"
	Include "Input.bmx"
	Include "TEntity.bmx"
	Include "TShot.bmx"
	Include "TTower.bmx"
	Include "TPassiveDoodad.bmx"
	Include "TEnemy.bmx"
	Include "TWayPoint.bmx"
	Include "IngameVariables.bmx"
	Include "TAnim.bmx"
	Include "Gui.bmx"

	
	
	





Global FpsTimer:TTimer = CreateTimer(60)
' MainLoop

	Repeat
	Cls
	SortList(MF_TEntity.List)
		'Input
		mh1:Int = MouseHit(MOUSE_LEFT)
		mh2:Int = MouseHit(MOUSE_RIGHT)
		mh3:Int = MouseHit(MOUSE_MIDDLE)
		md1:Int = MouseDown(MOUSE_LEFT)
		md2:Int = MouseDown(MOUSE_RIGHT)
		md3:Int = MouseDown(MOUSE_MIDDLE)

		If KeyHit(KEY_SPACE)
			Local tmp:TWayPoint = New TWayPoint
			tmp.SetX(MouseX())
			tmp.SetY(MouseY())
			tmp = Null
		End If
		
		If KeyHit(KEY_LCONTROL) Then Credits = 1000
		
		
		If KeyHit(KEY_LSHIFT)
			TEnemy.Create	(..
						TWayPoint(TWayPoint.List.First()).GetX(), TWayPoint(TWayPoint.List.First()).GetY(), ..	'x, y
						Img_EnemyTest, Img_ExploTest, Null, Img_SmallExploTest, ..	' Images
						Null, Snd_EnemyDie, Snd_ShotHit, Snd_EnemyHitten, ..		' Sounds
						50, 1, ..										' Hp, Dmg
						1, 100, ..										' RelTime, Range
						1 ..											' Speed
						)
		End If
		
		
		If mh2
			TTower.Create	(..
						MouseX(), MouseY(), ..									' x, y
						Img_TowerTest, Img_ExploTest, Img_ShotTest, Img_SmallExploTest, ..	' Images
						Snd_SmallShot, Snd_SmallExplo, Snd_ShotHit, Snd_TowerHitten, ..	' Sounds
						250, 2, ..											' Hp, Dmg
						0.5, 100, ..										' RelTime, Range
						10, 250 ..											' MaxUpgradeLevel, Buildcost
						)
		End If
		
		If mh3
			'TPassiveDoodad.Create(MouseX(), MouseY(), Img_PassiveDoodadTest)
		End If 

	
	MF_TEntity.RenderAll()
	TAnim.RenderAll()
	TShot.RenderAll()
	TWayPoint.DebugAll(mh1, mh3)
	
	
	UpdateGui()
	DrawGui()
	
	DrawText "Credits: " + Credits, 5, 5
	DrawText "Life: " + Life, 250, 5
	
	DrawText MF_GetAngle(GW/2, GH/2, MouseX(), MouseY() ), 0, 100
	DrawText MF_GetViewDirection8(GW/2, GH/2, MouseX(), MouseY()), 0, 120
	DrawOval GW/2-1, GH/2-1,2,2
	
	Flip(1)
	WaitTimer(FpsTimer)
	If KeyHit(Key_Escape) Or AppTerminate() Then End
	Forever












