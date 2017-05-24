



Type TAnim
	
	Field _link:TLink
	
	Field _x:Float, _y:Float
	
	Field _image:TImage
	
	Field _anim:MF_TAnimSeq
	
	Field _alpha:Float
	
	Method New()
		Self._link = List.AddLast(Self)
	End Method
	
	' Public
	
	Global List:TList = New TList
	
	Function Create:TAnim(x:Float, y:Float, image:TImage, frames:Int, alpha:Float = 1.0)
		Local ani:TAnim = New TAnim
		ani._anim = MF_TAnimSeq.Create(0, frames-1, 0.08)
		ani._x = x
		ani._y = y
		ani._image = image
		ani._alpha = alpha
		If ani._image <> Null
			SetImageHandle ani._image, ImageWidth(ani._image) / 2, ImageHeight(ani._image) / 2
		Else
			RuntimeError "  Image for TAnim-Object is Null!"
		End If
	End Function
	
	Method Update()
		If Self._anim.PlayedOnce() Then Free()
	End Method
	
	Method Draw()
		SetAlpha Self._alpha
		If Self._image <> Null Then Self._anim.Play(Self._image, Self._x, Self._y)
		SetAlpha 1.0
	End Method
	
	' Dieses Objekt aus der Liste entfernen und löschen
	Method Free()
		If Self._link
			Self._link.Remove()
			Self._link = Null
		EndIf
	EndMethod
	
	
	Function RenderAll()
		For Local ani:TAnim = EachIn TAnim.List
			ani.Update()
			ani.Draw()
		Next
	End Function

End Type
