


Type TEntity Extends MF_TEntity

	'Private
		' Das eigene Bild
		Field _image:TImage
		' Das Bild wenn Self stirbt
		Field _imageDeath:TImage
		' Das Bild des Schusses welcher von Self erstellt wird
		Field _imageShot:TImage
		' Das Bild wenn Self sein Schuss getroffen hat
		Field _imageShotHit:TImage
		
		' Der Sound wenn Self einen Schuss erstellt
		Field _sndShot:TSound
		' Der Sound wenn Self sein Schuss getroffen hat
		Field _sndShotHit:TSound
		' Der Sound wenn Self stirbt
		Field _sndDeath:TSound
		' Der Sound wenn Self von einem Schuss getroffen
		Field _sndHitten:TSound
		

		Field _maxHp:Int ' Maximale Lebenspunkte
		Field _currentHp:Int ' Aktuelle Lebenspunkte
		Field _baseDmg:Int
		Field _totalDmg:Int
		Field _baseReloadTime:Double, _totalReloadTime:Double, _reloadTimer:Double
		Field _baseRange:Int, _totalRange:Int
		Field _speed:Float

		Field _targetLink:TLink
		
		
		Method Draw() Abstract
		
		Method Update() Abstract
		
		Method Death() Abstract

		
		' Addieren ( einen bestimmten Betrag aufaddieren )
		Method AddHp(amount:Int)
			Self._currentHp:+ amount
			If Self._currentHp > Self._maxHp Then Self._currentHp = Self._maxHp
		End Method
		
		' Subtact ( einen bestimmten Betrag abziehen )
		Method SubHp(amount:Int)
			Self._currentHp:- amount
			If Self._sndHitten <> Null Then MF_PlaySound(Self._sndHitten, SfxChannel)
			If Self._currentHp <= 0
				Death()
			End If
		End Method
		
		

End Type



