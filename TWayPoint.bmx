


Type TWayPoint
	
	'Private
		Field _x:Float, _y:Float
		
		Field _link:TLink
		
		Field _nextWp:TWayPoint
		
		Field _lastWp:TWayPoint
	
		Method SetNextWp(wp:TwayPoint)
			Self._nextWp = wp
		End Method
	
	
	' Public
	
		Global List:TList = New TList
		Global Before:TWaypoint
	
		Method New()
			Self._link = List.AddLast(Self)
			If TWayPoint.Before <> Null
				' Dem vorherigen Wegpunkt, den grade erstellten Wegpunkt übergeben
				TWayPoint.Before.SetNextWp(Self)
				' Dem grade erstellten Wegpunkt, den vorherigen übergeben
				Self._lastWp = TWayPoint.Before
			End If
			TWayPoint.Before = self
		End Method
		
		Method GetNextWp:TWayPoint()
			Return Self._nextWp
		End Method
		
		Method GetLink:TLink()
			Return Self._link
		End Method
		
		Method GetX:Float()
			Return Self._x
		End Method
		Method GetY:Float()
			Return Self._y
		End Method
		
		Method SetX(x:Float)
			Self._x = x
		End Method
		Method SetY(y:Float)
			Self._y = y
		End Method
		
		Method Free()
			' Wenn selber ein Wegpunkt mittendrin war
			' Den nächsten und vorherigen Wegpunkt miteinander verbinden
			If Self._lastWp <> Null And Self._nextWp <> Null
				Self._lastWp._nextWp = Self._nextWp
				Self._nextWp._lastWp = Self._lastWp
			' Wenn selber der erste Wegpunkt, sich selber beim nächten Wegpunkt löschen
			ElseIf Self._nextWp <> Null And Self._lastWp = Null
				Self._nextWp._lastWp = Null
			' Wenn selber der letzte Wegpunkt, sich selber beim vorherigen Wegpunkt löschen
			ElseIf Self._lastWp <> Null And Self._nextWp = Null
				Self._lastWp._nextWp = Null
				Before = Self._lastWp
			' Wenn selber der einzige Wegpunkt
			ElseIf Self._lastWp = Null And Self._nextWp = Null
				Before = Null
			End If
			' Und Schlussendlich sich selber löschen
			If Self._link
	        		Self._link.Remove()
	         		Self._link = Null
	      	EndIf
		End Method
	
	
		' Zu Debugzwecken und zum verschieben eines Wegpunktes
		Field _mouseGrabbed:Byte
		Global Grabbed:Byte
		Function DebugAll(buttonForMove:Int, buttonForDelete:Int)
			' Wegpunkte zeichnen
			For Local wp:TWayPoint = EachIn TWayPoint.List
				If wp._nextWp = Null
					SetColor 255, 0, 0
				ElseIf wp._lastWp = Null
					SetColor 0, 0, 255
				Else
					SetColor 0, 255, 0
				End If
				DrawOval(wp.GetX()-3, wp.GetY()-3, 6, 6)
				
				If wp._lastWp <> Null
					SetColor 250, 250, 0
					DrawLine wp._lastWp._x, wp._lastWp._y, wp._x, wp._y
				End If
				
				
				' Wegpunkte verschiebbar machen (mouseX mouseY) wenn übergebener Button gedrückt
				If wp._mouseGrabbed = True
					wp._x = MouseX()
					wp._y = MouseY()
				End If
				
				If MF_GetDistance( wp._x, wp._y, MouseX(), MouseY() ) < 10 And buttonForMove
					wp._mouseGrabbed = 1 - wp._mouseGrabbed
				End If
				
				If MF_GetDistance( wp._x, wp._y, MouseX(), MouseY() ) < 10 And buttonForDelete
					wp.Free()
				End If
			Next
			SetColor 255, 255, 255
			
			
			
		End Function
	

End Type






