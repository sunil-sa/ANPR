function speakout(txt)
text = "Hey sunil, its "+" "+txt;
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
obj.Rate = 0.25;
Speak(obj, text);
end