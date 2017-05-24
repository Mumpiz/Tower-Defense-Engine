


Type TPassiveDoodad Extends MF_TEntity

	Field _image:TImage
	
	Function Create(x:Float, y:Float, image:TImage)
		Local pd:TPassiveDoodad = New TPassiveDoodad
		pd._x = x
		pd._y = y
		pd._image = image
		If pd._image <> Null
			SetImageHandle pd._image, ImageWidth(pd._image) / 2, ImageHeight(pd._image) - ImageHeight(pd._image)/4
		End If
	End Function
	
	Method Draw()
		If Self._image <> Null Then DrawImage Self._image, Self._x, Self._y
	End Method
	
	Method Update()
	End Method
End Type
