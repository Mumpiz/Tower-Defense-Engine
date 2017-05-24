

Type TTower Extends TEntity
	
	'Private
		Field _selected:Byte = False ' Einfache Variable die beinhalted, ob ein Objekt ausgewählt ist oder nicht ( True oder False )
		
		' Bestimmt das maximale Upgradelevel
		Field _maxUpgradeLevel:Int
		
		' Upgrade
		Field _cost:Int ' Preis des Towers
		Field _hpRecoverCost:Int ' Preis für vollständige Reperatur
		
		Field _damageUpgradeLevel:Int = 1
		Field _damageUpgradeCost:Int
		
		Field _rangeUpgradeLevel:Int = 1
		Field _rangeUpgradeCost:Int
		
		Field _reloadTimeUpgradeLevel:Int = 1
		Field _reloadTimeUpgradeCost:Int
		
		
		
		
				
		Function Create	(..
					x:Float, y:Float, ..											' x, y
					image:TImage, imageDeath:TImage, imageShot:TImage, imageShotHit:TImage, .. 	' Images
					sndShot:TSound, sndDeath:TSound, sndShotHit:TSound, sndHitten:TSound, ..		' Sounds
					hp:Int, dmg:Int, ..											' Hp, Dmg
					relTime:Double, range:Int, ..									' RelTime, Range
					maxUpgradeLevel:Int, cost:Int ..									' MaxUpgradeLevel, Buildcost
					)
					
			Local tower:TTower = New TTower
			tower._x = x
			tower._y = y
			tower._maxHp = hp
			tower._currentHp = hp
			tower._baseDmg = dmg
			tower._totalDmg = dmg
			tower._baseReloadTime = relTime + 0.011
			tower._totalReloadTime = relTime + 0.011
			tower._baseRange = range
			tower._totalRange = range
			tower._maxUpgradeLevel = maxUpgradeLevel
			tower._cost = cost
			
			tower._image = image
			tower._imageDeath = imageDeath
			tower._imageShot = imageShot
			tower._imageShotHit = imageShotHit
			
			tower._sndShot = sndShot
			tower._sndDeath = sndDeath
			tower._sndShotHit = sndShotHit
			tower._sndHitten = sndHitten
			
			If tower._image <> Null
				SetImageHandle tower._image, ImageWidth(tower._image) / 2, ImageHeight(tower._image) - ImageHeight(tower._image)/4
			Else
				RuntimeError "  Image for TTower-Object is Null!"
			End If

			If tower._imageDeath = Null
				RuntimeError "  ImageDeath for TTower-Object is Null!"
			End If
			If tower._imageShot = Null
				RuntimeError "  ImageShot for TTower-Object is Null!"
			End If
			If tower._imageShotHit = Null
				RuntimeError "  ImageShotHit for TTower-Object is Null!"
			End If
			
		End Function
		
		
		Method Update()
			UpdateSelected()
			FindTarget()
			UpdateShootBehavior()
			UpdateUpgradeInfluences()
		End Method
		
		
		Method Draw()
			' Der SchussReichweitenradius
			If Self._selected = True
				DrawRange()
			End If
			' Healthbar
			SetColor 255, 100, 100
			DrawRect(  Self._x - ImageWidth(Self._image)/2 + (100/3)/2, Self._y - ImageHeight(Self._image), 100/3, 4 )
			SetColor 100, 200, 100 
			DrawRect( Self._x - ImageWidth(Self._image)/2 + (100/3)/2, Self._y - ImageHeight(Self._image), ((100 * Self._currentHp) / Self._maxHp)/3, 4 )
			SetColor 255, 255, 255
			' Das Image
			If Self._selected = True
				SetColor 255, 255, 255 
			Else
				SetColor 150, 150, 150 
			End If
			DrawImage(Self._image, Self._x , Self._y)
			SetColor 255, 255, 255
			' Das Upgrade Menü
			DrawUpgradeMenu()
		End Method
		
		
		' Sucht ein Feindliches Ziel zum angreifen
		Method FindTarget()			
			For Local target:TEnemy = EachIn MF_TEntity.List
				If MF_GetDistance( Self._x, Self._y, target.GetX(), target.GetY() ) < Self._totalRange
					Self._targetLink = target.GetLink()
					Exit
				Else
					Self._targetLink = Null
				End If
			Next
		End Method
		
		' Regelt, ob das Objekt selectiert ist oder nicht
		Method UpdateSelected()
			If MouseX() <= 800
				If MF_GetDistance( Self._x, Self._y, MouseX(), MouseY() ) < ImageWidth(Self._image)/2 And Mh1
					Self._selected = True
				ElseIf MF_GetDistance( Self._x, Self._y, MouseX(), MouseY() ) >= ImageWidth(Self._image)/2 And Mh1
					Self._selected = False
				End If
			End If
		End Method
		
		' Aktualisiert die Veränderungen durch Upgrades
		Method UpdateUpgradeInfluences()
			Self._totalDmg = Self._baseDmg + Self._damageUpgradeLevel
			Self._totalRange = Self._baseRange + Self._rangeUpgradeLevel * 5
			
			Self._totalReloadTime = Self._baseReloadTime - (Double(Self._reloadTimeUpgradeLevel)/50) + 0.01
			If Self._totalReloadTime <= 0.051 Then Self._totalReloadTime = 0.051
			
			' Kosten
			Self._hpRecoverCost:Int = ( Self._maxHp - Self._currentHp ) / 2
			
			Self._damageUpgradeCost = ( ((Self._cost / 50)+1) * Self._damageUpgradeLevel) + ( Self._damageUpgradeLevel * 2 )

			Self._rangeUpgradeCost = ( ((Self._cost / 50)+1) * Self._rangeUpgradeLevel) + ( Self._rangeUpgradeLevel * 2 )

			Self._reloadTimeUpgradeCost = ( ((Self._cost / 50)+1) * Self._reloadTimeUpgradeLevel) + ( Self._reloadTimeUpgradeLevel * 2 )
			
		End Method
		
		
		Method DrawUpgradeMenu()
			Local x:Int = 810
			Local y:Int = 500
			
			If Self._selected = True
				
				' Lebenspunkte
				SetColor 40, 160, 250
				DrawText "HP: " + Self._currentHp + "/" + Self._maxHp, x, y
				If Credits >= Self._hpRecoverCost
					If Self._currentHp <> Self._maxHp
						SetColor 160, 160, 0
						DrawText Self._hpRecoverCost + " C.", x + 160, y
						If RectsOverlap(x + 100 - 2, y - 2, 32, 12, MouseX(), MouseY(), 1, 1)
							SetColor 250, 250, 0
							DrawText "Rep", x + 100, y
							If Mh1
								Self._currentHp = Self._maxHp
								Credits = Credits - Self._hpRecoverCost
							End If
						Else
							SetColor 160, 160, 0
							DrawText "Rep", x + 100, y
						End If
					End If
				End If
				SetColor 40, 160, 250
				
				' Schaden ( Damage )
				DrawText "Atk: " + Self._totalDmg, x, y + 20
				DrawText "L " + Self._damageUpgradeLevel, x + 125, y + 20
				If Self._damageUpgradeLevel < Self._maxUpgradeLevel
					SetColor 160, 160, 0
					DrawText Self._damageUpgradeCost + " C.", x + 160, y + 20
					If Credits >= Self._damageUpgradeCost
						If RectsOverlap(x + 100 - 2, y + 20 - 2, 22, 12, MouseX(), MouseY(), 1, 1)
							SetColor 250, 250, 0
							DrawText "Up", x + 100, y + 20
							If Mh1
								Self._damageUpgradeLevel:+ 1
								Credits = Credits - Self._damageUpgradeCost
							End If
						Else
							SetColor 160, 160, 0
							DrawText "Up", x + 100, y + 20
						End If
					End If
				Else
					SetColor 160, 160, 0
					DrawText "Max", x + 95, y + 20
				End If
				SetColor 40, 160, 250
				
				' Reichweite
				DrawText "Range: "+ Self._totalRange, x, y + 40
				DrawText "L " + Self._rangeUpgradeLevel, x + 125, y + 40
				If Self._rangeUpgradeLevel < Self._maxUpgradeLevel
					SetColor 160, 160, 0
					DrawText Self._rangeUpgradeCost + " C.", x + 160, y + 40
					If Credits >= Self._rangeUpgradeCost
						If RectsOverlap(x + 100 - 2, y + 40 - 2, 22, 12, MouseX(), MouseY(), 1, 1)
							SetColor 250, 250, 0
							DrawText "UP", x + 100, y + 40
							If Mh1
								Self._rangeUpgradeLevel:+ 1
								Credits = Credits - Self._rangeUpgradeCost
							End If
						Else
							SetColor 160, 160, 0
							DrawText "UP", x + 100, y + 40
						End If
					End If
				Else
					SetColor 160, 160, 0
					DrawText "Max", x + 95, y + 40
				End If
				SetColor 40, 160, 250
				
				
				' Schussrate bzw. Nachladezeit
				Local reloadTimeStr:String = String(Self._totalReloadTime)
				Local pos:Int = Instr(reloadTimeStr, ".")
				Local afterComma:Int = 2
				If Mid(reloadTimeStr, pos + afterComma, 1) = "0" Then afterComma = 1
				Local reloadTimeStrNew:String = Left(reloadTimeStr, pos + afterComma)
				
				DrawText "Rate: " + reloadTimeStrNew + " s", x, y + 60
				DrawText "L " + Self._reloadTimeUpgradeLevel, x + 125, y + 60
				If Self._reloadTimeUpgradeLevel < Self._maxUpgradeLevel
					SetColor 160, 160, 0
					DrawText Self._reloadTimeUpgradeCost + " C.", x + 160, y + 60
					If Credits >= Self._reloadTimeUpgradeCost And Self._totalReloadTime >= 0.021
						If RectsOverlap(x + 100 - 2, y + 60 - 2, 22, 12, MouseX(), MouseY(), 1, 1)
							SetColor 250, 250, 0
							DrawText "UP", x + 100, y + 60
							If Mh1
								Self._reloadTimeUpgradeLevel:+ 1
								Credits = Credits - Self._reloadTimeUpgradeCost
							End If
						Else
							SetColor 160, 160, 0
							DrawText "UP", x + 100, y + 60
						End If
					End If
				Else
					SetColor 160, 160, 0
					DrawText "Max", x + 95, y + 60
				End If
				SetColor 255, 255, 255
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
						TShot.Create(Self._x, Self._y - ImageHeight(Self._image)/4, Self._imageShot, Self._imageShotHit, Self._sndShotHit, Self._totalDmg, Self._targetLink, Self._link)
						If Self._sndShot <> Null Then MF_PlaySound(Self._sndShot, SfxChannel)
						Self._reloadTimer = MilliSecs() + Self._totalReloadTime * 1000
					End If
				End If
			End If
			Self._targetLink = Null
		End Method
		
		
		Method DrawRange()
			SetAlpha 0.1
			DrawOval( Self._x - Self._totalRange, Self._y - Self._totalRange, Self._totalRange*2, Self._totalRange*2 )
			SetAlpha 1
		End Method
			
		Method Death()
			If Self._sndDeath <> Null Then MF_PlaySound(Self._sndDeath, SfxChannel)
			TAnim.Create(Self._x, Self._y, Self._imageDeath, 12)
			Free()
		End Method

End Type


