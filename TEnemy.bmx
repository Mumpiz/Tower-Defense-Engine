


Type TEnemy Extends TEntity

		
		
		Field _wayPoint:TWayPoint
		
		Field _animR:MF_TAnimSeq = MF_TAnimSeq.Create(0, 11, 0.05)
		Field _animL:MF_TAnimSeq = MF_TAnimSeq.Create(12, 23, 0.05)
		
		Field _view:Byte = 0 ' 1 = links, 2 = rechts

		Function Create	(..
					x:Float, y:Float, ..										' x, y
					image:TImage, imageDeath:TImage, imageShot:TImage, imageShotHit:TImage, .. ' Images
					sndShot:TSound, sndDeath:TSound, sndShotHit:TSound, sndHitten:TSound, ..	' Sounds
					hp:Int, dmg:Int, ..										' Hp, Dmg
					relTime:Double, range:Int, ..								' RelTime, Range
					speed:Int ..											' Speed
					)
					
			Local enemy:TEnemy = New TEnemy
			enemy._x = x
			enemy._y = y
			enemy._maxHp = hp
			enemy._currentHp = hp
			enemy._baseDmg = dmg
			enemy._totalDmg = dmg
			enemy._baseReloadTime = relTime
			enemy._totalReloadTime = relTime
			enemy._baseRange = range
			enemy._totalRange = range
			enemy._speed = speed
			
			enemy._image = image
			enemy._imageDeath = imageDeath
			enemy._imageShot = imageShot
			enemy._imageShotHit = imageShotHit
			
			enemy._sndShot = sndShot
			enemy._sndDeath = sndDeath
			enemy._sndShotHit = sndShotHit
			enemy._sndHitten = sndHitten
			
			If enemy._image <> Null
				SetImageHandle enemy._image, ImageWidth(enemy._image) / 2, ImageHeight(enemy._image) - ImageHeight(enemy._image)/2
			Else
				RuntimeError "  Image for TEnemy-Object is Null!"
			End If

			If enemy._imageDeath = Null
				RuntimeError "  ImageDeath for TEnemy-Object is Null!"
			End If
			If enemy._imageShot = Null
				'RuntimeError "  ImageShot for TEnemy-Object is Null!"
			End If
			If enemy._imageShotHit = Null
				RuntimeError "  ImageShotHit for TEnemy-Object is Null!"
			End If
		End Function
		

		Method Update()
			FindTarget()
			UpdateShootBehavior()
			MoveAlongPath()
		End Method
		
		Method Draw()
			Rem
			Local r:Int = 255 - ( ( (100 * Self._currentHp) / Self._maxHp) * 2 )
			Local g:Int = ( (100 * Self._currentHp) / Self._maxHp ) * 2
			Local b:Int = ( (100 * Self._currentHp) / Self._maxHp ) * 2
			
			SetColor( 0, 0, 0 )
			DrawOval( Self._x - 5, Self._y - 5, 10, 10)
			SetColor( r, g, b )
			DrawOval( Self._x - 4, Self._y - 4, 8, 8)
			SetColor( 255, 255, 255 )
			EndRem
			
			' Healthbar
			SetColor 255, 100, 100
			DrawRect(  Self._x - ImageWidth(Self._image)/2 + (100/3)/2, Self._y - (ImageHeight(Self._image)/4)*3, 100/3, 4 )
			SetColor 100, 200, 100 
			DrawRect( Self._x - ImageWidth(Self._image)/2 + (100/3)/2, Self._y - (ImageHeight(Self._image)/4)*3, ((100 * Self._currentHp) / Self._maxHp)/3, 4 )
			SetColor 255, 255, 255
			
			' Das Image
			If Self._view = 1
				Self._animL.Play(Self._image, Self._x, Self._y)
			ElseIf Self._view = 2
				Self._animR.Play(Self._image, Self._x, Self._y)
			End If
			
		End Method
		
		
		Method FindTarget()			
			For Local target:TTower = EachIn MF_TEntity.List
				If MF_GetDistance( Self._x, Self._y, target.GetX(), target.GetY() ) < Self._totalRange
					Self._targetLink = target.GetLink()
					Exit
				Else
					Self._targetLink = Null
				End If
			Next
		End Method
		
		
		Method MoveAlongPath()
			If Self._wayPoint = Null
				Self._wayPoint = TWayPoint(TWayPoint.List.First())
			Else
				If Self._x < Self._wayPoint.GetX()
					Self._view = 2
				Else
					Self._view = 1
				End If
				
				MF_MoveTowardsPoint( Self._x, Self._y, Self._wayPoint.GetX(), Self._wayPoint.GetY(), Self._speed )
				If MF_GetDistance( Self._x, Self._y, Self._wayPoint.GetX(), Self._wayPoint.GetY() ) < 5
					' Ende des Pfades erreicht
					If Self._wayPoint.GetNextWp() = Null
						Destroy()
					Else
						Self._wayPoint = Self._wayPoint.GetNextWp()
					End If
				End If
			End If
		End Method
		
		
		
		' Wenn ein Gegner in der Nähe gefunden wurde,
		' dann wird auf ihn geschossen
		Method UpdateShootBehavior()
			' Schuss
			If Self._baseDmg > 0
				' Exsistiert Gegner noch?
				If Self._targetLink <> Null
					' Kann schon wieder geschossen werden?
					If Self._reloadTimer < MilliSecs()
						'Schuss erstellen und positionieren
						TShot.Create(Self._x, Self._y, Null, Self._imageShotHit, Self._sndShotHit, Self._totalDmg, Self._targetLink, Self._link)
						
						If Self._sndShot <> Null Then MF_PlaySound(Self._sndShot, SfxChannel)
						Self._reloadTimer = MilliSecs() + Self._totalReloadTime * 1000
					End If
				End If
			End If
			Self._targetLink = Null
		End Method
		
		
		
		Method Destroy()
			Life = Life - 1
			Free()
		End Method
		
		Method Death()
			If Self._sndDeath <> Null Then MF_PlaySound(Self._sndDeath, SfxChannel)
			If Self._imageDeath <> Null Then TAnim.Create(Self._x, Self._y, Self._imageDeath, 12)
			Credits = Credits + Self._maxHp/10 + 1
			Free()
		End Method

End Type



