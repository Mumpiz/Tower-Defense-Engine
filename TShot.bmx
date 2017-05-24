


Type TShot

	' Private
		Field _x:Float, _y:Float
		Field _image:TImage
		Field _imageHit:TImage
		
		Field _sndHit:TSound
		
		Field _damage:Int = 0		' Schaden des Schusses
		Field _speed:Int = 5		' Geschwindigkeit des Schusses
		
		Field _anim:MF_TAnimSeq = MF_TAnimSeq.Create(0, 7, 0.05)
		
		Field _link:TLink
		
		' Link vom Ziel, auf das sich der Schuss zubewegen soll
		Field _targetLink:TLink
		
		' Link vom Erzeuger des Schusses
		Field _creatorLink:TLink

	'Public
		Global List:TList = New TList

		Global StrikeDistance:Int = 30 ' Die maximale Distance zwischen Schuss und Zielobjekt damit es noch ein Volltreffer ist
		Global MissedDistance:Int = 5 ' Die maximale Distance zwischen Schuss und Zielobjekt wenn es daneben ging

		
		Method New()
			Self._link = List.AddLast(Self)
		End Method

		
		Function Create(x:Float, y:Float, image:TImage, imageHit:TImage, sndHit:TSound, damage:Int, targetLink:TLink, creatorLink:TLink)
			Local shot:TShot = New TShot
			shot._x = x
			shot._y = y
			shot._damage = damage
			
			shot._image = image
			shot._imageHit = imageHit
			
			shot._sndHit = sndHit
			
			shot._targetLink = targetLink
			shot._creatorLink = creatorLink
			If shot._image <> Null
				SetImageHandle shot._image, ImageWidth(shot._image) / 2, ImageHeight(shot._image)
			End If
		End Function


		Method Update()

			Local target:TEntity = TEntity(Self._targetLink.Value())
			If target <> Null
				
				' Richtung Ziel bewegen
	      		MF_MoveTowardsPoint(Self._x, Self._y, target.GetX(), target.GetY(), Self._speed)
				' Löschen wenn Zielposition erreicht, jedoch noch nichts getroffen wurde
				If MF_GetDistance(Self._x, Self._y, target.GetX(), target.GetY() ) < TShot.MissedDistance
					Destroy()
				End If
				' Wenn Zielobjekt getroffen wurde, schaden austeilen und danach den Schuss löschen
				If MF_GetDistance(Self._x, Self._y, target.GetX(), target.GetY()) < TShot.StrikeDistance
					target.SubHp(Self._damage)
					Destroy()
				End If
			Else
				Free()
			End If
			
			' Löschen falls ausserhalb der Map
			If (Self._x < -GW Or Self._x > GW) Or (Self._y < -GH Or Self._y > GH)
				Free()
			End If
		End Method
		
		
		Method Draw()
			Local target:TEntity = TEntity(Self._targetLink.Value())
			Local creator:TEntity = TEntity(Self._creatorLink.Value())
			If target <> Null
				If Self._image <> Null
					If creator <> Null
						' Blickrichtung ausrichten
						SetRotation MF_GetAngle(creator.GetX(), creator.GetY(), target.GetX(), target.GetY())
					Else
						Free()
					End If
					Self._anim.Play(Self._image, Self._x, Self._y)
					' Rotation zurücksetzen
					SetRotation 0
				Else
					DrawOval Self._x - 2, Self._y - 2, 4, 4
				End If
			End If
		End Method
		
		
		Method Destroy()
			If Self._imageHit <> Null Then TAnim.Create(Self._x, Self._y, Self._imageHit, 8)
			If Self._sndHit <> Null Then MF_PlaySound(Self._sndHit, SfxChannel)
			Free()
		End Method
		
		' Dieses Objekt aus der Liste entfernen und löschen
	   	Method Free()
	      	If Self._link
	        		Self._link.Remove()
	         		Self._link = Null
	      	EndIf
	   	EndMethod
	
		
		Function RenderAll()
			For Local shot:TShot = EachIn TShot.List
				shot.Update()
				shot.Draw()
			Next
		End Function
		
End Type







