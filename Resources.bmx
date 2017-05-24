
' Font

Incbin "cyberspace.otf"
	' Schriftfarbe 40, 160, 250
	Global Font:TImageFont = LoadImageFont("Incbin::cyberspace.otf", 10)
	SetImageFont(Font)


' Grafiken
Incbin "TowerTest.png"
Global Img_TowerTest:TImage = LoadImage("Incbin::TowerTest.png")

Incbin "PassiveDoodadTest.png"
Global Img_PassiveDoodadTest:TImage = LoadImage("Incbin::PassiveDoodadTest.png")

Incbin "EnemyTestAni.png"
Global Img_EnemyTest:TImage = LoadAnimImage("Incbin::EnemyTestAni.png", 60, 60, 0, 24)

Incbin "ExploTest.png"
Global Img_ExploTest:TImage = LoadAnimImage("Incbin::ExploTest.png", 80, 80, 0, 12)

Incbin "SmallExploTest.png"
Global Img_SmallExploTest:TImage = LoadAnimImage("Incbin::SmallExploTest.png", 40, 40, 0, 8)

Incbin "ShotAniTest.png"
Global Img_ShotTest:TImage = LoadAnimImage("Incbin::ShotAniTest.png", 40, 40, 0, 8)



' Sounds

Global SfxChannel:TChannel[6]
For Local i:Int = 0 To 5
	SfxChannel[i] = AllocChannel()
Next

Incbin "SmallShot.wav"
Global Snd_SmallShot:TSound = LoadSound("Incbin::SmallShot.wav")

Incbin "BigShot.WAV"
Global Snd_BigShot:TSound = LoadSound("Incbin::BigShot.WAV")

Incbin "ShotHit.wav"
Global Snd_ShotHit:TSound = LoadSound("Incbin::ShotHit.wav")

Incbin "SmallExplo.WAV"
Global Snd_SmallExplo:TSound = LoadSound("Incbin::SmallExplo.WAV")

Incbin "EnemyDie.wav"
Global Snd_EnemyDie:TSound = LoadSound("Incbin::EnemyDie.wav")

Incbin "EnemyHitten.wav"
Global Snd_EnemyHitten:TSound = LoadSound("Incbin::EnemyHitten.wav")

Incbin "TowerHitten.wav"
Global Snd_TowerHitten:TSound = LoadSound("Incbin::TowerHitten.wav")











