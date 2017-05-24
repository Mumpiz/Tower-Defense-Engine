
Rem
	______________________________________________________________________________________
	
		Standard Library mit diversen Hilfsfunktionen und Types
		von Michael Frank
	
		Diese Funktionen sind alle unabhängig voneinander, dh. sie können auch einzelnd
		in den eigenen Quelltext kopiert werden
	______________________________________________________________________________________
	
End Rem


' --------------------------------------------------
' Basisklasse für Entitys von der alle Entity-artigen Types abgeleitet werden können
' --------------------------------------------------
Type MF_TEntity

	' Private
	
		Field _x:Float      	' x-Position
	   	Field _y:Float      	' y-Position
	
	
	   	Field _link:TLink   	' Listeneintrag
	
	
	   	' "Method Compare" veranlasst bei einem Aufruf
		' von SortList, dass diese Liste, in der ein Objekt
		' dieses Types (TEntity) sich befindet, nach der Größe der Y-Koordinate Sortiert wird
		' Bsp.:
		'	Ein Objekt vom Typ TEntity wurde erstellt und in eine Liste mit dem Namen "MeineListe" eingetragen...
		'	Nun möchte ich diese Liste so sortieren, dass das Objekt mit der kleinsten y Koordinate ganz am Anfang steht...
		'	Also muss ich nur die Funktion "SortList" aufrufen:
		'	SortList(MeineListe)
		Method Compare:Int(other:Object)
			If other=Null Return 0
			If Self._y = MF_TEntity(other)._y Return 0
			If Self._y < MF_TEntity(other)._y Then Return -1 Else Return 1
		End Method
		
		Method New()
			Self._link = List.AddLast(Self)
		End Method
		
	
	' Public
	
		Global List:TList = New TList
	
		' Dieses Objekt aus der Liste entfernen und löschen
	   	Method Free()
	      	If Self._link
	        		Self._link.Remove()
	         		Self._link = Null
	      	EndIf
	   	EndMethod
	
	
		' Setter und Getter
		Method SetX(x:Float)
			Self._x = x
		End Method
		Method SetY(y:Float)
			Self._y = y
		End Method
	
		Method GetX:Float()
			Return Self._x
		End Method
		Method GetY:Float()
			Return Self._y
		End Method
		Method GetLink:TLink()
			Return Self._link
		End Method
		
		Method Draw() Abstract
	   	Method Update() Abstract
	
		Function RenderAll()
			For Local entity:MF_TEntity = EachIn MF_TEntity.List
				entity.Update()
				entity.Draw()
			Next
		End Function

EndType




' --------------------------------------------------
' Eine einfache Klasse für 2D Animationen
' Erstelle eine Objekt der Klasse... : meineAni:MF_TAnimseq = Create:MF_TAnimSeq(startFrame, endFrame, animSpeed)
' Um mein Image dann zu Zeichnen einfach die Methode: meineAni.Play(image, x, y) aufrufen
' den Rest macht alles das Objekt
' --------------------------------------------------
Type MF_TAnimSeq
   
   	Field _timer:Float

   	Field _totalFrames:Int
   
   	Field _currentFrame:Int
   	Field _startFrame:Int
   	Field _endFrame:Int
   	Field _animSpeed:Float

	Field _timesPlayed:Int = 0
   
   
   	Function Create:MF_TAnimSeq(startFrame:Int, endFrame:Int, animSpeed:Float = Null, randomStartFrame:Byte = False) Final
		SeedRnd(MilliSecs())
      	Local n:MF_TAnimSeq = New MF_TAnimSeq
         	n._startFrame = startFrame
         	n._endFrame = endFrame
		n._animSpeed = animSpeed
		If randomStartFrame = True
         		n._currentFrame = Rand(startFrame, endFrame)
		Else
			n._currentFrame = startFrame
		End If
      	Return n
   	EndFunction
   
   
   	Method Play(image:TImage, x:Int, y:Int) Final
		If Self._animSpeed <> Null
	   		If Self._timer < MilliSecs()
	            	Self._currentFrame:+ 1
	            	If Self._currentFrame > Self._endFrame
					Self._currentFrame = Self._startFrame
					Self._timesPlayed:+1
				End If
				Self._timer = MilliSecs() + Self._animSpeed * 1000
	      	EndIf
		End If
		DrawImage image, x, y, Self._currentFrame
   	EndMethod
   
   	Method SetAnimSpeed(animSpeed:Float)
   		Self._animSpeed = animSpeed
   	End Method

	Method GetFrame:Int()
		Return Self._currentFrame
	End Method
	
	Method PlayedOnce:Byte()
		If Self._timesPlayed <> 0
			Return True
		End If
		Return False
	End Method
   
EndType 



' --------------------------------------------------
' Gibt den Winkel von Punkt(x1|y1) zu Punkt(x2|y2) zurück
' --------------------------------------------------
Function MF_GetAngle:Int(x1:Int, y1:Int, x2:Int, y2:Int)
	Local angle:Int = ATan2(y2 - y1, x2 - x1) + 90
	If angle < 0 angle:+360
	If angle >= 360 angle:-360
	Return angle
EndFunction


' --------------------------------------------------
' Gibt den Winkel als 8-Wege Richtung zurück: Nord (0), Nord-Ost (1), Ost (2), Süd-Ost (3), Süd (4)... usw
' --------------------------------------------------
Function MF_GetViewDirection8:Int(x1:Int, y1:Int, x2:Int, y2:Int)
	Local angle:Int = ATan2(y2 - y1, x2 - x1) + 90
	angle:- 22
	If angle < 0 angle:+360
	If angle >= 360 angle:-360
	
	Local view:Int = angle / 45
	view:+1
	If view > 7 view = 0

	Return view
End Function


' --------------------------------------------------
' In einer Schleife aufgerufen, veranlasst diese Funktion, dass sich ein Punkt(oder auch anderes, wie zB. ein Image) mit den Koordinaten
' "x1" und "y1" auf einen Punkt(oder auch anderes, wie zB. ein Image) mit den Koordinaten "x2" und "y2", 
' mit einer Geschwindigkeit von "speed" zubewegt
' --------------------------------------------------
Function MF_MoveTowardsPoint(x1:Float Var, y1:Float Var, x2:Float, y2:Float, speed:Float)
	Local angle:Int = ATan2(y2 - y1, x2 - x1) + 90
	If angle < 0 angle:+360
	If angle >= 360 angle:-360
	x1 = x1 + Cos( angle-90 ) * speed
	y1 = y1 + Sin( angle-90 ) * speed
End Function



' --------------------------------------------------
' Gibt die Distanz zwischen 2 Punkten zurück
' --------------------------------------------------
Function MF_GetDistance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Return Sqr( (x1 -x2)^2 + (y1 - y2)^2 )
EndFunction



' --------------------------------------------------
' Überprüft ob sich der Wert "Val" zwischen dem Wert "minVal" und "maxVal" befindet
' --------------------------------------------------
Function IsBetween:Byte(val:Int, minVal:Int, maxVal:Int)
	If val >= minVal And val < maxVal Then Return True
	Return False
End Function


' --------------------------------------------------
' Überprüft ob sich zwei Rechtecke Überlappen
' --------------------------------------------------
Function RectsOverlap:Byte(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	If x1 <= (x2 + w2) And y1 <= y2 + h2 And (x1 + w1) >= x2 And (y1 + h1) >= y2 Then Return True
	Return False
End Function


' --------------------------------------------------
' Überprüft auf ein freien Channel im übergebenen Channelarray
' und spielt den Sound ab, wenn ein unbenutzer Channel gefunden wurde
' --------------------------------------------------
Function MF_PlaySound(sound:TSound, channelArray:TChannel[])
	Local chn:TChannel
	Local i:Int = 0
	For chn = EachIn channelArray
		If Not ChannelPlaying(channelArray[i])
			PlaySound(sound, channelArray[i])
			Exit
		End If
		i:+ 1
	Next
End Function









